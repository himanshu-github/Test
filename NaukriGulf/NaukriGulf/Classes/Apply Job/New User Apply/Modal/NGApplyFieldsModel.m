//
//  NGApplyFieldsModel.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/27/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGApplyFieldsModel.h"

@implementation NGApplyFieldsModel

- (id)init{
    self = [super init];
    if (self) {
        _name = @"";
        _emailId = @"";
        _mobileNumber = @"";
        _gender = @"";
        _workEx = [[NSMutableDictionary alloc] init];
        _gradCourse = [[NSMutableDictionary alloc] init];
        _gradspecialisation = [[NSMutableDictionary alloc] init];
        _pgCourse = [[NSMutableDictionary alloc] init];
        _pgSpecialisation = [[NSMutableDictionary alloc] init];
        _workEx = [[NSMutableDictionary alloc] init];
        _doctCourse = [[NSMutableDictionary alloc] init];
        _doctspecialisation = [[NSMutableDictionary alloc] init];
        _country = [[NSMutableDictionary alloc] init];
        _city = [[NSMutableDictionary alloc] init];
        _nationality = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)setWorkEx:(NSMutableDictionary *)paramWorkEx{
    _workEx = paramWorkEx;
    if (_workEx) {
        NSString *expOfYears = [[_workEx objectForKey:KEY_YEAR_DICTIONARY] objectForKey:KEY_VALUE];
        
        if (0>=[[ValidatorManager sharedInstance] validateValue:expOfYears withType:ValidationTypeString].count && [@"0" isEqualToString:expOfYears]) {
            _isFresher = YES;
        }else{
            _isFresher = NO;
        }
        
    }
}



- (NSMutableDictionary*)dictionaryOfObjectData{
    NSMutableDictionary *objectDataDictionary = [NSMutableDictionary new];
    
    NSMutableDictionary *expYearsDic = [_workEx objectForKey:KEY_YEAR_DICTIONARY];
    NSMutableDictionary *expMonthsDic = [_workEx objectForKey:KEY_MONTH_DICTIONARY];
    
    
    NSArray *contactNumberArray = [_mobileNumber componentsSeparatedByString:@"+"];
    NSString *mobileNumber = [contactNumberArray fetchObjectAtIndex:0];
    NSString *countryCode = [contactNumberArray fetchObjectAtIndex:1];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    
    if (0<[vManager validateValue:mobileNumber withType:ValidationTypeString].count) {
        mobileNumber = @"";
    }
    if (0<[vManager validateValue:countryCode withType:ValidationTypeString].count) {
        countryCode = @"0";
    }
    
    
    [objectDataDictionary setCustomObject:[_nationality objectForKey:KEY_VALUE] forKey:@"Nationality"];//for value
    [objectDataDictionary setCustomObject:[_nationality objectForKey:KEY_ID] forKey:@"NATIONALITY"];//for id
    
    [objectDataDictionary setCustomObject:_name forKey:@"NAME"];
    [objectDataDictionary setCustomObject:_emailId forKey:@"EMAIL"];
    
    [objectDataDictionary setCustomObject:[_city objectForKey:KEY_ID] forKey:@"CITY"];//id
    [objectDataDictionary setCustomObject:[_city objectForKey:KEY_VALUE] forKey:@"City"];//value
    
    [objectDataDictionary setCustomObject:@"1" forKey:@"ISMOBILE"];//1 fix value
    
    [objectDataDictionary setCustomObject:mobileNumber forKey:@"MPHONE"];
    [objectDataDictionary setCustomObject:countryCode forKey:@"MCNTRYCODE"];//0 if not given
    
    [objectDataDictionary setCustomObject:_gender forKey:@"GENDER"];
    
    [objectDataDictionary setCustomObject:[_city objectForKey:KEY_ID] forKey:@"COUNTRY"];//id
    [objectDataDictionary setCustomObject:[_city objectForKey:KEY_VALUE] forKey:@"Country"];//value
    
    [objectDataDictionary setCustomObject:[expYearsDic objectForKey:KEY_VALUE] forKey:@"Exp In Years"];//value
    
    if (!_currentDesignation) {
        _currentDesignation = @" ";
    }
    [objectDataDictionary setCustomObject:_currentDesignation forKey:@"CURDESIG"];
    
    [objectDataDictionary setCustomObject:@"json" forKey:@"format"];
    
    [objectDataDictionary setCustomObject:[expYearsDic objectForKey:KEY_ID] forKey:@"WORKEXPYR"];
    
    if (_isFresher) {
        //fresher
        [objectDataDictionary setCustomObject:[_gradCourse objectForKey:@"id"] forKey:@"UGCOURSE"];//for fresher only
        [objectDataDictionary setCustomObject:[_gradspecialisation objectForKey:@"id"] forKey:@"UGSPEC"];//for fresher only
        [objectDataDictionary setCustomObject:[_pgCourse objectForKey:@"id"] forKey:@"PGCOURSE"];//for fresher only
        [objectDataDictionary setCustomObject:[_pgSpecialisation objectForKey:@"id" ]forKey:@"PGSPEC"];//for fresher only
        [objectDataDictionary setCustomObject:[_doctCourse objectForKey:@"id"] forKey:@"PPGCOURSE"];//for fresher only
        [objectDataDictionary setCustomObject:[_doctspecialisation objectForKey:@"id"] forKey:@"PPGSPEC"];//for fresher only
    }else{
        //exp
        
        if(![[expYearsDic objectForKey:KEY_ID] isEqualToString:@"30plus"]) {
        
            [objectDataDictionary setCustomObject:[expMonthsDic objectForKey:KEY_ID] forKey:@"WORKEXPMNTH"];
        }
    }
    
    //clearing objects
    expYearsDic = nil;
    expMonthsDic = nil;
    contactNumberArray = nil;
    mobileNumber = nil;
    countryCode = nil;
    vManager = nil;

    return objectDataDictionary;
}

- (NSString*)getFinalExperience{
    
    NSMutableDictionary *selectedExpOfYears = [self.workEx objectForKey:KEY_YEAR_DICTIONARY];
    NSMutableDictionary *selectedExpOfMonths = [self.workEx objectForKey:KEY_MONTH_DICTIONARY];
    if (nil==selectedExpOfYears && nil == selectedExpOfMonths) {
        return nil;
    }
    
    NSString *tmpExpYear = [selectedExpOfYears objectForKey:KEY_VALUE];
    NSString *tmpExpMonth = [selectedExpOfMonths objectForKey:KEY_VALUE];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    
    if (0<[vManager validateValue:tmpExpYear withType:ValidationTypeString].count) {
        tmpExpYear = @"0";
    }
    if (0<[vManager validateValue:tmpExpMonth withType:ValidationTypeString].count) {
        tmpExpMonth = @"0";
    }
    
    
    NSString* finalString = @"";
    NSString* appendString1 = @"Years";
    NSString* appendString2 = @"Months";
    
    if ([tmpExpYear isEqualToString:@"0"] ||
        [tmpExpYear isEqualToString:@"1"])
        appendString1 = @"Year";
    
    if ([tmpExpMonth isEqualToString:@"0"] ||
        [tmpExpMonth isEqualToString:@"1"])
        appendString2 = @"Month";
    
    if ([tmpExpMonth isEqualToString:@"0"])
        finalString = [NSString stringWithFormat:@"%@ %@",tmpExpYear, appendString1];
    else
        finalString = [NSString stringWithFormat:@"%@ %@, %@ %@",
                       tmpExpYear,appendString1, tmpExpMonth, appendString2];
    if ([finalString isEqualToString:@"fresher Years"] ||
        [finalString isEqualToString:@"fresher Year"] ) {
        finalString = @"0 Year";
    }
    
    return finalString;
}


// In the implementation
-(id)copyWithZone:(NSZone *)zone {
   
    
    NGApplyFieldsModel *newApplyModel = [[[self class] allocWithZone:zone] init];
    
    if(newApplyModel) {
        
        [newApplyModel setName:self.name];
        [newApplyModel setEmailId:self.emailId];
        [newApplyModel setMobileNumber:self.mobileNumber];
        [newApplyModel setGender:self.gender];
        [newApplyModel setWorkEx:[self.workEx mutableCopy]];
        [newApplyModel setCurrentDesignation:self.currentDesignation];
        [newApplyModel setGradCourse:[self.gradCourse mutableCopy]];
        [newApplyModel setGradspecialisation:[self.gradspecialisation mutableCopy]];
        [newApplyModel setPgCourse:[self.pgCourse mutableCopy]];
        [newApplyModel setPgSpecialisation:[self.pgSpecialisation mutableCopy]];
        [newApplyModel setDoctCourse:[self.doctCourse mutableCopy]];
        [newApplyModel setDoctspecialisation:[self.doctspecialisation mutableCopy]];
        [newApplyModel setCountry:[self.country mutableCopy]];
        [newApplyModel setCity:[self.city mutableCopy]];
        [newApplyModel setNationality:[self.nationality mutableCopy]];
        [newApplyModel setIsFresher:self.isFresher];
       
    }
   
    return newApplyModel;

}
@end
