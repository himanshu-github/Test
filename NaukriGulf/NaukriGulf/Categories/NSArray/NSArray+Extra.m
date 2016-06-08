//
//  NSArray+Extra.m
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NSArray+Extra.h"

@implementation NSArray (Extra)


+(NSArray *)getIDsForSelectedValues:(NSArray *)selectedArr inContents:(NSArray *)dataArr withIDKey:(NSString *)idkey valueKey:(NSString *)valueKey{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i<dataArr.count; i++) {
        NSDictionary *dict = [dataArr fetchObjectAtIndex:i];
        NSString *value = [dict objectForKey:valueKey];
        
        if ([selectedArr containsObject:value]) {
            [arr addObject:[dict objectForKey:idkey]];
        }
    }
    
    return arr;
}
+(NSArray *)stringSeparateByComma:(NSString *)inputString{
    
    NSArray *resultArray;
    if([inputString length]){
        
        resultArray = [inputString componentsSeparatedByString:@","];
    }
    
    return resultArray;
}
+(NSArray *)getFilteredJobsFromList:(NSArray *)arr comparedToList:(NSArray *)comparedArr{
    
    NSMutableArray *newJobsArr = [NSMutableArray array];
    
    for (int i=0; i<arr.count; i++)
    {
        NGJobDetails* jobObj=[arr fetchObjectAtIndex:i];
        
        BOOL doesExist = FALSE;
        
        for (int j=0; j<comparedArr.count; j++)
        {
            NGJobDetails* savedJobObj=[comparedArr fetchObjectAtIndex:j];
            
            if([savedJobObj.jobID isEqualToString:jobObj.jobID])
            {
                doesExist = TRUE;
                break;
            }
        }
        if(!doesExist){
            
            [newJobsArr addObject:jobObj];
            
        }
    }
    
    
    return newJobsArr;
}

@end
