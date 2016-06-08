//
//  NGURLDataFormatter.m
//  NaukriGulf
//
//  Created by bazinga on 26/05/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGURLDataFormatter.h"

@implementation NGURLDataFormatter

-(NSString *)convertFromDict:(NSDictionary *)paramsDict{
if([paramsDict isKindOfClass:[NSDictionary class]] || [paramsDict isKindOfClass:[NSMutableDictionary class]])
{
    if(((NSDictionary*)paramsDict).allKeys.count==0)
        return @"";
    
    NSString *paramString=@"";
    for (id key in ((NSDictionary*)paramsDict).allKeys)
    {
        
        //For Conerting in to Array (e.g.-Clusters in SRP)
        if([[paramsDict valueForKey:key] isKindOfClass:[NSArray class]])
        {
            
            NSString* str= [self createQueryStringForArray:[paramsDict objectForKey:key] withName:key];
            paramString = [paramString stringByAppendingFormat:@"%@",str];
            
        }
        
        else
            paramString = [paramString stringByAppendingFormat:@"&%@=%@",key,[paramsDict objectForKey:key]];
    }
    
    NSRange range=NSMakeRange(0, 1);
    NSString *finalString = [paramString stringByReplacingCharactersInRange:range withString:@""];
    return finalString;
    
    
}
return nil;
}



-(NSString*)createQueryStringForArray:(NSArray*)array withName:(NSString*)name
{
    NSString *formattedValues = [NSString getStringsFromArrayWithoutSpace:array];
    
    return [NSString stringWithFormat:@"&%@=%@",name,formattedValues];
    
}



@end
