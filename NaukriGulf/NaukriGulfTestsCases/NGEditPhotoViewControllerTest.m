//
//  NGEditPhotoViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/6/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NGLoginHelperTest.h"

@interface NGEditPhotoViewControllerTest : XCTestCase<NGLoginHelperTestDelegate>{
 
    XCTestExpectation *expectation;
    UIImage *imageFromDevice;
}

@end

@implementation NGEditPhotoViewControllerTest

- (void)setUp {
    [super setUp];
    imageFromDevice = [UIImage imageNamed:@"alreadyAppliedJobIcon"];
    
    expectation = [self expectationWithDescription:@"NGEditPhotoViewController"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogIn];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
}

- (void)tearDown {
    
    [super tearDown];
    expectation = [self expectationWithDescription:@"NGEditPhotoViewController"];
    [NGLoginHelperTest sharedInstance].delegate = self;
    [[NGLoginHelperTest sharedInstance] makeUserLogOut];
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
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

- (void)testEditPhoto {
   
    expectation = [self expectationWithDescription:@"NGEditPhotoViewController"];
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_FILE_UPLOAD];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setCustomObject:imageFromDevice forKey:@"PHOTO"];
    [params setCustomObject:k_FILE_UPLOAD_APP_ID_MNJ forKey:k_FILE_UPLOAD_APP_ID_KEY];
    [params setCustomObject:[NSNumber numberWithUnsignedInteger:NGFileUploadTypePhoto] forKey:K_FILE_UPLOAD_TYPE_KEY];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
            XCTAssertTrue(responseInfo.isSuccess, @"Problem with File Uplaod");
           [self uploadPhoto:responseInfo];

   }];

    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];

}

-(void)uploadPhoto:(NGAPIResponseModal*)paramResponseInfo{
    
    
    NSString *formKey = [paramResponseInfo.parsedResponseData objectForKey:@"formKey"];
    NSString *fileKey = [paramResponseInfo.parsedResponseData objectForKey:@"fileKey"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPLOAD_PHOTO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setCustomObject:fileKey forKey:@"fileKey"];
    [params setCustomObject:formKey forKey:@"formKey"];
    
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (responseInfo.isSuccess) {
                
                XCTAssertTrue(responseInfo.isSuccess, @"Problem with Uploading Photo");
                [self downloadPhotoTestCase];
                
            }
            
            
        });
        
    }];
    
}


-(void) downloadPhotoTestCase {
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_PROFILE_PHOTO];
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseInfo) {
        
        if (responseInfo.isSuccess) {
            XCTAssertTrue(responseInfo.isSuccess, @"Problem with Download Photo");
            [self deletePhotoTestCase];
            
        }
    }];
}

-(void) deletePhotoTestCase{
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DELETE_PHOTO];
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseInfo) {
        
        if (responseInfo.isSuccess) {
            XCTAssertTrue(responseInfo.isSuccess, @"Problem with Delete Photo");
            [expectation fulfill];
        }
    }];
}








@end
