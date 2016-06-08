//
//  NGSettingsModel.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGSettingsModel.h"

@implementation NGSettingsModel

#pragma mark JSON Model Methods
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}



+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"localRecoInterval": @"localRecoInterval",
                                                       @"isLoggingEnabled":
                                                           @"isLoggingEnabled",
                                                       @"willShowCelebrationImage":
                                                           @"willShowCelebrationImage"
                                                      }];
}


-(void)setDropDownModifiedListFromDic:(NSDictionary*)paramDic{
    if (nil != paramDic && NO == [paramDic isKindOfClass:[NSNull class]]) {

        NSDictionary *dropDownDic = [[[paramDic objectForKey:@"default"] objectForKey:@"modifiedList"] objectForKey:@"dropdowns"];
        [DDBase fetchDataFromServer:dropDownDic];
        
    }
}
@end
