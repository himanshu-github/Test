//
//  NGExceptionHandler.h
//  Naukri
//
//  Created by Arun Kumar on 3/25/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGWebDataManager.h"
#import "NGServerErrorDataModel.h"

@interface NGExceptionHandler : NSObject

+(void)initiateExceptionLoggingTimer;
+(void)logException:(NSException *)exception withTopView:(NSString*)controller;//for crash
+(void)logServerError:(NGServerErrorDataModel *)errorModal;//for api error

@end
