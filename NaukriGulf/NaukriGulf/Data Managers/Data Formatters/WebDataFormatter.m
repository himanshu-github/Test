//
//  WebDataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "WebDataFormatter.h"

@implementation WebDataFormatter

-(NSString *)convertToXMLFromDict:(NSDictionary *)paramsDict{
    NSString *xmlString = @"";
    
    for (NSString *key in paramsDict.allKeys) {
        id obj = [paramsDict objectForKey:key];        
        
        if ([obj isKindOfClass:[NSMutableArray class]]) {
            xmlString = [xmlString stringByAppendingFormat:@"<%@>",key];
            NSMutableArray *arr = obj;
            NSInteger i = 0;
            for (NSString *value in arr) {
                xmlString = [xmlString stringByAppendingFormat:@"<%ld>",(long)i];
                xmlString = [xmlString stringByAppendingFormat:@"%@",value];
                xmlString = [xmlString stringByAppendingFormat:@"</%ld>",(long)i];
                i++;
            }
            
            xmlString = [xmlString stringByAppendingFormat:@"</%@>",key];
            
        }else{
            xmlString = [xmlString stringByAppendingFormat:@"<%@>",key];
            xmlString = [xmlString stringByAppendingFormat:@"%@",obj];
            xmlString = [xmlString stringByAppendingFormat:@"</%@>",key];
        }
        
    }
    
    return xmlString;
}

-(NSString *)convertToJSONFromDict:(NSDictionary *)paramsDict{
    NSString *jsonString = @"";
    return jsonString;
}

@end
