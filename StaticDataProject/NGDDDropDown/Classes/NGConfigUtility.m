//
//  NGConfigUtility.m
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGConfigUtility.h"

@implementation NGConfigUtility



+(NSString *)getDropDownConfigPath{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DropdownsConfig"
                                                         ofType:@"plist"];
    return filePath;
}


+(NSArray *)getAppDropDownArray{
    NSString *filePath = [NGConfigUtility getDropDownConfigPath];
    if (filePath) {
        return [[NSArray alloc] initWithContentsOfFile:filePath];
    }
    
    return nil;
}

+(NSString *)getAppDropDownFileName:(int) index
{
    NSString *filePath = [NGConfigUtility getDropDownConfigPath];
    if (filePath) {
        NSArray *fileArray =   [[NSArray alloc] initWithContentsOfFile:filePath];
        if(index < fileArray.count)
        {
            NSDictionary *dict = [fileArray objectAtIndex:index];
            return  [dict objectForKey:@"name"];
        }
    }
    
    return @"";
}



@end
