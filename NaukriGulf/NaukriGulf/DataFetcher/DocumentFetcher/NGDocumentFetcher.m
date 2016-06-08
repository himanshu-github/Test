//
//  NGDocumentFetcher.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 30/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGDocumentFetcher.h"
#import "NGHelper.h"
#import "NGWebDataManager.h"
#import "NGResmanCVUploadViewController.h"
#import "NGQLDocumentPreviewViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface NGDocumentFetcher (){
    
    UINavigationController *vc;
}
@property (nonatomic, strong)UINavigationController *navigationController;
@property (nonatomic, strong)NSMutableArray *arrayOfDocuments;

@end

@implementation NGDocumentFetcher

+(instancetype)sharedInstance{
    
    static NGDocumentFetcher *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGDocumentFetcher alloc]init];
    });
    return sharedInstance;
}

-(id)init{
    if (self=[super init]) {
        self.arrayOfDocuments = [[NSMutableArray alloc]init];
        self.navigationController = (IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController;
        self.resumeTransferStatus = kResumeTransferStatusNone;
    }
    
    return self;
}


-(void)previewDocumentWithPath:(NSString *)filePath inController:(UINavigationController *)nvc{
    
    if (self.navigationController) {
        
        [self.arrayOfDocuments removeAllObjects];
        [self.arrayOfDocuments addObject:filePath];
        
        UIStoryboard * storyBoard =[UIStoryboard storyboardWithName:@"OthersStoryboard" bundle:nil];
        NGQLDocumentPreviewViewController *dPCntlr = [storyBoard instantiateViewControllerWithIdentifier:@"NGQLDocumentPreviewViewController"];
        dPCntlr.arrayOfDocuments = [NSMutableArray arrayWithObjects:filePath, nil];
        dPCntlr.showDownloadedFile = NO;
        dPCntlr.isCloudDocument = NO;
        [(IENavigationController*)self.navigationController pushActionViewController:dPCntlr Animated:YES];
    }
}


#pragma mark Helper Methods

-(void)showOptions{
    
    UIActionSheet *sheet;
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
        sheet = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Google Drive",@"DropBox", nil];

    else
        sheet = [[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Google Drive",@"DropBox",@"iCloud", nil];

    [sheet showInView:[(UIViewController*)_commingFromVC view]];
}

-(void)showDropBoxOption{
    
    UINavigationController *dropBoxNavBar = [[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"DropBoxBrowser"];
    
    DropboxBrowserViewController *dropboxBrowserVC = (DropboxBrowserViewController*)dropBoxNavBar.topViewController;
    dropboxBrowserVC.allowedFileTypes = @[@"pdf", @"docx",@"doc",@"rtf"];
    dropboxBrowserVC.shouldDisplaySearchBar = YES;
    dropboxBrowserVC.commingFromVC = self.commingFromVC;
    dropboxBrowserVC.rootViewDelegate = self;
    self.navigationController = dropBoxNavBar;
    [self.commingFromVC presentViewController:dropBoxNavBar animated:YES completion:nil];
}

-(void)showGoogleDriveOption{
    
    UINavigationController *gDriveNavBar = [[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"GoogleDriveBrowser"];
    
    GoogleDriveBrowserViewController *googleDriveVC = (GoogleDriveBrowserViewController*)gDriveNavBar.topViewController;
    googleDriveVC.rootViewDelegate = self;
    googleDriveVC.commingFromVC = self.commingFromVC;
    
    self.navigationController = gDriveNavBar;
    
    [self.commingFromVC presentViewController:gDriveNavBar animated:YES completion:nil];
}


-(void)showiCloudDriveOption{
    
    id iCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if ( iCloudToken != nil) {
        // User has enabled icloud in your app...

        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:19.0], NSFontAttributeName, nil]];
        UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString*)@"org.openxmlformats.wordprocessingml.document",(NSString *)kUTTypeRTF,(NSString *)kUTTypePDF,@"com.microsoft.word.doc"] inMode:UIDocumentPickerModeOpen];
        documentPicker.delegate = self;
        [self.commingFromVC presentViewController:documentPicker animated:YES completion:^{
        }];

    } else {
        // Icloud is not enabled for your app...
        [NGUIUtility showAlertWithTitle:@"Attention!" message:@"iCloud is not enabled on your phone. Please enable it from your Phone Settings." delegate:nil];
    }

}
#pragma mark iCloud Document Picker View Controller
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    if (self.navigationController) {
        UIStoryboard * storyBoard =[UIStoryboard storyboardWithName:@"OthersStoryboard" bundle:nil];
        NGQLDocumentPreviewViewController *dPCntlr = [storyBoard instantiateViewControllerWithIdentifier:@"NGQLDocumentPreviewViewController"];
        dPCntlr.showDownloadedFile = NO;
        dPCntlr.myURL = url;
        dPCntlr.isCloudDocument = YES;
        [(IENavigationController*)[(UIViewController*)self.commingFromVC navigationController] pushActionViewController:dPCntlr Animated:YES];
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
}

#pragma mark UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self showGoogleDriveOption];
            break;
            
        case 1:
            [self showDropBoxOption];
            break;
            
        case 2:
            if(actionSheet.cancelButtonIndex != buttonIndex)
            [self showiCloudDriveOption];
            break;
        default:
            break;
    }
}

#pragma mark DropBox Delegate

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser didDownloadFile:(NSString *)fileName didOverwriteFile:(BOOL)isLocalFileOverwritten{
    
    NSString *newFileName = [self renameFileInDocDir: fileName];
    [self previewDocumentWithPath:newFileName inController:self.navigationController];
}

-(NSString*) renameFileInDocDir : (NSString*) filePath {
    
    NSString *fileExtension = [[filePath componentsSeparatedByString:@"."] fetchObjectAtIndex:1];
    NSString *newFilename = [NSString stringWithFormat:@"Resume.%@",fileExtension];
    self.fileExtensions = fileExtension;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    
    NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:filePath];
    NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:newFilename];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePathSrc]) {
        NSError *error = nil;
        [manager moveItemAtPath:filePathSrc toPath:filePathDst error:&error];
        if (error) {
        }
    } else {
    }
    
    return newFilename;
}


- (void)dropboxBrowser:(DropboxBrowserViewController *)browser didFailToDownloadFile:(NSString *)fileName{
    [self showErrorBannerWithMsg:@"Some error occurred, unable to download file from Dropbox!!!"];
}

- (void)dropboxBrowserDismissed:(DropboxBrowserViewController *)browser{
}

#pragma mark Google Drive Delegate

-(void)googleDriveBrowser:(GoogleDriveBrowserViewController *)browser didDownloadFile:(NSString *)fileName{
    
    NSString *newFileName = [self renameFileInDocDir:fileName];
    [self previewDocumentWithPath:newFileName inController:self.navigationController];
    
}

-(void)googleDriveBrowser:(GoogleDriveBrowserViewController *)browser didFailToDownloadFile:(NSString *)fileNam{
    [self showErrorBannerWithMsg:@"Some error occurred, unable to download file from Google drive!!!"];
}

-(void)icloudFileExtention:(NSString*)strFileExtension{
    
    self.fileExtensions = strFileExtension;
}

#pragma mark - Upload Resume Methods

-(void) uploadResumeFileOnServer {
    
    //login check
    if (![NGHelper sharedInstance].isUserLoggedIn) {
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Please login to upload CV" animationTime:3 showAnimationDuration:0.5];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CV_TRANSFER_STATUS_NOTIFICATION object:@{CV_TRANSFER_STATUS_NOTIFICATION_KEY:[NSNumber numberWithBool:NO]}];
        return;
    }
    
    //file size check
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths fetchObjectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Resume"];
    NSString *completeFilePath = [NSString stringWithFormat:@"%@.%@",filePath,self.fileExtensions];
    if ([NGDirectoryUtility fileSizeAtPath:completeFilePath] > RESUME_SIZE*1024) {
        [NGMessgeDisplayHandler showErrorBannerFromTop:[UIApplication sharedApplication].keyWindow title:@"" subTitle:[NSString stringWithFormat:@"Resume size cannot exceed %dKB",RESUME_SIZE] animationTime:2 showAnimationDuration:0.5];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CV_TRANSFER_STATUS_NOTIFICATION object:@{CV_TRANSFER_STATUS_NOTIFICATION_KEY:[NSNumber numberWithBool:NO]}];
        
        return;
    }
    
    
    if (kResumeTransferStatusNone == self.resumeTransferStatus) {
        self.resumeTransferStatus = kResumeTransferStatusUploading;
        
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setCustomObject:filePath forKey:K_KEY_RESUME_UPLOAD];
        [params setCustomObject:self.fileExtensions forKey:K_KEY_RESUME_EXTENSION];
        [params setCustomObject:[NSNumber numberWithUnsignedInteger:NGFileUploadTypeResume] forKey:K_FILE_UPLOAD_TYPE_KEY];
        [params setCustomObject:k_FILE_UPLOAD_APP_ID_MNJ forKey:k_FILE_UPLOAD_APP_ID_KEY];
        
        if ([self.commingFromVC isMemberOfClass:[NGResmanCVUploadViewController class]]) {
            [params setCustomObject:K_RESMAN_API_REQUEST_SOURCE forKey:K_API_REQUEST_SOURCE_KEY];
        }
        
        __weak NGDocumentFetcher *weakSelf = self;
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_FILE_UPLOAD];
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BOOL hasError = NO;
                
                if (!responseInfo.isRequestCancelled) {
                    
                    if (responseInfo.isSuccess) {
                        
                        [weakSelf updateResumeInfoWithResponseModel:responseInfo];
                    }
                    else
                    {
                        hasError = YES;
                    }
                }else{
                    hasError = YES;
                }
                
                if (hasError) {
                    [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Server error in Saving CV" animationTime:3 showAnimationDuration:0.5];
                    
                    weakSelf.resumeTransferStatus = kResumeTransferStatusNone;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:CV_TRANSFER_STATUS_NOTIFICATION object:@{CV_TRANSFER_STATUS_NOTIFICATION_KEY:[NSNumber numberWithBool:NO]}];
                }
                
            });
        }];
    }
}
-(void)updateResumeInfoWithResponseModel:(NGAPIResponseModal*)paramResponseInfo{
    
    //get form and filekey
    NSString *formKey = [paramResponseInfo.parsedResponseData objectForKey:@"formKey"];
    NSString *fileKey = [paramResponseInfo.parsedResponseData objectForKey:@"fileKey"];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    if(0 >= [vManager validateValue:formKey withType:ValidationTypeString].count &&
       0 >= [vManager validateValue:fileKey withType:ValidationTypeString].count){
        
        __weak NGDocumentFetcher *weakSelf = self;
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPLOAD_RESUME];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setCustomObject:fileKey forKey:@"fileKey"];
        [params setCustomObject:formKey forKey:@"formKey"];
        
        
        if ([self.commingFromVC isMemberOfClass:[NGResmanCVUploadViewController class]]) {
            [params setCustomObject:K_RESMAN_API_REQUEST_SOURCE forKey:K_API_REQUEST_SOURCE_KEY];
        }
        
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!responseInfo.isRequestCancelled) {
                    
                    if (responseInfo.isSuccess) {
                        
                        [NGHelper sharedInstance].resumeFormat = weakSelf.fileExtensions;
                        if (nil != weakSelf.commingFromVC) {
                            
                            if(_bIsCloudFile){
                                UIViewController *topController = ((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController).topViewController;
                             [topController.navigationController popViewControllerAnimated:YES];
                            }
                            else
                             [weakSelf.commingFromVC dismissViewControllerAnimated:YES completion:nil];
                            _bIsCloudFile = NO;
                            NSString *objectClassName = NSStringFromClass([weakSelf.commingFromVC class]);
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_RESUME_UPLOAD object:nil userInfo:@{CV_UPLOAD_FOR_OBJECT_KEY:objectClassName}];
                        }else{
                            [(IENavigationController*)([NGAppDelegate appDelegate].container.centerViewController) popViewControllerAnimated:YES];
                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshuserdata" object:nil];
                        }
                    }
                    else
                    {
                        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Server error in Saving CV" animationTime:3 showAnimationDuration:0.5];
                        
                    }
                    
                    weakSelf.resumeTransferStatus = kResumeTransferStatusNone;
                    //
                    [[NSNotificationCenter defaultCenter] postNotificationName:CV_TRANSFER_STATUS_NOTIFICATION object:@{CV_TRANSFER_STATUS_NOTIFICATION_KEY:[NSNumber numberWithBool:NO]}];
                    
                }else{
                    [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Server error in Saving CV" animationTime:3 showAnimationDuration:0.5];
                    
                    weakSelf.resumeTransferStatus = kResumeTransferStatusNone;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:CV_TRANSFER_STATUS_NOTIFICATION object:@{CV_TRANSFER_STATUS_NOTIFICATION_KEY:[NSNumber numberWithBool:NO]}];
                }
            });
            
        }];
    }else{
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Server error in Saving CV" animationTime:3 showAnimationDuration:0.5];
        
        self.resumeTransferStatus = kResumeTransferStatusNone;
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:CV_TRANSFER_STATUS_NOTIFICATION object:@{CV_TRANSFER_STATUS_NOTIFICATION_KEY:[NSNumber numberWithBool:NO]}];
    }
}
-(void)showErrorBannerWithMsg:(NSString*)paramMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:paramMsg animationTime:3 showAnimationDuration:0.5];
    });
}
-(void)showSuccessBannerWithMsg:(NSString*)paramMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:paramMsg animationTime:3 showAnimationDuration:0.5];
    });
}
-(void)dealloc {
    
    self.fileExtensions = nil;
}
@end
