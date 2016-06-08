//
//  NGRecentSearchServiceClient.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGRecentSearchServiceClient.h"
#import "NGRecentSearchParser.h"

@implementation NGRecentSearchServiceClient

-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.apiRequestObj = [[APIRequestModal alloc]init];
    
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_RECENT_SEARCH_COUNT];
    self.apiRequestObj.apiId = SERVICE_TYPE_RECENT_SEARCH_COUNT;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_GET;
    self.apiRequestObj.isBackgroundTask = YES;
    self.apiRequestObj.queryStringParameterKey = @"searchVars";

    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[NGJsonDataFormatter alloc]init];
    self.dataParserObj = [[NGRecentSearchParser alloc]init];
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    
    self.apiRequestObj.authorisationHeaderNeeded = YES;
    NSArray *arr = [params objectForKey:@"recentsearcharrkey"];
    
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
    
    for (int i=0; i<arr.count; i++) {
        NGRescentSearchTuple *tempObj = arr[i];
        NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
        
        NSString *exp = @"";
        
        if (tempObj.experience>=0) {
            exp = [NSString stringWithFormat:@"%ld", (long)[[tempObj experience] integerValue]];
        }
        
        [tempDictionary setCustomObject:exp forKey:@"experience"];
        [tempDictionary setCustomObject:[NSString stringWithFormat:@"%@", tempObj.location] forKey:@"location"];
        [tempDictionary setCustomObject:[NSString stringWithFormat:@"%@", tempObj.keyword] forKey:@"keyword"];
        [tempDictionary setCustomObject:@"" forKey:@"farea"];
        [tempDictionary setCustomObject:@"" forKey:@"industry"];
        [tempDictionary setCustomObject:[NSString stringWithFormat:@"%ld",(long)(arr.count-1-i)] forKey:@"rSearchId"];
        
        [finalParams setCustomObject:tempDictionary forKey:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    self.apiRequestObj.requestParameters = finalParams;
}

@end
