//
//  NGNewUserApplyPreviewViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 27/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGNewUserApplyPreviewViewController.h"
#import "NGCustomQuestionViewController.h"
#import "NGBasicInfoCell.h"
#import "NGContactDetailCell.h"
#import "NGEducationDetailsCell.h"
#import "NGUnRegApplyViewController.h"

float const K_DEFAULT_VALUE = 50.0;

enum CellType{
    CellTypeBasicDetails = 0,
    CellTypeEditDetails,
    CellTypeContactDetails,
    CellTypeEducationDetails
};

@interface NGNewUserApplyPreviewViewController ()
{
    NSString* masterDegreeInfo;
    NSString* doctorateDegreeInfo;
    NSMutableDictionary* previewInfoDict;
  
    NGLoader* loader;
    
}

@end

@implementation NGNewUserApplyPreviewViewController


- (void)viewDidLoad
{
    [AppTracer traceStartTime:TRACER_UNREG_APPLY_PREVIEW];    
    [super viewDidLoad];
    
    [self addNavigationBarWithBackBtnWithTitle:@"Preview your Job Application"];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    self.applyModel = [[DataManagerFactory getStaticContentManager]getApplyFields];
    [super viewWillAppear:animated];
}





-(void)viewDidAppear:(BOOL)animated{
    [NGHelper sharedInstance].appState = APP_STATE_UNREG_APPLY;
    [super viewDidAppear:animated];
    [NGGoogleAnalytics sendScreenReport:K_GA_APPLAY_UNREG_PREVIEW_SCREEN];
    [self.tableView reloadData];
    [AppTracer traceEndTime:TRACER_UNREG_APPLY_PREVIEW];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([loader isLoaderAvail]) {
        [loader hideAnimatior:self.view];
    }
    
    [AppTracer clearLoadTime:TRACER_UNREG_APPLY_PREVIEW];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSInteger row = [indexPath row];
    switch (row) {
        case CellTypeBasicDetails:
        {
            
            NSString * CellIdentifier =@"BasicDetailsCell";
            NGBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                cell = [[NGBasicInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
            }
            
            [cell configure:self.applyModel];
            
            return cell;
            
        }
            
        case CellTypeEditDetails:{
            NSString * CellIdentifier =@"editDetailsCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:CellIdentifier];
            }
            return cell;
            
            break;
        }
            
        case CellTypeContactDetails:
        {
            
            NSString * CellIdentifier =@"ContactsDetailCell";
            NGContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                cell = [[NGContactDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIdentifier];
            }
            
            
            [cell configure:self.applyModel];
            return cell;
            
        }
            
       case CellTypeEducationDetails:
        {
            
            NSString * CellIdentifier =@"eduExpCell";
            NGEducationDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                cell = [[NGEducationDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:CellIdentifier];
            }
            
            [cell configure:self.applyModel];
            
            return cell;
            
        }
            
        default:
        {
            NSString * CellIdentifier =@"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:CellIdentifier];
            }
            return cell;
            
        }
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case CellTypeBasicDetails:{
            static NSString * CellIdentifier =@"BasicDetailsCell";
            NGBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                cell = [[NGBasicInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
            }
            
            [cell configure:self.applyModel];
            return [UITableViewCell getCellHeight:cell];
            
            break;
        }
        
        case CellTypeEditDetails:
            return 55;
            
        case CellTypeContactDetails:{
            static NSString * CellIdentifier =@"ContactsDetailCell";
            NGContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                cell = [[NGContactDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIdentifier];
            }
            
            [cell configure:self.applyModel];
            return [UITableViewCell getCellHeight:cell];
            
            break;
        }
            
        case CellTypeEducationDetails:{
            static NSString * CellIdentifier =@"eduExpCell";
            NGEducationDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
                cell = [[NGEducationDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:CellIdentifier];
            }
            
            [cell configure:self.applyModel];
            return [UITableViewCell getCellHeight:cell];
            
            break;
        }
        
        default:
            break;
    }
    
    return 0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case CellTypeEditDetails:{
            NGUnRegApplyViewController *unregApplyVC = [[NGUnRegApplyViewController alloc] init];
            unregApplyVC.jobObj = self.jobObj;
            unregApplyVC.openJDLocation = _openJDLocation;
            unregApplyVC.applyModelObj = [self.applyModel copy];
            [(IENavigationController*)self.navigationController pushActionViewController:unregApplyVC Animated:YES];
            break;
        }
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)applyJobFromPreview:(id)sender
{
 
    if([[[[NGOperationQueueManager sharedManager]operationQueue] operations] count]>0)
        return;

    __block BOOL bIsRegisteredUser;
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_CHECK_REGISTERED_USER];
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:_applyModel.emailId,@"email", nil] handler:^(NGAPIResponseModal *responseData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideAnimator];
            if (responseData.isSuccess) {
                NSString* emailExistStr = [[responseData.responseData JSONValue] objectForKey:KEY_REGISTERED_EMAIL_DATA];
                
                if ([emailExistStr isEqualToString:@"true"])
                    bIsRegisteredUser = YES;
                else
                    bIsRegisteredUser = NO;
                
            }
            else
                bIsRegisteredUser = NO;
            
            
            NGJobsHandlerObject *obj =  [[NGJobsHandlerObject alloc]init];
            obj.jobObj= self.jobObj;
            obj.isEmailRegistered = bIsRegisteredUser;
            obj.Controller =  self;
            obj.applyState =  LoginApplyStateUnRegistered;
            obj.unregApplyModal = self.applyModel;
            obj.viewLoadingStartTime =  nil;
            obj.openJDLocation = _openJDLocation;
            [[NGApplyJobHandler sharedManager] jobHandlerAppliedForFinalStep:obj];
        });
    }];
}

@end
