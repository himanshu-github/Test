//
//  NGTestWorkExperienceDetails.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/2/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSMutableDictionary+SetObject.h"

@interface NGTestWorkExperienceDetails : XCTestCase<NGLoginHelperTestDelegate>{
    
 XCTestExpectation *expectation;    
}

@end

@implementation NGTestWorkExperienceDetails

- (void)setUp {
    
    [super setUp];
   
    expectation = [self expectationWithDescription:@"NGTestWorkExperienceDetails"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
}

- (void)tearDown {
    
    [super tearDown];
    
    expectation =[self expectationWithDescription:@"NGTestWorkExperienceDetails"];
    
    [NGLoginHelperTest sharedInstance].delegate = self;
    
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
    // Put teardown code here. This method is called after the invocation of each }
}
#pragma mark Login Delegate
-(void)successfullyLoginTest{
 
    [expectation fulfill];
}
- (void)successfullyLogoutTest{
    
    [expectation fulfill];
}
-(void)errorInLoginTest{
    
    XCTFail(@"Error In Login");
    [expectation fulfill];
}

-(void)errorInLogoutTest{
    XCTFail(@"Error In Logout");
    [expectation fulfill];
}

- (void)testAddWorkExperience {

    expectation =[self expectationWithDescription:@"NGTestWorkExperienceDetails"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setCustomObject:@"test designation" forKey:@"designation"];
    
    [params setCustomObject:@"test designation" forKey:@"designationEN"];
    
    [params setCustomObject:@"test organisation" forKey:@"organization"];
    [params setCustomObject:@"test organisation" forKey:@"organizationEN"];
    
    [params setCustomObject:@"2014-11-01" forKey:@"startDate"];
    
    [params setCustomObject:@"Present" forKey:@"endDate"];
    
    [params setCustomObject:@"test your job profile" forKey:@"jobProfile"];
    [params setCustomObject:@"test your job profile" forKey:@"jobProfileEN"];
    
    [params setCustomObject:@"0" forKey:@"resId"];
    
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
    [finalParams setCustomObject:params forKey:@"workExperience"];
    
    [obj getDataWithParams:finalParams handler:^(NGAPIResponseModal *responseInfo) {
        
        XCTAssertTrue(responseInfo.isSuccess,@"Problem with Add Work Ex api Response");
        [self editWorkExpTest];
        
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

-(void) editWorkExpTest {
    
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    
    if (objModel.workExpList.count) {
  
      NGWorkExpDetailModel *workObjModel =   [objModel.workExpList objectAtIndex:0];
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setCustomObject:@"test edit designation " forKey:@"designation"];
        
        [params setCustomObject:@"test edit designation" forKey:@"designationEN"];
        
        [params setCustomObject:@"test  edit organisation" forKey:@"organization"];
        [params setCustomObject:@"test edit organisation" forKey:@"organizationEN"];
        
        [params setCustomObject:@"2016-11-01" forKey:@"startDate"];
        
        [params setCustomObject:@"Present" forKey:@"endDate"];
        
        [params setCustomObject:@"test edit your job profile" forKey:@"jobProfile"];
        [params setCustomObject:@"test edit your job profile" forKey:@"jobProfileEN"];
        
        [params setCustomObject:@"0" forKey:@"resId"];
        
        NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
        [finalParams setCustomObject:params forKey:@"workExperience"];
        
        [finalParams setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:workObjModel.workExpID,@"id", nil] forKey:@"where"];
        
        [obj getDataWithParams:finalParams handler:^(NGAPIResponseModal *responseInfo) {
            
            XCTAssertTrue(responseInfo.isSuccess,@"Problem with EDIT Work Ex API Response");
            [self deleteWorkExpTest];
        }];
    
    }
   
}

-(void) deleteWorkExpTest{
   
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    
    if (objModel.workExpList.count) {
        
        NGWorkExpDetailModel *workObjModel =   [objModel.workExpList objectAtIndex:0];
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DELETE_RESUME];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setCustomObject:workObjModel.workExpID forKey:@"id"];
        [params setCustomObject:@"0" forKey:@"resId"];
        
        NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
        
        [finalParams setCustomObject:params forKey:@"workExperience"];
        
        [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:finalParams,@"where", nil] handler:^(NGAPIResponseModal *responseInfo) {
            XCTAssertTrue(responseInfo.isSuccess,@"Problem with Delete Work Ex API Response");
          
            [expectation fulfill];
            
        }];
        
    }
    
}
@end
