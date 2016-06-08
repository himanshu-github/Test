//
//  ValidatorManager.h
//  Magic Mirror
//
//  Created by Arun Kumar on 12/17/14.
//  Copyright (c) 2014 Arun Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ValidatorBlocks.h"

typedef enum : NSUInteger {
    ValidationTypeName,
    ValidationTypeEmail,
    ValidationTypeString,
    ValidationTypeDate,
    ValidationTypeNumber,
    ValidationTypeArray,
    ValidationTypeKeywords,
    ValidationTypeJSON,
    ValidationTypeNotSpecialCharOrNumeric,
    ValidationTypePassword
} ValidationType;

@interface ValidatorManager : NSObject

+ (ValidatorManager*)sharedInstance;


-(NSMutableArray*)validateValue:(NSString *)str withType:(ValidationType)validationType;
-(NSMutableArray*)validateArray:(NSArray *)paramArray withType:(ValidationType)validationType;

-(NSMutableArray*)validateValue:(NSString *)str withType:(ValidationType)validationType minLength:(NSInteger)minLength maxLength:(NSInteger)maxLength;
-(NSMutableArray*)validateValue:(NSString *)str withType:(ValidationType)validationType withMinLength:(NSInteger)minLen withMaxLength:(NSInteger)maxLen;


@end
