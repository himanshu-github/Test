//
//  ValidatorManager.m
//  Magic Mirror
//
//  Created by Arun Kumar on 12/17/14.
//  Copyright (c) 2014 Arun Kumar. All rights reserved.
//

#import "ValidatorManager.h"

#define DEFAULT_MIN_LENGTH 0
#define DEFAULT_MAX_LENGTH 1000

@interface ValidatorManager(){
    NSString *_strToValidate;
    NSInteger _minLength;
    NSInteger _maxLength;
    NSArray *_arrayToValidate;
}

@property (nonatomic, strong) NSMutableArray *validationsArr;


@end

@implementation ValidatorManager

+ (ValidatorManager*)sharedInstance
{
    static dispatch_once_t once;
    static ValidatorManager* sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[ValidatorManager alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if (self=[super init]) {
        [self setUp];
    }
    
    return self;
}

#pragma mark Public Methods




-(NSMutableArray*)validateValue:(NSString *)str withType:(ValidationType)validationType withMinLength:(NSInteger)minLen withMaxLength:(NSInteger)maxLen{
    
    [self validateValue:str withType:validationType minLength:minLen maxLength:maxLen];
    return self.validationsArr;

}


-(NSMutableArray*)validateValue:(NSString *)str withType:(ValidationType)validationType{
    
    [self validateValue:str withType:validationType minLength:DEFAULT_MIN_LENGTH maxLength:DEFAULT_MAX_LENGTH];
   
    return self.validationsArr;
}

-(NSMutableArray*)validateArray:(NSArray *)paramArray withType:(ValidationType)validationType{
    
    [self clearValidationsArr];
    
    _arrayToValidate = paramArray;
    [self setUpAllValidationsForArray];
    
    return self.validationsArr;
}

-(NSMutableArray*)validateValue:(NSString *)str withType:(ValidationType)validationType minLength:(NSInteger)minLength maxLength:(NSInteger)maxLength{
    
    [self clearValidationsArr];
    
    _strToValidate = str;
    _minLength = minLength;
    _maxLength = maxLength;
    
    switch (validationType) {
        case ValidationTypeName:{
            [self setUpAllValidationsForName];
            break;
        }
            
        case ValidationTypeEmail:{
            [self setUpAllValidationsForEmail];
            break;
        }
            
        case ValidationTypeString:{
            [self setUpAllValidationsForOpenFields];
            break;
        }
            
        case ValidationTypeDate:{
            [self setUpAllValidationsForDate];
            break;
        }
        
        case ValidationTypeNumber:{
            [self setUpAllValidationsForNumber];
            break;
        }
            
        case ValidationTypeKeywords:{
            [self setUpAllValidationsForKeywords];
            break;
        }
            
        case ValidationTypeJSON:{
            [self setUpAllValidationsForJSON];
            break;
        }
            
        case ValidationTypeNotSpecialCharOrNumeric:{
            [self setUpAllValidationsForNotSpecialCharOrNumeric];
            break;
        }
        case ValidationTypePassword:{
            
            [self setUpAllValidationsForPasswordwithMinLen:_minLength withMaxLen:_maxLength];
            break;
        }
        default:
            break;
    }
    
    return self.validationsArr;
}


#pragma mark Private Methods
-(void)clearValidationsArr{
    NSUInteger zeroUnsigned = 0;
    if (self.validationsArr && zeroUnsigned<self.validationsArr.count) {
        [self.validationsArr removeAllObjects];
    }
}
-(void)setUp{
    self.validationsArr = [[NSMutableArray alloc]init];
}

-(void)addValidation:(ValidationErrorType)validationErrorType{
    if (validationErrorType!=ValidationErrorTypeNone) {
        [self.validationsArr addObject:[NSNumber numberWithInteger:validationErrorType]];
    }
}

-(NSMutableArray*)setUpAllValidationsForOpenFields{
    
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].nullValidator(_strToValidate);
    [self addValidation:vType];
    
    vType = [ValidatorBlocks sharedInstance].emptyValidator(_strToValidate);
    [self addValidation:vType];
    
    return self.validationsArr;
    
}

-(NSMutableArray*)setUpAllValidationsForName{
    
    [self setUpAllValidationsForOpenFields];
    
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].specialCharOrNumberValidator(_strToValidate);
    [self addValidation:vType];
    
    return self.validationsArr;
    
}

-(NSMutableArray*)setUpAllValidationsForEmail{
    [self setUpAllValidationsForOpenFields];
    
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].emailValidator(_strToValidate);
    [self addValidation:vType];
    
    return self.validationsArr;
    
}

-(NSMutableArray*)setUpAllValidationsForDate{
    [self setUpAllValidationsForOpenFields];
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].dateValidator(_strToValidate);
    [self addValidation:vType];
    
    return self.validationsArr;
    
}

-(NSMutableArray*)setUpAllValidationsForNumber{
    [self setUpAllValidationsForOpenFields];
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].numberValidator(_strToValidate);
    [self addValidation:vType];
    
    return self.validationsArr;
    
}

-(NSMutableArray*)setUpAllValidationsForArray{
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].arrayEpmtyNullValidator(_arrayToValidate);
    [self addValidation:vType];
    
    return self.validationsArr;
    
}

-(NSMutableArray*)setUpAllValidationsForKeywords{
    [self setUpAllValidationsForOpenFields];
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].regExValidator(_strToValidate,@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789@#./_ &++,-\\");
    [self addValidation:vType];
    
    return self.validationsArr;
    
}

-(NSMutableArray*)setUpAllValidationsForJSON{
    [self setUpAllValidationsForOpenFields];
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].jsonValidator(_strToValidate);
    [self addValidation:vType];
    
    return self.validationsArr;
    
}
-(NSMutableArray*)setUpAllValidationsForNotSpecialCharOrNumeric{
    [self setUpAllValidationsForOpenFields];
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].specialCharOrNumberValidator(_strToValidate);
    [self addValidation:vType];
    
    return self.validationsArr;
    
}

-(NSMutableArray*)setUpAllValidationsForPasswordwithMinLen:(NSInteger)minLen withMaxLen:(NSInteger) maxLen{
    [self setUpAllValidationsForOpenFields];
    
    ValidationErrorType vType = [ValidatorBlocks sharedInstance].regExValidator(_strToValidate,@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_.@-");
    [self addValidation:vType];
    
     vType = [ValidatorBlocks sharedInstance].lengthValidator(_strToValidate,minLen,maxLen);
    [self addValidation:vType];
    return self.validationsArr;

    
}


@end
