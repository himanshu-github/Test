//
//  NGAppliedJobDetailModel.m
//  NaukriGulf
//
//  Created by Swati Kaushik on 30/06/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGAppliedJobDetailModel.h"
@implementation NGAppliedJobDetails
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
   return  [super initWithCoder:aDecoder];
}
+(JSONKeyMapper*)keyMapper
{
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"Designation": @"designation",
                                                       @"IsFeaturedEmployer": @"isFeaturedEmployer",
                                                       @"Company.Name": @"cmpnyName",
                                                       @"Keywords": @"keywords",
                                                       @"Experience.Min": @"minExp",
                                                       @"IsQuickWebJob": @"isQuickWebJob",
                                                       @"Location": @"location",
                                                       @"IsApplied": @"isAlreadyApplied",
                                                       @"Description": @"description",
                                                       @"IsWebJob": @"isWebJob",
                                                       @"JobId": @"jobID",
                                                       @"Vacancies": @"vacancy",
                                                       @"Company.Id": @"cmpnyID",
                                                       @"JdURL": @"jdURL",
                                                       @"LatestPostedDate": @"latestPostDate",
                                                       @"IsTopEmployer": @"isTopEmployer",
                                                       @"Experience.Max": @"maxExp",
                                                       @"ApplyDate": @"appliedDate",
                                                       @"LogoUrl": @"logoURL"
                                                       }];
}

@end
@implementation NGAppliedJobDetailModel
#pragma mark JSON Model Methods

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"TotalJobsCount": @"totoalJobsCount",
                                                       @"Jobs": @"jobList",
                                                       }];
}

@end
