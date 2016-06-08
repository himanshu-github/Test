//
//  AppTracer.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TracerAPIModel.h"
#import "TracerExceptionModel.h"
#import "TracerConstant.h"

@interface AppTracer : NSObject

/**
 * Turn TRACER ON or OFF
 */
+(void) setMode:(TracerMode) mode;

 
/**
 * Basic initialisaiton for App tracer
 */
+(void) setLogType:(NSInteger) logType;

/**
 * Trace API Requests
 */
+(void) traceAPI :   (TracerAPIModel*) traceAPIModel ;

/**
 * Trace Load Time
 */

+(void) traceStartTime:(NSString*) identifier;
+(void) traceEndTime:(NSString*) identifier;
+(void) clearLoadTime:(NSString*) identifier;

/**
 * Trace Crashes and Exceptions
 */
+(void) traceExceptionsAndCrashes:(TracerExceptionModel*) tracerExceptionModel;

@end
