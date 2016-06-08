//
//  NGStaticContentManager.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGStaticContentManager.h"


@implementation NGStaticContentManager



#pragma mark Suggested Strings
+(NSArray *)getNewDropDownData:(int) ddType{
    
    NGFileDataFetcher *fileDataFetcher = [[NGFileDataFetcher alloc] init];
    NSString * data = [fileDataFetcher getDataFromFile:[NGConfigUtility  getAppDropDownFileName:ddType ] ];
    NGStaticContentParser *scpObj = [[NGStaticContentParser alloc]init];
    NSArray *ddArr;
    NSDictionary *ddDict = [scpObj parseTextResponseData:[NSDictionary dictionaryWithObjectsAndKeys:data,KEY_DD_DATA,[NSNumber numberWithInteger:ddType],KEY_DD_TYPE, nil]];
    if (ddDict) {
        ddArr = [ddDict objectForKey:KEY_DD_DATA];
    }
    return ddArr;
    
    
}



@end
