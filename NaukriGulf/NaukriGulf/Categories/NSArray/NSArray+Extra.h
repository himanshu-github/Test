//
//  NSArray+Extra.h
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extra)


+(NSArray *)getIDsForSelectedValues:(NSArray *)selectedArr inContents:(NSArray *)dataArr withIDKey:(NSString *)idkey valueKey:(NSString *)valueKey;
+(NSArray *)getFilteredJobsFromList:(NSArray *)arr comparedToList:(NSArray *)comparedArr;
+(NSArray *)stringSeparateByComma:(NSString *)inputString;

@end
