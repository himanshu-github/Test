//
//  NGSearchJobHelperTest.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGSearchJobHelperTest.h"


@implementation NGSearchJobHelperTest

+(instancetype)sharedInstance{
    static NGSearchJobHelperTest *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGSearchJobHelperTest alloc]init];
    });
    return sharedInstance;
}
-(NSInteger)jobDownloadLimitForTest{
    return 5;
}
-(void)fetchNonAppliedJDWithHandler:(void(^)(NGJobDetails * jobDetail))completionHandler{
    
    [self fetchJDWithHandler:^(NGJobDetailModel *jobDetailModel) {
        if (jobDetailModel) {
            if(jobDetailModel.jobList.count>0)
            {
                NGJobDetails *jobDetail = nil;
                
                for (NGJobDetails *jdLoopVar in jobDetailModel.jobList) {
                    if (NO == jdLoopVar.isAlreadyApplied) {
                        jobDetail = jdLoopVar;
                        break;
                    }
                }
                completionHandler(jobDetail);
            }else{
                completionHandler(nil);
            }
        }else{
            completionHandler(nil);
        }
    }];
}
-(void)fetchAppliedJDWithHandler:(void(^)(NGJobDetails* jobDetail))completionHandler{
    [self fetchJDWithHandler:^(NGJobDetailModel *jobDetailModel) {
        if (jobDetailModel) {
            if(jobDetailModel.jobList.count>0)
            {
                NGJobDetails *jobDetail = nil;
                
                for (NGJobDetails *jdLoopVar in jobDetailModel.jobList) {
                    if (YES == jdLoopVar.isAlreadyApplied) {
                        jobDetail = jdLoopVar;
                        break;
                    }
                }
                completionHandler(jobDetail);
            }else{
                completionHandler(nil);
            }
        }else{
            completionHandler(nil);
        }
    }];
}
-(void)fetchJDWithHandler:(void(^)(NGJobDetailModel* jobDetailModel))completionHandler{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:0] forKey:@"Offset"];
    [params setObject:[NSNumber numberWithInteger:[self jobDownloadLimitForTest]] forKey:@"Limit"];
    [params setObject:@"sales" forKey:@"Keywords"];
    [params setObject:@"" forKey:@"Location"];
    [params setObject:[self expToSearch] forKey:@"Experience"];
    [params setObject:@"ios" forKey:@"requestsource"];

    [self fetchJDWithParams:params AndHandler:completionHandler];
    
}
-(void)fetchJDWithParams:(NSMutableDictionary*)params AndHandler:(void(^)(NGJobDetailModel* jobDetailModel))completionHandler{
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_ALL_JOBS];
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *responseDataDict = (NSDictionary *)responseInfo.parsedResponseData;
            NGJobDetailModel *objModel = [responseDataDict objectForKey:KEY_JOBS_INFO];
            
            if(objModel.jobList.count>0)
            {
                completionHandler(objModel);
            }
            else
            {
                completionHandler(nil);
                
            }
        });
        
    }];
    
}
-(NSString*)keywordToSearch{
    NSString *keyword = @"Sales";
    NSArray *keywordList = [self getKeywordSuggestions];
    if ([keywordList count] > 0) {
        u_int32_t randomNumberRange = (u_int32_t)[keywordList count];
        keyword = (NSString*)[keywordList fetchObjectAtIndex:arc4random_uniform(randomNumberRange)];
    }
    return keyword;
}
-(NSNumber*)expToSearch{
    NSNumber* exp = 0;
    NSArray *expList = @[@99,@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15];
    if ([expList count] > 0) {
        u_int32_t randomNumberRange = (u_int32_t)[expList count];
        exp = [expList fetchObjectAtIndex:arc4random_uniform(randomNumberRange)];
    }
    return exp;
}
-(NSArray *)getKeywordSuggestions
{
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedStringsFromKey:K_KEYWORDS_SUGGESTOR_KEY];
    return suggestors;
    
}
@end
