//
//  NGNewMonkErrorLogTest.m
//  NaukriGulf
//
//  Created by Himanshu on 12/24/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NGServerErrorCoreData.h"
#import "NGServerErrorDataModel.h"

@interface NGNewMonkErrorLogTest : XCTestCase
{
    XCTestExpectation *monkApiExpectation;

}
@end

@implementation NGNewMonkErrorLogTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testNewMonkApi{

    monkApiExpectation = [self expectationWithDescription:@"NGNewMonkApiTest"];
    {
        
        NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
        sedm.serverExceptionErrorType = @"logger";
        sedm.serverExceptionDescription = @"Invalid Json Response";
        [NGExceptionHandler logServerError:sedm];
        //will save in database
        
        NSArray* errorsArray = [[[NGStaticContentManager alloc]init]fetchSavedErrorsForServer];
        
        if(errorsArray.count == 0)
        {
            XCTFail(@"Exception Not saved in Database");
        }
        
        NSMutableDictionary *errDict  = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"app",K_NEW_MONK_EXCEPTION_SOURCE,
                                         @"2",K_NEW_MONK_EXCEPTION_APPID,
                                         [UIDevice currentDevice].identifierForVendor.UUIDString,K_NEW_MONK_EXCEPTION_UID,
                                         [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSMutableDictionary
                                           dictionaryWithObjectsAndKeys:@"ios",@"name",[UIDevice currentDevice].systemVersion,@"version", nil],K_NEW_MONK_EXCEPTION_OS,
                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString getAppVersion],@"version", nil],K_NEW_MONK_EXCEPTION_APP,
                                          [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIDevice currentDevice].model,@"name", nil],K_NEW_MONK_EXCEPTION_DEVICE,
                                          nil],K_NEW_MONK_EXCEPTION_ENVIRONMENT,
                                         nil];
        
        if(errDict==nil)
            XCTFail(@"Error in parameters");
        
        NSMutableArray* errArr = [[NSMutableArray alloc]init];
        for (NGServerErrorCoreData* errorServer in errorsArray)
        {
            if(errorServer.errorName==nil)
                XCTFail(@"Exception not found");
            
            [errArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               errorServer.errorTag,K_NEW_MONK_EXCEPTION_TAG,
                               //@"1",K_NEW_MONK_EXCEPTION_COUNT,     //optional
                               errorServer.timeStamp,K_NEW_MONK_EXCEPTION_TIME_STAMP,
                               errorServer.errorType,K_NEW_MONK_EXCEPTION_TYPE,
                               errorServer.errorName,K_NEW_MONK_EXCEPTION_MESSAGE,
                               //@"",K_NEW_MONK_EXCEPTION_CODE,     //optional
                               //@"",K_NEW_MONK_EXCEPTION_FILE,     //optional
                               //@"",K_NEW_MONK_EXCEPTION_LINE,     //optional
                               errorServer.errorDesription,K_NEW_MONK_EXCEPTION_STACK_TRACE,
                               nil]];
        }
        if(errArr==nil)
            XCTFail(@"Error in parameters");

        
        [errDict setObject:errArr forKey:K_NEW_MONK_EXCEPTION];
        if(errDict==nil)
            XCTFail(@"Error in parameters");

        NGWebDataManager* dataManager = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_ERROR_LOGGING];
        
        [dataManager getDataWithParams:errDict handler:^(NGAPIResponseModal *responseData){
            
            XCTAssertEqual(responseData.responseCode, K_RESPONSE_SUCESS_WITHOUT_BODY,@"Error in Logging exception on New Monk");
            [[[NGStaticContentManager alloc]init]deleteExceptions];

            [monkApiExpectation fulfill];
        }];
    }
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}
@end
