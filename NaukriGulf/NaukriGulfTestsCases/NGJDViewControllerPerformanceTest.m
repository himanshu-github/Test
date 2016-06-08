//
//  NGJDViewControllerPerformanceTest.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/9/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGJDViewController.h"
@interface NGJDViewControllerPerformanceTest : XCTestCase{
    
    NGJDViewController *jdVc;
    
}

@end

@implementation NGJDViewControllerPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    jdVc = [[NGHelper sharedInstance].jobSearchstoryboard instantiateViewControllerWithIdentifier:@"JDView2"];
    NGJobDetails *obj = nil;
    jdVc.jobID = obj.jobID;
    
    jdVc.srpJobObj = obj;
    jdVc.openJDLocation = 0;
    jdVc.viewCtrller=self;
    jdVc.selectedIndex = 0;
    

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark Performance Test cases
- (void)testPerformanceViewDidLoad {
    
    [self measureBlock:^{
        [jdVc viewDidLoad];
        
    }];
}

- (void)testPerformanceViewWillAppear{
    
    [self measureBlock:^{
        [jdVc viewWillAppear:YES];
    }];
}


- (void)testPerformanceViewDidAppear{
    
    [self measureBlock:^{
        [jdVc viewDidAppear:YES];
        
    }];
}

- (void)testPerformanceViewWillDisappear{
    
    [self measureBlock:^{
        [jdVc viewWillDisappear:YES];
        
    }];
}

- (void)testPerformanceViewDidDisappear{
    
    [self measureBlock:^{
        [jdVc viewDidDisappear:YES];
        
    }];
}


@end
