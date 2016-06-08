//
//  NGStaticContentParser.m
//  NaukriGulf
//
//  Created by Arun Kumar on 12/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGStaticContentParser.h"

@implementation NGStaticContentParser

-(NSDictionary*)parseTextResponseData:(NSDictionary *)dataDict
{
    NSInteger ddType = [[dataDict objectForKey:KEY_DD_TYPE]integerValue];
    NSString *data = [dataDict objectForKey:KEY_DD_DATA];
    NSMutableDictionary *parsedDict = [NSMutableDictionary dictionary];

    NSLog(@"ddType>>%i", ddType);
    
    switch (ddType) {
        case DDC_COUNTRY:
        {
            [parsedDict setCustomObject:[self parseCountries:data] forKey:KEY_DD_DATA];
 
            break;
        }
            
        case DDC_UGCOURSE:{
            
            [parsedDict setCustomObject:[self parseBasicDegree:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_PGCOURSE:{
            [parsedDict setCustomObject:[self parseMasterDegree:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_PPGCOURSE:{
            [parsedDict setCustomObject:[self parseDoctorateDegree:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_EXP_MONTH:{
            
            [parsedDict setCustomObject:[self parseMonths:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_WORK_LEVEL:{
            
            [parsedDict setCustomObject:[self parseWorkLevel:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_SALARY_LACS:{
            [parsedDict setCustomObject:[self parseSalary:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_INDUSTRY_TYPE:{
            [parsedDict setCustomObject:[self parseIndustryType:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_JOBTYPE:{
            [parsedDict setCustomObject:[self parseEmploymentStatus:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_PREFRENCE_LOCATION:{
            [parsedDict setCustomObject:[self parsePrefferedLocation:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_EMPLOYMENT_STATUS:{
            [parsedDict setCustomObject:[self parseEmploymentPreference:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_FAREA:{
            
            [parsedDict setCustomObject:[self parseFunctionalArea:data] forKey:KEY_DD_DATA];
            break;
        }
            
        case DDC_CURRENCY:{
            [parsedDict setCustomObject:[self parseCurrency:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_WORK_STATUS:{
            [parsedDict setCustomObject:[self parseVisaStatus:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_NATIONALITY:{
            [parsedDict setCustomObject:[self parseNationality:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_NOTICE_PERIOD:{
            [parsedDict setCustomObject:[self parseAvailabiltyToJoin:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_RELIGION:{
            [parsedDict setCustomObject:[self parseReligion:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_MARITAL_STATUS:{
            [parsedDict setCustomObject:[self parseMaritalStatus:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_EXP_YEARS:{
            [parsedDict setCustomObject:[self parseYears:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_LANGUAGE:{
            [parsedDict setCustomObject:[self parseLangauges:data] forKey:KEY_DD_DATA];

            break;
        }
  
        case DDC_HIGHEST_EDUCTAION:{
            [parsedDict setCustomObject:[self parseHighestEducation:data] forKey:KEY_DD_DATA];

            break;
        }
            
        case DDC_ALERT:{
            [parsedDict setCustomObject:[self parseAlerts:data] forKey:KEY_DD_DATA];

            break;
        }
        case DDC_GENDER:
            [parsedDict setCustomObject:[self parseGender:data] forKey:KEY_DD_DATA];

            break;
            
        case DDC_SALARY_RANGE:
            [parsedDict setCustomObject:[self parseSalaryRange:data] forKey:KEY_DD_DATA];

            break;
            
            
        case DDC_LOCATION:
            [parsedDict setCustomObject:[self parseLocations:data] forKey:KEY_DD_DATA];

            break;
        case DDC_DESIGNATION:
            [parsedDict setCustomObject:[self parseDesignation:data] forKey:KEY_DD_DATA];
            
            break;
        case DDC_COMPANY:
            [parsedDict setCustomObject:[self parseCompany:data] forKey:KEY_DD_DATA];
            
            break;

            
            
        default:
            break;

    }
    
    [parsedDict setCustomObject:[NSNumber numberWithInteger:ddType] forKey:KEY_DD_TYPE];
    
    return parsedDict;
}

/**
 *  This method is used to parse the data for Year dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseYears:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"Years"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Month dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseMonths:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"Months"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Nationality dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseNationality:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"Nationality"]];
    
    return parsedArr;
}

-(NSArray *)parseAlerts:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"AlertsSetting"]];
    
    return parsedArr;
}

-(NSArray *)parseCurrency:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"Currency"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Country dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseCountries:(NSString *)str{
    NSMutableArray *parsedArr = [NSMutableArray array];
    NSData* data=[NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"country"]];    
    
    for (NSInteger i =0; i<[arr count]; i++) {
        NSDictionary *dict = [arr fetchObjectAtIndex:i];
        NSString *countryName = [dict objectForKey:@"label"];
        NSString *value = [dict objectForKey:@"value"];
        NSArray *valueArr = [value componentsSeparatedByString:@"|X|"];
        NSString *countryID = [valueArr fetchObjectAtIndex:0];
        NSString *citiesStr = [valueArr fetchObjectAtIndex:1];
        NSArray *citiesArr = [citiesStr componentsSeparatedByString:@","];
        
        NSMutableArray *finalCityArr = [[NSMutableArray alloc] init];
        
        for (NSInteger j = 0; j<[citiesArr count]; j++) {
            NSString *cityStr = [citiesArr fetchObjectAtIndex:j];
            NSArray *cityArr = [cityStr componentsSeparatedByString:@"#"];
            NSString *cityID = [cityArr fetchObjectAtIndex:0];
            NSString *cityName = [cityArr fetchObjectAtIndex:1];
            
            NSMutableDictionary *finalCityDict = [[NSMutableDictionary alloc]init];
            [finalCityDict setCustomObject:cityName forKey:@"cityName"];
            [finalCityDict setCustomObject:cityID forKey:@"cityID"];
            [finalCityArr addObject:finalCityDict];
        }
        
        NSMutableDictionary *finalDict = [[NSMutableDictionary alloc]init];
        [finalDict setCustomObject:countryName forKey:@"CountryName"];
        [finalDict setCustomObject:countryID forKey:@"CountryID"];
        [finalDict setCustomObject:finalCityArr forKey:@"CityList"];
        [parsedArr addObject:finalDict];
    }
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Basic Degree dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseBasicDegree:(NSString *)str{
    NSMutableArray *parsedArr = [NSMutableArray array];
    NSData* data=[NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"BasicDegree"]];
    
    for (NSInteger i =0; i<[arr count]; i++)
    {
        NSDictionary *dict = [arr fetchObjectAtIndex:i];
        NSString *countryName = [dict objectForKey:@"label"];
        NSString *value = [dict objectForKey:@"value"];
        NSArray *valueArr = [value componentsSeparatedByString:@"|X|"];
        NSString *countryID = [[[valueArr fetchObjectAtIndex:0] componentsSeparatedByString:@","] fetchObjectAtIndex:0];
        NSString *citiesStr = [valueArr fetchObjectAtIndex:1];
        NSArray *citiesArr = [citiesStr componentsSeparatedByString:@"#"];
        
        
        NSMutableArray *finalCityArr = [[NSMutableArray alloc] init];
        
        for (NSInteger j = 0; j<[citiesArr count]-1; j++)
        {
            NSString *cityStr = [citiesArr fetchObjectAtIndex:j];
            NSArray *cityArr = [cityStr componentsSeparatedByString:@","];
            
            NSString *cityID ;
            NSString *cityName;
            {
                cityID = [cityArr fetchObjectAtIndex:0];
                cityName = [cityArr fetchObjectAtIndex:1];
                
                
                
                NSMutableDictionary *finalCityDict = [[NSMutableDictionary alloc]init];
                [finalCityDict setCustomObject:cityName forKey:@"BasicCourseName"];
                [finalCityDict setCustomObject:cityID forKey:@"BasicCourseID"];
                [finalCityArr addObject:finalCityDict];
            }
        }
        
        
        NSMutableDictionary *finalDict = [[NSMutableDictionary alloc]init];
        [finalDict setCustomObject:countryName forKey:@"BasicDegreeName"];
        [finalDict setCustomObject:countryID forKey:@"BasicDegreeID"];
        [finalDict setCustomObject:finalCityArr forKey:@"BasicCourseList"];
        [parsedArr addObject:finalDict];
        
        
    }
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Master Degree dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseMasterDegree:(NSString *)str{
    NSMutableArray *parsedArr = [NSMutableArray array];
    NSData* data=[NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"Masters"]];
    
    for (NSInteger i =0; i<[arr count]; i++)
    {
        NSDictionary *dict = [arr fetchObjectAtIndex:i];
        NSString *countryName = [dict objectForKey:@"label"];
        NSString *value = [dict objectForKey:@"value"];
        NSArray *valueArr = [value componentsSeparatedByString:@"|X|"];
        NSString *countryID = [[[valueArr fetchObjectAtIndex:0] componentsSeparatedByString:@","] fetchObjectAtIndex:0];
        NSString *citiesStr = [valueArr fetchObjectAtIndex:1];
        NSArray *citiesArr = [citiesStr componentsSeparatedByString:@"#"];
        
        
        NSMutableArray *finalCityArr = [[NSMutableArray alloc] init];
        
        for (NSInteger j = 0; j<[citiesArr count]-1; j++)
        {
            NSString *cityStr = [citiesArr fetchObjectAtIndex:j];
            NSArray *cityArr = [cityStr componentsSeparatedByString:@","];
            
            NSString *cityID ;
            NSString *cityName;
            {
                cityID = [cityArr fetchObjectAtIndex:0];
                cityName = [cityArr fetchObjectAtIndex:1];
                
                
                
                NSMutableDictionary *finalCityDict = [[NSMutableDictionary alloc]init];
                [finalCityDict setCustomObject:cityName forKey:@"MastersCourseName"];
                [finalCityDict setCustomObject:cityID forKey:@"MastersCourseID"];
                [finalCityArr addObject:finalCityDict];
            }
        }
        
        
        NSMutableDictionary *finalDict = [[NSMutableDictionary alloc]init];
        [finalDict setCustomObject:countryName forKey:@"MastersDegreeName"];
        [finalDict setCustomObject:countryID forKey:@"MastersDegreeID"];
        [finalDict setCustomObject:finalCityArr forKey:@"MastersCourseList"];
        [parsedArr addObject:finalDict];
        
        
    }
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Doctorate dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseDoctorateDegree:(NSString *)str{
    NSMutableArray *parsedArr = [NSMutableArray array];
    NSData* data=[NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"Doctorate"]];
    
    for (NSInteger i =0; i<[arr count]; i++)
    {
        NSDictionary *dict = [arr fetchObjectAtIndex:i];
        NSString *countryName = [dict objectForKey:@"label"];
        NSString *value = [dict objectForKey:@"value"];
        NSArray *valueArr = [value componentsSeparatedByString:@"|X|"];
        NSString *countryID = [[[valueArr fetchObjectAtIndex:0] componentsSeparatedByString:@","] fetchObjectAtIndex:0];
        NSString *citiesStr = [valueArr fetchObjectAtIndex:1];
        NSArray *citiesArr = [citiesStr componentsSeparatedByString:@"#"];
        
        
        NSMutableArray *finalCityArr = [[NSMutableArray alloc] init];
        
        for (NSInteger j = 0; j<[citiesArr count]-1; j++)
        {
            NSString *cityStr = [citiesArr fetchObjectAtIndex:j];
            NSArray *cityArr = [cityStr componentsSeparatedByString:@","];
            
            NSString *cityID ;
            NSString *cityName;
            {
                cityID = [cityArr fetchObjectAtIndex:0];
                cityName = [cityArr fetchObjectAtIndex:1];
                
                
                
                NSMutableDictionary *finalCityDict = [[NSMutableDictionary alloc]init];
                [finalCityDict setCustomObject:cityName forKey:@"DoctorateCourseName"];
                [finalCityDict setCustomObject:cityID forKey:@"DoctorateCourseID"];
                [finalCityArr addObject:finalCityDict];
            }
        }
        
        
        NSMutableDictionary *finalDict = [[NSMutableDictionary alloc]init];
        [finalDict setCustomObject:countryName forKey:@"DoctorateDegreeName"];
        [finalDict setCustomObject:countryID forKey:@"DoctorateDegreeID"];
        [finalDict setCustomObject:finalCityArr forKey:@"DoctorateCourseList"];
        [parsedArr addObject:finalDict];
        
    }
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Location dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseLocations:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"Locations"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Functional Area dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseFunctionalArea:(NSString *)str{
    
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"FArea"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Industry dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseIndustryType:(NSString *)str{
    NSError* error;
    
    NSMutableDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];

    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[jsonObj valueForKey:@"IndustryType"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Salary dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseSalary:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"ctc"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Gender dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseGender:(NSString *)str{    
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"gender"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Visa Status dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseVisaStatus:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"VisaStatus"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Religion dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseReligion:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"Religion"]];
    return parsedArr;
}

/**
 *  This method is used to parse the data for Marital Status dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseMaritalStatus:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"MaritalStatus"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Languages dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseLangauges:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"languages"]];
    return parsedArr;
}

/**
 *  This method is used to parse the data for Work Level dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseWorkLevel:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"WorkLevel"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Employment Status dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseEmploymentStatus:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"EmploymentStatus"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Employment Preference dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseEmploymentPreference:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"EmploymentPreference"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Preffered Location dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parsePrefferedLocation:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"PrefferedLocation"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Notice Period dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseAvailabiltyToJoin:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"AvailabilityToJoin"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Salary Range dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseSalaryRange:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"SalaryRange"]];
    
    return parsedArr;
}

-(NSArray *)parseHighestEducation:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSMutableDictionary *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *parsedArr = [[NSMutableArray alloc] initWithArray:[root valueForKey:@"HighestEducation"]];
    
    return parsedArr;
}

/**
 *  This method is used to parse the data for Designation dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseDesignation:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSArray *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *parsedArr = [[NSMutableArray alloc] initWithArray:root];
    return parsedArr;
}
/**
 *  This method is used to parse the data for CompanyName dropdown.
 *
 *  @param str Represents the dropdown data to be parsed.
 *
 *  @return Returns the list of dropdown values after parsing.
 */
-(NSArray *)parseCompany:(NSString *)str{
    NSData* data = [NSData dataWithBytes:[str UTF8String] length:[str length]];
    NSError* error;
    NSArray *root=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *parsedArr = [[NSMutableArray alloc] initWithArray:root];
    return parsedArr;
}


@end
