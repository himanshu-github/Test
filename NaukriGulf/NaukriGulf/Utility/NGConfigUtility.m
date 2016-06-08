//
//  NGConfigUtility.m
//  NaukriGulf
//
//  Created by Ayush Goel on 01/07/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGConfigUtility.h"
#include <sys/sysctl.h>
#import <sys/utsname.h>

@implementation NGConfigUtility


+(NSMutableDictionary *)getAppConfigDictionary{
    NSString *filePath = [NGConfigUtility getAppConfigFilePath];
    
    if (filePath) {
       NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        return dict;
    }
    
    return nil;
}

+(NSString *)getAppStateConfigFilePath{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:APP_STATE_CONFIG ofType:@"plist"];
    return filePath;
}

+(NSArray *)getAppStateConfigDictionary{
    NSString *filePath = [NGConfigUtility getAppStateConfigFilePath];
    if (filePath) {
        return [[NSArray alloc] initWithContentsOfFile:filePath];
    }
    
    return nil;
}


+(NSString *)getAppConfigFilePath{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[[NSBundle mainBundle] infoDictionary][@"AppConfigFile"] ofType:@"plist"];
    
    
    return filePath;
}


+(NSString *)getBaseURL{
    
    if ([NGHelper sharedInstance].appConfigDict) {
        return [[[NGHelper sharedInstance].appConfigDict valueForKey:@"BaseURL"]fetchObjectAtIndex:0];
    }
    
    return nil;
}
+(NSString *)getBaseURLWithServiceType:(NSInteger)baseURLType{
    
    if ([NGHelper sharedInstance].appConfigDict) {
        
        return [[[NGHelper sharedInstance].appConfigDict valueForKey:@"BaseURL"]fetchObjectAtIndex:baseURLType];
    }
    return nil;
}

+(NSInteger)getJobDownloadLimit{
    if ([NGHelper sharedInstance].appConfigDict) {
        return [[[NGHelper sharedInstance].appConfigDict valueForKey:@"JobsDownloadLimit"]integerValue];
    }
    
    return -1;
}

+(NSString *)getDropDownConfigPath{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:APP_DROPDOWN_CONFIG
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

+(NSString *)getAPIURLWithServiceType:(NSInteger)serviceType{
    if ([NGHelper sharedInstance].appConfigDict) {        
        return [[[NGHelper sharedInstance].appConfigDict valueForKey:@"APIURL"]objectAtIndex:serviceType];
    }
    
    return nil;
}
+ (NSString*) getDeviceModel
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini"        // (3rd Generation iPad Mini - Wifi (model A1599))
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database.
        deviceName = code;
     
    }
    
    return deviceName;
}
@end
