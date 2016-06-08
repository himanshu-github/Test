//
//  NGWatchOSAndiOSCommunicationLayerTests.m
//  NaukriGulf
//
//  Created by Nveen Bandlamoodi on 08/06/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WatchOSAndiOSCommunicationLayer.h"
#import "NGJDdataFetcher.h"

@interface WatchOSAndiOSCommunicationLayer (CategoryForUnitTesting)

-(NSDictionary*)jdDetails:(NGJDJobDetails*)jdObj;

-(NSMutableDictionary*)getRecoJob:(NGJobDetails*)jdObj;

-(NSMutableDictionary*)parseCVViewsForWatch:(NSDictionary*)cvObj;

@end

@interface NGWatchOSAndiOSCommunicationLayerTests : XCTestCase
{
    XCTestExpectation *expectation;
}

@end

@implementation NGWatchOSAndiOSCommunicationLayerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedInstance
{
    WatchOSAndiOSCommunicationLayer *instanceOne = [WatchOSAndiOSCommunicationLayer sharedInstance];
    WatchOSAndiOSCommunicationLayer *instanceTwo = [WatchOSAndiOSCommunicationLayer sharedInstance];
    
    //single instance not nil
    XCTAssertNotNil(instanceOne, @"Instance is nil");
    
    //two instaces should be same
    XCTAssertEqual(instanceOne, instanceTwo, @"Instances are not equal");
    
    //Alloc
    instanceOne = [[WatchOSAndiOSCommunicationLayer alloc] init];
    
    //alloc instance not nil
    XCTAssertNotEqual(instanceOne, instanceTwo, @"Instances should not be equal but they are equal");
}

- (void)testJdDetails
{
    expectation = [self expectationWithDescription:@"NGJDLoggedInTest"];
    WatchOSAndiOSCommunicationLayer *instance = [WatchOSAndiOSCommunicationLayer sharedInstance];
    
    NGStaticContentManager *jobMgrObj = [DataManagerFactory getStaticContentManager];
    NSArray *jobsArr = [jobMgrObj getAllRecommendedJobs];
    
    NGJobDetails *jobDet = [jobsArr firstObject];
    
    NSDictionary *resourceParams = [NSDictionary dictionaryWithObjectsAndKeys:jobDet.jobID,@"jobId", nil];
    NSMutableDictionary *attributeParams = [NSMutableDictionary  dictionaryWithDictionary:resourceParams];
    [attributeParams removeObjectForKey:@"jobId"];
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_JD];
    [obj getDataWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:resourceParams,K_RESOURCE_PARAMS,attributeParams,K_ATTRIBUTE_PARAMS, nil] handler:^(NGAPIResponseModal *responseData)
    {
        NSString *response = responseData.responseData;
        NSDictionary *jobDetail = [response JSONValue];
        
        NGJDJobDetails *jdObj = nil;
        
        if (jobDetail && ![jobDetail objectForKey:@"error"])
        {
            NSError* err = nil;
            jdObj = [[NGJDJobDetails alloc]initWithDictionary:[jobDetail objectForKey:@"Job"]  error:&err];
        }
        
        NSDictionary* myDict = [instance jdDetails:jdObj];
        
        XCTAssertEqualObjects(jdObj.designation, myDict[@"designation"]);
        XCTAssertEqualObjects(jdObj.companyName, myDict[@"company"]);
        XCTAssertEqualObjects(jdObj.formattedExperience, myDict[@"experience"]);
        XCTAssertEqualObjects(jdObj.location, myDict[@"location"]);
        XCTAssertEqualObjects(jdObj.jobDescription, myDict[@"job_description"]);
        XCTAssertEqualObjects(jdObj.companyProfile, myDict[@"employer_details"]);
        XCTAssertEqualObjects(jdObj.gender, myDict[@"gender"]);
        XCTAssertEqualObjects(jdObj.nationality, myDict[@"nationality"]);
        XCTAssertEqualObjects(jdObj.education, myDict[@"education"]);
        XCTAssertEqualObjects(jdObj.dcProfile, myDict[@"dc_profile"]);
        XCTAssertEqualObjects(jdObj.contactName, myDict[@"contact_name"]);
        XCTAssertEqualObjects(jdObj.formattedVacancies, myDict[@"vacancy"]);
        XCTAssertEqualObjects(jdObj.formattedSalary, myDict[@"salary"]);
        XCTAssertEqualObjects(jdObj.formattedLatestPostedDate, myDict[@"postedOn"]);
        XCTAssertEqualObjects(jdObj.isCtcHidden, myDict[@"isCtcHidden"]);
        XCTAssertEqualObjects(jdObj.industryType, myDict[@"industryType"]);
        XCTAssertEqualObjects(jdObj.functionalArea, myDict[@"functionalArea"]);
        XCTAssertEqualObjects(jdObj.keywords, myDict[@"keywords"]);
        XCTAssertEqualObjects(jdObj.contactWebsite, myDict[@"contact_website"]);
        XCTAssertEqualObjects(jdObj.isJobRedirection, myDict[@"isRedirectionJob"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [expectation fulfill];
            
        });
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT handler:nil];
    
}

- (void)testGetRecoJob
{
    WatchOSAndiOSCommunicationLayer *instance = [WatchOSAndiOSCommunicationLayer sharedInstance];
    
    NGStaticContentManager *jobMgrObj = [DataManagerFactory getStaticContentManager];
    NSArray *jobsArr = [jobMgrObj getAllRecommendedJobs];
    
    NGJobDetails *jobDet = [jobsArr firstObject];
    
    NSMutableDictionary* myDict = [instance getRecoJob:jobDet];
    
    XCTAssertEqual(myDict[@"Designation"], jobDet.designation, @"");
    XCTAssertEqual(myDict[@"Location"], jobDet.location, @"");
    
    NSDictionary *minMaxDict = [NSDictionary dictionaryWithObjectsAndKeys:jobDet.minExp,@"Min",jobDet.maxExp,@"Max", nil];
    XCTAssertEqualObjects(myDict[@"Experience"], minMaxDict);
    
    NSDictionary *companyDict = [NSDictionary dictionaryWithObjectsAndKeys:jobDet.cmpnyName,@"Name",jobDet.cmpnyID,@"Id", nil];
    XCTAssertEqualObjects(myDict[@"Company"], companyDict);
    
    XCTAssertEqual(myDict[@"JobId"], jobDet.jobID);
    XCTAssertEqualObjects(myDict[@"IsWebJob"], jobDet.isWebJob?@"true":@"false");
    
    NSString *isAlreadyApplied = [NSString stringWithFormat:@"%i",jobDet.isAlreadyApplied];
    XCTAssertEqual(myDict[@"IsApplied"], isAlreadyApplied);
    
}

- (void)testParseCVViewsForWatch
{
    WatchOSAndiOSCommunicationLayer *instance = [WatchOSAndiOSCommunicationLayer sharedInstance];

    NSDictionary *cvObj = [NSDictionary dictionaryWithObjectsAndKeys:@"Noida", @"cityLabel", @"id", @"clientId", @"Naukri", @"compName", @"India", @"countryLabel", @"11-11-1993", @"viewedDate", @"SomeLabel", @"indLabel", nil];
    
    NSDictionary *parsedDict = [instance parseCVViewsForWatch:cvObj];
    
    XCTAssertEqualObjects(cvObj, parsedDict, @"Error in parsing dictionaries");
}

@end
