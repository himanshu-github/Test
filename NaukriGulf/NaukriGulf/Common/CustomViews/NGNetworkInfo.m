//
//  NGNetworkInfo.m
//  NaukriGulf
//
//  Created by Himanshu on 5/13/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGNetworkInfo.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"

@implementation NGNetworkInfo

- (id)init{
    self = [super init];
    if (self) {
        _type = @"NA";
        _strength = @"NA";
        
        [self getNetworkType];
    }
    return self;
}

-(void)getNetworkType{
    
    //first check from reahcability
    Reachability* reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        //no network
        _type = @"No Network";
        _strength = @"0";
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        //via cellular network
        CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
        _type = [self getType:telephonyInfo.currentRadioAccessTechnology];
        _strength = [self getStrength:telephonyInfo.currentRadioAccessTechnology];
        
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        //via wifi
        _type = @"Wi-Fi";
        _strength = @"Moderate";
    }
  
}

- (NSString*)getStrength:(NSString*)radioAccessTechnology {
    if(radioAccessTechnology == nil)
        return @"0";
    if([radioAccessTechnology isKindOfClass:[NSString class]]){
        
    if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
        return @"Very Slow";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) {
        return @"Slow";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]) {
        return @"Fast";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]) {
        return @"Fast";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]) {
        return @"Fast";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        return @"Slow";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
        return @"Fast";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
        return @"Fast";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
        return @"Fast";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        return @"Fast";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        return @"Fast";
    }
    
    return @"Fast";
    }
    else
      return @"0";
}
- (NSString*)getType:(NSString*)radioAccessTechnology {
    if(radioAccessTechnology == nil)
        return @"No Network";
    if([radioAccessTechnology isKindOfClass:[NSString class]]){
        
    if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
        return @"GPRS";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) {
        return @"EDGE";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]) {
        return @"WCDMA";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]) {
        return @"HSDPA";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]) {
        return @"HSUPA";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        return @"CDMA1x";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
        return @"CDMAEVDORev0";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
        return @"CDMAEVDORevA";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
        return @"CDMAEVDORevB";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        return @"HRPD";
    } else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        return @"LTE";
    }
    
    return @"Cellular";
    }
    else
        return @"No Network";
}

@end
