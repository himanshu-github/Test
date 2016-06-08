//
//  NGEditPhotoViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEditPhotoViewController.h"

#define REMOVE_ALERT_TAG 100

@interface NGEditPhotoViewController (){
        
        BOOL bIsPhotoAvailable;
        int belowViewOriginY;
        UIView * belowView;
        NGButton* btnPhoto;
        UIImage* imageFromDevice;
        BOOL bIsPhotoDeleted;
        BOOL bIsPhotoUploaded;
        BOOL bIsComingFromImagePicker;
        UIView* viewDelete;
        UIGestureRecognizer* singleTapGesture;
    NGLabel *viewLbl;
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

@implementation NGEditPhotoViewController

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
    
    [self customizeNavBarForCancelOnlyButtonWithTitle:@"Photograph"];
    self.editTableView.scrollEnabled = NO;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    

}

- (void)viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    
    [super viewWillAppear:animated];
    
    if (bIsComingFromImagePicker)
        return;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self addPhotoIcon];
        
        bIsPhotoUploaded = NO;
        bIsPhotoDeleted = NO;
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [self refreshEditPhotoUI];
        
        [NGDecisionUtility checkNetworkStatus];

    });


    
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

- (void)refreshEditPhotoUI{
    
    NSString *photoStr = [NSString getProfilePhotoPath];
    
    UIImage* imageName = nil;
    if ([[NSFileManager defaultManager]fileExistsAtPath:photoStr]){
        
        bIsPhotoAvailable = YES;
        imageName = [UIImage imageWithContentsOfFile:photoStr];
        viewLbl.hidden = YES;
    }
    else{
        imageName = [UIImage imageNamed:@"usrPic"];
        viewLbl.hidden = NO;
    }
    
    imageName = [UIImage imageWithImage:imageName scaledToSize:CGSizeMake(140, 140)];
    imageName = [UIImage cropImageCircularWithBorderWidth:5.0
                                                                borderColor:[UIColor lightGrayColor]
                                                                    ofImage:imageName];
    
    [btnPhoto setImage:imageName forState:UIControlStateNormal];
    [self addBelowView];
}

- (void)addPhotoIcon{
    
    float fOriginXProfile = 40;
    if(IS_IPHONE6)
        fOriginXProfile += 22;
    else if (IS_IPHONE6_PLUS)
        fOriginXProfile += 37;
    
    
    float fOriginY = 10;
    if (IS_IPHONE6_PLUS)
        fOriginY += 60;
    
    viewLbl = [[NGLabel alloc] initWithFrame:CGRectMake(fOriginXProfile, fOriginY, 240, 100)];
    [viewLbl setText:@"Profiles with photos receive 40% more views by employers."];
    [viewLbl setTextAlignment:NSTextAlignmentCenter];
    viewLbl.numberOfLines = 2;
    [viewLbl setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:12.0]];
    [viewLbl setTextColor:[UIColor grayColor]];
    [viewLbl setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewLbl];
    
    float fOriginX = 60;
    if(IS_IPHONE6)
        fOriginX += 22;
    else if (IS_IPHONE6_PLUS)
        fOriginX += 37;
    
    
    //80
    btnPhoto = (NGButton*)[UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhoto setFrame:CGRectMake(fOriginX, fOriginY+70, 200, 200)];
    [btnPhoto setBackgroundColor:[UIColor clearColor]];
    [btnPhoto setImage:[UIImage imageNamed:@"usrPic"] forState:UIControlStateNormal];
    //[btnPhoto setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin];
    [btnPhoto addTarget:self action:@selector(onPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPhoto];
    
    float fOriginXCamera = 200;
    if(IS_IPHONE6)
        fOriginXCamera += 22;
    else if (IS_IPHONE6_PLUS)
        fOriginXCamera += 37;
    
    //227
    UIButton * btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCamera setBackgroundColor:[UIColor clearColor]];
    [btnCamera setFrame:CGRectMake(fOriginXCamera, fOriginY+217, 28, 28)];
    [btnCamera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(onPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    //[btnCamera setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin];
    [self.view addSubview:btnCamera];
    
}

- (void)onPhotoClick{
    
    [self displayPhotoSelectionOptions];
}

- (void)addBelowView{
    
    if ([self.view viewWithTag:786]){
        [belowView removeFromSuperview];
        [viewDelete removeGestureRecognizer:singleTapGesture];
    }
    
    int labelHeight = 15;
    int belowViewHeight = 90;
    int OriginY = self.view.frame.size.height - 95;
    if (bIsPhotoAvailable)
        OriginY = self.view.frame.size.height - 150;
    
    belowView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY , SCREEN_WIDTH, belowViewHeight)];
    [belowView setTag:786];
    [belowView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:belowView];
    
    NGView* viewTOS = [[NGView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, belowViewHeight*0.5)];
    [viewTOS setBackgroundColor:[UIColor clearColor]];
    [viewTOS setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    
    float upperY = -15.0;
    float fOriginX = 17;
    if(IS_IPHONE6)
        fOriginX += 22;
    else if (IS_IPHONE6_PLUS)
        fOriginX += 37;
    NGLabel* lbl1 = [[NGLabel alloc] initWithFrame:CGRectMake(fOriginX, upperY, 92, labelHeight)];
    [lbl1 setText:@"Supported Formats"];
    [lbl1 setTextAlignment:NSTextAlignmentLeft];
    [lbl1 setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:10.0]];
    [lbl1 setTextColor:[UIColor grayColor]];
    [lbl1 setBackgroundColor:[UIColor clearColor]];
    [viewTOS addSubview:lbl1];
    
    NGLabel* lblTypes = [[NGLabel alloc] initWithFrame:CGRectMake(lbl1.frame.origin.x +
                                                                  lbl1.frame.size.width,
                                                                  upperY, 120, labelHeight)];
    [lblTypes setText:@"JPEG, JPG, PNG, GIF"];
    [lblTypes setTextAlignment:NSTextAlignmentLeft];
    [lblTypes setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:11.0]];
    [lblTypes setTextColor:[UIColor darkGrayColor]];
    [lblTypes setBackgroundColor:[UIColor clearColor]];
    [viewTOS addSubview:lblTypes];
    
    NGLabel* lblSize = [[NGLabel alloc] initWithFrame:CGRectMake(lblTypes.frame.origin.x+
                                                                 lblTypes.frame.size.width, upperY, 45, labelHeight)];
    [lblSize setText:@"Max Size"];
    [lblSize setTextAlignment:NSTextAlignmentLeft];
    [lblSize setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:10.0]];
    [lblSize setTextColor:[UIColor grayColor]];
    [lblSize setBackgroundColor:[UIColor clearColor]];
    [viewTOS addSubview:lblSize];
    
    NGLabel* lblMB = [[NGLabel alloc] initWithFrame:CGRectMake(lblSize.frame.origin.x+
                                                               lblSize.frame.size.width, upperY, 30, labelHeight)];
    [lblMB setText:@"3 MB"];
    [lblMB setTextAlignment:NSTextAlignmentLeft];
    [lblMB setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:11.0]];
    [lblMB setTextColor:[UIColor grayColor]];
    [lblMB setBackgroundColor:[UIColor clearColor]];
    [viewTOS addSubview:lblMB];
    
    
    NGButton* btn = (NGButton*)[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect btnFrame = CGRectMake(lblTypes.frame.origin.x, 7, SCREEN_WIDTH-2*lblTypes.frame.origin.x, 18);
    [btn setFrame: btnFrame];
    [btn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:11.0]];
    [btn setTitleColor:Clr_Blue_SearchJob forState:UIControlStateNormal];
    [btn setTitleColor:Clr_Blue_SearchJob forState:UIControlStateSelected];
    [btn setTitleColor:Clr_Blue_SearchJob forState:UIControlStateHighlighted];
    [btn setTitle:@"terms of service" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onTOS) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [viewTOS addSubview:btn];
    
    NGView* viewLine = [[NGView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 1)];
    [viewLine setBackgroundColor:[UIColor lightGrayColor]];
    [viewTOS addSubview:viewLine];
    
    [belowView addSubview:viewTOS];
//    lbl1 = nil;
//    lblMB = nil;
//    lblSize = nil;
//    lblTypes = nil;
    
    viewLbl.hidden = YES;
    
    if (!bIsPhotoAvailable){
        
        [belowView setFrame:CGRectMake(belowView.frame.origin.x,belowView.frame.origin.y, SCREEN_WIDTH, belowViewHeight*0.5)];
        [viewLine setBackgroundColor:[UIColor clearColor]];
        
        viewLbl.hidden = NO;
        return;
    }
    
    
    viewDelete = [[NGView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, belowViewHeight*0.5)];
    [viewDelete setBackgroundColor:[UIColor clearColor]];
    [viewDelete setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    
    
    float fOriginXBottom = 85;
    if(IS_IPHONE6)
        fOriginXBottom += 22;
    else if (IS_IPHONE6_PLUS)
        fOriginXBottom += 37;
    
    NGButton* btnTrash = (NGButton*)[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect btnFrame1 = CGRectMake(fOriginXBottom, -5, 18, 18);
    [btnTrash setFrame: btnFrame1];
    [btnTrash setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [btnTrash setBackgroundColor:[UIColor clearColor]];
    [viewDelete addSubview:btnTrash];
    
    NGLabel* _lbl1 = [[NGLabel alloc] initWithFrame:CGRectMake(btnFrame.origin.x + 12, -5, 200, 20)];
    [_lbl1 setText:@"Remove Photo"];
    [_lbl1 setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:17.0]];
    [_lbl1 setTextColor:[UIColor grayColor]];
    [_lbl1 setBackgroundColor:[UIColor clearColor]];
    [viewDelete addSubview:_lbl1];
    
    NGLabel* lbl2 = [[NGLabel alloc] initWithFrame:CGRectMake(0, 13, SCREEN_WIDTH, 30)];
    [lbl2 setText:@"This will remove Photo permanently"];
    [lbl2 setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:12.0]];
    [lbl2 setTextAlignment:NSTextAlignmentCenter];
    [lbl2 setTextColor:[UIColor lightGrayColor]];
    [lbl2 setBackgroundColor:[UIColor clearColor]];
    [viewDelete addSubview:lbl2];
    
    [belowView addSubview:viewDelete];
    
    singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(handleSingleTapOnDeletePhoto)];
    
    [viewDelete addGestureRecognizer:singleTapGesture];
    
    [UIAutomationHelper setAccessibiltyLabel:@"delete_btn" forUIElement:viewDelete withAccessibilityEnabled:YES];
}

-(void)onTOS{
    
   NGWebViewController *webView = (NGWebViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.isCloseBtnHidden = NO;
    
   
    
    
    [webView setNavigationTitle:@"Terms of Service" withUrl:@"http://www.naukrigulf.com/ni/nilinks/nkr_links.php?open=tos"];
    IENavigationController *cntrllr = APPDELEGATE.container.centerViewController;
    cntrllr.navigationItem.leftBarButtonItem = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [cntrllr pushActionViewController:webView Animated:YES];

}



- (void)handleSingleTapOnDeletePhoto{
    
    [NGUIUtility showDeleteAlertWithMessage:@"Are you sure you want to remove the photo?" withDelegate:self];
    
}

- (void)saveButtonPressed{
    
    __weak NGEditPhotoViewController *weakSelf = self;
    
    if (bIsPhotoDeleted) {
        [self showAnimator];
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DELETE_PHOTO];
        [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hideAnimator];
                
                if (responseInfo.isSuccess) {
                    [weakSelf.editDelegate editedPhotoWithSuccess:YES];
                    
                    [NGDirectoryUtility saveImage:nil WithName:USER_PROFILE_PHOTO_NAME];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoUpdated" object:nil];
                    
                    [(IENavigationController*)APPDELEGATE.container.centerViewController popActionViewControllerAnimated:YES];
                }
                
            });
        }];
        
    }else if (bIsPhotoUploaded){
        
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)updatePhotoInfoWithResponseModel:(NGAPIResponseModal*)paramResponseInfo{
    
    //get form and filekey
    NSString *formKey = [paramResponseInfo.parsedResponseData objectForKey:@"formKey"];
    NSString *fileKey = [paramResponseInfo.parsedResponseData objectForKey:@"fileKey"];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    if(0 >= [vManager validateValue:formKey withType:ValidationTypeString].count &&
       0 >= [vManager validateValue:fileKey withType:ValidationTypeString].count){
        
        __weak NGEditPhotoViewController *weakSelf = self;
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPLOAD_PHOTO];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setCustomObject:fileKey forKey:@"fileKey"];
        [params setCustomObject:formKey forKey:@"formKey"];
        
        __weak UIImage *weakImage = imageFromDevice;
        
        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hideAnimator];
                
                if (responseInfo.isSuccess) {
                    
                    [weakSelf.editDelegate editedPhotoWithSuccess:YES];
                    
                    [NGDirectoryUtility saveImage:weakImage WithName:USER_PROFILE_PHOTO_NAME];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoUpdated" object:weakImage];
                    
                    [((UINavigationController *)APPDELEGATE.container.centerViewController) popViewControllerAnimated:YES];
                }else{
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
#pragma mark -
#pragma mark Alert Delegate

-(void) customAlertbuttonClicked:(int)index {
    
    [NGHelper sharedInstance].isAlertShowing = FALSE;
    
    if(index == 0) {
        
        bIsPhotoAvailable = NO;
        bIsPhotoDeleted = YES;
        bIsPhotoUploaded = NO;
        
        UIImage* imageName = [UIImage imageWithImage:[UIImage imageNamed:@"usrPic"] scaledToSize:CGSizeMake(140, 140)];
        imageName = [UIImage cropImageCircularWithBorderWidth:5.0
                                                  borderColor:[UIColor lightGrayColor]
                                                      ofImage:imageName];
        
        [btnPhoto setImage:imageName forState:UIControlStateNormal];

        [self addBelowView];
        
    }
    
}

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
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
    bIsPhotoDeleted = NO;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(140, 140)];
    imageFromDevice = image;
    
    image = [UIImage cropImageCircularWithBorderWidth:5.0
                                                            borderColor:[UIColor lightGrayColor] ofImage:image];
    [btnPhoto setImage:image forState:UIControlStateNormal];
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self addBelowView];
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


#pragma mark UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==REMOVE_ALERT_TAG) {
        switch (buttonIndex) {
            case 1:{
                bIsPhotoAvailable = NO;
                bIsPhotoDeleted = YES;
                bIsPhotoUploaded = NO;
                
                UIImage* imageName = [UIImage imageNamed:@"usrPic"];
                
                imageName = [UIImage cropImageCircularWithBorderWidth:5.0
                                                                            borderColor:[UIColor lightGrayColor]
                                                                                ofImage:imageName];
                
                [btnPhoto setImage:imageName forState:UIControlStateNormal];
                [self addBelowView];
                break;
            }
            default:
                break;
        }
    }
}


@end
