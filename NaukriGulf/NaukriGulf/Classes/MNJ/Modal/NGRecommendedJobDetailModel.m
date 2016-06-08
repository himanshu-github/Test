//
//  NGRecommendedJobDetailModel.m
//  NaukriGulf
//
//  Created by bazinga on 13/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGRecommendedJobDetailModel.h"

@implementation NGRecommendedJobDetails
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    return  [super initWithCoder:aDecoder];
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"Job.Designation": @"designation",
                                                       @"Job.IsFeaturedEmployer": @"isFeaturedEmployerStr",
                                                       @"Job.Company.Name": @"cmpnyName",
                                                       @"Job.Keywords": @"keywords",
                                                       @"Job.Experience.Min": @"minExp",
                                                       @"Job.IsQuickWebJob": @"isQuickWebJobStr",
                                                       @"Job.Location": @"location",
                                                       @"Job.IsApplied": @"isAlreadyAppliedStr",
                                                       @"Job.Description": @"jobDescription",
                                                       @"Job.IsWebJob": @"isWebJobStr",
                                                       @"Job.JobId": @"jobID",
                                                       @"Job.Vacancies": @"vacancy",
                                                       @"Job.Company.Id": @"cmpnyID",
                                                       @"Job.JdURL": @"jdURL",
                                                       @"Job.LatestPostedDate": @"latestPostDate",
                                                       @"Job.IsTopEmployer": @"isTopEmployerStr",
                                                       @"Job.IsPremium": @"isPremiumJobStr",
                                                       @"Job.Experience.Max": @"maxExp",
                                                       @"Job.ApplyDate": @"appliedDate",
                                                       @"Job.LogoUrl": @"logoURL"
                                                       
                                                       }];
}

@end

@implementation NGRecommendedJobDetailModel
#pragma mark JSON Model Methods

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"TotalJobsCount": @"totoalJobsCount",
                                                       @"list": @"jobList",
                                                       @"NewJobsCount": @"newJobsCount",
                                                       }];
}

@end

