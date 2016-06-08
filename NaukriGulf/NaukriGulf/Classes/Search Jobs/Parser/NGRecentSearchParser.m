//
//  NGRecentSearchParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGRecentSearchParser.h"
#import "NGRecentSearchReponseModal.h"

@implementation NGRecentSearchParser


-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{

    NSString *responseData = dataDict.responseData;
    NSDictionary *rscDict = [responseData JSONValue];
    NSMutableArray *rscArr = [[NSMutableArray alloc]init];
    
    NSDictionary *responseDataDict = [rscDict objectForKey:@"list"];

    if (responseDataDict.count > 0) {
        for (NSDictionary *searches in responseDataDict) {
            NGRecentSearchReponseModal *recentSearchResponseModal = [[NGRecentSearchReponseModal alloc] init];
            recentSearchResponseModal.searchId = [searches valueForKey:@"id"];
            
            recentSearchResponseModal.numberOfJobs = [searches valueForKey:@"count"];
            
            [rscArr addObject:recentSearchResponseModal];
        }
        
    }
    dataDict.parsedResponseData = rscArr;
    return dataDict;
    
}


@end
