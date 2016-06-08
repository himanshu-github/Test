//
//  NGCVRemindMeLaterClient.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 10/03/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGCVRemindMeLaterClient.h"
#import "NGCVRemindMeLaterParser.h"
#import "WebDataFormatter.h"

@implementation NGCVRemindMeLaterClient

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


-(void)initialize{
    
    self.apiRequestObj = [[APIRequestModal alloc]init];
    self.apiRequestObj.apiUrl = [NGConfigUtility getAPIURLWithServiceType:SERVICE_TYPE_CV_REMIND_ME_LATER];
    self.apiRequestObj.baseUrl = [NGConfigUtility getBaseURL];
    self.apiRequestObj.apiId = SERVICE_TYPE_CV_REMIND_ME_LATER;
    self.apiRequestObj.requestMethod = K_REQUEST_METHOD_POST;
    self.apiRequestObj.isBackgroundTask = NO;
    
    self.webAPICallerObj = [[WebAPICaller alloc]init];
    self.webDataFormatterObj = [[WebDataFormatter alloc]init];
    self.dataParserObj = [[NGCVRemindMeLaterParser alloc]init];    
    
}

-(void)customizeRequestParams:(NSMutableDictionary *)params{
    self.apiRequestObj.authorisationHeaderNeeded = YES;
}
@end
