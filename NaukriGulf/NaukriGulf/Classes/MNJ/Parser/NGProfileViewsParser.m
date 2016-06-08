//
//  NGProfileViewsParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGProfileViewsParser.h"
#import "NGProfileViewDetails.h"

@implementation NGProfileViewsParser

- (id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict {
    
    NSMutableDictionary *parseDict = [NSMutableDictionary dictionaryWithDictionary:[dataDict.responseData JSONValue]];
    
    if ([parseDict objectForKey:@"ViewsDetail"]) {
        NSArray* profileViews = nil;
        
        if ([parseDict objectForKey:@"ViewsDetail"] == [NSNull null]) {
            profileViews = [NSArray array];
        }
        else {
            profileViews = [parseDict objectForKey:@"ViewsDetail"];
        }
        NSMutableArray* profileViewsArray=[[NSMutableArray alloc] init];
        
        for (int i=0;i<profileViews.count ;i++)
        {
            NGProfileViewDetails* profileViewDetail=[[NGProfileViewDetails alloc] init];
            
            profileViewDetail.compName=[[profileViews fetchObjectAtIndex:i] valueForKey:@"compName"];
            if ([profileViewDetail.compName class] == [NSNull class])
                profileViewDetail.compName = @"";
            
            
            profileViewDetail.compLocation=[[profileViews fetchObjectAtIndex:i] valueForKey:@"countryLabel"];
            if ([profileViewDetail.compLocation class] == [NSNull class])
                profileViewDetail.compLocation = @"";
            
            profileViewDetail.indType=[[profileViews fetchObjectAtIndex:i] valueForKey:@"indLabel"];
            if ([profileViewDetail.indType class] == [NSNull class])
                profileViewDetail.indType = @"";
            
            profileViewDetail.profileViewedDate=[[profileViews fetchObjectAtIndex:i] valueForKey:@"viewedDate"];
            if ([profileViewDetail.profileViewedDate class] == [NSNull class])
                profileViewDetail.profileViewedDate = @"";
            
            profileViewDetail.clientID=[[profileViews fetchObjectAtIndex:i] valueForKey:@"clientId"];
            if ([profileViewDetail.clientID class] == [NSNull class])
                profileViewDetail.clientID = @"";
            
            [profileViewsArray addObject:profileViewDetail];
        }
        [parseDict setCustomObject:profileViewsArray forKey:@"ViewsDetail"];
    }
    else {
//#warning Plzzz check the error details I dont  know about it
        NSArray *errorsArr = [parseDict objectForKey:@"Errors"];
        if (errorsArr.count>0)
        {
            NSDictionary *errorDict = [errorsArr fetchObjectAtIndex:0];
            NSString *msgStr = [[errorDict objectForKey:@"Error"]objectForKey:@"Message"];
            [parseDict setCustomObject:msgStr forKey:@"ViewsDetail"];
        }
    }
    dataDict.parsedResponseData = parseDict;
    
    return dataDict;
}

@end
