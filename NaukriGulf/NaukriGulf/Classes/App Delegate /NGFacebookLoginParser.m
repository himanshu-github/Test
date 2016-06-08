//
//  NGFacebookLoginParser.m
//  NaukriGulf
//
//  Created by Himanshu on 3/16/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGFacebookLoginParser.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define profilePicWidth 280
#define profilePicHeight 280

@implementation NGFacebookLoginParser

+ (NGResmanDataModel*)parseTheFacebookData:(NSDictionary*)userDictionary inResmanModel:(NGResmanDataModel*)resmanModel
{
    NSArray *allKeys = [userDictionary allKeys];
    if ([allKeys containsObject:@"name"])
    {
        resmanModel.name = [userDictionary objectForKey:@"name"];
    }
    if ([allKeys containsObject:@"email"])
    {
        resmanModel.userName = [userDictionary objectForKey:@"email"];
    }
    else
    {
        resmanModel.userName = nil;
    }
    if ([allKeys containsObject:@"gender"])
    {
        resmanModel.gender = [[userDictionary objectForKey:@"gender"] capitalizedString];
    }
    if ([allKeys containsObject:@"birthday"])
    {
        resmanModel.dob = [NGDateManager getDateInLongStyleFromFacebookDate:[userDictionary objectForKey:@"birthday"]];
    }
    if ([allKeys containsObject:@"location"])
    {
        [NGFacebookLoginParser parseLocationDetailsToResmanModelFrom:[[userDictionary objectForKey:@"location"] objectForKey:@"name"] andResmanModel:resmanModel];
    }
    
    if ([allKeys containsObject:@"education"])
    {
        [NGFacebookLoginParser parseEducationDetailsToResmanModelFrom:[userDictionary objectForKey:@"education"] andResmanModel:resmanModel];
    }
    
    if ([allKeys containsObject:@"work"])
    {
        [NGFacebookLoginParser parseWorkDetailsToResmanModelFrom:[userDictionary objectForKey:@"work"] andResmanModel:resmanModel];
    }
    
    
    
    [NGFacebookLoginParser getFacebookUserProfilePicDataWithHandler:^(NSDictionary *result) {
        if([[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"is_silhouette"] integerValue] == 0)
            [self getProfilePicWithID:[userDictionary objectForKey:@"id"] withWidth:profilePicWidth andHeight:profilePicHeight];
        else
            [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];

        
    } withError:^(NSError *error) {
        
    }];
    
    
    return resmanModel;

}

+ (void)parseLocationDetailsToResmanModelFrom: (NSString*)locationName andResmanModel: (NGResmanDataModel*)resmanModel
{
    NSArray *locationValues = [[NSArray alloc] initWithArray:[locationName componentsSeparatedByString:@","]];
    
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
        }
        
        resmanModel.isOtherCity = YES;
        NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
        [cityDict setCustomObject:@"1000" forKey:KEY_ID];
        [cityDict setCustomObject:locationName forKey:KEY_VALUE];
        resmanModel.city = cityDict;
        
    }
}

+ (void)parseEducationDetailsToResmanModelFrom:(NSArray*)educationArray andResmanModel: (NGResmanDataModel*)resmanModel
{
    if (educationArray.count <= 0)
    {
        return;
    }
    
    BOOL isUgFound = false, isPgFound = false, isPpgFound = false;
    for (NSUInteger i = educationArray.count; i > 0; i--)
    {
        NSDictionary *eduDict = [educationArray objectAtIndex:i-1];
        if ([[eduDict objectForKey:@"type"] isEqual: @"Graduate School"])
        {
            if ([eduDict.allKeys containsObject:@"degree"])
            {
                DDBase *ppgObj = [[NGDatabaseHelper searchForType:KEY_VALUE havingValue:[NSString stringWithString: [[eduDict objectForKey:@"degree"] objectForKey:@"name"]].lowercaseString andDDType:DDC_PPGCOURSE] fetchObjectAtIndex:0];
                if (ppgObj != nil && !isPpgFound)
                {
                    [resmanModel.highestEducation setCustomObject:[NSString stringWithFormat:@"%d", 3] forKey:KEY_ID];
                    [resmanModel.highestEducation setCustomObject:@"Doctorate" forKey:KEY_VALUE];
                    
                    [resmanModel.ppgCourse setCustomObject:ppgObj.valueName forKey:KEY_VALUE];
                    [resmanModel.ppgCourse setCustomObject:[NSString stringWithFormat:@"%@", ppgObj.valueID] forKey:KEY_ID];
                    
                    NSArray *ppgSpecs = [[ppgObj valueForKey:@"specs"] allObjects];
                    NSArray *concentrationArr = [eduDict objectForKey:@"concentration"];
                    for (NSDictionary *concentrationDict in concentrationArr)
                    {
                        for (DDBase *spec in ppgSpecs)
                        {
                            if ([spec.valueName isEqual: [concentrationDict objectForKey:@"name"]])
                            {
                                [resmanModel.ppgSpec setCustomObject:spec.valueName forKey:KEY_VALUE];
                                [resmanModel.ppgSpec setCustomObject:[NSString stringWithFormat:@"%@", spec.valueID] forKey:KEY_ID];
                                break;
                            }
                        }
                    }
                    isPpgFound = true;
                }
                else
                {
                    DDBase *pgObj = [[NGDatabaseHelper searchForType:KEY_VALUE havingValue:[NSString stringWithString: [[eduDict objectForKey:@"degree"] objectForKey:@"name"]].lowercaseString andDDType:DDC_PGCOURSE] fetchObjectAtIndex:0];
                    
                    if (pgObj != nil && !isPgFound)
                    {
                        [resmanModel.pgCourse setCustomObject:pgObj.valueName forKey:KEY_VALUE];
                        [resmanModel.pgCourse setCustomObject:[NSString stringWithFormat:@"%@", pgObj.valueID] forKey:KEY_ID];
                        
                        NSArray *pgSpecs = [[pgObj valueForKey:@"specs"] allObjects];
                        NSArray *concentrationArr = [eduDict objectForKey:@"concentration"];
                        for (NSDictionary *concentrationDict in concentrationArr)
                        {
                            for (DDBase *spec in pgSpecs)
                            {
                                if ([spec.valueName isEqual: [concentrationDict objectForKey:@"name"]])
                                {
                                    [resmanModel.pgSpec setCustomObject:spec.valueName forKey:KEY_VALUE];
                                    [resmanModel.pgSpec setCustomObject:[NSString stringWithFormat:@"%@", spec.valueID] forKey:KEY_ID];
                                    break;
                                }
                                
                            }
                            
                        }
                        isPgFound = true;
                    }
                    
                }
                
            }
            if (!isPpgFound)
            {
                [resmanModel.highestEducation setCustomObject:[NSString stringWithFormat:@"%d", 2] forKey:KEY_ID];
                [resmanModel.highestEducation setCustomObject:@"Masters" forKey:KEY_VALUE];
                isPgFound = true;
            }
            
        }
        else if (([[eduDict objectForKey:@"type"] isEqual: @"High School"] || [[eduDict objectForKey:@"type"]  isEqual: @"College"]) && !isUgFound)
        {
            // Do Something in Future
            
            if (!isPgFound && !isPpgFound)
            {
                if (!isPpgFound)
                {
                    [resmanModel.highestEducation setCustomObject:[NSString stringWithFormat:@"%d", 1] forKey:KEY_ID];
                    [resmanModel.highestEducation setCustomObject:@"Basic" forKey:KEY_VALUE];
                }
            }
            isUgFound = true;
        }
    }
    
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
        if (![workDict.allKeys containsObject:@"end_date"] && !isCurrentFound)
        {
            resmanModel.company = [[workDict objectForKey:@"employer"] objectForKey:@"name"];
            if ([workDict.allKeys containsObject:@"position"])
            {
                resmanModel.designation = [[workDict objectForKey:@"position"] objectForKey:@"name"];
            }
            isCurrentFound = true;
        }
        if ([workDict.allKeys containsObject:@"end_date"] && !isPreviousFound)
        {
            resmanModel.previousCompany = [[workDict objectForKey:@"employer"] objectForKey:@"name"];
            if ([workDict.allKeys containsObject:@"position"])
            {
                resmanModel.prevDesignation = [[workDict objectForKey:@"position"] objectForKey:@"name"];
            }
            isPreviousFound = true;
        }
        if (isCurrentFound && isPreviousFound)
        {
            break;
        }
    }
}
+ (void)getFacebookUserProfilePicDataWithHandler: (void (^)(NSDictionary* result))successBlock withError:(void (^)(NSError* error))errorBlock
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"me?fields=picture"] parameters:nil HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error != nil)
        {
            errorBlock(error);
        }
        else
        {
           successBlock(result);    
        }
    }];
}

+ (void)getProfilePicWithID:(NSString*)facebookID withWidth:(int)width andHeight:(int)height
{
    if (facebookID && ![facebookID  isEqual: @""])
    {
        NSURL *imageUrl = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&?height=%d", facebookID, width, height]];
        [NGUIUtility downloadImageWithURL:imageUrl completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {

                 [NGDirectoryUtility saveImage:image WithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];
                 NSLog(@"Profile Picture Downloaded Successfully !!");
             }
             else
             {
                 
                 [NGDirectoryUtility deletePhotoWithName:USER_PROFILE_PHOTO_NAME_FROM_SOCIAL_LOGIN];
                 NSLog(@"Error Downloading Facebook Profile Picture !!");
             }
         }];
    }
}

@end
