//
//  GoogleDriveBrowserViewController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 30/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//
#import "GoogleDriveBrowserViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

// View tags to differeniate alert views
NS_ENUM(NSUInteger, NGGoogleDriveAlertViewTag){
    kNGGoogleDriveAlertViewTagSignIn,
    kNGGoogleDriveAlertViewTagSignOut,
    kNGGoogleDriveAlertViewTagFileExists
};

NS_ENUM(NSUInteger, GoogleDriveUserLoginStatus){
    kGoogleDriveUserLoginStatusUserFailedOrCancelledLogin,
    kGoogleDriveUserLoginStatusNotLoggedIn,
    kGoogleDriveUserLoginStatusLogging,
    kGoogleDriveUserLoginStatusLoggedIn
};

NS_ENUM(NSUInteger, NGGoogleDriveFetchRequestStatus){
    kNGGoogleDriveFetchRequestStatusNone,
    kNGGoogleDriveFetchRequestStatusFetching,
    kNGGoogleDriveFetchRequestStatusCancelled,
    kNGGoogleDriveFetchRequestStatusDone
};

@interface GoogleDriveBrowserViewController (){
    NGLoader *loader;
    UIButton *navigationBarLeftBtn;
    enum GoogleDriveUserLoginStatus userLoginStatus;//required as is auth not giving correct status on viewwillapear and viewdid apper methods
    enum NGGoogleDriveFetchRequestStatus userFetchRequestStatus;
    GTMHTTPFetcher *fetcher;
    
    UIAlertView *googleDriveAlertView;
    NSCache *imagesCache;

}

@property (nonatomic, strong) GTLServiceDrive *driveService;
@property (nonatomic, strong) NSMutableArray *filesArr;
@property (nonatomic,strong)  UIButton *navigationBarRightBtn;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation GoogleDriveBrowserViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imagesCache = [[NSCache alloc] init];
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 4;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    userLoginStatus = kGoogleDriveUserLoginStatusNotLoggedIn;
    userFetchRequestStatus = kNGGoogleDriveFetchRequestStatusNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    if (self.title == nil || [self.title isEqualToString:@""]) self.title = @"Google Drive";
    
    [self addNavigationBarTitleWithCancelAndSaveButton:self.title withLeftNavTilte:@"Cancel" withRightNavTitle:nil];
    
    self.filesArr = [[NSMutableArray alloc]init];
    
    // Initialize the drive service & load existing credentials from the keychain if available
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemNameForGoogleDrive
                                                                                         clientID:GOOGLE_DRIVE_CLIENT_ID
                                                                                     clientSecret:GOOGLE_DRIVE_CLIENT_SECRET_KEY];
    if (self.title == nil || [self.title isEqualToString:@""]) self.title = @"Google Drive";
    
    if ([self isAuthorized])
    {
        userLoginStatus = kGoogleDriveUserLoginStatusLoggedIn;
        [self listAllFiles];
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self listenForNotification:NO];
    
    [self hideAnimator];
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initSetupOfGoogleDrive];
    [self listenForNotification:YES];
}
-(void)initSetupOfGoogleDrive{
    self.navigationController.navigationBar.translucent = NO;
    
    [self performSelector:@selector(showright) withObject:nil afterDelay:2.0];
    
    if(userLoginStatus == kGoogleDriveUserLoginStatusNotLoggedIn || userLoginStatus == kGoogleDriveUserLoginStatusUserFailedOrCancelledLogin){
        googleDriveAlertView = [[UIAlertView alloc] initWithTitle:@"Login to Google Drive" message:[NSString stringWithFormat:@"%@ is not linked to your Google Drive. Would you like to login now and allow access?", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        googleDriveAlertView.tag = kNGGoogleDriveAlertViewTagSignIn;
        [googleDriveAlertView show];
        
    }
    [NGDirectoryUtility deleteOldResumeIfPresent];
}
//------------------------------------------------------------------------------------------------------------//
//------- AlertView Delegate ---------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kNGGoogleDriveAlertViewTagSignIn) {
        switch (buttonIndex) {
            case 0:
                [self removeGoogleDriveBrowser];
                break;
            case 1:
                userLoginStatus = kGoogleDriveUserLoginStatusLogging;
                [self.navigationController pushViewController:[self createAuthController] animated:YES];
                break;
            default:
                break;
        }
    }else if (alertView.tag == kNGGoogleDriveAlertViewTagSignOut) {
        switch (buttonIndex) {
            case 0: break;
            case 1: {
                [self removeGoogleDriveBrowser];
            } break;
            default:
                break;
        }
    }else{
        //dummy
    }
}
-(void) showright {
    
    if ([self isAuthorized])
        
        _navigationBarRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];;
    [_navigationBarRightBtn setFrame:CGRectMake(0, 0, 60, 40)];
    [_navigationBarRightBtn setTitle:@"Log out" forState:UIControlStateNormal];
    _navigationBarRightBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_navigationBarRightBtn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_REGULAR size:15.0]];
    [_navigationBarRightBtn setTitleColor:Clr_Edit_Profile_Blue forState:UIControlStateNormal];
    [_navigationBarRightBtn addTarget:self action:@selector(gDriveLogoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [self createBarButtonItemWithButton:_navigationBarRightBtn];
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeGoogleDriveBrowser {
    
    if (userLoginStatus!=kGoogleDriveUserLoginStatusUserFailedOrCancelledLogin) {
        userFetchRequestStatus = kNGGoogleDriveFetchRequestStatusCancelled;
        [fetcher stopFetching];//cancel google drive requests
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (userLoginStatus == kGoogleDriveUserLoginStatusUserFailedOrCancelledLogin){
        userLoginStatus = kGoogleDriveUserLoginStatusNotLoggedIn;
    }else{
        //dummy
    }
}

-(void)listAllFiles{
    
    
    [self showAnimator];
    
    
    [self.filesArr removeAllObjects];
    
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = @"mimeType = 'application/pdf' or mimeType = 'application/msword' or mimeType = 'text/richtext' or mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' or mimeType = 'application/rtf'";
    
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFileList *filesList,
                                                              
                                                              NSError *error) {
        if (error == nil) {
            
            [self.filesArr addObjectsFromArray:filesList.items
             ];
            
        }
        [self hideAnimator];
        [self.tableView reloadData];
    }];
    
    
}

-(void)downloadFile:(NSString *)fileURL withName:(NSString *)fileName{
    
    [self showAnimator];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    fetcher = [self.driveService.fetcherService fetcherWithURLString:fileURL];
    userFetchRequestStatus = kNGGoogleDriveFetchRequestStatusFetching;
    __weak GoogleDriveBrowserViewController *weakSelf = self;
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (userFetchRequestStatus == kNGGoogleDriveFetchRequestStatusFetching) {
            userFetchRequestStatus = kNGGoogleDriveFetchRequestStatusDone;
            [weakSelf hideAnimator];
            if (error == nil) {
                [data writeToFile:path atomically:YES];
                [NGDirectoryUtility addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
                if ([weakSelf.rootViewDelegate respondsToSelector:@selector(googleDriveBrowser:didDownloadFile:)]) {
                    [weakSelf.rootViewDelegate googleDriveBrowser:weakSelf didDownloadFile:fileName];
                }
                
            } else {
                [NGUIUtility showAlertWithTitle:@"Oops!" withMessage:[NSArray arrayWithObject:@"Error occured while downloading the file."] withButtonsTitle:@"OK" withDelegate:nil];
                
                if ([weakSelf.rootViewDelegate respondsToSelector:@selector(googleDriveBrowser:didFailToDownloadFile:)]) {
                    [weakSelf.rootViewDelegate googleDriveBrowser:weakSelf didFailToDownloadFile:fileName];
                }
            }
        }
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.filesArr count] == 0) {
        return 0; // Return cell to show the folder is empty
        
        
    } else {
        
        return [self.filesArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.filesArr count] == 0) {
        // There are no files in the directory - let the user know
        if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            
            cell.textLabel.text = @"Folder is Empty";
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        GTLDriveFile *file = [self.filesArr fetchObjectAtIndex:indexPath.row];
        cell.textLabel.text = file.originalFilename;
        [cell.textLabel setNeedsDisplay];
        
        // Display icon
        NSString *imagename = file.iconLink;
        UIImage *image = [imagesCache objectForKey:file.iconLink];
        if (image){
            cell.imageView.image = image;
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"blank_doc.png"];
            [self.queue addOperationWithBlock:^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagename]]];
                if (image){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                        if (cell)
                            cell.imageView.image = image;
                    }];
                    [imagesCache setObject:image forKey:imagename];
                }
            }];
        }
        
        
        // Setup Last Modified Date
        NSLocale *locale = [NSLocale currentLocale];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E MMM d yyyy" options:0 locale:locale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:locale];
        
        NSString *fileSize = [NSString stringWithFormat:@"%0.1f KB",[file.fileSize integerValue]/1000.0];
        
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, modified %@", fileSize, [formatter stringFromDate:file.modifiedDate.date]];
        [cell.detailTextLabel setNeedsDisplay];
        
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
    if (indexPath == nil)
        return;
    
    if ([self.filesArr count] == 0) {
        // Do nothing, there are no items in the list. We don't want to download a file that doesn't exist (that'd cause a crash)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        GTLDriveFile *selectedFile = (GTLDriveFile *)[self.filesArr fetchObjectAtIndex:indexPath.row];
        
        if( [selectedFile.fileSize longLongValue] > RESUME_SIZE *1024) {
            [NGMessgeDisplayHandler showErrorBannerFromTop:[UIApplication sharedApplication].keyWindow title:@"" subTitle:[NSString stringWithFormat:@"Resume size cannot exceed %dKB",RESUME_SIZE] animationTime:2 showAnimationDuration:0.5];
            return;
            
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Create the local file path
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *localPath = [documentsPath stringByAppendingPathComponent:selectedFile.originalFilename];
        
        if ([fileManager fileExistsAtPath:localPath isDirectory:NO]) {
            [fileManager removeItemAtPath:localPath error:nil];
        }
        
        [self downloadFile:selectedFile.downloadUrl withName:selectedFile.originalFilename];
        
    }
}

#pragma mark Google Drive Authentication

// Helper to check if user is authorized
- (BOOL)isAuthorized
{
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive
                                                                clientID:GOOGLE_DRIVE_CLIENT_ID
                                                            clientSecret:GOOGLE_DRIVE_CLIENT_SECRET_KEY
                                                        keychainItemName:kKeychainItemNameForGoogleDrive
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    
    if (error != nil)
    {
        userLoginStatus = kGoogleDriveUserLoginStatusUserFailedOrCancelledLogin;
        self.driveService.authorizer = nil;
        [self removeGoogleDriveBrowser ];
    }
    else{
        userLoginStatus = kGoogleDriveUserLoginStatusLoggedIn;
        self.driveService.authorizer = authResult;
        [self listAllFiles];
    }
}

#pragma mark - nav bar customisation

- (void)addNavigationBarTitleWithCancelAndSaveButton:(NSString*)navigationTitle withLeftNavTilte:(NSString *)leftNavTitle withRightNavTitle:(NSString *)rightNavTilte {
    
    float _font = 15.0;
    
    [self addNavigationBarWithTitle:navigationTitle];
    
    navigationBarLeftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationBarLeftBtn.frame = CGRectMake(0, 0, 60, 40);
    [navigationBarLeftBtn setTitle:leftNavTitle forState:UIControlStateNormal];
    [navigationBarLeftBtn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:_font]];
    
    navigationBarLeftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [navigationBarLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBarLeftBtn addTarget:self action:@selector(gDriveCancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [self createBarButtonItemWithButton:navigationBarLeftBtn];
    
    if(rightNavTilte) {
        _navigationBarRightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navigationBarRightBtn setFrame:CGRectMake(0, 0, 60, 40)];
        [_navigationBarRightBtn setTitle:rightNavTilte forState:UIControlStateNormal];
        _navigationBarRightBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_navigationBarRightBtn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_REGULAR size:_font]];
        [_navigationBarRightBtn setTitleColor:Clr_Edit_Profile_Blue forState:UIControlStateNormal];
        [_navigationBarRightBtn addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [self createBarButtonItemWithButton:_navigationBarRightBtn];
        
    }
}
- (void)gDriveCancelButtonTapped:(id)sender{
    
    [self removeGoogleDriveBrowser];
}

- (void)addNavigationBarWithTitle:(NSString *)navigationTitle {
    self.title = navigationTitle;
    [self customizeNavigationTitleFont];
}

-(void)customizeNavigationTitleFont{
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
      [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:19.0], NSFontAttributeName,nil]];
    self.navigationController.navigationBar.translucent = NO;
    
}


-(UIBarButtonItem *)createBarButtonItemWithButton:(UIButton *)button{
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barBtnItem;
    
}

-(void) gDriveLogoutButtonClick {
    // Sign out
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemNameForGoogleDrive];
    [[self driveService] setAuthorizer:nil];
    [self removeGoogleDriveBrowser ];
    
    [self performSelector:@selector(showMessage:) withObject:@"You have been successfully logged out from Google Drive" afterDelay:1.0];
}

-(void) showMessage: (NSString *) msg{
    [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:msg animationTime:3 showAnimationDuration:0.5];
}
#pragma mark - Animator
-(void)showAnimator{
    
    if(!loader){
        
        loader = [[NGLoader alloc] initWithFrame:self.view.frame];
        
    }
    [loader showAnimation:self.view];
    
}

-(void)hideAnimator{
    
    if ([loader isLoaderAvail]){
        [loader hideAnimatior:self.view];
        loader = nil;
    }
    
}
-(void)dealloc{
    [self listenForNotification:NO];
}
-(void)listenForNotification:(BOOL)paramSwitch{
    if (paramSwitch) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedGoogleDriveNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
}
-(void)receivedGoogleDriveNotification:(NSNotification*)paramNotification{
    if (nil != paramNotification) {
        
        if ([UIApplicationWillEnterForegroundNotification isEqualToString:paramNotification.name]) {
            [self hideAnimator];
            if (googleDriveAlertView) {
                [googleDriveAlertView dismissWithClickedButtonIndex:-1234 animated:YES];
            }
            [self initSetupOfGoogleDrive];
            [self showAnimator];
        }
    }
}
@end
