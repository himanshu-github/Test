//
//  NGResmanExploreOptionViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/4/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanExploreOptionViewController.h"
#import "NGResmanProfileOrSearchCell.h"
#import "NGSearchJobsViewController.h"
#import "NGResmanJobPreferencesViewController.h"
#import "NGViewController.h"
@interface NGResmanExploreOptionViewController (){
    NGResmanDataModel *resmanModel;
}

@end

@implementation NGResmanExploreOptionViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.saveBtn setHidden:FALSE];

    [self.navigationItem setHidesBackButton:YES];
 
    [self customizeNavBarWithTitle:@"Next Steps"];

    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.isSwipePopGestureEnabled = NO;
    self.isSwipePopDuringTransition = NO;
    
}

-(void) viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    [super viewDidAppear:animated];

    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    
    if (resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_START_EXPLORING_FRESHER];
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_START_EXPLORING_EXPERIENCED];
    }
    
    [self setAutomationLabel];

}


-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:@"ExperienceBasicDeails_table" forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [self setEditTableInFullScreenMode];
    
    self.editTableView.scrollEnabled = YES;
    [NGDecisionUtility checkNetworkStatus];

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 1.0f)];
    [footerView setBackgroundColor:UITABLEVIEW_SEPERATOR_COLOR];
    return footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 100;
    }
    return 185;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIndentifier ;
    
    switch (indexPath.row) {
            
        case kResmanProfileOrSearchRowTypeLetsStart :{
            
            cellIndentifier = @"GeneralDesc";
            
            UITableViewCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            
        case kResmanProfileOrSearchRowTypeProfileOption:{
            
            cellIndentifier = @"Option";
           
            NGResmanProfileOrSearchCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            
            cell.index = kResmanProfileOrSearchRowTypeProfileOption;
            [cell configureCell];
            return cell;
        }
        case kResmanProfileOrSearchRowTypeSearchOption:{
            
            cellIndentifier = @"Option";
            NGResmanProfileOrSearchCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
            cell.index = kResmanProfileOrSearchRowTypeSearchOption;
            [cell configureCell];
        
            return cell;
            break;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kResmanProfileOrSearchRowTypeProfileOption:{
            
            NGResmanJobPreferencesViewController *jobPreferences = [[NGResmanJobPreferencesViewController alloc] init];
            [(IENavigationController*)self.navigationController pushActionViewController:jobPreferences Animated:YES];
            break;
            
        }
        case kResmanProfileOrSearchRowTypeSearchOption:{
            
            [[NGResmanNotificationHelper sharedInstance] setJobPreferenceNotification];
            
            if (resmanModel.isFresher) {
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_START_JOB_SEARCH_FRESHER withEventLabel:K_GA_RESMAN_EVENT_START_JOB_SEARCH_FRESHER withEventValue:nil];
            }else{
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_START_JOB_SEARCH_EXPERIENCED withEventLabel:K_GA_RESMAN_EVENT_START_JOB_SEARCH_EXPERIENCED withEventValue:nil];
            }
            
           NGViewController *splashviewController = (NGViewController*)[self.navigationController.viewControllers objectAtIndex:0];
            
            
            NGSearchJobsViewController *navgationController_ = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JobSearch"];
            
            UINavigationController *navVC = (UINavigationController *)APPDELEGATE.container.centerViewController;
            
            [navVC setViewControllers:[NSArray arrayWithObjects:splashviewController,navgationController_,nil] animated:YES];
            
            break;
            

        }
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
