//
//  NGBackgroundfetcherHelperTests.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/6/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGBackgroundFetchHelper.h"

@interface NGBackgroundfetcherHelperTests : XCTestCase

@end

@implementation NGBackgroundfetcherHelperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSharedInstance {
    
    NGBackgroundFetchHelper *instanceOne = [NGBackgroundFetchHelper sharedInstance];
    NGBackgroundFetchHelper *instanceTwo = [NGBackgroundFetchHelper sharedInstance];
    
    //single instance not nil
    XCTAssertNotNil(instanceOne,@"Instance is nil");
    
    //two instaces should be same
    XCTAssertEqual(instanceOne, instanceTwo,@"Instances are not equal");
    
    //Alloc
    instanceOne = [[NGBackgroundFetchHelper alloc] init];
    
    //alloc instance not nil
    XCTAssertNotEqual(instanceOne, instanceTwo,@"Instances should not be equal but they are equal");
    
}
-(void)testAppDelegatePerformFetch{
    
    [APPDELEGATE application:[UIApplication sharedApplication] performFetchWithCompletionHandler:^(UIBackgroundFetchResult result) {
        
        //on failure result must send something else of new data
        XCTAssertTrue(UIBackgroundFetchResultNewData == result,@"background fetch failed");
        
    }];
}
-(void)tecsstShouldPerformBgFetchForRecommendedJobs{
    
    //##### Cases to check #####
    
    //1.Server switch for background fetch
    
    //2.isNightTimeForRecoJobs
    //This method's test depends on your machines time
    
    //3.interval between last hit time and now is greater than or equal to server reco interval
    
    //##### Cases to check #####
    
    
    NSDate *lastHitDateOfRecoJobsDownload_original = [NGSavedData lastHitDateOfRecoJobsDownload];
    NSNumber *recoJobBackgroundHitInterval_original = [NGSavedData recoJobBackgroundHitInterval];
    
    //1.Check backgroundfetch switch from server
    
    //1.a Switch is ON
    
    NGBackgroundFetchHelper *bgFetchHelper = [NGBackgroundFetchHelper sharedInstance];
    
    [NGSavedData saveRecoJobBackgroundHitInterval:@1];
    XCTAssertTrue([bgFetchHelper shouldPerformBgFetchForRecommendedJobs],@"Background fetch server switch is ON");
    
    //1.b Switch is OFF
    [NGSavedData saveRecoJobBackgroundHitInterval:@(-1)];
    XCTAssertFalse([bgFetchHelper shouldPerformBgFetchForRecommendedJobs],@"Background fetch server switch is OFF");
    
    //2.is night time check
    //11pm ot 7am(6:59am)
    XCTAssertFalse([NGDateManager isNightTimeInDate:[NSDate date]],@"Background fetch isNightTimeForRecoJobs");
    
    
    //3.interval between last hit time and now is smaller than or equal to server reco interval
    [NGSavedData saveRecoJobBackgroundHitInterval:@(12*60*60)];//taking 12hrs as default
    [NGSavedData saveLastHitDateOfRecoJobsDownload:[NSDate date]];
    XCTAssertFalse([bgFetchHelper shouldPerformBgFetchForRecommendedJobs],@"interval between last hit and now is almost zero");
    
    
    [NGSavedData saveLastHitDateOfRecoJobsDownload:[NSDate dateWithTimeIntervalSince1970:0]];
    XCTAssertTrue([bgFetchHelper shouldPerformBgFetchForRecommendedJobs],@"interval between last hit and now is almost infinity");
    
    
    //reset to original
    [NGSavedData saveLastHitDateOfRecoJobsDownload:lastHitDateOfRecoJobsDownload_original];
    [NGSavedData saveRecoJobBackgroundHitInterval:recoJobBackgroundHitInterval_original];
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
