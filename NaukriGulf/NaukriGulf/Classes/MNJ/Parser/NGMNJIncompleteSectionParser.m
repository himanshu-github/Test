//
//  NGMNJIncompleteSectionParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 18/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGMNJIncompleteSectionParser.h"

@implementation NGMNJIncompleteSectionParser


-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    
    NSDictionary *userDetailsDict = [dataDict.responseData JSONValue];

    NSDictionary *incompleteDict = [userDetailsDict objectForKey:@"IncompleteSections"];
    
    NSMutableDictionary *parseDict = [NSMutableDictionary dictionary];
    if([userDetailsDict objectForKey:KEY_ERROR]|| [incompleteDict class]==[NSNull class])
    {
        [parseDict setCustomObject:KEY_ERROR forKey:KEY_MNJ_INCOMPLETE_SECTION_STATUS];
        [parseDict setCustomObject:KEY_ERROR forKey:KEY_MNJ_RECOMMENDED_JOBS_COUNT_STATUS];
        [parseDict setCustomObject:KEY_ERROR forKey:KEY_MNJ_VIEW_DETAIL_COUNT_STATUS];

    }

    else
    {
        [parseDict setCustomObject:KEY_SUCCESS_RESPONSE forKey:KEY_MNJ_INCOMPLETE_SECTION_STATUS];
        [parseDict setCustomObject:KEY_SUCCESS_RESPONSE forKey:KEY_MNJ_VIEW_DETAIL_COUNT_STATUS];
        [parseDict setCustomObject:KEY_SUCCESS_RESPONSE forKey:KEY_MNJ_APPLY_HISTORY_COUNT_STATUS];

        
        [parseDict setCustomObject:incompleteDict forKey:KEY_MNJ_INCOMPLETE_SECTION_DATA];
        NSString *viewCountStr   = [[userDetailsDict objectForKey:@"ViewDetail"] objectForKey:@"count"];
        if(viewCountStr)
        [parseDict setCustomObject:viewCountStr forKey:KEY_MNJ_VIEW_DETAIL_COUNT_DATA];
        else
            [parseDict setCustomObject:[NSNumber numberWithInt:0] forKey:KEY_MNJ_VIEW_DETAIL_COUNT_DATA];

        NSDictionary *recommendedJobsDict = [userDetailsDict objectForKey:@"RecommendJobs"];
        if([recommendedJobsDict isKindOfClass:[NSMutableDictionary class]]||[recommendedJobsDict isKindOfClass:[NSDictionary class]])
        {
            [parseDict setCustomObject:KEY_SUCCESS_RESPONSE forKey:KEY_MNJ_RECOMMENDED_JOBS_COUNT_STATUS];
            [parseDict setCustomObject:[recommendedJobsDict objectForKey:@"TotalJobsCount"] forKey:KEY_MNJ_RECOMMENDED_JOBS_COUNT_DATA];
            [parseDict setCustomObject:[recommendedJobsDict objectForKey:@"NewJobsCount"] forKey:KEY_MNJ_RECOMMENDED_NEW_JOBS_COUNT_DATA];
        }
        else{
            [parseDict setCustomObject:KEY_ERROR forKey:KEY_MNJ_RECOMMENDED_JOBS_COUNT_STATUS];
        }
        
        
        NSDictionary *applyhistoryDict = [userDetailsDict objectForKey:@"ApplyHistory"];
        [parseDict setCustomObject:[applyhistoryDict objectForKey:@"applyCounts"] forKey:KEY_MNJ_APPLY_HISTORY_COUNT_DATA];

    }
    dataDict.parsedResponseData = parseDict;
    return dataDict;
}

@end
