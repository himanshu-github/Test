//
//  NGDateManager.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 23/12/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGDateManager : NSObject

+ (NSString*)stringFromDate:(NSDate*)paramDate WithDateFormat:(NSString*)paramDateFormat;
+(NSDate*)dateFromString:(NSString*)paramString WithDateFormat:(NSString*)paramDateFormat;
+(NSString*)stringFromDate:(NSDate*)paramDate WithDateFormat:(NSString*)paramDateFormat AndStyle:(NSDateFormatterStyle)paramStyle;
+ (NSDate*)dateFromString:(NSString*)paramString WithDateFormat:(NSString*)paramDateFormat AndStyle:(NSDateFormatterStyle)paramStyle;
+ (NSString*)stringFromDate:(NSDate*)paramDate WithStyle:(NSDateFormatterStyle)paramStyle;
+ (NSString *)formatDateInMonthYear:(NSString *)dateStr;
+ (NSString *)getDateInLongStyle:(NSString *)dateStr;
+ (NSString *)getDateFromLongStyle:(NSString *)dateStr;
+ (NSString *)getDateFromMonthYear:(NSString *)dateStr;
+ (NSString *)getDateInMediumStyleFormat:(NSString *)dateStr;
+ (NSDate*) getDateInMonthDayStyle : (NSString*)date ;
+ (NSString *)getDateInLongStyleFromFacebookDate:(NSString *)dateStr;
+ (int)daysDiffrence:(NSString*)fromDateString;
+ (NSString *)formatDateMonthYearStringToServerFormat:(NSString *)dateString;
+ (BOOL)isValidStartDateEndate:(NSString *)startDate withEndDate:(NSString *)endaDate;
+ (BOOL)isValideDate:(NSString *)dateString;
+(NSDate*)dateByAddingValue:(NSTimeInterval)paramValue InUnit:(enum NGTimeUnit)paramUnit ToDate:(NSDate*)paramToDate;
+ (NSDate*)UTCDateFromString:(NSString*)paramString WithDateFormat:(NSString*)paramDateFormat;
+(BOOL)isNightTimeInDate:(NSDate*)paramDate;
+(NSDate*)createNewDateFromDate:(NSDate*)paramFromDate ForHour:(NSUInteger)paramHour AndForMinute:(NSUInteger)paramMinute;
+(NSDateComponents *)getCurrentDateComponents;
+(NSDateComponents *)getDifferenceBTWDate:(NSDate *)date1 withDate:(NSDate *)date2;
+(BOOL)isDate:(NSDate*)paramDate nDaysOld:(NSInteger)paramNDays;
+(NSInteger)yearsFromCurrentYearWithValue:(NSInteger)paramYears;
+ (NSString *)getDateForGPlusLogin:(NSString *)dateStr;

@end
