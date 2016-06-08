//
//  NGSystemUtility.m
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGDecisionUtility.h"
#import "Reachability.h"

@implementation NGDecisionUtility
static Reachability* reachability;



+(BOOL)checkNetworkConnectivity
{
    BOOL status = NO;
    
    Reachability* reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        status=NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        status=YES;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        status=YES;
    }
    
    [NGHelper sharedInstance].isNetworkAvailable = status;
    
    return status;
}

+(BOOL)checkNetworkStatus{
    __block BOOL status = NO;
    
    reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    
    // Internet is reachable
    reachability.reachableBlock = ^(Reachability*reach)
    {
        status = YES;
    };
    
    // Internet is not reachable
    reachability.unreachableBlock = ^(Reachability*reach)
    {
        status = NO;
    };
    
    [reachability startNotifier];
    
    return status;
    
}

+ (BOOL)isJobReadWithID:(NSString *)jobID{
    NSMutableArray *arr = [NGSavedData getAllReadJobsID];
    
    if (arr!=nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",jobID];
        
        NSArray *filterArr = [arr filteredArrayUsingPredicate:predicate];
        if ([filterArr count]>0) {
            return TRUE;
        }
    }
    
    return FALSE;
}


+ (BOOL)isLooseCriteria:(NSDictionary *)paramsDict{
    
    for (NSString *keys in paramsDict.allKeys) {
        if ([keys isEqualToString:@"Location"]) {
            NSString *val = [paramsDict objectForKey:keys];
            if (![val isEqualToString:@""]) {
                return FALSE;
            }
        }else if ([keys isEqualToString:@"Experience"]) {
            NSInteger val = [[paramsDict objectForKey:keys]integerValue];
            if (val>=0 && val!=Const_Any_Exp_Tag) {
                return FALSE;
            }
        }else if (![keys isEqualToString:@"Limit"] && ![keys isEqualToString:@"Offset"] && ![keys isEqualToString:@"Keywords"] && ![keys isEqualToString:@"CompanyType"] && ![keys isEqualToString:@"Freshness"]) {
            NSArray *val = [paramsDict objectForKey:keys];
            if (val!=nil) {
                return FALSE;
            }
        }
    }
    
    return TRUE;
}

+ (BOOL)isLeftSwipeEnabledForAppState:(NSInteger)appState{
    NSDictionary *dict = [[NGHelper sharedInstance].appStateConfigArr fetchObjectAtIndex:appState-1];
    BOOL isEnabled = [[dict objectForKey:@"LeftSwipe"]boolValue];
    
    return isEnabled;
}

+ (BOOL)isRightSwipeEnabledForAppState:(NSInteger)appState{
    NSDictionary *dict = [[NGHelper sharedInstance].appStateConfigArr fetchObjectAtIndex:appState-1];
    BOOL isEnabled = [[dict objectForKey:@"RightSwipe"]boolValue];
    return isEnabled;
}
+ (BOOL)isEmailDomainRestricted:(NSString*)paramEmailDomain{
    return ((NSOrderedSame == [paramEmailDomain compare:@"naukri" options:NSCaseInsensitiveSearch]) ||
            (NSOrderedSame == [paramEmailDomain compare:@"naukrigulf" options:NSCaseInsensitiveSearch]));
}


+ (BOOL)isValidDeeplinkingURL:(NSString*)paramURL{
    return (NSNotFound != [paramURL rangeOfString:@"ng://" options:NSCaseInsensitiveSearch].location);
}

+(void)checkForSessionExpire:(enum ResponseCode)errorCode
{
    if (errorCode==K_RESPONSE_AUTH_TOKEN_EXPIRED_ERROR)
    {
        [NGUIUtility makeUserLoggedOutOnSessionExpired:YES];
        
    }
}

+ (BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL) isValidNumber:(NSString *)checkString
{
    
    //NSString *phoneRegex = @"[0-9]{10}";
    
    //Minimum 1 digit, Maximum 20 digit.
    NSString *phoneRegex = @"[0-9]{1,20}?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:checkString];
    return matches;
}
+ (BOOL)doesStringContainSpecialCharOrNumeric:(NSString *)checkString
{
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:
                             @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.'&# "]
                            invertedSet];
    if ([checkString rangeOfCharacterFromSet:set].location == NSNotFound)
        return NO;
    return  YES;
}

+(BOOL) isTextFieldNotEmpty:(NSString *)checkString
{
    if (checkString.length==0 ||[[checkString trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0)
        return FALSE;
    else
        return TRUE;
}

+(BOOL) isTextViewNotEmpty:(NSString *)checkString
{
    if ([checkString isEqualToString:@""])
        return FALSE;
    else
        return TRUE;
}

+(BOOL)isValidDate:(NSString *)dateStr{
    BOOL isValid = TRUE;
    
    if (!dateStr || [dateStr isEqualToString:@""] || [dateStr isEqualToString:@"0000-00-00"] || [dateStr isEqualToString:@"0001-01-01"]) {
        isValid = FALSE;
    }
    
    return isValid;
}

+(BOOL)isValidJSON:(NSString *)str{
    NSError *error;
    
    if (str && [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error] != nil) {
        
        return TRUE;
    }
    
    return FALSE;
}
+(BOOL)isValidString:(id)checkString{
    
    if(checkString == [NSNull null])
        return NO;
    checkString = [checkString trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(((NSString*)checkString).length == 0)
        return NO;
    return YES;
}
+ (BOOL) doesStringContainSpecialCharsForKeywords:(NSString*) checkString {
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:
                            @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789@#./_ &++,-\\" ]
                           invertedSet];
    
    if ([checkString rangeOfCharacterFromSet:set].location == NSNotFound){
        return NO;
    }
    
    return YES;
    
    
}
+ (BOOL)doesStringContainsSpecialChar:(NSString *)checkString{
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:
                             @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789.'& " ]
                            invertedSet];
    
    if ([checkString rangeOfCharacterFromSet:set].location == NSNotFound){
        return NO;
    }
    
    return YES;
}
+ (BOOL) isValidNonEmptyNotNullString:(id)checkString{
    if(![checkString isKindOfClass:[NSString class]])
        return NO;
    
    if(checkString == [NSNull null])
        return NO;
    
    if([((NSString*)checkString) trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        return NO;
    
    return YES;
}
+ (BOOL)isValidArray:(NSArray*)paramArray{
    return paramArray && 0 < [paramArray count];
}
+ (BOOL)doesStringContainsSpecialCharAndNumeric:(NSString *)checkString
{
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:
                             @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.'&# "]
                            invertedSet];
    if ([checkString rangeOfCharacterFromSet:set].location == NSNotFound)
        return NO;
    return  YES;
}
+ (BOOL)doesStringContainsSpecialCharForDesignation:(NSString *)checkString{
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:
                             @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789.' &-#()@," ]
                            invertedSet];
    
    if ([checkString rangeOfCharacterFromSet:set].location == NSNotFound){
        return NO;
    }
    
    return YES;
}

+(BOOL)isValidDropDownItem:(NSDictionary*)paramDDItem{
    NSString *itemId = [paramDDItem objectForKey:KEY_ID];
    NSString *itemValue = [paramDDItem objectForKey:KEY_VALUE];
    return (nil!=paramDDItem && 0<paramDDItem.count && nil!=itemId && 0<itemId.length && 0 < itemId.integerValue && nil!=itemValue && 0<itemValue.length);
}

@end
