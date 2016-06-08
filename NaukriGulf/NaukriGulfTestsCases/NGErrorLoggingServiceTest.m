////
////  NGErrorLoggingServiceTest.m
////  NaukriGulf
////
////  Created by Sandeep.Negi on 02/11/14.
////  Copyright (c) 2014 Infoedge. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import <XCTest/XCTest.h>
//#import "NGExceptionCoreData.h"
//#import "NGServerErrorCoreData.h"
//
//@interface NGErrorLoggingServiceTest : XCTestCase{
//    int testState;
//}
//
//@end
//
//@implementation NGErrorLoggingServiceTest
//
//- (void)setUp {
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//- (void)testErrorLogging {
//    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
//    
//    NSArray* logsArray = [[[NGStaticContentManager alloc]init]fetchSavedExceptions];
//    NSArray* errorsArray = [[[NGStaticContentManager alloc]init]fetchSavedErrorsForServer];
//    
//    if(logsArray.count + errorsArray.count == 0)
//        return;
//    
//    NSMutableArray* errArr = [[NSMutableArray alloc]init];
//    
//    for (NGExceptionCoreData* exception in logsArray)
//        [errArr addObject:[NSString stringWithFormat:@"#TimeStamp: %@ #Exception: %@ #Cause: %@ #trace",exception.timeStamp,exception.exceptionName,exception.exceptionDebugDescription]];
//    
//    
//    for (NGServerErrorCoreData* errorServer in errorsArray)
//        [errArr addObject:[NSString stringWithFormat:@"#ApiType: %@ #ErrorDescription: %@",
//                           errorServer.errorType, errorServer.errorDesription]];
//    
//    NSString* crashStr = [[NGHelper sharedInstance]getStringsFromArray:errArr];
//    NSString* messageToLog = [NSString stringWithFormat:@"#App Version:%@ #Handset Model:%@  #iOS Version:%@ %@",[[NGHelper sharedInstance]getAppVersion],[UIDevice currentDevice].model,[UIDevice currentDevice].systemVersion,crashStr];
//    NGWebDataManager* dataManager = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_ERROR_LOGGING];
////    dataManager.delegate = self;
////    [dataManager getDataWithParameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:messageToLog,@"message",@"1f0n3",@"clientId", nil]];
//    
//    while (!testState && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
//}
//
//-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData {
//    testState=1;
//    XCTAssert(YES,@"Success");
//}
//
//-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData {
//    testState=1;
//    XCTAssert(YES,@"Failed");
//}
//
//@end
