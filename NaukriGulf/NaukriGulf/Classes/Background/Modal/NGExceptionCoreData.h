//
//  NGExceptionCoreData.h
//  NaukriGulf
//
//  Created by Swati Kaushik on 07/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NGExceptionCoreData : NSManagedObject

@property (nonatomic, retain) NSString * exceptionDebugDescription;
@property (nonatomic, retain) NSString * exceptionName;
@property (nonatomic, retain) NSString * timeStamp;
@property (nonatomic, retain) NSString * exceptionType;
@property (nonatomic, retain) NSString * exceptionTag;

@end
