//
//  NGSpotlightSearchHelper.m
//  NaukriGulf
//
//  Created by Arun on 11/18/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "NGSpotlightSearchHelper.h"
#import "NGSRPViewController.h"
#import "NGJobAnalyticsViewController.h"
#import "NGShortlistedJobsViewController.h"
#import "NGResmanLoginDetailsViewController.h"
#import "NGSpotLightModel.h"



#import "NGWhoViewedMyCVViewController.h"
#import "NGProfileViewDetails.h"


@interface NGSpotlightSearchHelper(){
    
    int jobAnalyticsPageIndex;
    NSUserActivity *activity;
    //NSString* jobIdForJD;
}

@end

@implementation NGSpotlightSearchHelper

+(NGSpotlightSearchHelper *)sharedInstance{
    
    static NGSpotlightSearchHelper *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGSpotlightSearchHelper alloc]init];
    });
    return sharedInstance;
}

-(instancetype)init{
    if (self) {
        
        _spotlightAppPage = NGSpotlightPageNone;
        _spotlightAppState = NGSpotlightAppStateNone;
        jobAnalyticsPageIndex = 1;
        [self listenAppStateNotificationForSpotlight];

    }
    return self;
}


-(void)listenAppStateNotificationForSpotlight{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSpotlightAppNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
  
}

-(void)handleSpotlightAppNotification:(NSNotification*)notification{
    
    if (nil != notification && nil != notification.name) {
        
        if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification])
            _spotlightAppState = NGSpotlightAppStateNone;
       
        
    }
}
-(void)setSpotlightConfigFromLaunchOption:(NSDictionary*)paramLaunchOption{
    
    if (SYSTEM_VERSION_LESS_THAN(@"9.0"))
        return;
    //value will be like "com.apple.corespotlightitem"
    NSString* spotlightItem = [[paramLaunchOption objectForKey:UIApplicationLaunchOptionsUserActivityDictionaryKey] objectForKey:UIApplicationLaunchOptionsUserActivityTypeKey];
    if (spotlightItem.length || spotlightItem!= nil)
        _spotlightAppState = NGSpotlightAppStateLaunch;
    else
        _spotlightAppState = NGSpotlightAppStateNone;

}

-(void)handleSpotlightItemClick{
    
    if (SYSTEM_VERSION_LESS_THAN(@"9.0"))
        return;
    
    if (_spotlightAppState == NGSpotlightAppStateLaunch  && _spotlightUserActivity != nil)
        [self goToMNJ:NO];
    
    [self performSpotlightItmeClick];
}


-(void)performSpotlightItmeClick{
    
    NSString* identifier = _spotlightUserActivity.userInfo[CSSearchableItemActivityIdentifier];
    NSArray* arrIdentifiers = [identifier componentsSeparatedByString:@"."];
    NSString* landingPage = [arrIdentifiers firstObject];

    
    if([landingPage isEqualToString:K_SPOTLIGHT_SRP])
        [self navigateToSrpWithParams:arrIdentifiers];
    
    else if ([landingPage isEqualToString:K_SPOTLIGHT_SHORTLISTED_JOBS]){
        
        jobAnalyticsPageIndex = 1;
        [self navigateToJobAnalytics:K_SPOTLIGHT_SHORTLISTED_JOBS];
    }
    else if ([landingPage isEqualToString:K_SPOTLIGHT_RECOMMENDED_JOBS]){
        
        jobAnalyticsPageIndex = 2;
        [self navigateToJobAnalytics:K_SPOTLIGHT_RECOMMENDED_JOBS];
    }

    else if ([landingPage isEqualToString:K_SPOTLIGHT_APPLIED_JOBS]){
        
        jobAnalyticsPageIndex = 3;
        [self navigateToJobAnalytics: K_SPOTLIGHT_APPLIED_JOBS];
    }
    else if ([landingPage isEqualToString:K_SPOTLIGHT_CV_VIEW])
        [self navigateToCVView];
    
    else if ([landingPage isEqualToString:K_SPOTLIGHT_PROFILE])
        [self navigateToProfilePage];
    
    else if ([landingPage isEqualToString:K_SPOTLIGHT_REGISTRATION]){
        
        [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGResmanLoginDetailsViewController"];
        NGResmanLoginDetailsViewController *resmanVc = [[NGResmanLoginDetailsViewController alloc] initWithNibName:nil bundle:nil];
        [APPDELEGATE.container.centerViewController pushActionViewController:resmanVc Animated:NO];
    }
    else if ([landingPage isEqualToString:K_SPOTLIGHT_SEARCH]){
        
        [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGSearchJobsViewController"];
        NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
        [appStateHandler setDelegate:self];
        [appStateHandler setAppState:APP_STATE_JOB_SEARCH usingNavigationController:APPDELEGATE.container.centerViewController animated:NO];
    }
 
    else if ([landingPage isEqualToString:K_SPOTLIGHT_HOME]){
        
        if (![NGHelper sharedInstance].isUserLoggedIn){
            
            NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
            [appStateHandler setDelegate:self];
            [(IENavigationController*)APPDELEGATE.container.centerViewController popToRootViewControllerAnimated:NO];
        }
        else{
        
            [self goToMNJ:NO];
        }
        [NGSpotlightSearchHelper sharedInstance].isComingFromSpotlightSearch = NO;
        
    }
    
    /*else if([landingPage isEqualToString:K_SPOTLIGHT_JOB_DESCRIPTION])
    {
        jobIdForJD = [arrIdentifiers lastObject];
        [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGJDParentViewController"];
        [[NGAppStateHandler sharedInstance] setDelegate:self];
        [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JD usingNavigationController:APPDELEGATE.container.centerViewController animated:NO];
    }*/
    
     [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_ACTION_SPOTLIGHT_LAND  withEventLabel:landingPage withEventValue:nil];
}


#pragma mark Page Navigations
-(void)goToMNJ:(BOOL)isAnimated{
    
    if ([NGHelper sharedInstance].isUserLoggedIn) {

        [[NGAppStateHandler sharedInstance] setDelegate:self];
        [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:isAnimated];
    }
}
-(void)navigateToSrpWithParams:(NSArray*)srpData{
   
    NGAppDelegate* delegate = [NGAppDelegate appDelegate];
    
    NSString *concatenatedStr = @"";
    
    if(srpData.count == 3)
        concatenatedStr =[srpData objectAtIndex:1];
   
    
    NSArray* searchParams = [concatenatedStr componentsSeparatedByString:@"_"];
    NSString* strKeyword = [searchParams fetchObjectAtIndex:0];
    NSString* strLocation = [searchParams fetchObjectAtIndex:1];
    NSInteger iExperience = [[searchParams fetchObjectAtIndex:2] integerValue];
    
    if (!strKeyword)
        strKeyword = @"";
    
    if (!strLocation)
        strLocation = @"";
    
    if (!iExperience)
        iExperience = 99;
    
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JOB_SEARCH usingNavigationController:delegate.container.centerViewController animated:NO];
    
    NGRescentSearchTuple *searchTuple = [[NGRescentSearchTuple alloc] init];
    searchTuple.keyword = [strKeyword trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchTuple.location = [strLocation trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchTuple.location = [self clearLocationStringFromString:searchTuple.location];
    searchTuple.experience =[NSNumber numberWithInteger:iExperience];
    [NGSavedData saveSearchedJobCriteria:searchTuple];

    
    NGSRPViewController *_navgationController = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"SRPView"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:0] forKey:@"Offset"];
    [params setObject:[NSNumber numberWithInteger:[NGConfigUtility getJobDownloadLimit]] forKey:@"Limit"];
    [params setObject:strKeyword forKey:@"Keywords"];
    [params setObject:strLocation forKey:@"Location"];
    [params setObject:[NSNumber numberWithInteger:iExperience] forKey:@"Experience"];
    _navgationController.paramsDict = params;
    
    [((IENavigationController*)delegate.container.centerViewController)
                                    pushActionViewController:_navgationController Animated:YES];
    
    params = nil;

    }
- (NSString*)clearLocationStringFromString:(NSString*)loc{
    NSInteger locLength = [loc length];
    if (loc && 2<locLength && [[loc substringFromIndex:locLength-2] isEqualToString:@", "]) {
        return [loc substringToIndex:locLength-2];
    }
    return loc;
}

-(void)navigateToJobAnalytics:(NSString*)screenName{
    
    if (![NGHelper sharedInstance].isUserLoggedIn){
        
        if ([screenName isEqualToString:K_SPOTLIGHT_SHORTLISTED_JOBS]) {
            
            NGShortlistedJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobsForYouStoryboard instantiateViewControllerWithIdentifier:@"ShortlistedJobsView"];
            
            [((IENavigationController*)APPDELEGATE.container.centerViewController) pushActionViewController:navgationController_ Animated:YES];
            
        }else if ([screenName isEqualToString:K_SPOTLIGHT_APPLIED_JOBS] ||
                  [screenName isEqualToString:K_SPOTLIGHT_RECOMMENDED_JOBS]){
            
           
            NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
            [appStateHandler setDelegate:self];
            [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:YES];
        }
        return;
    }
    
    NGAppDelegate* delegate = [NGAppDelegate appDelegate];

    [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGLoginViewController"];
    [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGJobAnalyticsViewController"];
    
    [[NGAppStateHandler sharedInstance] setDelegate:self];
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_MNJ_ANALYTICS
                    usingNavigationController:((IENavigationController*)delegate.container.centerViewController) animated:NO];
}
-(void)navigateToCVView{
    
    if (![NGHelper sharedInstance].isUserLoggedIn){
        
            NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
            [appStateHandler setDelegate:self];
            [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:YES];
        
        return;
    }
    
    NGAppDelegate* delegate = [NGAppDelegate appDelegate];
    
    [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGLoginViewController"];
    [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGWhoViewedMyCVViewController"];
    
    [[NGAppStateHandler sharedInstance] setDelegate:self];
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_PROFILE_VIEWER
                    usingNavigationController:((IENavigationController*)delegate.container.centerViewController) animated:NO];
    
}
-(void)navigateToProfilePage{
    
    if (![NGHelper sharedInstance].isUserLoggedIn){
        
        NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
        [appStateHandler setDelegate:self];
        [appStateHandler setAppState:APP_STATE_LOGIN usingNavigationController:[NGAppDelegate appDelegate].container.centerViewController animated:YES];
        
        return;
    }
    
    [NGUIUtility removeViewControllerFromVCStackOfTypeName:@"NGProfileViewController"];
    NGAppStateHandler *appStateHandler = [NGAppStateHandler sharedInstance];
    [appStateHandler setDelegate:self];
    [appStateHandler setAppState:APP_STATE_PROFILE usingNavigationController:
                                                    APPDELEGATE.container.centerViewController animated:NO];
}

-(void)setPropertiesOfVC:(id)vc{
    
    if([vc isKindOfClass:[NGJobAnalyticsViewController class]])
    {
        NGJobAnalyticsViewController* jaVC = (NGJobAnalyticsViewController*)vc;
        jaVC.selectedTabIndex = jobAnalyticsPageIndex;
    }
    else if([vc isKindOfClass:[NGLoginViewController class]])
    {
        NGLoginViewController* viewC = (NGLoginViewController*)vc;
        
        [viewC showViewWithType:LOGINVIEWTYPE_REGISTER_VIEW];
        [viewC setTitleForLoginView:@"Job Seeker Login"];
    }
   /* else if([vc isKindOfClass:[NGJDParentViewController class]])
    {
        NGJDParentViewController *jdVC = (NGJDParentViewController*)vc;
        NGJobDetails* jobObj = [[NGJobDetails alloc]init];
        
        jobObj.jobID = jobIdForJD;
        jobObj.isInitiatedFromSpotlight  = YES;
        jdVC.allJobsArr = [NSMutableArray arrayWithObject:jobObj];
        jdVC.selectedIndex = 0;
        
    }
    */
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
    
}

/*
-(void)deleteSearchableIndexHavingId:(NSString*)idToDelete{
}
 */

#pragma mark - Set Spotlight data
-(NGSpotLightModel*)getSpotlightModelForVC:(SPOTLIGHT_PAGES)pageId withModel:(id)param{
    if (SYSTEM_VERSION_LESS_THAN(@"9.0"))
        return nil;

    NGSpotLightModel *model = [[NGSpotLightModel alloc] init];
    
    switch (pageId) {
        case V_SPOTLIGHT_HOME:
        {
            model.keywords = @"Naukrigulf home, naukrigulf";
            model.title = @"My Naukrigulf Home";
            model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_HOME_PAGE;
            model.spotlightId = K_SPOTLIGHT_HOME;
            model.page = V_SPOTLIGHT_HOME;
        }
            break;
            
        case V_SPOTLIGHT_CV_VIEW:
        {
            model.keywords = @"CV views, naukrigulf";
            model.title = @"CV views by Employers";
            model.contentDescription = @"";
            model.spotlightId = K_SPOTLIGHT_CV_VIEW;
            model.page = V_SPOTLIGHT_CV_VIEW;

        
            NGProfileViewDetails *pvObj = nil;
            
            if ([(NSMutableArray*)param count])
                pvObj = [(NSMutableArray*)param firstObject];
            else
                model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_CV_VIEWS_PAGE;
            
            
            if (pvObj){
                
                NSString* companyName = pvObj.compName;
                NSString* industryType = pvObj.indType;
                NSString* location = pvObj.compLocation;
                
                if ([industryType isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:industryType])
                    model.contentDescription = companyName;
                else
                    model.contentDescription = [companyName stringByAppendingString:[NSString stringWithFormat:@"\n%@",industryType]];
                
                if ([location isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:location])
                    model.contentDescription = model.contentDescription;
                else
                    model.contentDescription = [model.contentDescription stringByAppendingString:[NSString stringWithFormat:@"\n%@",location]];
            }
        }
            break;
        case V_SPOTLIGHT_SRP:
        {
            model.keywords = @"";
            model.title = @"";
            model.contentDescription = @"";
            model.page = V_SPOTLIGHT_SRP;

        {
            NSMutableDictionary *_paramsDict = param;
            NSString* strKeyword = [_paramsDict objectForKey:@"Keywords"];
            NSString* strLocation = [_paramsDict objectForKey:@"Location"];
            NSString* strExperience = [(NSNumber*)[_paramsDict objectForKey:@"Experience"] stringValue];
            strExperience = [strExperience isEqualToString:@"15"]?@"15+": strExperience;
            NSString* strExpModified = [strExperience isEqualToString:@"99"]?@"Any":strExperience;
            
            NSString* expUnit = @"Years";
            if ([strExpModified isEqualToString:@"Any"])
                expUnit = @"";
            else if ([strExpModified isEqualToString:@"0"] || [strExpModified isEqualToString:@"1"])
                expUnit = @"Year";
            
            strKeyword = [NSString tripWhiteSpace:strKeyword];
            
            model.keywords = [NSString stringWithFormat:@"%@,%@,%@,%@",strKeyword,strLocation,K_SPOTLIGHT_SEARCH_KEYWORD_JOB,K_SPOTLIGHT_SEARCH_KEYWORD_NAUKRI_GULF];
            
            
            NSString* strTitle = @"";
            NSString* strDescription = @"";
            
            if (!strKeyword || ![NGDecisionUtility isValidNonEmptyNotNullString:strKeyword]){
                
                strTitle = @"New Jobs on Naukrigulf.com";
                strDescription = [NSString stringWithFormat:@"Location: %@ \nExperience: %@ %@",strLocation, strExpModified, expUnit];
                
                
            }else if (!strLocation || ![NGDecisionUtility isValidNonEmptyNotNullString:strLocation]){
                
                strTitle = [NSString stringWithFormat:@"%@ Jobs", strKeyword];
                strDescription = [NSString stringWithFormat:@"Location: Any \nExperience: %@ %@",strExpModified, expUnit];
                
            }else{
                
                strTitle = [NSString stringWithFormat:@"%@ Jobs", strKeyword];
                strDescription = [NSString stringWithFormat:@"Location: %@ \nExperience: %@ %@",strLocation, strExpModified, expUnit];
            }
            
           NSString* strSearchParams = [NSString stringWithFormat:@"%@.%@_%@_%@",K_SPOTLIGHT_SRP, strKeyword, strLocation, strExperience];
           model.spotlightId = strSearchParams;
           model.title = strTitle;
           model.contentDescription = strDescription;
        }
            
        }
            break;
        case V_SPOTLIGHT_SHORTLISTED_JOBS:
        {
            model.keywords = @"Short-listed jobs, saved jobs, naukrigulf, shortlist";
            model.title = @"Shortlisted Jobs";
            model.contentDescription = @"";
            model.spotlightId = K_SPOTLIGHT_SHORTLISTED_JOBS;
            model.page = V_SPOTLIGHT_SHORTLISTED_JOBS;

        {
            NGJobDetails *jobObj = nil;
            NSMutableArray *_savedJobsArr = param;
            if (_savedJobsArr.count)
                jobObj = [_savedJobsArr firstObject];
            else
                model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_SHORTLISTED_JOBS_PAGE;
            
            
            if (jobObj){
                
                NSString* designation = jobObj.designation;
                NSString* companyName = jobObj.cmpnyName;
                NSString* location = jobObj.location;
                
                if ([companyName isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:companyName])
                    model.contentDescription = designation;
                else
                    model.contentDescription = [designation stringByAppendingString:[NSString stringWithFormat:@"\n%@",companyName]];
                
                if ([location isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:location])
                    model.contentDescription = model.contentDescription;
                else
                    model.contentDescription = [model.contentDescription stringByAppendingString:[NSString stringWithFormat:@"\n%@",location]];
            }
        }
        }
            break;
        case V_SPOTLIGHT_SEARCH:
        {
            model.keywords = @"Search jobs, naukrigulf, jobs";
            model.title = @"Search jobs in Dubai, UAE, Gulf & Middle East";
            model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_SEARCH_PAGE;
            model.spotlightId = K_SPOTLIGHT_SEARCH;
            model.page = V_SPOTLIGHT_SEARCH;

        }
            break;
        case V_SPOTLIGHT_REGISTRATION:
        {
            model.keywords = @"Register, post CV, registration, naukrigulf";
            model.title = @"Register with Naukrigulf.com";
            model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_REGISTRATION_PAGE;
            model.spotlightId = K_SPOTLIGHT_REGISTRATION;
            model.page = V_SPOTLIGHT_REGISTRATION;

        }
            break;
        case V_SPOTLIGHT_PROFILE:
        {
            model.keywords = @"Naukrigulf profile, CV, edit CV, edit profile";
            model.title = @"My Naukrigulf Profile";
            model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_PROFILE_PAGE;
            model.spotlightId = K_SPOTLIGHT_PROFILE;
            model.page = V_SPOTLIGHT_PROFILE;

        }
            break;
            
        case V_SPOTLIGHT_MNJ:
        {
            model.keywords = @"Naukrigulf home, naukrigulf";
            model.title = @"My Naukrigulf Home";
            model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_MNJ_PAGE;
            model.spotlightId = K_SPOTLIGHT_HOME;
            model.page = V_SPOTLIGHT_HOME;

        }
            break;
            
            
        case V_SPOTLIGHT_SHORTLISTED_JOBS_AT_JOB_ANALYTICS:
        {
            model.keywords = @"Short-listed jobs, saved jobs, naukrigulf, shortlist";
            model.title = @"Shortlisted Jobs";
            model.spotlightId = K_SPOTLIGHT_SHORTLISTED_JOBS;
            model.page = V_SPOTLIGHT_SHORTLISTED_JOBS;

            NSMutableArray *_savedJobsArr = param;
            NGJobDetails *jobObj = nil;

            if (_savedJobsArr.count)
                jobObj = [_savedJobsArr firstObject];
            else
               model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_SHORTLISTED_JOBS_PAGE;
            
            if (jobObj){
                
                NSString* designation = jobObj.designation;
                NSString* companyName = jobObj.cmpnyName;
                NSString* location = jobObj.location;
                
                if ([companyName isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:companyName])
                    model.contentDescription = designation;
                else
                    model.contentDescription = [designation stringByAppendingString:[NSString stringWithFormat:@"\n%@",companyName]];
                
                if ([location isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:location])
                    model.contentDescription = model.contentDescription;
                else
                    model.contentDescription = [model.contentDescription stringByAppendingString:[NSString stringWithFormat:@"\n%@",location]];
            }

        }
            break;
            
           
            

            
        case V_SPOTLIGHT_APPLIED_JOBS:
        {
            model.keywords = @"Applied jobs, naukrigulf";
            model.title = @"Applied Jobs";
            model.spotlightId = K_SPOTLIGHT_APPLIED_JOBS;
            model.page = V_SPOTLIGHT_APPLIED_JOBS;

            NSMutableArray *_appliedJobsArr = param;

            NGJobDetails *jobObj = nil;
            if (_appliedJobsArr.count)
               jobObj = [_appliedJobsArr firstObject];
            else
               model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_APPLIED_JOBS_PAGE;
            
            if (jobObj){
                
                NSString* designation = jobObj.designation;
                NSString* companyName = jobObj.cmpnyName;
                NSString* location = jobObj.location;
                
                if ([companyName isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:companyName])
                    model.contentDescription = designation;
                else
                    model.contentDescription = [designation stringByAppendingString:[NSString stringWithFormat:@"\n%@",companyName]];
                
                if ([location isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:location])
                    model.contentDescription = model.contentDescription;
                else
                    model.contentDescription = [model.contentDescription stringByAppendingString:[NSString stringWithFormat:@"\n%@",location]];
            }

        }
            break;
        case V_SPOTLIGHT_RECOMMENDED_JOBS:
        {
            model.keywords = @"Recommended, jobs, naukrigulf, new jobs, job alert";
            model.title = @"Recommended Jobs";
            model.spotlightId = K_SPOTLIGHT_RECOMMENDED_JOBS;
            model.page = V_SPOTLIGHT_RECOMMENDED_JOBS;

            NSMutableArray *_recomendedJobsArr = param;
            NGJobDetails *jobObj = nil;

            if (_recomendedJobsArr.count)
                jobObj = [_recomendedJobsArr firstObject];
            else
                model.contentDescription = K_SPOTLIGHT_SEARCH_STATIC_RECOMMENDED_JOBS_PAGE;
            
            if (jobObj){
                
                NSString* designation = jobObj.designation;
                NSString* companyName = jobObj.cmpnyName;
                NSString* location = jobObj.location;
                
                if ([companyName isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:companyName])
                    model.contentDescription = designation;
                else
                    model.contentDescription = [designation stringByAppendingString:[NSString stringWithFormat:@"\n%@",companyName]];
                
                if ([location isEqualToString:@"Not Mentioned"] || ![NGDecisionUtility isValidNonEmptyNotNullString:location])
                    model.contentDescription = model.contentDescription;
                else
                    model.contentDescription = [model.contentDescription stringByAppendingString:[NSString stringWithFormat:@"\n%@",location]];
            }
            
        }
            break;
            
            
        default:
            break;
    }
    return model;

}
-(void)setDataOnSpotlightWithModel:(NGSpotLightModel*)model{
    if (SYSTEM_VERSION_LESS_THAN(@"9.0"))
        return;
    
    CSSearchableItemAttributeSet *attributeSet;
    attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
    attributeSet.keywords = [model.keywords componentsSeparatedByString:@","];
    attributeSet.title = model.title;
    attributeSet.contentDescription = model.contentDescription;
    
    
    UIImage *image = [UIImage imageNamed:K_SPOTLIGHT_SEARCH_ITEM_ICON];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    attributeSet.thumbnailData = imageData;
    
    NSString* uniqueIdentifier = [model.spotlightId stringByAppendingString:@".naukrigulf"];
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:uniqueIdentifier domainIdentifier:@"spotlight.sample" attributeSet:attributeSet];
    
    if (model.page == V_SPOTLIGHT_SEARCH || model.page == V_SPOTLIGHT_SRP || model.page == V_SPOTLIGHT_REGISTRATION)
    {
        activity = [[NSUserActivity alloc] initWithActivityType:uniqueIdentifier];
        activity.title = model.title;
        activity.keywords = [[NSSet alloc] initWithArray:[model.keywords componentsSeparatedByString:@","]];
        activity.contentAttributeSet = attributeSet;
        activity.webpageURL = [[NSURL alloc] initWithString:@"http://www.naukrigulf.com/"];
        activity.eligibleForPublicIndexing = YES;
        activity.needsSave = YES;
        [activity becomeCurrent];
    }
    
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
        if (!error){
        }
    }];
}

@end
