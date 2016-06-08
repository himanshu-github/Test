//
//  NGDateManager.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 23/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGDateManager.h"



@implementation NGDateManager


+ (NSString*)stringFromDate:(NSDate*)paramDate WithDateFormat:(NSString*)paramDateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterNoStyle;
    [dateFormatter setDateFormat:paramDateFormat];
    return [dateFormatter stringFromDate:paramDate];
}

+ (NSDate*)dateFromString:(NSString*)paramString WithDateFormat:(NSString*)paramDateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterNoStyle;
    [dateFormatter setDateFormat:paramDateFormat];
    return [dateFormatter dateFromString:paramString];
}

+ (NSString*)stringFromDate:(NSDate*)paramDate WithDateFormat:(NSString*)paramDateFormat AndStyle:(NSDateFormatterStyle)paramStyle
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = paramStyle;
    [dateFormatter setDateFormat:paramDateFormat];
    return [dateFormatter stringFromDate:paramDate];
}

+ (NSDate*)dateFromString:(NSString*)paramString WithDateFormat:(NSString*)paramDateFormat AndStyle:(NSDateFormatterStyle)paramStyle
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = paramStyle;
    [dateFormatter setDateFormat:paramDateFormat];
    return [dateFormatter dateFromString:paramString];
}

+ (NSString*)stringFromDate:(NSDate*)paramDate WithStyle:(NSDateFormatterStyle)paramStyle
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = paramStyle;
    return [dateFormatter stringFromDate:paramDate];
}


+ (NSDate*)UTCDateFromString:(NSString*)paramString WithDateFormat:(NSString*)paramDateFormat
{
    if(paramString == nil || paramString.length == 0)
        return nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    formatter.dateStyle = kCFDateFormatterNoStyle;
    [formatter setDateFormat:paramDateFormat];
    return [formatter dateFromString:paramString];
}

+(BOOL)isNightTimeInDate:(NSDate*)paramDate{
    NSDate *date = paramDate;
    NSString *convertedString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *inLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"];
    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"hh:mm a"
                                                                 options:0
                                                                  locale:inLocale]];
    convertedString = [dateFormatter stringFromDate:date];
    
    return [NGDateManager checkTime:convertedString];
}
+(NSDate*)createNewDateFromDate:(NSDate*)paramFromDate ForHour:(NSUInteger)paramHour AndForMinute:(NSUInteger)paramMinute{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth |
                                                             NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:paramFromDate];
    [dateComponents setHour:paramHour];//NOTE:Hour should be in 24 hour format and NOT in 12-format
    [dateComponents setMinute:paramMinute];
    
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    
    if ([self isDatePassed:newDate]) {
        [dateComponents setDay:(dateComponents.day + 1)];
        
        //reset day for date
        newDate = nil;
        newDate = [calendar dateFromComponents:dateComponents];
    }
    
    return newDate;
}
+(BOOL)isDatePassed:(NSDate*)paramDate{
    NSDate *dateTimeNow = [NSDate date];
    return (NSOrderedDescending != [paramDate compare:dateTimeNow]);
}
+(BOOL) checkTime : (NSString*) convertedString {
    
    NSArray *hourArray = (NSArray*) [convertedString componentsSeparatedByString:@" "];
    NSString *unitString = [[hourArray fetchObjectAtIndex:1] lowercaseString];
    
    if([unitString isEqualToString:@"am"]){
        
        NSString* hour = ([[[hourArray fetchObjectAtIndex:0] componentsSeparatedByString:@":"]fetchObjectAtIndex:0]);
        NSInteger hourValue = [hour integerValue];
        //< 7 means, also handle 6:59 and allow
        if((hourValue >=1 && hourValue < 7) || hourValue==12) {
            
            return TRUE;
        }
        else{
            
            return FALSE;
        }
    }else if ([unitString isEqualToString:@"pm"]){
        NSString* hour = ([[[hourArray fetchObjectAtIndex:0] componentsSeparatedByString:@":"]fetchObjectAtIndex:0]);
        NSInteger hourValue = [hour integerValue];
        
        if(hourValue == 11) {
            
            return TRUE;
        }
        else{
            
            return FALSE;
        }
    }else{
        //dummy
    }
    return FALSE;
}

//+(NSDate*)dateByAddingValue:(NSTimeInterval)paramValue InUnit:(enum NGTimeUnit)paramUnit ToDate:(NSDate*)paramToDate{
//    NSDate *newDate;
//    
//    switch (paramUnit) {
//        case NGTimeUnitMinute:{
//            NSTimeInterval secondsInMinute = 60;
//            newDate = [paramToDate dateByAddingTimeInterval:(paramValue * secondsInMinute)];
//        }break;
//            
//        case NGTimeUnitHour:{
//            NSTimeInterval secondsInHour = 3600;
//            newDate = [paramToDate dateByAddingTimeInterval:(paramValue * secondsInHour)];
//        }break;
//            
//        case NGTimeUnitDay:{
//            NSTimeInterval secondsInDay = 86400;
//            newDate = [paramToDate dateByAddingTimeInterval:(paramValue * secondsInDay)];
//        }break;
//            
//        default:
//            newDate = paramToDate;
//            break;
//    }
//    return newDate;
//}


+ (NSDateComponents *)getCurrentDateComponents{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return components;
}


+ (NSDateComponents *)getDifferenceBTWDate:(NSDate *)date1 withDate:(NSDate *)date2{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay
                                               fromDate:date1
                                                 toDate:date2
                                                options:0];
    return components;
}


+ (BOOL)isDate:(NSDate*)paramDate nDaysOld:(NSInteger)paramNDays{
    
    return paramNDays <= [NGDateManager daysBetweenDate:paramDate andDate:[NSDate date]];
}


+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    return [difference day];
}

+ (NSString *)formatDateInMonthYear:(NSString *)dateStr{
    NSString *finalStr = nil;
    
    NSArray *monthArr = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    
    if (![dateStr isEqualToString:@""]) {
        NSArray *dateComponent = [dateStr componentsSeparatedByString:@"-"];
        if (dateComponent.count==3) {
            NSString *monthStr = [monthArr fetchObjectAtIndex:[[dateComponent fetchObjectAtIndex:1]integerValue]-1];
            NSString *yearStr = [dateComponent fetchObjectAtIndex:0];
            finalStr = [NSString stringWithFormat:@"%@, %@",monthStr,yearStr];
        }
    }
    
    return finalStr;
}

+ (NSString *)getDateInLongStyle:(NSString *)dateStr
{
    // Convert string to date object
    NSDate *date = [NGDateManager dateFromString:dateStr WithDateFormat:@"yyyy-MM-dd"];
    
    // Convert date object to desired output format
    dateStr = [NGDateManager stringFromDate:date WithDateFormat:@"MMMM d,yyyy"];
    return dateStr;
}

+ (NSString *)getDateFromLongStyle:(NSString *)dateStr{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //dateFormat.dateStyle = NSDateFormatterLongStyle;
    [dateFormat setDateFormat:@"MMMM dd,yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormat stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)getDateFromMonthYear:(NSString *)dateStr{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM, yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormat stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)getDateInMediumStyleFormat:(NSString *)dateStr{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    // Convert date object to desired output format
    
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    dateStr = [dateFormat stringFromDate:date];
    
    return dateStr;
}

+ (NSString*) getDateInMonthDayStyle : (NSString*)dateStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [formatter dateFromString:dateStr];
    [formatter setDateFormat:@"MMM dd"];
    
    return [formatter stringFromDate:date];
    
}
+ (int)daysDiffrence:(NSString*)fromDateString{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDateString = [dateFormatter stringFromDate:today];
    NSDate *todayDate = [dateFormatter dateFromString:todayDateString];
    NSDate *fromDate = [dateFormatter dateFromString:fromDateString];
    
    NSTimeInterval secondsBetween = [todayDate timeIntervalSinceDate:fromDate];
    int numberOfDays = secondsBetween / 86400;
    return numberOfDays;
}



+ (NSString *)formatDateMonthYearStringToServerFormat:(NSString *)dateString{
    
    if(![dateString length]){
        
        return nil;
    }
    NSMutableString *stringFromArray = [NSMutableString string];
    [stringFromArray appendString:@""];
    NSArray *resultArray;
    if([dateString length]){
        
        resultArray = [dateString componentsSeparatedByString:@","];
    }
    
    if (resultArray.count - 1 > 0) {
        [stringFromArray appendString:[resultArray fetchObjectAtIndex:resultArray.count-1]];
    }
    if(resultArray.count - 2 == 0){
        [stringFromArray appendFormat:@"-%@",[resultArray fetchObjectAtIndex:0]];
    }
    [stringFromArray appendString:@"-01"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MMMM-dd";
    NSDate *date = [formatter dateFromString:stringFromArray];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss ZZZ";
    dateString = [formatter stringFromDate:date];
    return dateString;
}


+ (BOOL)isValideDate:(NSString *)dateString{
    
    if(![dateString length])
        return NO;
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss ZZZ"];
    NSString * currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
    return [self isValidStartDateEndate:dateString withEndDate:currentDate];
    
}


+ (BOOL)isValidStartDateEndate:(NSString *)startDate withEndDate:(NSString *)endaDate{
    
    BOOL validDate = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss ZZZ"];
    NSDate *startDateVal = [dateFormatter dateFromString:startDate];
    NSDate *endDateVal = [dateFormatter dateFromString:endaDate];
    NSComparisonResult result = [startDateVal compare:endDateVal];
    if(result == NSOrderedAscending){
        
        validDate = YES;
    }
    else if (result == NSOrderedSame){
        
        validDate = YES;
    }
    
    return validDate;
}

+(NSInteger)yearsFromCurrentYearWithValue:(NSInteger)paramYears{
    return ([self getCurrentDateComponents].year + paramYears);
}

@end
