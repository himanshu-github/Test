//
//  NGWhoViewedCVInterfaceController.m
//  NaukriGulf
//
//  Created by Himanshu on 2/7/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGWhoViewedCVInterfaceController.h"
#import "WatchConstants.h"
#import "WatchHelper.h"
#import "NGCVViewRowController.h"


#define NUMBER_OF_JOB_LOAD_AT_FIRST_TIME 5

@interface NGWhoViewedCVInterfaceController ()<WCSessionDelegate,NGCVViewRowControllerDelegate>
{
    NSMutableArray* arrCVViews;
    int totalCVViewCount;
    int currentlyLoadedCell;

}

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tblCVViews;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpErrorOcurred;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblStatus;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpSpinner;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imgSpinner;

@end

@implementation NGWhoViewedCVInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [super awakeWithContext:context];
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    [_tblCVViews setHidden:YES];
    [_grpErrorOcurred setHidden:YES];
    
    arrCVViews = [NSMutableArray array];
    [self setTitle:@"CV Views"];

    [self fetchCVViews];
    
    [WatchHelper sendScreenReportOnGA:GA_WATCH_VIEWEDCV_SCREEN];

}
#pragma mark- error message show
-(void)showStatus:(NSString*)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_tblCVViews setHidden:YES];
        [_grpSpinner setHidden:YES];
        [_grpErrorOcurred setHidden:NO];
        [_lblStatus setText:message];
        
    });
}
#pragma mark- fetch CVView

-(void)fetchCVViews{
    
    [self showSpinner];
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.reachable) {
            [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"check_eligibility",@"name", nil]
                replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            if([[replyMessage objectForKey:@"internet"] boolValue]){
            if([[replyMessage objectForKey:@"isLoggedIn"] boolValue]){
            [[WCSession defaultSession] sendMessage:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"api_CVViews",@"name",nil]
                replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){
                    
                if([replyMessage[@"response"] isKindOfClass:[NSMutableArray class]]){
                    if (arrCVViews.count)
                    [arrCVViews removeAllObjects];
                    [arrCVViews addObjectsFromArray:replyMessage[@"response"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.0];
                    });
                  }
                  else{
                      dispatch_async(dispatch_get_main_queue(), ^{
                              [self showStatus:K_SOME_ERROR_OCCURED];
                      });
                  }
                  
              } errorHandler:^(NSError * _Nonnull error) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self showStatus:K_SOME_ERROR_OCCURED];
                  });
              }];

    }
    else
    [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
    [NSDictionary dictionaryWithObjectsAndKeys:K_LOGIN_FROM_IPHONE,KEY_MESSAGE, nil]];

    }
    else
    [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:[NSDictionary dictionaryWithObjectsAndKeys:K_NO_INTERENT,KEY_MESSAGE,                                                                                                             nil]];
                                           
    }
    errorHandler:^(NSError * _Nonnull error) {
    [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
    [NSDictionary dictionaryWithObjectsAndKeys:K_SOME_ERROR_OCCURED,KEY_MESSAGE, nil]];
                                           
    }];
            
    }else
    [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
    [NSDictionary dictionaryWithObjectsAndKeys:K_ERROR_REACHABLE,KEY_MESSAGE, nil]];
    }
}
#pragma mark - Table Loading
-(void)loadTable{
        if (!arrCVViews.count) {
            [_tblCVViews setHidden:YES];
            [_grpErrorOcurred setHidden:NO];
            [_grpSpinner setHidden:YES];
            [_lblStatus setText:K_NO_CV_VIEWS];
            return;
        }
    int iIndex = arrCVViews.count;
    totalCVViewCount = iIndex;
    
    int jobNumberToLoad = 0;
    BOOL isShowLoadMore = NO;
    
    if(totalCVViewCount>NUMBER_OF_JOB_LOAD_AT_FIRST_TIME)
    {
        jobNumberToLoad = NUMBER_OF_JOB_LOAD_AT_FIRST_TIME;
        isShowLoadMore = YES;
    }
    else
    {
        jobNumberToLoad = totalCVViewCount;
        isShowLoadMore = NO;
    }
    
    if(isShowLoadMore)
    {
        [_tblCVViews setNumberOfRows:jobNumberToLoad+1 withRowType:K_CV_TABLE_CELL_ID];
        for (int i = 0; i < jobNumberToLoad; i++)
            [self refreshTableRowAt:i];
        [self configureLoadMoreAtIndex:jobNumberToLoad];
        
    }else{
        
        [_tblCVViews setNumberOfRows:jobNumberToLoad withRowType:K_CV_TABLE_CELL_ID];
        for (int i = 0; i < jobNumberToLoad; i++)
            [self refreshTableRowAt:i];
    }
    
    currentlyLoadedCell = jobNumberToLoad;
    
    [_tblCVViews setHidden:NO];
    [_grpSpinner setHidden:YES];
    
}

-(void)configureLoadMoreAtIndex:(NSInteger)iIndex{
    NGCVViewRowController * row = [_tblCVViews rowControllerAtIndex:iIndex];
    row.delegate = self;
    row.iTag = iIndex;
    [row configureCVViewCellForLoadMore];
    
}
-(void)refreshTableRowAt:(NSInteger)iIndex{

    NGCVViewRowController * row = [_tblCVViews rowControllerAtIndex:iIndex];
    NSMutableDictionary* dictCV = [arrCVViews objectAtIndex:iIndex];
    row.delegate = self;
    row.iTag = iIndex;
    [row configureCVViewCell:dictCV forIndex:iIndex];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
-(void)loadMoreTapped:(int)index{
    
    NGCVViewRowController * loadMoreRow = [_tblCVViews rowControllerAtIndex:index];
    [loadMoreRow configureCVForShowingLoadMore];
    dispatch_async(dispatch_get_main_queue(), ^{

    int jobNumberToLoad = 0;
    BOOL isShowLoadMore = NO;
    
    if(currentlyLoadedCell+NUMBER_OF_JOB_LOAD_AT_FIRST_TIME<totalCVViewCount)
    {
        jobNumberToLoad = NUMBER_OF_JOB_LOAD_AT_FIRST_TIME;
        isShowLoadMore = YES;
    }
    else
    {
        jobNumberToLoad = totalCVViewCount - currentlyLoadedCell;
        isShowLoadMore = NO;
    }
    
    if(isShowLoadMore)
    {
        for (int i = currentlyLoadedCell; i < currentlyLoadedCell + jobNumberToLoad; i++)
        {
            [_tblCVViews insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:i] withRowType:K_CV_TABLE_CELL_ID];
            [self refreshTableRowAt:i];
        }
        [self configureLoadMoreAtIndex:currentlyLoadedCell + jobNumberToLoad];
        
    }else{
        
        for (int i = currentlyLoadedCell; i < currentlyLoadedCell + jobNumberToLoad; i++)
        {
            [_tblCVViews insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:i] withRowType:K_CV_TABLE_CELL_ID];
            [self refreshTableRowAt:i];
        }
        //remove load-more row
        [_tblCVViews removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:totalCVViewCount]];
        
    }
    currentlyLoadedCell = currentlyLoadedCell + jobNumberToLoad;
    });
}
-(void)showResponse:(id)response{
    
    [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:response];
}

-(void)showNotLoggedInView{
    
    [_grpSpinner setHidden:YES];
    [_tblCVViews setHidden:YES];
    [_grpErrorOcurred setHidden:NO];
    [_lblStatus setText:K_LOGIN_FROM_IPHONE];
}
-(void)showSpinner{
    [_grpSpinner setHidden:NO];
    [_imgSpinner setHidden:NO];
    [_imgSpinner setImageNamed:@"spinner"];
    [_imgSpinner startAnimatingWithImagesInRange:NSMakeRange(1, 42)
                                            duration:1.0
                                         repeatCount:0];
}


@end



