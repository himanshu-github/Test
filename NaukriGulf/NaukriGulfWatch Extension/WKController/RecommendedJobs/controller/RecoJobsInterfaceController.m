//
//  RecoJobsInterfaceController.m
//  NaukriGulf
//
//  Created by Arun on 12/27/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "RecoJobsInterfaceController.h"
#import "RecoTableRowController.h"
#import "ResponseInterfaceController.h"
#import "WatchConstants.h"
#import "WatchHelper.h"

#define NUMBER_OF_JOB_LOAD_AT_FIRST_TIME 5

@interface RecoJobsInterfaceController ()<WCSessionDelegate, RecoTableRowControllerDelegate>{
    
    NSMutableArray* arrRecoJobs;
    NSMutableArray* arrSavedJobs;
    BOOL isRecoPage;
    
    BOOL bJobSavedFromJD;
    BOOL bJobAppliedFromJDForReco;
    BOOL bJobAppliedFromJDForSaved;
    NSDictionary* dictDataFromJD;

    int totalRecoCount;
    int currentlyLoadedCell;
    
}

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tblRecoJobs;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpErrorOcurred;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblStatus;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpSpinner;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imgRecoSpinner;

@end

@implementation RecoJobsInterfaceController

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }

    [_tblRecoJobs setHidden:YES];
    [_grpErrorOcurred setHidden:YES];
    
    arrSavedJobs = [NSMutableArray array];
    arrRecoJobs = [NSMutableArray array];

    if ([context[@"page"] isEqualToString:@"reco_jobs"]) {
        [self setTitle:@"Reco Jobs"];
        isRecoPage = YES;
        [arrRecoJobs removeAllObjects];
        if(context[@"comingFrom"]){
          dispatch_async(dispatch_get_main_queue(), ^{
            [self showSpinner];
            [self hitApiForRecoJobComingFromNotification];
            });
        }
        else{
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTheRecoData:) name:@"RecoData" object:nil];
            [arrRecoJobs addObjectsFromArray:context[@"data"]];
            if (arrRecoJobs.count>0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSpinner];
                });
                [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.5];
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([context[@"_isRecoApiHitting"] integerValue] == NO)
                        [self showStatus:K_NO_RECO_JOBS];
                    else
                        [self showSpinner];
                });
            }
        }
        [WatchHelper sendScreenReportOnGA:GA_WATCH_RECO_SCREEN];

    }else{
        
        [self setTitle:@"Saved Jobs"];
        isRecoPage = NO;
        [self fetchSavedJobs];
        
        [WatchHelper sendScreenReportOnGA:GA_WATCH_SAVEDJOB_SCREEN];
        
    }
    
    
}
#pragma mark- Hit Reco API data
-(void)hitApiForRecoJobComingFromNotification{

    [[WCSession defaultSession] sendMessage:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"api_reco_jobs",@"name",nil]
            replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){
                
                if([replyMessage[@"response"] isKindOfClass:[NSMutableArray class]]){
                                       //NSLog(@"success in reco service");
                    if (arrRecoJobs.count)
                       [arrRecoJobs removeAllObjects];
                    [arrRecoJobs addObjectsFromArray:replyMessage[@"response"]];
                    if (arrRecoJobs.count>0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showSpinner];
                            [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.5];
                        });
                    
                    }
                    else{
                                           
                        dispatch_async(dispatch_get_main_queue(), ^{
                             [self showStatus:K_NO_RECO_JOBS];
                        });
                    }
                    }
                else{
                    //NSLog(@"got error in reco service");
                        dispatch_async(dispatch_get_main_queue(), ^{
                             [self showStatus:K_NO_INTERENT];
                        });
                    }
                                   
                   } errorHandler:^(NSError * _Nonnull error) {
                                   //NSLog(@"got error in connectivity");
                        dispatch_async(dispatch_get_main_queue(), ^{
                              [self showStatus:K_ERROR_REACHABLE];
                        });
                       
                   }];
}
#pragma mark - Notification of reco data
-(void)gotTheRecoData:(NSNotification*)noti{
    //return;
    if([[noti.userInfo objectForKey:@"response"] isKindOfClass:[NSString class]]){
        if(arrRecoJobs.count == 0)
        [self showStatus:[noti.userInfo objectForKey:@"response"]];
    }
    else if([[noti.userInfo objectForKey:@"response"] isKindOfClass:[NSArray class]]){
        
        if(arrRecoJobs.count>0){
            [self performSelector:@selector(loadAfterSomeTime:) withObject:[noti.userInfo objectForKey:@"response"] afterDelay:2.0];
        }
        else{
        [arrRecoJobs addObjectsFromArray:(NSArray*)[noti.userInfo objectForKey:@"response"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arrRecoJobs.count>0){
                [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.5];
            }
            else
                [self showStatus:K_NO_RECO_JOBS];
        });
        }
    }

}
-(void)loadAfterSomeTime:(NSArray*)arr{
    [arrRecoJobs removeAllObjects];
    [arrRecoJobs addObjectsFromArray:arr];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (arrRecoJobs.count>0){
            [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.5];
        }
        else
            [self showStatus:K_NO_RECO_JOBS];
    });
}
- (void)willActivate {
    
    [super willActivate];
    if (bJobSavedFromJD) {
        bJobSavedFromJD = NO;
        if (dictDataFromJD)
        [self jobSavedFromJD];
        
    }
    else if (bJobAppliedFromJDForReco) {
        
        bJobAppliedFromJDForReco = NO;
        if (dictDataFromJD)
            [self jobAppliedFromJDForReco];
    }
    else if (bJobAppliedFromJDForSaved) {
        
        bJobAppliedFromJDForSaved = NO;
        if (dictDataFromJD)
            [self jobAppliedFromJDForSaved];
    }
    
}
#pragma mark- error message show
-(void)showStatus:(NSString*)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_tblRecoJobs setHidden:YES];
        [_grpSpinner setHidden:YES];
        [_grpErrorOcurred setHidden:NO];
        [_lblStatus setText:message];
        
    });
}
#pragma mark- fetch saved jobs

-(void)fetchSavedJobs{
    
    [self showSpinner];
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
       if(session.reachable)
       {
    [[WCSession defaultSession] sendMessage:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"api_saved_jobs",@"name",nil]
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){
                                   
       NSMutableArray* arrJobs = [NSMutableArray arrayWithArray:replyMessage[@"response"]];
       
       if (arrSavedJobs.count)
           [arrSavedJobs removeAllObjects];
       
       [arrSavedJobs addObjectsFromArray:arrJobs];
       
       if (arrSavedJobs.count)
           dispatch_async(dispatch_get_main_queue(), ^{
               [self loadTable];
           });
       else
           [self showStatus:K_NO_SAVED_JOBS];

                                   
       } errorHandler:^(NSError * _Nonnull error) {
           
           [self showStatus:K_SOME_ERROR_OCCURED];

       }];
       }
       else
       {
           [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
            [NSDictionary dictionaryWithObjectsAndKeys:K_ERROR_REACHABLE,KEY_MESSAGE, nil]];
       }
        
    }
}
#pragma mark - Table Loading
-(void)loadTable{

    NSMutableArray* arrData = [NSMutableArray array];
    if (isRecoPage)
        arrData = arrRecoJobs;
    
    else{
        if (!arrSavedJobs.count) {
            [_tblRecoJobs setHidden:YES];
            [_grpErrorOcurred setHidden:NO];
            [_lblStatus setText:K_NO_SAVED_JOBS];
            return;
        }
        arrData = arrSavedJobs;
    }
    
    int iIndex = arrData.count;
    totalRecoCount = iIndex;

    int jobNumberToLoad = 0;
    BOOL isShowLoadMore = NO;
    
    if(totalRecoCount>NUMBER_OF_JOB_LOAD_AT_FIRST_TIME)
    {
        jobNumberToLoad = NUMBER_OF_JOB_LOAD_AT_FIRST_TIME;
        isShowLoadMore = YES;
    }
    else
    {
        jobNumberToLoad = totalRecoCount;
        isShowLoadMore = NO;
    }
    
    if(isShowLoadMore)
    {
        [_tblRecoJobs setNumberOfRows:jobNumberToLoad+1 withRowType:K_RECO_TABLE_CELL_ID];
        for (int i = 0; i < jobNumberToLoad; i++)
            [self refreshTableRowAt:i];
            [self configureLoadMoreAtIndex:jobNumberToLoad];
        
    }else{
    
        [_tblRecoJobs setNumberOfRows:jobNumberToLoad withRowType:K_RECO_TABLE_CELL_ID];
        for (int i = 0; i < jobNumberToLoad; i++)
            [self refreshTableRowAt:i];
    }
    
    currentlyLoadedCell = jobNumberToLoad;

    [_tblRecoJobs setHidden:NO];
    [_grpSpinner setHidden:YES];
    
}

-(void)configureLoadMoreAtIndex:(NSInteger)iIndex{
    RecoTableRowController * row = [_tblRecoJobs rowControllerAtIndex:iIndex];
    row.delegate  = self;
    row.iTag = iIndex;
    [row configureRecoCellForLoadMore];

}
-(void)refreshTableRowAt:(NSInteger)iIndex{
    
    NSMutableArray* arrData = [NSMutableArray array];
    if (isRecoPage)
        arrData = arrRecoJobs;
    else
        arrData = arrSavedJobs;
    
    RecoTableRowController * row = [_tblRecoJobs rowControllerAtIndex:iIndex];
    row.delegate  = self;
    row.iTag = iIndex;
    NSMutableDictionary* dictRecoJob = [arrData objectAtIndex:iIndex];
    [row configureRecoCell:dictRecoJob forIndex:iIndex];
}


-(void)updateTableRowAtIndex:(NSInteger)iIndex withStatus:(NSString*)status{
    
    NSMutableArray* arrData = [NSMutableArray array];
    if (isRecoPage)
        arrData = arrRecoJobs;
    else
        arrData = arrSavedJobs;
    
    RecoTableRowController * row = [_tblRecoJobs rowControllerAtIndex:iIndex];
    row.delegate  = self;
    row.iTag = iIndex;
    
    NSMutableDictionary* dictRecoJob = [NSMutableDictionary dictionaryWithDictionary:[arrData objectAtIndex:iIndex]];
    if ([status isEqualToString:@"applied"])
        [dictRecoJob setObject:[NSNumber numberWithInt:1] forKey:@"IsApplied"];
  
    [row configureRecoCell:dictRecoJob forIndex:iIndex];
}


-(void)hideTheLoaderAtIndex:(NSInteger)iIndex withStatus:(NSString*)status{
    
    NSMutableArray* arrData = [NSMutableArray array];
    if (isRecoPage)
        arrData = arrRecoJobs;
    else
        arrData = arrSavedJobs;
    
    RecoTableRowController * row = [_tblRecoJobs rowControllerAtIndex:iIndex];
    row.delegate  = self;
    row.iTag = iIndex;
    
    NSMutableDictionary* dictRecoJob = [NSMutableDictionary dictionaryWithDictionary:[arrData objectAtIndex:iIndex]];
    if ([status isEqualToString:@"applied"])
        [dictRecoJob setObject:[NSNumber numberWithInt:1] forKey:@"IsApplied"];
    
    [row hideLoader:dictRecoJob forIndex:iIndex];
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RecoData" object:nil];
}

#pragma mark - BUtton actions
-(void)applyClickedAtIndex:(NSInteger)index{
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.reachable) {
            [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"check_eligibility",@"name", nil]
                   replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
               if([[replyMessage objectForKey:@"internet"] boolValue]){
                   
                   if([[replyMessage objectForKey:@"isLoggedIn"] boolValue]){
                       [self callApplyClickedAtIndex:index];
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

-(void)callApplyClickedAtIndex:(NSInteger)index{

    NSMutableDictionary* dictJobDetails = nil;
    if (isRecoPage)
        dictJobDetails = [arrRecoJobs objectAtIndex:index];
    else
        dictJobDetails = [arrSavedJobs objectAtIndex:index];
    
    
    
    
    NSInteger webJob = [[dictJobDetails[@"IsWebJob"] lowercaseString] isEqualToString:@"true"]?1:0;

    
    __block RecoTableRowController * row = [_tblRecoJobs rowControllerAtIndex:index];
    NSString* strJobId =  dictJobDetails[@"JobId"];
    
    [row configureRecoCellForApply];

    //fetch jd for is redirection type job
    [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"jd",@"name",
                                             strJobId,@"jobId",
                                             nil]
        replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                   
        if ([replyMessage[@"response"] isKindOfClass:[NSString class]])
                                       
        [self showStatus:K_NO_INTERENT];
                                   
        else if ([replyMessage[@"response"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary*  dictData = [NSMutableDictionary dictionaryWithDictionary:replyMessage[@"response"]];
                NSInteger redirectionJob = [dictData[@"isRedirectionJob"] intValue]?1:0;
                                       
                if (webJob || redirectionJob){
                    
                    

                if (isRecoPage){
                                               
                            if (![self isALreadySaved:strJobId])
                               [self saveClicked:index];
                    
                    [self hideTheLoaderAtIndex:index withStatus:@"webJob/redirectionJob"];
                            [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithInteger:index],KEY_INDEX,
                                               K_ERROR_WEB_APPLIED_RECO,KEY_MESSAGE,
                                               nil,KEY_DELEGATE,
                                               nil]];
                            }
                else{
                    [self hideTheLoaderAtIndex:index withStatus:@"webJob/redirectionJob"];
                    
                            [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithInteger:index],KEY_INDEX,
                                               K_ERROR_WEB_APPLIED_SAVED,KEY_MESSAGE,
                                               nil,KEY_DELEGATE,
                                               nil]];
                }
                    
                }

                    else if (![WatchHelper sharedInstance].isUserLoggedIn)
                    [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:index],KEY_INDEX,
                                   K_LOGIN_FROM_IPHONE,KEY_MESSAGE,
                                   nil,KEY_DELEGATE,
                                   nil]];

                        else{
//                        #warning testing
//                        return;

                        //[row configureRecoCellForApply];
                        NSMutableDictionary* dictDataForPhone = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @"api_apply",@"name",
                                                            strJobId,@"job_id",
                                                            nil];

[[WCSession defaultSession] sendMessage:dictDataForPhone
      replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){
          
          // NSLog(@"Response **** %@", arrRecoJobs);
          NSString* status = replyMessage[@"apply_status"];
          
          
          dispatch_async(dispatch_get_main_queue(), ^{
              
              if (isRecoPage) {
                  
                  if ([status isEqualToString:@"cq"]){
                      
                      [self updateTableRowAtIndex:index withStatus:@"error"];
                      
                      if (![self isALreadySaved:strJobId])
                          [self saveClicked:index];
                      [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInteger:index],KEY_INDEX,
                                          K_ERROR_CQ_APPLIED_RECO,KEY_MESSAGE,
                                          nil,KEY_DELEGATE,
                                          nil]];
                  }
                  
                  else if ([status isEqualToString:@"sucess"]){
                      
                      [self updateTableRowAtIndex:index withStatus:@"applied"];
                      [self showResponse: [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInteger:index],KEY_INDEX,
                                           K_SUCCESSFULLY_APPLIED,KEY_MESSAGE,
                                           nil,KEY_DELEGATE,
                                           nil]];
                  }
                  else{
                      [self updateTableRowAtIndex:index withStatus:@"error"];
                      [self showResponse: [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInteger:index],KEY_INDEX,
                                           K_SOME_ERROR_OCCURED,KEY_MESSAGE,
                                           nil,KEY_DELEGATE,
                                           nil]];
                  }
                  
              }else{
                  
                  if ([status isEqualToString:@"cq"]){
                      [self updateTableRowAtIndex:index withStatus:@"error"];
                      [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInteger:index],KEY_INDEX,
                                          K_ERROR_CQ_APPLIED_SAVED,KEY_MESSAGE,
                                          nil,KEY_DELEGATE,
                                          nil]];
                  }
                  
                  else if ([status isEqualToString:@"sucess"]){
                      
                      [self reloadRowsAfterIndex:index];
                      [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInteger:index],KEY_INDEX,
                                          K_SUCCESSFULLY_APPLIED,KEY_MESSAGE,
                                          nil,KEY_DELEGATE,
                                          nil]];
                  }
                  else{
                      
                      [self updateTableRowAtIndex:index withStatus:@"error"];
                      [self showResponse: [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInteger:index],KEY_INDEX,
                                           K_SOME_ERROR_OCCURED,KEY_MESSAGE,
                                           self,KEY_DELEGATE,
                                           nil]];
                  }
              }
              
          });
          
      } errorHandler:^(NSError * _Nonnull error) {
          [self showStatus:K_SOME_ERROR_OCCURED];
      }];
}


}
            
        }
   errorHandler:^(NSError * _Nonnull error) {
       
       [self showStatus:K_SOME_ERROR_OCCURED];
       
   }];

    
    
    
    
    
  
}
-(void)loadMoreTapped:(NSInteger)index{

    RecoTableRowController* loadMoreRow = [_tblRecoJobs rowControllerAtIndex:index];
    [loadMoreRow configureRecoCellForShowingLoadMore];
    dispatch_async(dispatch_get_main_queue(), ^{

        int jobNumberToLoad = 0;
        BOOL isShowLoadMore = NO;
        
        if(currentlyLoadedCell+NUMBER_OF_JOB_LOAD_AT_FIRST_TIME<totalRecoCount)
        {
            jobNumberToLoad = NUMBER_OF_JOB_LOAD_AT_FIRST_TIME;
            isShowLoadMore = YES;
        }
        else
        {
            jobNumberToLoad = totalRecoCount - currentlyLoadedCell;
            isShowLoadMore = NO;
        }
        
        if(isShowLoadMore)
        {
            for (int i = currentlyLoadedCell; i < currentlyLoadedCell + jobNumberToLoad; i++)
            {
                [_tblRecoJobs insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:i] withRowType:K_RECO_TABLE_CELL_ID];
                [self refreshTableRowAt:i];
            }
            [self configureLoadMoreAtIndex:currentlyLoadedCell + jobNumberToLoad];
            
        }else{
            
            for (int i = currentlyLoadedCell; i < currentlyLoadedCell + jobNumberToLoad; i++)
            {
                [_tblRecoJobs insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:i] withRowType:K_RECO_TABLE_CELL_ID];
                [self refreshTableRowAt:i];
            }
            //remove load-more row
            [_tblRecoJobs removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:totalRecoCount]];
            
        }
        currentlyLoadedCell = currentlyLoadedCell + jobNumberToLoad;
    });
   
}
-(void)saveClicked:(NSInteger)index{

    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.reachable) {
    RecoTableRowController *row = [_tblRecoJobs rowControllerAtIndex:index];
    [row configureRecoForSaving];

    //synch with iphone
    NSMutableDictionary* dictJob = nil;
    if(isRecoPage)
    dictJob = [arrRecoJobs objectAtIndex:index];
    else
    dictJob = [arrSavedJobs objectAtIndex:index];

    NSString* strJobId =  dictJob[@"JobId"];
    //[dictJob setObject:[NSNumber numberWithInteger:1] forKey:@"IsSaved"];
            
    
    NSDictionary* saveMessage = [NSDictionary dictionaryWithObjectsAndKeys:@"api_save",@"name",
                                 strJobId,@"job_id",nil];

    [[WCSession defaultSession] sendMessage:saveMessage
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){

                               }
                               errorHandler:^(NSError * _Nonnull error) {
                                   
                                   [self showStatus:K_SOME_ERROR_OCCURED];
                               }];
        }
    }
}

-(void)unSaveClicked:(NSInteger)index{

    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.reachable) {

    NSMutableArray* arrData = nil;
    if (isRecoPage)
        arrData = arrRecoJobs;
    else
        arrData = arrSavedJobs;
    
    NSMutableDictionary* dictRecoJob = [arrData objectAtIndex:index];
    //[dictRecoJob setObject:[NSNumber numberWithInteger:0] forKey:@"IsSaved"];

    NSString* strJobId =  dictRecoJob[@"JobId"];
    
    if (isRecoPage) {
        
        RecoTableRowController * row = [_tblRecoJobs rowControllerAtIndex: index];
        [row configureRecoForUnsaving];
    }
    else
        [self reloadRowsAfterIndex:index];


    //synch with iphone
    NSDictionary* unSaveMessage = [NSDictionary dictionaryWithObjectsAndKeys:@"api_unsave",@"name",
                                   strJobId,@"job_id",nil];
    
    [[WCSession defaultSession] sendMessage:unSaveMessage
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){}
                               errorHandler:^(NSError * _Nonnull error) {
                                   
                                   [self showStatus:K_SOME_ERROR_OCCURED];
                               }];
        }
    }
}
#pragma mark--------
-(BOOL)isALreadySaved:(NSString*)jobId{
    
    NSArray *dataArr = nil;
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"JobId == %@", jobId];
    dataArr =  [arrSavedJobs filteredArrayUsingPredicate:namePredicate];
    if(dataArr.count >0)
        return YES;
    else
        return NO;
    
}

-(void)reloadRowsAfterIndex:(NSInteger)index{
    
    [arrSavedJobs removeObjectAtIndex:index];
    [_tblRecoJobs removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
    currentlyLoadedCell = currentlyLoadedCell-1;
    totalRecoCount = totalRecoCount-1;
    
    if (!arrSavedJobs.count) {
        [_tblRecoJobs setHidden:YES];
        [_grpErrorOcurred setHidden:NO];
        [_lblStatus setText:K_NO_SAVED_JOBS];
    }
    
    for (int i = index; i<currentlyLoadedCell; i++) {
        RecoTableRowController * row = [_tblRecoJobs rowControllerAtIndex: i];
        row.iTag = i;
        //[row setConfig:i withDict:[arrSavedJobs objectAtIndex:i]];
    }
   
}

-(void)showResponse:(id)response{
    
    [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:response];
}

-(void)showNotLoggedInView{
    
    [_grpSpinner setHidden:YES];
    [_tblRecoJobs setHidden:YES];
    [_grpErrorOcurred setHidden:NO];
    [_lblStatus setText:K_LOGIN_FROM_IPHONE];
}
-(void)showSpinner{
    [_grpSpinner setHidden:NO];
    [_imgRecoSpinner setHidden:NO];
    [_imgRecoSpinner setImageNamed:@"spinner"];
    [_imgRecoSpinner startAnimatingWithImagesInRange:NSMakeRange(1, 42)
                                    duration:1.0
                                 repeatCount:0];
}

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext{
    [WatchHelper sharedInstance].isUserLoggedIn = [applicationContext[@"login_status"] boolValue];
}
#pragma mark - Tableview delgates
-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    NSMutableArray* arrData = nil;
    if (isRecoPage)
        arrData = arrRecoJobs;
    else
        arrData = arrSavedJobs;
    
    NSDictionary* dataDict = [arrData objectAtIndex:rowIndex];
    [self pushControllerWithName:CONTROLLER_JD_SCREEN context:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isRecoPage],@"reco_page",
                                                              dataDict,@"data",
                                    [NSNumber numberWithInteger:[dataDict[@"IsApplied"] integerValue]],@"is_applied",
                                    self, KEY_DELEGATE,
                                    [NSNumber numberWithInteger:rowIndex], KEY_INDEX,
                                                               nil]];
}

-(void)jobSavedFromJD{
    
    NSString* jobId = dictDataFromJD[@"job_id"];
    if(isRecoPage)
    {
    
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"JobId == %@", jobId];
        NSArray *dataArr = [arrRecoJobs filteredArrayUsingPredicate:namePredicate];
        if(dataArr.count>0)
        {
            NSInteger index = [arrRecoJobs indexOfObject:[dataArr objectAtIndex:0]];
            [self saveClicked:index];

        }
        
    }
    else{
        
            NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"JobId == %@", jobId];
            NSArray *dataArr = [arrSavedJobs filteredArrayUsingPredicate:namePredicate];
            if(dataArr.count>0)
            {
                NSInteger index = [arrSavedJobs indexOfObject:[dataArr objectAtIndex:0]];
                [self saveClicked:index];
                
            }

    }
        dictDataFromJD = nil;
}

-(void)jobAppliedFromJDForReco{
    
    NSInteger index = [dictDataFromJD[KEY_INDEX] integerValue];
    [self updateTableRowAtIndex:index withStatus:@"applied"];
    dictDataFromJD = nil;

    
}

-(void)jobAppliedFromJDForSaved{
    
    NSInteger index = [dictDataFromJD[KEY_INDEX] integerValue];
    [self reloadRowsAfterIndex:index];
    dictDataFromJD = nil;

}
#pragma mark JD_DELEGATES

-(void)updateValuesForSave:(NSDictionary*)dictData{
    
    bJobSavedFromJD = YES;
    dictDataFromJD = dictData;
}

-(void)updateApplyValueFromReco:(NSDictionary*)dictData{
    
    bJobAppliedFromJDForReco = YES;
    dictDataFromJD = dictData;
}


-(void)updateApplyValueFromSaved:(NSDictionary*)dictData{
    
    bJobAppliedFromJDForSaved = YES;
    dictDataFromJD = dictData;
}
@end



