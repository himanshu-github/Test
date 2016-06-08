//
//  NGRegisterationHelper.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/27/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGRegisterationHelper.h"
#import "NGResmanDataModel.h"

@interface NGRegisterationHelper()<LoginHelperDelegate>{
    
    NGResmanDataModel *resmanModel;
    NSMutableDictionary *resmanDict;
    
}

@end

@implementation NGRegisterationHelper

-(void) registerUserWithCompletionHandler:(void(^)(NGAPIResponseModal* responseInfo))completionHandler {
    
    resmanDict = [[NSMutableDictionary alloc] init];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    
    if (resmanModel) {
        
        __block NGRegisterationHelper *mySelfVC = self;
        
        [self setDictForRegisteration];
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_USER_REGISTERATION];
        
        [obj getDataWithParams:resmanDict handler:^(NGAPIResponseModal *responseInfo) {
            
    
            if (responseInfo.isSuccess) {
                
                [NGLoginHelper sharedInstance].delegate = mySelfVC;
                [NGLoginHelper sharedInstance].conMnj = [responseInfo.parsedResponseData objectForKey:@"conmnj"];

                resmanModel.cvHeadline = [responseInfo.parsedResponseData objectForKey:@"headline"];
                [[DataManagerFactory getStaticContentManager]saveResmanFields:resmanModel];
                
                [[NGResmanNotificationHelper sharedInstance] reportUserRegistrationForGA];
                
            }
            
            completionHandler(responseInfo);
            
        }];
        
    }
    else{
        
        NGAPIResponseModal *responseModel = [[NGAPIResponseModal alloc] init];
        responseModel.isSuccess = NO;
        completionHandler(responseModel);
    }
}

-(void) setDictForRegisteration {
    
    [resmanDict setCustomObject:resmanModel.userName forKey:@"username"];
    [resmanDict setCustomObject:resmanModel.password forKey:@"passwordText"];
    [resmanDict setCustomObject:resmanModel.gender forKey:@"gender"];
    [resmanDict setCustomObject:resmanModel.name forKey:@"name"];
    [resmanDict setCustomObject:resmanModel.countryCode forKey:@"zip"];
    [resmanDict setCustomObject:resmanModel.mobileNum forKey:@"mphone"];
    [resmanDict setCustomObject:[resmanModel.nationality objectForKey:KEY_ID]forKey:@"nationality"];
    [resmanDict setCustomObject:[resmanModel.city objectForKey:KEY_VALUE] forKey:@"cityOther"];
    [resmanDict setCustomObject:[resmanModel.city objectForKey:KEY_ID] forKey:@"cityIndex"];
    [resmanDict setCustomObject:[resmanModel.alertSetting objectForKey:KEY_ID]forKey:@"alertSetting"];
    [resmanDict setCustomObject:resmanModel.keySkills forKey:@"keySkills_default"];
    [resmanDict setCustomObject:@"google" forKey:@"adnetwork"];
    resmanModel.isFresher?[self setDataForFresherRegistration]:[self setDataForExperiencedRegistration];
    [resmanDict setCustomObject:[NSString stringWithFormat:@"%d",resmanModel.isFresher] forKey:@"isFresher"];
    
}

-(void) setDataForExperiencedRegistration {
    
    NSString *experience = [[resmanModel.totalExp objectForKey:@"yearExp"] objectForKey:KEY_ID];
    [resmanDict setCustomObject:experience forKey:@"totalExperienceYears"];
    BOOL  isThirtyPlus = [experience isEqualToString:@"30plus"] ? YES : NO;
    NSString *monthExp = @"";
    
    if (!isThirtyPlus) {
        
        @try{
            monthExp = 0 < [[[resmanModel.totalExp objectForKey:@"monthExp"] objectForKey:KEY_ID] integerValue]?[[resmanModel.totalExp objectForKey:@"monthExp"] objectForKey:KEY_ID]:@"";
        }@catch(NSException *ex){
            monthExp = @"";
        }
        
    }
    
    [resmanDict setCustomObject:monthExp forKey:@"totalExperienceMonths"];
    
    [resmanDict setCustomObject:resmanModel.designation forKey:@"designation"];
    [resmanDict setCustomObject:resmanModel.company forKey:@"organization"];
    
    [resmanDict setCustomObject:resmanModel.currentSalary forKey:@"locSalary"];
    
    [resmanDict setCustomObject:[resmanModel.currency objectForKey:KEY_ID] forKey:@"currency"];
    
    if ([[resmanModel.functionalArea objectForKey:KEY_ID] integerValue] == 1000) {
        
        [resmanDict setCustomObject:@"1000" forKey:@"functionalArea_id"];
        [resmanDict setCustomObject:[resmanModel.functionalArea objectForKey:KEY_SUBVALUE] forKey:@"functionalArea_other"];
        
    }else{
        
        [resmanDict setCustomObject:[resmanModel.functionalArea objectForKey:KEY_ID] forKey:@"functionalArea_id"];
        [resmanDict setCustomObject:@"" forKey:@"functionalArea_other"];
    }
    
    
    if ([[resmanModel.industry objectForKey:KEY_ID] integerValue]== 1000) {
        
        [resmanDict setCustomObject:@"1000" forKey:@"industryType_id"];
        [resmanDict setCustomObject:[resmanModel.industry objectForKey:KEY_SUBVALUE] forKey:@"industryType_other"];
        
    }else{
        
        [resmanDict setCustomObject:[resmanModel.industry objectForKey:KEY_ID] forKey:@"industryType_id"];
        [resmanDict setCustomObject:@"" forKey:@"industryType_other"];
    }
}

-(void) setDataForFresherRegistration{
    
   // [resmanDict setCustomObject:[resmanModel.highestEducation objectForKey:KEY_ID] forKey:@"edu"];
    
    NSString* ppgCourse = @"";
    ppgCourse = [resmanModel.ppgCourse objectForKey:KEY_ID];
    
    if (ppgCourse !=nil && ppgCourse.length>0){
        
        [resmanDict setCustomObject:ppgCourse forKey:@"ppgCourse_id"];
        [resmanDict setCustomObject:[NSString stringWithFormat:@"%@",
                                    [resmanModel.ppgSpec objectForKey:KEY_ID]] forKey:@"ppgSpec_id"];
    }
    
    
    NSString* pgCourse = @"";
    pgCourse = [resmanModel.pgCourse objectForKey:KEY_ID];
    
    if (pgCourse !=nil && pgCourse.length>0){
        
        [resmanDict setCustomObject:pgCourse forKey:@"pgCourse_id"];
        [resmanDict setCustomObject:[NSString stringWithFormat:@"%@",
                            [resmanModel.pgSpec objectForKey:KEY_ID]] forKey:@"pgSpec_id"];
    }
    
    
    NSString* ugCourse = @"";
    ugCourse = [resmanModel.ugCourse objectForKey:KEY_ID];
    
    if (ugCourse !=nil && ugCourse.length>0){
        
        [resmanDict setCustomObject:ugCourse forKey:@"ugCourse_id"];
        [resmanDict setCustomObject:[NSString stringWithFormat:@"%@",
                                     [resmanModel.ugSpec objectForKey:KEY_ID]] forKey:@"ugSpec_id"];
    }
}

-(void) performAutoLoginForUser {
    //conmnj
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:resmanModel.userName,@"username",resmanModel.password,@"password", nil];

    __block NGRegisterationHelper *mySelfVC = self;
    
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_LOGIN];
    
    [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseData){
        if (responseData.isSuccess) {
            
            NSDictionary *responseDataDict = (NSDictionary *)responseData.parsedResponseData;
            
            NSString *conMnj = [responseDataDict objectForKey:KEY_LOGIN_CONMNJ]?[responseDataDict objectForKey:KEY_LOGIN_CONMNJ]:[responseDataDict objectForKey:KEY_LOGIN_AUTH];
            [NGLoginHelper sharedInstance].delegate = mySelfVC;
            [NGLoginHelper sharedInstance].conMnj = conMnj;
           
        }
    }];
    
}


-(void)doneFetchingProfile:(NGMNJProfileModalClass *)profileModal{
 
    [NGLoginHelper sharedInstance].delegate = nil;
}
@end
