//
//  NGDateHandlerTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 06/02/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface NGDateHandlerTest : XCTestCase

@end

@implementation NGDateHandlerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testGetDateFromLongStyle{
    
    NSString *dateStr;
    
    //nil check
    dateStr = nil;
    XCTAssertNil([NGDateManager getDateFromLongStyle:dateStr],@"NGDateHandler->getDateFromLongStyle giving invalid result.");
    
    
    //empty string check
    dateStr = @"";
    XCTAssertNil([NGDateManager getDateFromLongStyle:dateStr],@"NGDateHandler->getDateFromLongStyle giving invalid result.");
    
    //invalid character date
    dateStr = @"er-34-4550 er:56:55";
    XCTAssertNil([NGDateManager getDateFromLongStyle:dateStr],@"NGDateHandler->getDateFromLongStyle giving invalid result.");
    
    //valid date object
    dateStr = @"February 28,1998";
    NSString *dateStrTobeChecked = [NGDateManager getDateFromLongStyle:dateStr];
    XCTAssertNotNil(dateStrTobeChecked,@"NGDateHandler->getDateFromLongStyle giving null result.");
    
    //now correct date result
    XCTAssertTrue([@"1998-02-28" isEqualToString:dateStrTobeChecked],@"NGDateHandler->getDateFromLongStyle giving unexpected result.");
}

-(void) testFormatDateInMonthYear{
    
    NSString *dateStr;
    dateStr = nil;
    XCTAssertNil([NGDateManager formatDateInMonthYear:dateStr],@"NGDateHandler->testFormatDateInMonthYear giving invalid result.");
    
    dateStr = @"";
    XCTAssertNil([NGDateManager formatDateInMonthYear:dateStr],@"NGDateHandler->testFormatDateInMonthYear giving invalid result.");
    
    
    dateStr = @"er344550 er:56:55";
    XCTAssertNil([NGDateManager formatDateInMonthYear:dateStr],@"NGDateHandler->testFormatDateInMonthYear giving invalid result.");

    dateStr = @"2015-12-01";
    NSString *dateStrTobeChecked = [NGDateManager formatDateInMonthYear:dateStr];
    XCTAssertNotNil(dateStrTobeChecked,@"NGDateHandler->getDateFromLongStyle giving null result.");
    
    //now correct date result
    XCTAssertTrue([@"December, 2015" isEqualToString:dateStrTobeChecked],@"NGDateHandler->getDateFromLongStyle giving unexpected result.");

}

-(void) testGetDateInLongStyle{
    
    NSString *dateStr;
    dateStr = nil;
    XCTAssertNil([NGDateManager getDateInLongStyle:dateStr],@"NGDateHandler->testGetDateInLongStyle giving invalid result.");
    
    dateStr = @"";
    XCTAssertNil([NGDateManager getDateInLongStyle:dateStr],@"NGDateHandler->testGetDateInLongStyle giving invalid result.");
    
    dateStr = @"er344550 er:56:55";
    XCTAssertNil([NGDateManager getDateInLongStyle:dateStr],@"NGDateHandler->testGetDateInLongStyle giving invalid result.");
    
    dateStr = @"1980-01-01";
    NSString *dateStrTobeChecked = [NGDateManager getDateInLongStyle:dateStr];
    XCTAssertNotNil(dateStrTobeChecked,@"NGDateHandler->testGetDateInLongStyle giving null result.");
    
    //now correct date result
    XCTAssertTrue([@"January 1,1980" isEqualToString:dateStrTobeChecked],@"NGDateHandler->testGetDateInLongStyle giving unexpected result.");


}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
