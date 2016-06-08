//
//  NGResmanPhotoViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 2/4/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanPhotoViewController.h"
#import "NGResmanExploreOptionViewController.h"


@interface NGResmanPhotoViewController (){
    
    
    BOOL bIsPhotoAvailable;
    BOOL bIsPhotoUploaded;
    BOOL bIsComingFromImagePicker;
    UIImage* imageFromDevice;
    
    IBOutlet UIButton* btnPhoto;
    IBOutlet UILabel* lblDesc;
    
    NGResmanDataModel *resmanModel;
    __weak IBOutlet NSLayoutConstraint *helptextBottomConstrains;
}

/**
 *   BOOL Value to check if Profile  Photo is displayed
 */
@property (nonatomic) BOOL isPhotoExist;
/**
 *  a Custom animation appears on loading services
 */
@property (strong, nonatomic) NGLoader* loader;

@end

@implementation NGResmanPhotoViewController

#pragma mark - ViewController LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [lblDesc setTextColor:[UIColor lightGrayColor]];
    
    self.editTableView.scrollEnabled = NO;
    lblDesc.text = @"Profile with a photograph has 40% higher chances of getting noticed by the Employers.";
    CGFloat colorCode = 122.0f/255.0f;
    [lblDesc setTextColor:[UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f]];
    [lblDesc setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:12]];
    [self setProfilePic];

    //NOTE:This must be here becz we r using model view controller here
    //which triggers screen report again and again.
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    
    if (resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_PHOTO_UPLOAD_FRESHER];
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_PHOTO_UPLOAD_EXPERIENCED];
    }
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    
    [super viewWillAppear:animated];
    
    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Profile Photo"];
    
    if (bIsComingFromImagePicker)
        return;
    if(bIsPhotoAvailable)
        bIsPhotoUploaded = YES;
    else
        bIsPhotoUploaded = NO;

    if (IS_IPHONE4) {
        helptextBottomConstrains.constant = 25;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [NGDecisionUtility checkNetworkStatus];

}

-(void)viewDidAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;

    [super viewDidAppear:animated];
    
    [NGHelper sharedInstance].appState = APP_STATE_EDIT_FLOW;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.loader isLoaderAvail]) {
        [self.loader hideAnimatior:self.view];
    }
}


- (void)setProfilePic{
    
    NSString *photoStr = [NSString getProfilePhotoPath];//cached photo
    
    
    NSString *photoStrFromSocialLogin = [NSString getProfilePhotoPathForSocialLogin];//cached photo from Social Login

    
    UIImage* imageName = nil;
    if ([[NSFileManager defaultManager]fileExistsAtPath:photoStr]){
        
        bIsPhotoAvailable = YES;
        imageName = [UIImage imageWithContentsOfFile:photoStr];
    }
    else if ([[NSFileManager defaultManager]fileExistsAtPath:photoStrFromSocialLogin]){
        bIsPhotoAvailable = YES;
        bIsPhotoUploaded = YES;
        imageName = [UIImage imageWithContentsOfFile:photoStrFromSocialLogin];
        imageFromDevice = imageName;
    }
    else{
        imageName = [UIImage imageNamed:@"usrPic"];
    }
    
    imageName = [UIImage imageWithImage:imageName scaledToSize:CGSizeMake(140, 140)];
    imageName = [UIImage cropImageCircularWithBorderWidth:5.0
                                                                borderColor:[UIColor lightGrayColor]
                                                                    ofImage:imageName];
    
    [btnPhoto setImage:imageName forState:UIControlStateNormal];
}



-(IBAction)onPhotoClick:(id)sender{
    [self displayPhotoSelectionOptions];
    
}

-(IBAction)onTOS{
    
    NGWebViewController *webView = (NGWebViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.isCloseBtnHidden = NO;
    [webView setNavigationTitle:@"Terms of Service" withUrl:@"http://www.naukrigulf.com/ni/nilinks/nkr_links.php?open=tos"];

    IENavigationController *cntrllr = [NGAppDelegate appDelegate].container.centerViewController;
    cntrllr.navigationItem.leftBarButtonItem = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [cntrllr pushActionViewController:webView Animated:YES];
}


-(void)editPhotoToServer{
    
    __weak NGResmanPhotoViewController *weakSelf = self;
    
     if (bIsPhotoUploaded){
         
         [self showAnimator];
         
         NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_FILE_UPLOAD];
         
         NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
         
         [params setCustomObject:imageFromDevice forKey:@"PHOTO"];
         [params setCustomObject:k_FILE_UPLOAD_APP_ID_MNJ forKey:k_FILE_UPLOAD_APP_ID_KEY];
         [params setCustomObject:[NSNumber numberWithUnsignedInteger:NGFileUploadTypePhoto] forKey:K_FILE_UPLOAD_TYPE_KEY];
         
         [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (responseInfo.isSuccess) {
                     
                     [self updatePhotoInfoWithResponseModel:responseInfo];
                     
                 }else{
                     [weakSelf hideAnimator];
                 }
                 
             });
             
             
         }];
        
     }else{
        
        [self pushExploreOption];
     }
}
-(void)updatePhotoInfoWithResponseModel:(NGAPIResponseModal*)paramResponseInfo{
    //get form and filekey
    NSString *formKey = [paramResponseInfo.parsedResponseData objectForKey:@"formKey"];
    NSString *fileKey = [paramResponseInfo.parsedResponseData objectForKey:@"fileKey"];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    if(0 >= [vManager validateValue:formKey withType:ValidationTypeString].count &&
       0 >= [vManager validateValue:fileKey withType:ValidationTypeString].count){
        
        __weak NGResmanPhotoViewController *weakSelf = self;
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPLOAD_PHOTO];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setCustomObject:fileKey forKey:@"fileKey"];
        [params setCustomObject:formKey forKey:@"formKey"];
        
        
        __weak UIImage *weakImage = imageFromDevice;
        
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hideAnimator];
                
                if (responseInfo.isSuccess) {
                    
                    if (resmanModel.isFresher) {
                        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_PHOTO_UPLOADED_FRESHER withEventLabel:K_GA_RESMAN_EVENT_PHOTO_UPLOADED_FRESHER withEventValue:nil];
                    }else{
                        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_PHOTO_UPLOADED_EXPERIENCED withEventLabel:K_GA_RESMAN_EVENT_PHOTO_UPLOADED_EXPERIENCED withEventValue:nil];
                    }
                    
                    [weakSelf.editDelegate editedPhotoWithSuccess:YES];
                    
                    [NGDirectoryUtility saveImage:weakImage WithName:USER_PROFILE_PHOTO_NAME];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoUpdated" object:weakImage];
                    [self pushExploreOption];
                }
                else{
                    
                    [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Error in uploading photo.Please try again" animationTime:3 showAnimationDuration:0.5];
                }
                
            });
            
        }];
    }else{
        //show error
        [self hideAnimator];
        
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Server error in Saving File" animationTime:3 showAnimationDuration:0.5];
    }
}
- (IBAction)saveClicked{
    [self editPhotoToServer];
}
-(void)saveButtonPressed{
    
    if (bIsPhotoUploaded)
        [self editPhotoToServer];
    else
        [self pushExploreOption];
}

-(void)pushExploreOption{
    
    NGResmanExploreOptionViewController* vc = [[NGResmanExploreOptionViewController alloc] init];
    [(IENavigationController*)self.navigationController pushActionViewController:vc Animated:YES];

}

#pragma mark -
#pragma mark Alert Delegate

-(void) customAlertbuttonClicked:(int)index {
    
    [NGHelper sharedInstance].isAlertShowing = FALSE;
    
    if(index == 0) {
        
        bIsPhotoAvailable = NO;
        bIsPhotoUploaded = NO;
        
        UIImage* imageName = [UIImage imageNamed:@"usrPic"];
        
        imageName = [UIImage cropImageCircularWithBorderWidth:5.0
                                                                    borderColor:[UIColor lightGrayColor]
                                                                        ofImage:imageName];
        
        [btnPhoto setImage:imageName forState:UIControlStateNormal];
        
    }
    
}

#pragma mark UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [NGHelper sharedInstance].isAlertShowing = FALSE;
    
    switch (buttonIndex) {
        case 0:
            [self showImagePickerWithCamera];
            break;
        case 1:
            [self showImagePickerWithLibrary];
            break;
    }
}

#pragma mark UIImagePicker Delegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    bIsComingFromImagePicker = YES;
    bIsPhotoAvailable = YES;
    bIsPhotoUploaded = YES;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(140, 140)];
    imageFromDevice = image;
    
    image = [UIImage cropImageCircularWithBorderWidth:5.0
                                                            borderColor:[UIColor lightGrayColor] ofImage:image];
    [btnPhoto setImage:image forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    bIsComingFromImagePicker = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  Method creates an Instance of UIActionSheet for showing @"Camera", @"Library" as options
 */
- (void)displayPhotoSelectionOptions{
    
    [[[UIActionSheet alloc] initWithTitle:@"Select Source.."
                                 delegate:self
                        cancelButtonTitle:@"Close"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Camera", @"Library", nil]
     showInView:self.view];
    
}
/**
 *  Method creates an Instance of UIImagePickerController  for selecting profile photo from PhotoLibrary
 */
- (void)showImagePickerWithLibrary {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    [imagePicker setAllowsEditing:YES];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

/**
 *  Method creates an instance of UIImagePickerController and displays Camera,
 * if UIImagePickerControllerSourceTypeCamera is available else shows alert
 */
- (void)showImagePickerWithCamera {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setAllowsEditing:YES];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Your device does not support the camera." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self releaseMemory];
}

- (void)releaseMemory {
    
    self.editDelegate =  nil;
    self.loader =  nil;
}


@end
