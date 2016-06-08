//
//  ViewController.m
//  Ios8Test
//


#import "iCloudViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface iCloudViewController ()

@end

@implementation iCloudViewController
            
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self openDocumentPicker:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [NGDirectoryUtility deleteOldResumeIfPresent];
}

- (IBAction)openDocumentPicker:(id)sender
{
    
    UIDocumentPickerViewController *vc = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:
                                                        @[(NSString *)kUTTypeRTF,
                                                          (NSString *)kUTTypePDF,
                                                          (NSString *)kUTTypePlainText]
                                                                inMode:UIDocumentPickerModeOpen];
    
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{}];
    
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    [self showAnimator];

    //BOOL startAccessingWorked = [url startAccessingSecurityScopedResource];
    NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSString* fileName = [ubiquityURL lastPathComponent];
    
    NSLog(@"fileName %@",fileName);
//    NSLog(@"start %d",startAccessingWorked);
//    NSLog(@"url %@",url);

    
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    NSError *error;
    __weak iCloudViewController *weakSelf = self;

    [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
        
        [self hideAnimator];

        NSData *data = [NSData dataWithContentsOfURL:newURL];
        
        if (!error) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *localPath = [documentsPath stringByAppendingPathComponent:fileName];
            
            if ([fileManager fileExistsAtPath:localPath isDirectory:NO]) {
                [fileManager removeItemAtPath:localPath error:nil];
            }
            
            [data writeToFile:localPath atomically:YES];
            
            if ([weakSelf.rootViewDelegate respondsToSelector:@selector(iCloudBrowser:didDownloadFile:)]) {
                [weakSelf.rootViewDelegate iCloudBrowser:weakSelf didDownloadFile:fileName];
            }
        }else{
            
           
            [NGUIUtility showAlertWithTitle:@"Oops!" withMessage:[NSArray arrayWithObject:@"Error occured while downloading the file."] withButtonsTitle:@"OK" withDelegate:nil];
            
            if ([weakSelf.rootViewDelegate respondsToSelector:@selector(googleDriveBrowser:didFailToDownloadFile:)]) {
                [weakSelf.rootViewDelegate iCloudBrowser:weakSelf didFailToDownloadFile:fileName];
            }
        }
        
    }];
    [url stopAccessingSecurityScopedResource];
    
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
}



@end
