//
//  NGResmanFresherOrExpViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/13/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanFresherOrExpViewController.h"
#import "NGResmanFresherEducationViewController.h"
#import "NGResmanFresherOrExpTableViewCell.h"

@interface NGResmanFresherOrExpViewController (){
    
    NGResmanDataModel *resmanModel;
    
    UIView *footerView;
}

@end

@implementation NGResmanFresherOrExpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.editTableView.scrollEnabled = NO;
    
    [self.saveBtn setHidden:TRUE];
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [self addNavigationBarWithBackAndRightButtonTitle:nil WithTitle:@"Let's Build Your Profile"];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    [NGDecisionUtility checkNetworkStatus];

    
}
-(void) viewDidAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [AppTracer traceEndTime:TRACER_ID_RESMAN_FRSHER_OR_EXP];
    
    [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_EXP_OR_FRESHER];
    
    [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageSelectFresherOrExperience];
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [AppTracer clearLoadTime:TRACER_ID_RESMAN_FRSHER_OR_EXP];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (nil == footerView) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 1.0f)];
        [footerView setBackgroundColor:UITABLEVIEW_SEPERATOR_COLOR];
        
        self.scrollHelper.tableViewFooter = footerView;
    }
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
    
    return (indexPath.row==0)?50:130;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
      
        NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:@"" ];
        if (cell == nil)
        {
            cell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            NSInteger originX =  0;
            if (IS_IPHONE6)
                originX = 40;
            else if (IS_IPHONE6_PLUS)
                originX = 60;
            UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, 0, 320, 50)];
            txtLabel.textAlignment = NSTextAlignmentCenter;
            [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
            txtLabel.text =@"Do you have any Work Experience?";
            txtLabel.textColor = [UIColor darkGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:txtLabel];
            return cell;
        }
        
    }
    
    NSString* cellIndentifier = @"ResmanImageView";
    NGResmanFresherOrExpTableViewCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCell:indexPath];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.editTableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isFresher = indexPath.row==1?FALSE:TRUE;
    resmanModel.isFresher= isFresher;
    [[DataManagerFactory getStaticContentManager] saveResmanFields:resmanModel];
    
    if (indexPath.row==1) {
        
        [[NGResmanNotificationHelper sharedInstance] setUserAsFresher:NO];
        
        NGResmanExpBasicDetailsViewController *expBasicDetailVC = [[NGResmanExpBasicDetailsViewController alloc] initWithNibName:nil bundle:nil];
        
        [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:expBasicDetailVC Animated:YES];
    }else if(indexPath.row==2){
        
        [[NGResmanNotificationHelper sharedInstance] setUserAsFresher:YES];
        
        NGResmanFresherEducationViewController *fresherEduDetailVC = [[NGResmanFresherEducationViewController alloc] initWithNibName:nil bundle:nil];
        [((IENavigationController*)[NGAppDelegate appDelegate].container.centerViewController) pushActionViewController:fresherEduDetailVC Animated:YES];
    }
   
    

}

-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
}
- (void)saveButtonTapped:(id)sender{
    
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
