//
//  NGProfileViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 29/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGProfileViewController.h"
#import "NGEditResumeViewController.h"



#import "NGBasicDetailsCell.h"
#import "NGContactsDetailCell.h"
#import "NGCVHeadlineCell.h"
#import "NGKeySkillsCell.h"
#import "NGDesiredJobCell.h"
#import "NGIndustryInfoCell.h"
#import "NGWorkExpCell.h"
#import "NGEducationCell.h"
#import "NGPersonalDetailsCell.h"
#import "NGProjectsCell.h"
#import "NGITSkillsCell.h"
#import "NGCVCell.h"
#import "NGProfileSectionHeaderCell.h"
#import "NGAddNewItemCell.h"
#import "NGProfileWorkExpCell.h"
#import "NGProfileEducationCell.h"
#import "NGProfileProjectCell.h"
#import "NGHelpTextCell.h"




#define K_MY_PROFILE_HEADING @"My Profile"


typedef enum
{
    PPG=0,
    PG,
    UG
    
}courseType;




@interface NGProfileViewController ()
{
    NSDate *profileEndTime;
    UIRefreshControl *refreshControl;
    
    BOOL isResumeAvailable;
    NSString *resumeFormat;
    NSMutableDictionary *heightsArray;   // For caching heights
    BOOL isheightCached;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

/**
 *  Message to be displayed on receiving notification for profile update.
 */
@property (strong, nonatomic) NSString* notifyText;

/**
 *  Set to Yes when profile page is opened on clicking the push notification.
 */
@property (nonatomic) BOOL isPushNotified;

/**
 *  Saves the object of basic detail cell for setting the profile photo.
 */
@property (strong, nonatomic) NGBasicDetailsCell *basicDetailCell;

/**
 *  Maintains profile data fetched locally or from the server.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *usrDetailsObj;

@end

@implementation NGProfileViewController

#pragma mark - ViewController Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _autoLandingSection = NONE_SECTION;
    }
    return self;
}

- (void)viewDidLoad
{
    [AppTracer traceStartTime:TRACER_ID_PROFILE];
    
    [super viewDidLoad];
    heightsArray = [NSMutableDictionary dictionary];
    [self addNavigationBarWithTitleAndHamBurger:K_MY_PROFILE_HEADING];
    
    if(_showBackButton){
        [self changeHamburgerToBackButton];
    }

    
    _tableview.hidden = YES;
    [_tableview setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self getUserProfile];

    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchUserProfile) forControlEvents:UIControlEventValueChanged];
    [_tableview addSubview:refreshControl];


    self.isSwipePopDuringTransition = NO;
    self.isSwipePopGestureEnabled = YES;
    


}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.isSwipePopDuringTransition)
        return;
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshuserdata" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"photoUpdated" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUserProfile:) name:@"refreshuserdata" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePhoto:) name:@"photoUpdated" object:nil];
    
}
-(void)updatePhoto:(NSNotification*)notif{
    [self showProfilePic];

}
-(void)viewDidAppear:(BOOL)animated
{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewDidAppear:animated];
    [self viewPropertiesChanged];
    
    [NGHelper sharedInstance].appState = APP_STATE_PROFILE;
    [NGGoogleAnalytics sendScreenReport:K_GA_MNJ_PROFILE_SCREEN];
    [[NGNotificationWebHandler sharedInstance] resetNotifications:KEY_BADGE_TYPE_PU];
    [NGSavedData saveBadgeInfo:KEY_BADGE_TYPE_PU withBadgeNumber:0];
    
    if (CV == self.autoLandingSection) {
        self.autoLandingSection = NONE_SECTION;
        
        NSIndexPath* indexPathScroll = [NSIndexPath indexPathForRow:0 inSection:CV];
        [self.tableview scrollToRowAtIndexPath:indexPathScroll atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self editResumeButtonPressed:nil];
    }
    
    [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_PROFILE withModel:nil]];
    
    [self setAutomationLabel];
}
-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:@"myProfile_table" forUIElement:self.tableview withAccessibilityEnabled:NO];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hideAnimator];
    
    [AppTracer clearLoadTime:TRACER_ID_PROFILE];
}
#pragma mark Memory Management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshuserdata" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"photoUpdated" object:nil];
    
    [[NGDeepLinkingHelper sharedInstance] setDeeplinkingPage:NGDeeplinkingPageNone];
    
    _usrDetailsObj = nil;
    _tableview.delegate = nil;
    _tableview.dataSource = nil;
    _tableview =    nil;
    _notifyText = nil;
    _basicDetailCell = nil;
    _profileStartTime = nil;
    
    [super releaseMemory];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods

-(void)viewPropertiesChanged{
 
    [self performSelector:@selector(scrollToRelevantSection) withObject:nil afterDelay:0.5];
    
}

-(void)scrollToRelevantSection{
    NSInteger row = _scrollToIndex-1;
    if (0 < _scrollToIndex) {
        switch (_scrollToIndex+1) {
            case CV:
                [self scrollToBottom];
                break;
            default:
            {
                NSIndexPath* indexPathScroll = [NSIndexPath indexPathForRow:0 inSection:row];
                [_tableview scrollToRowAtIndexPath:indexPathScroll atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            break;
        }
        _scrollToIndex = 0;
    }
}
- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    if (_tableview.contentSize.height > _tableview.bounds.size.height) {
        yOffset = _tableview.contentSize.height - _tableview.bounds.size.height;
    }
    [_tableview setContentOffset:CGPointMake(0, yOffset) animated:YES];
}
/**
 *  Gets profile data locally or from the server.
 */
-(void)getUserProfile{
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    
    if (objModel) {
        _usrDetailsObj = objModel;
        [_usrDetailsObj createEducationList];
        [self displayUserProfile];
    }else{
        [self showAnimator];
    }
    
        [self fetchUserProfile];
}

/**
 *  Fetch profile data from the server.
 */
-(void)fetchUserProfile{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"fullCv",@"lastModTimeStamp",@"photoMetadata",@"attachedCvFormat",@"currentWorkExperience", nil],@"fields", nil];
    
    
    __weak NGProfileViewController* mySelf = self;
    __weak UIRefreshControl *weakRf = refreshControl;
    __block NSDate *weakEndDate = profileEndTime;
    
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_USER_DETAILS];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
      
        
        if (responseInfo.isSuccess) {
            
            weakEndDate=[NSDate date];
            NSString* notifyMsg=[[NGSavedData  getProfileNotificationUpdate] valueForKey:@"alert"];
            notifyMsg=[notifyMsg stringByReplacingOccurrencesOfString:@"Naukrigulf: " withString:@""];
            if(notifyMsg.length>0)
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [NGMessgeDisplayHandler showSuccessBannerFromBottom:mySelf.view title:@"" subTitle:notifyMsg animationTime:7 showAnimationDuration:0.5];
                    
                });
                
                
                [NGSavedData  saveProfileNotificationUpdate:[NSDictionary dictionary]];
            }
            
            NSDictionary* responseDataDict = responseInfo.parsedResponseData;
            NSString *statusStr = [responseDataDict objectForKey:KEY_USER_DETAILS_STATUS];
            if ([statusStr isEqualToString:@"success"]) {
                NGMNJProfileModalClass *obj = [responseDataDict objectForKey:KEY_USER_DETAILS_INFO];
                
                //Also check whether we have profile in db or not
                //if not then allow ui update with new data from API
                NGStaticContentManager *contentManager = [DataManagerFactory getStaticContentManager];
                NGMNJProfileModalClass *profileObjectModel = [contentManager getMNJUserProfile];
                
                if (nil==profileObjectModel || [mySelf isProfileModifiedWithDate:obj.lastModTimeStamp] || [self isProfilePhotoModifiedWithData:obj.photoMetaData]) {
                    mySelf.usrDetailsObj = obj;
                    
                    [mySelf.usrDetailsObj createEducationList];
                    
                    [contentManager saveMNJUserProfile:mySelf.usrDetailsObj];
                    
                    
                    profileObjectModel = nil;
                    contentManager = nil;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mySelf displayUserProfile];
                        [AppTracer traceEndTime:TRACER_ID_PROFILE];
                    });
                    
                    
                }
            }
            
            [NGGoogleAnalytics sendLoadTime:[weakEndDate timeIntervalSinceDate:mySelf.profileStartTime] withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:K_GA_EVENT_PROFILE withTimngLabel:@"success"];
            
        }else{
            
            weakEndDate=[NSDate date];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!responseInfo.isNetworFailed) {
                   
                    [NGDecisionUtility checkForSessionExpire:responseInfo.responseCode];
                }
                
            });
            
            
            [NGGoogleAnalytics sendLoadTime:[weakEndDate timeIntervalSinceDate:mySelf.profileStartTime] withCategory:K_GA_EVENT_CATEGORY_SERVICE_CALL withEventName:K_GA_EVENT_PROFILE withTimngLabel:@"Failure"];
            
        }
                
        dispatch_async(dispatch_get_main_queue(), ^{
            if([weakRf isRefreshing])
                [weakRf endRefreshing];
            [mySelf hideLoader];
        });
        
        
    }];
}

/**
 *  Display profile data.
 */
-(void)displayUserProfile{
    
    _tableview.hidden = NO;
    isheightCached = NO;
    [_tableview reloadData];
    isheightCached = YES;
    [self downloadUpdatedPhoto];
}

/**
 *  Fetch profile photo from the server.
 */
-(void)getUserProfilePhoto{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:BASIC_DETAILS inSection:0];
    
    _basicDetailCell = (NGBasicDetailsCell*)[_tableview cellForRowAtIndexPath:indexPath];
    _basicDetailCell.editPhotoBtn.enabled = NO;
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_PROFILE_PHOTO];
    
    __weak typeof(self) weakSelf = self;
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseInfo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf hideLoader];
            
            weakSelf.basicDetailCell.editPhotoBtn.enabled = YES;
            [weakSelf showProfilePic];
            
            if (!responseInfo.isSuccess && !responseInfo.isNetworFailed) {
               
                [NGDecisionUtility checkForSessionExpire:responseInfo.responseCode];
            }
            
            
            
        });
        
    }];
}

/**
 *  Download profile photo from the server if it is modified.
 */
-(void)downloadUpdatedPhoto{
    NSDictionary *dict = [NGSavedData getUserDetails];
    NSString *oldDate = [dict objectForKey:@"photoUploadDate"];
    
    NSDictionary *photoMetaDataDict = _usrDetailsObj.photoMetaData;
    NSString *photoUploadDate = @"";
    if ([self isValidPhotoMetaDataDic:photoMetaDataDict]) {
        photoUploadDate = [photoMetaDataDict objectForKey:@"uploadDate"];
        
        if (![oldDate isEqualToString:photoUploadDate]) {
            [NGSavedData saveUserDetails:@"photoUploadDate" withValue:photoUploadDate];
            
            [self performSelector:@selector(getUserProfilePhoto) withObject:nil afterDelay:0.4f];
        }
    }else{
        [NGSavedData saveUserDetails:@"photoUploadDate" withValue:@""];
    }
    
}
-(BOOL)isValidPhotoMetaDataDic:(NSDictionary*)paramPhotoMetaDataDic{
    BOOL isValidFlag = NO;
    if (nil != paramPhotoMetaDataDic) {
        
        ValidatorManager *vManager = [ValidatorManager sharedInstance];
        
        BOOL isValidFileName = (0 >= [vManager validateValue:[paramPhotoMetaDataDic objectForKey:@"filename"] withType:ValidationTypeString].count);
        BOOL isValidExtension = (0 >= [vManager validateValue:[paramPhotoMetaDataDic objectForKey:@"extension"] withType:ValidationTypeString].count);
        BOOL isValidUploadDate = (0 >= [vManager validateValue:[paramPhotoMetaDataDic objectForKey:@"uploadDate"] withType:ValidationTypeString].count);
        
        if (isValidFileName && isValidExtension && isValidUploadDate) {
            isValidFlag = YES;
        }
        
        vManager = nil;
    }
    return isValidFlag;
}
/**
 *  Display success message on the top after profile gets edited.
 *
 *  @param timer <#timer description#>
 */
-(void)showUpdateMessage:(NSTimer *)timer{
    [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Your profile has been successfully updated " animationTime:3 showAnimationDuration:0];
    
      [NGUIUtility showRateUsView];
}

/**
 *  Check if profile data is modified.
 *
 *  @param modDate modified date of profile fetched from the server.
 *
 *  @return Return TRUE if profile is modified.
 */
-(BOOL)isProfileModifiedWithDate:(NSString *)modDate{
    BOOL isModified = FALSE;
    
    NSDictionary *dict = [NGSavedData getUserDetails];
    NSString *oldModDate = [dict objectForKey:@"profileModifiedTimeStamp"];
    
    if (!oldModDate || ![oldModDate isEqualToString:modDate]) {
        [NGSavedData saveUserDetails:@"profileModifiedTimeStamp" withValue:modDate];
        isModified = TRUE;
    }
    
    return isModified;
}

/*
 Profile photo updated check method
 */
-(BOOL)isProfilePhotoModifiedWithData:(NSDictionary *)profilePhotoMetaData{
    BOOL isModified = FALSE;
    
    NSString *modDate = [profilePhotoMetaData objectForKey:@"uploadDate"];
    
    NSDictionary *dict = [NGSavedData getUserDetails];
    NSString *oldModDate = [[dict objectForKey:@"photoMetadata"] objectForKey:@"uploadDate"];
    
    if (!oldModDate || ![oldModDate isEqualToString:modDate]) {
        isModified = TRUE;
    }
    
    if (NO == [self isValidPhotoMetaDataDic:profilePhotoMetaData]) {
        //delete cached profile photo
        [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME];
    }
    
    return isModified;
}

#pragma mark Notification Methods

/**
 *  Refresh profile data on notified after editing.
 *
 *  @param notification the notification.
 */
-(void)refreshUserProfile:(NSNotification*)notification{
    
    [self showAnimator];
    [self fetchUserProfile];
    [self performSelector:@selector(showUpdateMessage:) withObject:nil afterDelay:1.5];
    
}
#pragma mark JobManager Delegate
-(void)hideLoader{
    [self hideAnimator];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 12; // 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger noOfRows = 0;
    switch (section) {
        case BASIC_DETAILS:
            noOfRows = 1;
            break;
        case CONTACT_DETAILS:
            noOfRows = 1;
            break;
        case CV_HEADLINE:
            noOfRows = 1;
            break;
        case KEY_SKILLS:
            noOfRows = 1;//key skill + add new item
            break;
        case INDUSTRY_INFO:
            noOfRows = 1;
            break;
        case WORK_EXPERIENCE:{//header cell + add new item + n work exp cells
            NSInteger workExpItemCount = [_usrDetailsObj.workExpList count];
            noOfRows = 2+workExpItemCount;
        }
            break;
        case EDUCATION:{//header cell + add new item[depends] + n work exp cells
            NSInteger  educationItemCount= [_usrDetailsObj.educationList count];
            NSString *addCourseTypeTmp = _usrDetailsObj.addCourseType;
            
            noOfRows = 1+educationItemCount;
            
            if ([addCourseTypeTmp isEqualToString:@"ppg"] || [addCourseTypeTmp isEqualToString:@"pg"] || [addCourseTypeTmp isEqualToString:@"ug"]) {
                noOfRows = 2+educationItemCount;//means add new item will also be needed
            }
        }
            break;
        case PERSONAL_DETAILS:
            noOfRows = 1;
            break;
        case DESIRED_JOB:
            noOfRows = 1;
            break;
        case PROJECTS:{//header cell + add new item + n work exp cells+help text
            NSInteger projectsItemCount = [_usrDetailsObj.projectsList count];
            noOfRows = 2+projectsItemCount;//help text cell
        }
            break;
        case IT_SKILLS:
            noOfRows = 1;
            break;
        case CV:
            noOfRows = 1;
            break;
            
        default:
            break;
    }
    return noOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self configureCell:indexPath];
}
-(void)showProfilePic{
    NSString *imageURL = [NSString getProfilePhotoPath];
    [_basicDetailCell.profileImg setImageWithLocalURL:imageURL];
    [_basicDetailCell.profileImg cropImageCircularWithBorderWidth:5.0f borderColor:[UIColor whiteColor]];
}
-(UITableViewCell *)configureCell:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case BASIC_DETAILS:{
            
            static NSString *CellIdentifier = @"BasicDetailsCell";
            
            NGBasicDetailsCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            _basicDetailCell = cell;
            [self showProfilePic];
            [NGSavedData saveUserDetails:@"modifiedDate" withValue:_usrDetailsObj.profileModifiedDate];
            [cell customizeUIWithModel:_usrDetailsObj];
            return cell;
            
            break;
        }
            
        case CONTACT_DETAILS:{
            static NSString *CellIdentifier = @"ContactsDetailCell";
            
            NGContactsDetailCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell customizeUIWithModel:_usrDetailsObj];
            return cell;
            
            break;
        }
            
        case CV_HEADLINE:{
            static NSString *CellIdentifier = @"CVHeadlineCell";
            
            NGCVHeadlineCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.modalClassObj = _usrDetailsObj;
            [cell customizeUI];
            return cell;
            
            break;
        }
            
        case KEY_SKILLS:{
            static NSString *CellIdentifier = @"KeySkillsCell";
            
            NGKeySkillsCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.modalClassObj = _usrDetailsObj;
            [cell customizeUI];
            return cell;
            
            break;
        }
            
        case DESIRED_JOB:{
            static NSString *CellIdentifier = @"DesiredJobCell";
            
            NGDesiredJobCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.modalClassObj = _usrDetailsObj;
            [cell customizeUI];
            
            return cell;
            
            break;
        }
        
        case INDUSTRY_INFO:{
            static NSString *CellIdentifier = @"IndustryInfoCell";
            
            NGIndustryInfoCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            cell.modalClassObj = _usrDetailsObj;
            [cell customizeUI];
            
            return cell;
            
            break;
        }
            
        case WORK_EXPERIENCE:{
            NSInteger itemRow = [indexPath row];
            if (0 == itemRow) {
                //header cell
                static NSString *CellIdentifier = @"profileSectionHeaderCellIdentifier";
                
                NGProfileSectionHeaderCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                
                [cell customizeUIWithData:@"Work Experience"];
                if([_usrDetailsObj.workExpList count] >0)
                    cell.redDot.hidden = YES;
                else
                    cell.redDot.hidden = NO;

                [UIAutomationHelper setAccessibiltyLabel:@"redDot_WorkExperience" value:@"redDot_WorkExperience" forUIElement:cell.redDot];

                return cell;
                
            }else if (itemRow <= [_usrDetailsObj.workExpList count]){
                //work exp data cell
                static NSString *CellIdentifier = @"profileWorkExpCellIdentifier";
                
                NGProfileWorkExpCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                
                NSInteger itemIndex = itemRow - 1;
                NGWorkExpDetailModel *workExpItemDataObject = [_usrDetailsObj.workExpList fetchObjectAtIndex:itemIndex];
                
                [cell setWorkExpData:workExpItemDataObject AndIndex:itemIndex];
                
                return cell;
                
            }else{
                //add new item cell
                static NSString *CellIdentifier = @"addNewItemCellIdentifier";
                
                NGAddNewItemCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                
                [cell customizeUIWithData:@"Add Work Experience" andTagValue:WORK_EXPERIENCE];

                return cell;
            }
            
            break;
        }
            
        case EDUCATION:{
            NSInteger itemRow = [indexPath row];
            if (0 == itemRow) {
                //header cell
                static NSString *CellIdentifier = @"profileSectionHeaderCellIdentifier";
                
                NGProfileSectionHeaderCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                [cell customizeUIWithData:@"Education"];
                if([_usrDetailsObj.educationList count] >0)
                    cell.redDot.hidden = YES;
                else
                    cell.redDot.hidden = NO;
                
                [UIAutomationHelper setAccessibiltyLabel:@"redDot_Education" value:@"redDot_Education" forUIElement:cell.redDot];

                return cell;
                
            }else if (itemRow <= [_usrDetailsObj.educationList count]){
                
                //Education data cell
                static NSString *CellIdentifier = @"profileEducationCellIdentifier";
                NGProfileEducationCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                [cell setEducationDataWithModel:_usrDetailsObj andIndex:itemRow - 1];
                return cell;
                
            }else{
                //add new item cell
                static NSString *CellIdentifier = @"addNewItemCellIdentifier";
                NGAddNewItemCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                NSString *addCourseTypeTmp = _usrDetailsObj.addCourseType;
                NSString *strTopass = @"";
                switch ([self getCourseTypeEnum:addCourseTypeTmp]) {
                    case PPG:
                    {
                        strTopass =@"Add Doctorate Education";
                        
                    }
                        break;
                    case UG:
                    {
                        strTopass =@"Add Basic Education";


                    }
                        break;
                    case PG:
                    {
                        strTopass =@"Add Master Education";

                    }
                        break;
                        
                    default:
                        break;
                }
                [cell customizeUIWithData:strTopass andTagValue:EDUCATION];
                cell.infoData = @{@"addCourseType":addCourseTypeTmp};
                return cell;
            }
            
            break;
        }
            
        case PERSONAL_DETAILS:{
            static NSString *CellIdentifier = @"PersonalDetailsCell";
            
            NGPersonalDetailsCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.modalClassObj = _usrDetailsObj;
            [cell customizeUI];

            return cell;
            
            break;
        }
            
        case PROJECTS:{
            NSInteger itemRow = [indexPath row];
            if (0 == itemRow) {
                //header cell
                static NSString *CellIdentifier = @"profileSectionHeaderCellIdentifier";
                
                NGProfileSectionHeaderCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                [cell customizeUIWithData:@"Projects"];
                if([_usrDetailsObj.projectsList count] >0)
                    cell.redDot.hidden = YES;
                else
                    cell.redDot.hidden = NO;
                [UIAutomationHelper setAccessibiltyLabel:@"redDot_Projects" value:@"redDot_Projects" forUIElement:cell.redDot];

                return cell;
                
            }else if (itemRow <= [_usrDetailsObj.projectsList count]){
                //work exp data cell
                static NSString *CellIdentifier = @"profileProjectCellIdentifier";
                
                NGProfileProjectCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                NGProjectDetailModel *projectItemDataObject = [_usrDetailsObj.projectsList fetchObjectAtIndex:(itemRow - 1)];
                [cell setProjectData:projectItemDataObject AndIndex:(itemRow - 1)];
                return cell;
                
            }else{
                //add new item cell
                static NSString *CellIdentifier = @"helpTextCellIdentifier";
                
                NGHelpTextCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
                [cell configureCell:@"(You can update Projects from Desktop site)"];
                
                
                return cell;
            }
            break;
        }
            
        case IT_SKILLS:{
            static NSString *CellIdentifier = @"ITSkillsCell";
            
            NGITSkillsCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            cell.skillsArr = _usrDetailsObj.IT_SkillsList;
            [cell configureCell];
            
            return cell;
            
            break;
        }
            
        case CV:{
            static NSString *CellIdentifier = @"CVCell";
            
            NGCVCell *cell = [_tableview dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (0>=[[ValidatorManager sharedInstance] validateValue:_usrDetailsObj.attachedCvFormat withType:ValidationTypeString].count) {
                resumeFormat = _usrDetailsObj.attachedCvFormat;
                isResumeAvailable = YES;
                [cell configureCellWithData:_usrDetailsObj];
                
            }else{
                //no resume found view
                [cell configureCellWithoutData];
            }
            
            return cell;
            break;
        }
            
        default:
            break;
    }
    
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    [cell.contentView updateConstraints];
    return cell;
}
-(IBAction)editResumeButtonPressed:(id)sender{
  
    NGEditResumeViewController *editResumeVc = (NGEditResumeViewController*)[[NGHelper sharedInstance].genericStoryboard instantiateViewControllerWithIdentifier:@"editResumeVCIdentifier"];
    [NGHelper sharedInstance].resumeFormat = resumeFormat;
    [editResumeVc setUploadOrDownload:isResumeAvailable];

    [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:editResumeVc Animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat height = 0.0f;
    if(isheightCached)
     height = [self cachedHeightForIndexPath:indexPath];
    // Not cached ?
    if (height <= 0)
        height = [self heightForIndexPath:indexPath];
    return height;

}
-(CGFloat)heightForIndexPath:(NSIndexPath*)indexPath{
    float height = 87;
    NSInteger section = [indexPath section];
    
    switch (section) {
        case BASIC_DETAILS:{
            NGBasicDetailsCell *cell = (NGBasicDetailsCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case CONTACT_DETAILS:{
            NGContactsDetailCell *cell = (NGContactsDetailCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case CV_HEADLINE:{
            NGCVHeadlineCell *cell = (NGCVHeadlineCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case KEY_SKILLS:{
            NGKeySkillsCell *cell = (NGKeySkillsCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case DESIRED_JOB:{
            NGDesiredJobCell *cell = (NGDesiredJobCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case INDUSTRY_INFO:{
            NGIndustryInfoCell *cell = (NGIndustryInfoCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case WORK_EXPERIENCE:{
            NGWorkExpCell *cell = (NGWorkExpCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];

            NSInteger itemRow = [indexPath row];
            if(itemRow!=0&&(!(itemRow <= [_usrDetailsObj.workExpList count])))
                height = 56;
            break;
        }
            
        case EDUCATION:{
            NGEducationCell *cell = (NGEducationCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case PERSONAL_DETAILS:{
            NGPersonalDetailsCell *cell = (NGPersonalDetailsCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case PROJECTS:{
            NGProjectsCell *cell = (NGProjectsCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case IT_SKILLS:{
            NGITSkillsCell *cell = (NGITSkillsCell*)[self configureCell:indexPath];
            height = [UITableViewCell getCellHeight:cell];
            break;
        }
            
        case CV:{
            
//            NGCVCell *cell = (NGCVCell*)[self configureCell:indexPath];
//            height = [UITableViewCell getCellHeight:cell];
            height = 140;
            break;
        }
            
        default:
            break;
    }
    height = ceil(height);
    if((indexPath.section != PROJECTS)&&(indexPath.section != EDUCATION)&&(indexPath.section != WORK_EXPERIENCE))
    [heightsArray setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];
    else{
    
        if([[heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]] isKindOfClass:[NSMutableDictionary class]])
        {
        
            NSMutableDictionary *dict = [heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];
            [dict setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        
        }
        else{
        [heightsArray setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:height],[NSString stringWithFormat:@"%ld", (long)indexPath.row] ,nil] forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];
        }
    }

    return height;
}
-(CGFloat)cachedHeightForIndexPath:(NSIndexPath*)indexPath{
    float height = 0.0f;
    if((indexPath.section != PROJECTS)&&(indexPath.section != EDUCATION)&&(indexPath.section != WORK_EXPERIENCE))
    {
    if([heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]])
    {
        NSNumber *num = [heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];
        height = num.floatValue;
    }
    }
    else{
    
    if([[heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]] isKindOfClass:[NSMutableDictionary class]])
    {
        NSNumber *num = [[heightsArray objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]] objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        height = num.floatValue;
    }
    }
    return height;
}

- (courseType) getCourseTypeEnum:(NSString*)addCourseTypeTmp {
    
        courseType result = 0;
        if ([addCourseTypeTmp isEqualToString:@"ppg"]) {
            result = PPG;
        }else if ([addCourseTypeTmp isEqualToString:@"pg"]) {
            result = PG;
        }
        else  if ([addCourseTypeTmp isEqualToString:@"ug"]) {
            result = UG;
        }
    
    return result;
}
@end
