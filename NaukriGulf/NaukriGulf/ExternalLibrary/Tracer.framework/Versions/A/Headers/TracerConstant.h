//
//  TracerConstant.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#ifndef NaukriGulf_TracerConstant_h
#define NaukriGulf_TracerConstant_h

#define PAGE_LOAD_THRESHOLD 10

//NS_OPTIONS are used for bitwise operation

typedef enum{
    ON = 0,
    OFF
}TracerMode;

typedef NS_OPTIONS(NSInteger, Trace) {
    TraceLoadTime = 1 << 0, // bits: 0001
    TraceApi = 1 << 1, // bits: 0010
    TraceCrashesAndExceptions = 1 << 2 // 0100
};


//DIRECTORY AND FILE STRUCTURE NAMES

#define TRACER_DOC_DIRECTORY_FOLDER_NAME @"Tracer Logs"
#define TRACER_DOC_DIRECTORY_API_LOGS @"API Logs"
#define TRACER_DOC_DIRECTORY_CRASHES_AND_EXCEPTION @"Crashes And Exceptions"
#define TRACER_DOC_DIRECTORY_PAGE_LOAD_FILE_NAME @"Load Times"

#endif
