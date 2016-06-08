//
//  ValidatorBlocks.m
//  Magic Mirror
//
//  Created by Arun Kumar on 12/17/14.
//  Copyright (c) 2014 Arun Kumar. All rights reserved.
//

#import "ValidatorBlocks.h"

@implementation ValidatorBlocks

+ (ValidatorBlocks*)sharedInstance
{
    static dispatch_once_t once;
    static ValidatorBlocks* sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[ValidatorBlocks alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        [self configureAllBlocks];
    }
    
    return self;
}


#pragma mark Private Methods

-(void)configureAllBlocks{
    // Validate the length of string
    self.lengthValidator = ^(NSString *str, NSInteger minLength, NSInteger maxLength){
      
        if ([str isKindOfClass:[NSString class]] && (str.length>=minLength && str.length<=maxLength)) {
            return ValidationErrorTypeNone;
        }
        
        return ValidationErrorTypeLength;
    };
    
    
    // Validate if the string is not null
    
    self.nullValidator = ^(NSString *str){
      
        if (str!=nil) {
            return ValidationErrorTypeNone;
        }
        return ValidationErrorTypeNull;
    };
    
    
    // Validate if string is valid email
    
    self.emailValidator = ^(NSString *str){
        
        BOOL stricterFilter = YES;
        //NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        
        //http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
        
        NSString *stricterFilterString = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";
        NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        if ([emailTest evaluateWithObject:str]) {
            return ValidationErrorTypeNone;
        }
        return ValidationErrorTypeEmail;
    };
    
    
    // Validate if string is a valid number
    
    self.numberValidator = ^(NSString *str){
        
        NSString *phoneRegex = @"[0-9]{1,20}?";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        
        if ([test evaluateWithObject:str]) {
            return ValidationErrorTypeNone;
        }
        return ValidationErrorTypeNumber;
    };
    
    
    // Validate if string contains special characters or number
    
    self.specialCharOrNumberValidator = ^(NSString *str){
        
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:
                                 @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.'&# "]
                                invertedSet];
        if ([str rangeOfCharacterFromSet:set].location == NSNotFound){
            return ValidationErrorTypeNone;
        }
        
        return ValidationErrorTypeSpecialCharOrNumeric;
    };
    
    
    // Validate if string is a valid date
    
    self.dateValidator = ^(NSString *str){
        
        if ([str isEqualToString:@"0000-00-00"] || [str isEqualToString:@"0001-01-01"]) {
            return ValidationErrorTypeDate;
        }
        
        return ValidationErrorTypeNone;
    };
    
    
    // Validate if string is a valid json
    
    self.jsonValidator = ^(NSString *str){
        
        NSError *error;
        
        if (str && [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error] != nil) {
            
            return ValidationErrorTypeNone;
        }
        return ValidationErrorTypeJSON;
    };
    
    
    // Validate if string contains special character
    
    self.specialCharValidator = ^(NSString *str){
        
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:
                                 @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789.'& " ]
                                invertedSet];
        
        if ([str rangeOfCharacterFromSet:set].location == NSNotFound){
            return ValidationErrorTypeSpecialChar;
        }
        return ValidationErrorTypeNone;
    };
    
    
    // Validate if string contains the regular expression
    
    // This is incorrect. i have changed this (Shikha)
    self.regExValidator = ^(NSString *str, NSString *regExStr){
        
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:
                                 regExStr ]
                                invertedSet];
        
        if ([str rangeOfCharacterFromSet:set].location != NSNotFound){
            return ValidationErrorTypeRegEx;
        }
        return ValidationErrorTypeNone;
    };
    
    
    // Validate if string is not empty
    
    self.emptyValidator = ^(NSString *str){
        
        if ([str isKindOfClass:[NSString class]] && (str.length==0 ||[[str trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0)){
            return ValidationErrorTypeEmpty;
        }
        
        return ValidationErrorTypeNone;
    };
    
    //validate if array is not nil and not empty
    self.arrayEpmtyNullValidator = ^(NSArray* paramArray){
        return (paramArray && [paramArray isKindOfClass:[NSArray class]] && 0 < [paramArray count])?ValidationErrorTypeNone:ValidationErrorTypeInvalidArray;
    };
}

@end
