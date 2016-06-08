//
//  NGShortlistedJobsViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 26/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGShortlistedJobsViewController.h"


@interface NGShortlistedJobsViewController ()
{
}
/**
 *  noResultsView appears if shortlisted jobs are not available
 */
@property (weak, nonatomic) IBOutlet UIView *noResultsView;
/**
 *  tableView for showing the shortlisted jobs
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation NGShortlistedJobsViewController

#pragma mark - ViewController Methods

- (void)viewDidLoad
{
    
    [AppTracer traceStartTime:TRACER_ID_SHORTLISTED_JOBS_PAGE];
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_jean"]];
    
    [self addNavigationBarWithBackBtnWithTitle:@"Shortlisted Jobs"];
    
    [UIAutomationHelper setAccessibiltyLabel:@"shortListJobTable" forUIElement:self.tableView withAccessibilityEnabled:NO];
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;

    
    
} 


-(void)viewWillAppear:(BOOL)animated
{
    if(self.isSwipePopDuringTransition)
        return;
    [super viewWillAppear:animated];
    NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]getAllSavedJobs]];
    
    self.savedJobsArr = (NSMutableArray*)[[tempArr reverseObjectEnumerator] allObjects];
    
    if (self.savedJobsArr.count>0)
    {
        self.noResultsView.hidden=YES;
    }
    else
    {
        self.noResultsView.hidden=NO;
        self.tableView.hidden=YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    [NGHelper sharedInstance].appState = APP_STATE_SHORTLISTED_JOB;
    [super viewDidAppear:animated];
    
    [AppTracer traceEndTime:TRACER_ID_SHORTLISTED_JOBS_PAGE];
    
    [self showAppliedBannerIfRequired];
    [[NGSpotlightSearchHelper sharedInstance] setDataOnSpotlightWithModel:[[NGSpotlightSearchHelper sharedInstance] getSpotlightModelForVC:V_SPOTLIGHT_SHORTLISTED_JOBS withModel:_savedJobsArr]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [AppTracer clearLoadTime:TRACER_ID_SHORTLISTED_JOBS_PAGE];
}

- (void)viewDidUnload {
    [self setNoResultsView:nil];
    
    [super viewDidUnload];
}

#pragma mark - Memory Management

-(void)dealloc
{
    self.tableView=nil;
    self.savedJobsArr=nil;
    self.noResultsView=nil;
    self.networkView=nil;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)gotoSearchJobs:(id)sender
{
    
    [[NGAppStateHandler sharedInstance]setAppState:APP_STATE_JOB_SEARCH usingNavigationController:((UINavigationController *)[NGAppDelegate appDelegate].container.centerViewController) animated:YES];
}


#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray* tempArr = [[NSMutableArray alloc]initWithArray:[[DataManagerFactory getStaticContentManager]getAllSavedJobs]];
    
    self.savedJobsArr = (NSMutableArray*)[[tempArr reverseObjectEnumerator] allObjects];
    
    if (self.savedJobsArr.count>0)
    {
        self.noResultsView.hidden=YES;
    }
    else
    {
        self.noResultsView.hidden=NO;
        self.tableView.hidden=YES;
    }
    
    return self.savedJobsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configureCell:indexPath];
}

#pragma  mark - TableView View Delegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NGJobTupleCustomCell* cell= [self configureCell:indexPath];
    return [UITableViewCell getCellHeight:cell];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger jobIndex = indexPath.row;
    
    NGJDParentViewController *jdVC = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JDView"];
    jdVC.allJobsArr = (NSMutableArray*)self.savedJobsArr;
    jdVC.selectedIndex = jobIndex;
    jdVC.totalJobsCount = [self.savedJobsArr count];
    [[NGAppDelegate appDelegate].container.centerViewController pushActionViewController:jdVC Animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}


#pragma mark - Private Methods

/**
 *  @name Private Methods
 */
/**
 *  Return customized NGJobTupleCustomCell at specific IndexPath
 *
 *  @param  The index path locating the row in the receiver
 *
 *  @return An object representing a cell of the table or nil if the cell is not visible or indexPath is out of range.
 */
-(NGJobTupleCustomCell*)configureCell:(NSIndexPath*)indexPath
{
    
   static NSString *cellIdentifier = @"NGJobTupleCustomCell";
    
    NGJobTupleCustomCell *cell = (NGJobTupleCustomCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (NGJobTupleCustomCell *)[nib fetchObjectAtIndex:0];
    }
    
    UIView *v = [[UIView alloc] init] ;
    v.backgroundColor = UIColorFromRGB(0xeffaff);
    cell.selectedBackgroundView = v;
    
    NSInteger jobIndex = indexPath.row;
    
    NGJobDetails *jobObj = [self.savedJobsArr fetchObjectAtIndex:jobIndex];
    
    [cell displayData:jobObj atIndex:jobIndex];
    
     cell.delegate = self;
    
    return cell;
    
}

/**
 *  Removes selected job from shortlisted list.
 *
 *  @param sender UIButton used for removing removeShortListedJob
 */

-(void)jobTupleCell:(NGJobTupleCustomCell *)jobTupleObj shortListTappedWithFlag:(BOOL)flag
{
    if(!flag)
    {
        NSIndexPath *removeIndexPath = [self.tableView indexPathForCell:jobTupleObj];
        
         NGJobDetails *jobObj = [self.savedJobsArr fetchObjectAtIndex:removeIndexPath.row];
        [self.savedJobsArr removeObjectAtIndex:removeIndexPath.row];
        [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:jobObj forStoring:NO];
        [self.tableView reloadData];
    
    }
}

/**
 *  this method trigger the event of closing the current View Controller using [NGAnimator sharedInstance]
 *
 *  @param sender UIButton tapped for closing the current View Controller
 */
-(void)closeTapped:(id)sender{
}


-(void)showAppliedBannerIfRequired{
    
    [self.tableView reloadData];
    
    if([NGSavedData getIfSimJobsExistsForTheJob])
    {
        
        [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"You have successfully applied to the job" animationTime:5 showAnimationDuration:0];
        [NGSavedData setIfSimJobsExistsForTheJob:FALSE];
        
        
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:KEY_DUPLICATE_APPLY])
    {
        
        [NGMessgeDisplayHandler showErrorBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:ERROR_MESSAGE_DUPLICATE_APPLY animationTime:5 showAnimationDuration:0];
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:KEY_DUPLICATE_APPLY];
        
    }
}


@end
