//
//  NGServerErrorDataModel.h
//  NaukriGulf
//
//  Created by Himanshu on 5/9/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGServerErrorDataModel : NSObject
@property (strong,nonatomic) NSString* serverExceptionErrorType;
@property (strong,nonatomic) NSString* serverExceptionDescription;
@property (strong,nonatomic) NSString* serverExceptionClassName;
@property (strong,nonatomic) NSString* serverExceptionMethodName;
@property (strong,nonatomic) NSString* serverExceptionApiURL;
@property (strong,nonatomic) NSString* serverExceptionErrorTag;
@property(nonatomic, strong) NSString* serverErrorSignalType;
@property(nonatomic, strong) NSString* serverErrorSignalStrength;
@property(nonatomic, strong) NSString* serverErrorUserId;

@property (strong,nonatomic) NSDate* serverExceptionTimeStamp;//managed internally

@end
