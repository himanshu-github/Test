//
//  NGSRPViewControllerPerformanceTest.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/9/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGSRPViewController.h"
@interface NGSRPViewControllerPerformanceTest : XCTestCase{
    
    NGSRPViewController *srpVc;
}

@end

@implementation NGSRPViewControllerPerformanceTest

- (void)setUp {
    [super setUp];
   
       srpVc = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"SRPView"];
    
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithInteger:0] forKey:@"Offset"];
        [params setObject:[NSNumber numberWithInteger:[NGConfigUtility getJobDownloadLimit]] forKey:@"Limit"];
        [params setObject:@"abc" forKey:@"Keywords"];
        [params setObject:@"delhi" forKey:@"Location"];
        [params setObject:[NSNumber numberWithInteger:1] forKey:@"Experience"];
        
        
        srpVc.paramsDict = params;
        srpVc.startTime = [NSDate date];
        

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [srpVc viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [srpVc viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [srpVc viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [srpVc viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [srpVc viewDidDisappear:YES];
        
    }];
}

@end
