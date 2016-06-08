//
//  NGResmanHalfWayToFullViewController.m
//  NaukriGulf
//
//  Created by Maverick on 28/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanHalfWayToFullViewController.h"
#import "NGResmanLoginDetailsViewController.h"
#import "NGResmanHalfWayStatusTableViewCell.h"
#import "NGApplyConfirmationViewController.h"


@interface NGResmanHalfWayData:NSObject
@property(nonatomic,strong) NSString *cellId;
@property(nonatomic,assign) float cellHeight;
@end

@implementation NGResmanHalfWayData
@end

@interface NGResmanHalfWayToFullViewController (){
   IBOutlet UITableView* tblSuccesfulUnregToResman;
    NSArray *myData;
}

@end

@implementation NGResmanHalfWayToFullViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addLogoToNavigationBarWithUnTappableImageName:@"Fevicon"];

    NGResmanHalfWayData* obj0 = [NGResmanHalfWayData new];
    obj0.cellId = @"ResmanHalfWay1";
    obj0.cellHeight = 51;
    
    NGResmanHalfWayData* obj1 = [NGResmanHalfWayData new];
    obj1.cellId = @"ResmanHalfWay2";
    obj1.cellHeight = 190;
    
    NGResmanHalfWayData* obj2 = [NGResmanHalfWayData new];
    obj2.cellId = @"ResmanHalfWay3";
    obj2.cellHeight = 125;
    
    NGResmanHalfWayData* obj3 = [NGResmanHalfWayData new];
    obj3.cellId = @"ResmanHalfWay4";
    obj3.cellHeight = IS_IPHONE4?50:115;
    
    
    myData = @[obj0,obj1,obj2,obj3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGResmanHalfWayData* obj = [myData fetchObjectAtIndex:indexPath.row];
    UITableViewCell* cell = nil;
    if (indexPath.row == 0){
        NGResmanHalfWayStatusTableViewCell * cell = [tblSuccesfulUnregToResman dequeueReusableCellWithIdentifier:obj.cellId];
        [cell configureCell:_isSuccess];
        return cell;
    }
    else
     cell = [tblSuccesfulUnregToResman dequeueReusableCellWithIdentifier:obj.cellId];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NGResmanHalfWayData* obj = [myData fetchObjectAtIndex:indexPath.row];
    return obj.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    IENavigationController *navController = (IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController;
    
    if (indexPath.row == 2) {
        
        NGResmanLoginDetailsViewController *resmanVc = [[NGResmanLoginDetailsViewController alloc] initWithNibName:nil bundle:nil];
        resmanVc.isComingFromUnregApply = YES;
        [navController pushActionViewController:resmanVc Animated:YES];
        
    }else if (indexPath.row == 3){
        
        [NGHelper sharedInstance].isResmanViaUnregApply = NO;
        if(((NSMutableArray*)[_parsedResponseForSim valueForKey:@"Sim Jobs"]).count){
            
            [[NGAppStateHandler sharedInstance]setDelegate:self];
            [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"NoSimJobsFound"];
            [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_APPLY_CONFIRMATION usingNavigationController:navController animated:YES];
            
        }else{
            
            [NGUIUtility removeAllViewControllersTillJobTupleSourceView];
            [navController popActionViewControllerAnimated:YES];
        }
       

    }
}

-(void)setPropertiesOfVC:(id)vc{
    
    if([vc isMemberOfClass:[NGApplyConfirmationViewController class]])
    {
        NGApplyConfirmationViewController* viewC = (NGApplyConfirmationViewController*)vc;
        
        if (SERVICE_TYPE_UNREG_APPLY == _serviceType){
            viewC.simJobs=(NSMutableArray*)[_parsedResponseForSim valueForKey:@"Sim Jobs"];;
            viewC.jobDesignation = _aObject.jobObj.designation;
            viewC.jobObj = _aObject.jobObj;
            viewC.bScrollTableToTop = YES;
            
        }
    }
    _serviceType = -1;
    _parsedResponseForSim = nil;
    [[NGAppStateHandler sharedInstance]setDelegate:nil];
    
}

@end





