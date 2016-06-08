//
//  NGServerErrorCoreData.h
//  NaukriGulf
//
//  Created by Swati Kaushik on 07/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NGServerErrorCoreData : NSManagedObject

@property (nonatomic, retain) NSString * errorDesription;
@property (nonatomic, retain) NSString * errorType;
@property (nonatomic, retain) NSString * errorTag;
@property (nonatomic, retain) NSString * errorName;
@property (nonatomic, retain) NSString * timeStamp;
@property (nonatomic, retain) NSString * errorClassName;
@property (nonatomic, retain) NSString * errorMethodName;
@property (nonatomic, retain) NSString * errorSignalType;
@property (nonatomic, retain) NSString * errorSingleStrength;
@property (nonatomic, retain) NSString * errorUserId;


@end
