//
//  ValidatorBlocks.h
//  Magic Mirror
//
//  Created by Arun Kumar on 12/17/14.
//  Copyright (c) 2014 Arun Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ValidationErrorTypeNone,
    ValidationErrorTypeLength,
    ValidationErrorTypeNull,
    ValidationErrorTypeEmail,
    ValidationErrorTypeNumber,
    ValidationErrorTypeSpecialCharOrNumeric,
    ValidationErrorTypeDate,
    ValidationErrorTypeJSON,
    ValidationErrorTypeSpecialChar,
    ValidationErrorTypeRegEx,
    ValidationErrorTypeEmpty,
    ValidationErrorTypeInvalidArray,
    ValidationErrorTypeInvalidSpecialCharsForKeywords
} ValidationErrorType;

@interface ValidatorBlocks : NSObject

@property (nonatomic, strong) ValidationErrorType (^lengthValidator)(NSString*, NSInteger, NSInteger);
@property (nonatomic, strong) ValidationErrorType (^nullValidator)(NSString*);
@property (nonatomic, strong) ValidationErrorType (^emailValidator)(NSString*);
@property (nonatomic, strong) ValidationErrorType (^numberValidator)(NSString*);
@property (nonatomic, strong) ValidationErrorType (^specialCharOrNumberValidator)(NSString*);
@property (nonatomic, strong) ValidationErrorType (^dateValidator)(NSString*);
@property (nonatomic, strong) ValidationErrorType (^jsonValidator)(NSString*);
@property (nonatomic, strong) ValidationErrorType (^specialCharValidator)(NSString*);
@property (nonatomic, strong) ValidationErrorType (^regExValidator)(NSString*,NSString*);

@property (nonatomic, strong) ValidationErrorType (^emptyValidator)(NSString*);
@property (nonatomic, strong) ValidationErrorType (^arrayEpmtyNullValidator)(NSArray*);

+ (ValidatorBlocks*)sharedInstance;

@end
