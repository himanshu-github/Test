//
//  NGResmanDataModel.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/14/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanDataModel.h"

@implementation NGResmanDataModel
-(id) init {
    
    self = [super init];
    if (self) {
    
        _preferredLoc = [[NSMutableDictionary alloc] init];
        _availabilityToJoin = [[NSMutableDictionary alloc] init];
        _totalExp = [[NSMutableDictionary alloc] init];
        _industry = [[NSMutableDictionary alloc] init];
        _functionalArea = [[NSMutableDictionary alloc] init];
        _highestEducation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_VALUE,@"",KEY_ID, nil];
        _ppgCourse = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_VALUE,@"",KEY_ID, nil];
        _ppgSpec = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_VALUE,@"",KEY_ID, nil];
        _pgCourse = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_VALUE,@"",KEY_ID, nil];
        _pgSpec = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_VALUE,@"",KEY_ID, nil];
        _ugCourse = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_VALUE,@"",KEY_ID, nil];
        _ugSpec = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_VALUE,@"",KEY_ID, nil];
        _visaStatus = [[NSMutableDictionary alloc] init];
        _dlIssuedBy = [[NSMutableDictionary alloc] init];
        _nationality = [[NSMutableDictionary alloc] init];
        _alertSetting = [[NSMutableDictionary alloc] init];
        _country = [[NSMutableDictionary alloc] init];
        _city = [[NSMutableDictionary alloc] init];
        _currency = [[NSMutableDictionary alloc] init];
        _religion = [[NSMutableDictionary alloc] init];
        _maritalStatus = [[NSMutableDictionary alloc] init];
        _languages = [[NSMutableDictionary alloc] init];
        
        
      }
    return self;
}

@end
