//
//  NGGoogleLoginParser.m
//  NaukriGulf
//
//  Created by Himanshu on 3/16/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGGoogleLoginParser.h"
#import <GoogleSignIn/GoogleSignIn.h>

@implementation NGGoogleLoginParser


+(NGResmanDataModel*)parseTheGoogleData:(NSDictionary*)userDictionary inResmanModel:(NGResmanDataModel*)resmanModel{

    
    
    
    if(resmanModel==nil)
        resmanModel = [[NGResmanDataModel alloc]init];
    
    if(resmanModel!=nil){
        //name
        if([userDictionary objectForKey:@"displayName"]){
            resmanModel.name = [userDictionary objectForKey:@"displayName"];
        }
        else if([userDictionary objectForKey:@"name"]&&[[userDictionary objectForKey:@"name"] isKindOfClass:[NSDictionary class]]){
            resmanModel.name = [NSString stringWithFormat:@"%@ %@",[[userDictionary objectForKey:@"name"] objectForKey:@"givenName"],[[userDictionary objectForKey:@"name"] objectForKey:@"familyName"]];
        }
        else{
           //keep the present old value
        }
        
        //emails
        if([userDictionary objectForKey:@"emails"]&&[[userDictionary objectForKey:@"emails"] isKindOfClass:[NSArray class]]){
            NSArray *emailsArr = [userDictionary objectForKey:@"emails"];
            if([emailsArr fetchObjectAtIndex:0]!=nil){
                resmanModel.userName = [[emailsArr fetchObjectAtIndex:0] objectForKey:@"value"];
            }
            else{
                //keep the present old value
            }
        }
        
        //gender
        if ([userDictionary objectForKey:@"gender"]) {
            resmanModel.gender = [[userDictionary objectForKey:@"gender"] capitalizedString];
        }
        else{
            //keep the present old value
        }
        
        //dob
        if ([userDictionary objectForKey:@"birthday"]) {
            resmanModel.dob = [NGDateManager getDateForGPlusLogin:[userDictionary objectForKey:@"birthday"] ];
        }
        else{
            //keep the present old value
        }
            
        //places lived
        NSArray *locArr = [userDictionary objectForKey:@"placesLived"];
        if(locArr!=nil)
        {
            if(locArr.count>0)
            {
                NSDictionary *primaryPlaceDict = [locArr firstObject];
                NSString *fbLocation = [primaryPlaceDict objectForKey:@"value"];
                NSArray *locationValues = [[NSArray alloc] initWithArray:[fbLocation componentsSeparatedByString:@","]];
                
                DDBase *cityObj = nil;
                DDBase *countryObj = nil;
                
                for (id locValue in locationValues) {
                    NSString *locationString = [locValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSArray *cityArr = [NGDatabaseHelper searchForType:KEY_VALUE havingValue:locationString andDDType:DDC_CITY];
                    if (cityArr.count > 0) {
                        cityObj = [cityArr firstObject];
                    }
                    NSArray *countryArr = [NGDatabaseHelper searchForType:KEY_VALUE havingValue:locationString andDDType:DDC_COUNTRY];
                    if (countryArr.count > 0) {
                        countryObj = [countryArr firstObject];
                    }
                }
                
                
                if(cityObj != nil)
                {
                    NSSet *countriesObj = (NSSet*)[cityObj valueForKey:@"country"];
                    countryObj = [countriesObj.allObjects firstObject];
                    
                    NSString *cityCountryId = [NSString stringWithFormat:@"%@.%@", countryObj.valueID, cityObj.valueID];
                    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
                    [cityDict setCustomObject:cityCountryId forKey:KEY_ID];
                    [cityDict setCustomObject:cityObj.valueName forKey:KEY_VALUE];
                    resmanModel.city = cityDict;
                    resmanModel.isOtherCity = NO;
                }
                else
                {
                    if(countryObj != nil)
                    {
                        NSString *cityCountryId = [NSString stringWithFormat:@"%@.1000",countryObj.valueID];
                        NSMutableDictionary *countryDict = [[NSMutableDictionary alloc] init];
                        [countryDict setCustomObject:cityCountryId forKey:KEY_ID];
                        [countryDict setCustomObject:countryObj.valueName forKey:KEY_VALUE];
                        resmanModel.country = countryDict;
                        fbLocation = [fbLocation stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",countryObj.valueName] withString:@""];
                        
                    }
                    
                    resmanModel.isOtherCity = YES;
                    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
                    [cityDict setCustomObject:@"1000" forKey:KEY_ID];
                    [cityDict setCustomObject:fbLocation forKey:KEY_VALUE];
                    resmanModel.city = cityDict;

                }

            }
            else{
                //keep the present old value

            }
        
        }
        else{
            //keep the present old value
        }
        
        
        
        //skill sets
        if ([userDictionary objectForKey:@"skills"]) {
            resmanModel.keySkills = [userDictionary objectForKey:@"skills"];
        }
        else{
            //keep the present old value
        }
        
        
        //profile pic parsing
        if ([userDictionary objectForKey:@"image"])
        {
            if([[userDictionary objectForKey:@"image"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *imageDict = [userDictionary objectForKey:@"image"];
                if([[imageDict objectForKey:@"isDefault"] integerValue] == 0){
                    NSString *imageStr = [imageDict objectForKey:@"url"];
                    NSRange range = [imageStr rangeOfString:@"sz=50"];
                    if(range.location != NSNotFound){
                        imageStr = [imageStr stringByReplacingOccurrencesOfString:@"sz=50" withString:@"sz=280"];
                    }
                    NSURL *imageURL = [NSURL URLWithString:imageStr];
                    [NGUIUtility downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
                        if(succeeded)
                            [NGDirectoryUtility saveImage:image WithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];
                        else
                            [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];
                    }];
                }
                else
                    [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];
  
            
            }
            else{
                [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];

            }
  
        }
        else{
            //keep the present old value
            [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];
        }

        //work  & Educations
        if([userDictionary objectForKey:@"organizations"]){
        
            NSArray *organizationArr = [userDictionary objectForKey:@"organizations"];
            
            if(organizationArr.count>0){
            
                NSPredicate *workArrPredicate = [NSPredicate predicateWithFormat:@"type = %@",@"work"];
                NSArray *workArr = [organizationArr filteredArrayUsingPredicate:workArrPredicate];
                
                NSPredicate *educationArrPredicate = [NSPredicate predicateWithFormat:@"type = %@",@"school"];
                NSArray *educationArr = [organizationArr filteredArrayUsingPredicate:educationArrPredicate];
                
                //adding work history
                [NGGoogleLoginParser parseWorkDetailsToResmanModelFrom:workArr andResmanModel:resmanModel];
            
                //adding education history
                
                [NGGoogleLoginParser parseEducationDetailsToResmanModelFrom:educationArr andResmanModel:resmanModel];
                
                
            }
                
        
        }
       
   
    }

    return resmanModel;
}
+ (void)parseWorkDetailsToResmanModelFrom:(NSArray*)workArray andResmanModel: (NGResmanDataModel*)resmanModel
{
    if (workArray.count <= 0)
    {
        return;
    }
    BOOL isCurrentFound = false, isPreviousFound = false;
    for (int i = 0; i < workArray.count; i++)
    {
        NSDictionary *workDict = [workArray objectAtIndex:i];
        if (!([[workDict objectForKey:@"primary"] integerValue]==0) && !isCurrentFound)
        {
            if([workDict objectForKey:@"name"])
                resmanModel.company = [workDict objectForKey:@"name"];
            
            if([workDict objectForKey:@"title"])
                resmanModel.designation = [workDict objectForKey:@"title"];
            
            isCurrentFound = true;
        }
        if (([[workDict objectForKey:@"primary"] integerValue]==0) && !isPreviousFound)
        {
            if([workDict objectForKey:@"name"])
                resmanModel.previousCompany = [workDict objectForKey:@"name"];
            
            if([workDict objectForKey:@"title"])
                resmanModel.prevDesignation = [workDict objectForKey:@"title"];
            isPreviousFound = true;
        }
        if (isCurrentFound && isPreviousFound)
        {
            break;
        }
    }
    


}
+ (void)parseEducationDetailsToResmanModelFrom:(NSArray*)educationArray andResmanModel: (NGResmanDataModel*)resmanModel
{
    if (educationArray.count <= 0)
    {
        return;
    }
    
    BOOL isUgFound = false, isPgFound = false, isPpgFound = false;
    for (int i = 0; i< educationArray.count; i++)
    {
            NSDictionary *eduDict = [educationArray objectAtIndex:i];
        
        //for ppg
        if((!isUgFound)&&(!isPgFound))
        {
            DDBase *ppgObj = [[NGDatabaseHelper searchForType:KEY_VALUE havingValue:[NSString stringWithString: [eduDict objectForKey:@"title"]].lowercaseString andDDType:DDC_PPGCOURSE] fetchObjectAtIndex:0];
            if (ppgObj != nil && !isPpgFound)
            {
                [resmanModel.highestEducation setCustomObject:[NSString stringWithFormat:@"%d", 3] forKey:KEY_ID];
                [resmanModel.highestEducation setCustomObject:@"Doctorate" forKey:KEY_VALUE];
                
                [resmanModel.ppgCourse setCustomObject:ppgObj.valueName forKey:KEY_VALUE];
                [resmanModel.ppgCourse setCustomObject:[NSString stringWithFormat:@"%@", ppgObj.valueID] forKey:KEY_ID];
                
                NSArray *ppgSpecs = [[ppgObj valueForKey:@"specs"] allObjects];
                for (DDBase *spec in ppgSpecs)
                {
                        if ([spec.valueName isEqual: [eduDict objectForKey:@"title"]])
                        {
                            [resmanModel.ppgSpec setCustomObject:spec.valueName forKey:KEY_VALUE];
                            [resmanModel.ppgSpec setCustomObject:[NSString stringWithFormat:@"%@", spec.valueID] forKey:KEY_ID];
                            break;
                        }
                }
                isPpgFound = true;
            }
         }
        
        
        //for pg
            if((!isUgFound)&&(!isPpgFound)){
                DDBase *pgObj = [[NGDatabaseHelper searchForType:KEY_VALUE havingValue:[NSString stringWithString: [eduDict objectForKey:@"title"]].lowercaseString andDDType:DDC_PGCOURSE] fetchObjectAtIndex:0];
                
                if (pgObj != nil && !isPgFound)
                {
                    [resmanModel.highestEducation setCustomObject:[NSString stringWithFormat:@"%d", 2] forKey:KEY_ID];
                    [resmanModel.highestEducation setCustomObject:@"Masters" forKey:KEY_VALUE];
                    
                    [resmanModel.pgCourse setCustomObject:pgObj.valueName forKey:KEY_VALUE];
                    [resmanModel.pgCourse setCustomObject:[NSString stringWithFormat:@"%@", pgObj.valueID] forKey:KEY_ID];
                    
                    NSArray *pgSpecs = [[pgObj valueForKey:@"specs"] allObjects];
                    for (DDBase *spec in pgSpecs)
                    {
                            if (spec.valueName == [eduDict objectForKey:@"title"])
                            {
                                [resmanModel.pgSpec setCustomObject:spec.valueName forKey:KEY_VALUE];
                                [resmanModel.pgSpec setCustomObject:[NSString stringWithFormat:@"%@", spec.valueID] forKey:KEY_ID];
                                break;
                            }
                    }
                    isPgFound = true;
                }
            }
            
        //for ug
          if((!isPgFound)&&(!isPpgFound)){
            DDBase *ugObj = [[NGDatabaseHelper searchForType:KEY_VALUE havingValue:[NSString stringWithString: [eduDict objectForKey:@"title"]].lowercaseString andDDType:DDC_UGCOURSE] fetchObjectAtIndex:0];
            
            if (ugObj != nil && !isUgFound)
            {
                [resmanModel.highestEducation setCustomObject:[NSString stringWithFormat:@"%d", 1] forKey:KEY_ID];
                [resmanModel.highestEducation setCustomObject:@"Basic" forKey:KEY_VALUE];
                
                [resmanModel.pgCourse setCustomObject:ugObj.valueName forKey:KEY_VALUE];
                [resmanModel.pgCourse setCustomObject:[NSString stringWithFormat:@"%@", ugObj.valueID] forKey:KEY_ID];
                
                NSArray *pgSpecs = [[ugObj valueForKey:@"specs"] allObjects];
                for (DDBase *spec in pgSpecs)
                {
                    if (spec.valueName == [eduDict objectForKey:@"title"])
                    {
                        [resmanModel.pgSpec setCustomObject:spec.valueName forKey:KEY_VALUE];
                        [resmanModel.pgSpec setCustomObject:[NSString stringWithFormat:@"%@", spec.valueID] forKey:KEY_ID];
                        break;
                    }
                }
                isUgFound = true;
            }
        }
       
    }
    
}

@end
