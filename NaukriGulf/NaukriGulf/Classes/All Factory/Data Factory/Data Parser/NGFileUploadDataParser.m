//
//  NGFileUploadDataParser.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 13/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGFileUploadDataParser.h"

@implementation NGFileUploadDataParser
-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict{
    
    @try {
        NSDictionary *serverResponseObj = [dataDict.responseData JSONValue];
        if(serverResponseObj){
            NSDictionary *newDict =  [self createInfoDictionaryFromServerResponse:serverResponseObj];
            if (newDict) {
                dataDict.parsedResponseData = newDict;
            }else{
                dataDict.parsedResponseData = serverResponseObj;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    return dataDict;
}
-(NSDictionary*)createInfoDictionaryFromServerResponse:(NSDictionary*)paramServerResponse{
    
    //method to create dictionary of keys
    //appId
    //formKey
    //fileKey
    //v
    
    NSMutableDictionary *infoDictionary = [[NSMutableDictionary alloc] init];
    NSString *dynamicKey = [paramServerResponse.allKeys fetchObjectAtIndex:0];
    NSString *downloadURLString = [[paramServerResponse objectForKey:dynamicKey] objectForKey:@"URL"];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    if (0 >= [vManager validateValue:downloadURLString withType:ValidationTypeString].count) {
        NSArray *mainArray = [downloadURLString componentsSeparatedByString:@"?"];
        NSArray *subArray = [[mainArray fetchObjectAtIndex:1] componentsSeparatedByString:@"&"];
        if (subArray) {
            for (NSString *subPart in subArray) {
                NSArray *allValues = [subPart componentsSeparatedByString:@"="];
                if (allValues) {
                    [infoDictionary setCustomObject:[allValues fetchObjectAtIndex:1] forKey:[allValues fetchObjectAtIndex:0]];
                }
                allValues = nil;
            }
        }else{
            return paramServerResponse;
        }
    }else{
        return paramServerResponse;
    }
    vManager = nil;
    return (NSDictionary*)infoDictionary;
    
}
@end
