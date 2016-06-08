//
//  DDCurrency.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDCurrency.h"


@implementation DDCurrency


+ (NSString*)getShortCurrencyWithCurrencyValue: (NSString*)value
{
    NSDictionary *currencyMapper = @{@"Bahraini Dinar": @"BHD", @"Kuwaiti Dinar": @"KWD", @"Omani Rial": @"OMR", @"Qatari Riyal": @"QAR", @"Saudi Riyal": @"SAR", @"UAE Dirham": @"AED", @"US Dollar": @"USD", @"British Pound": @"GBP", @"Indian Rupees": @"INR", @"Euro": @"EUR"};
    return [currencyMapper objectForKey:value];
}

+ (NSString*)getShortCurrencyWithCurrencyId: (NSString*)Id
{
    NSDictionary *currencyMapper = @{@"1": @"USD", @"2": @"SAR", @"3": @"AED", @"4": @"BHD", @"5": @"OMR", @"6": @"QAR", @"7": @"INR", @"8": @"EUR", @"9": @"GBP", @"10": @"KWD"};
    return [currencyMapper objectForKey:Id];
}


@end
