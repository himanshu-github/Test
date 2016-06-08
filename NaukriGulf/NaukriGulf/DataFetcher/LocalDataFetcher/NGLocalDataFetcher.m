//
//  WebDataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGLocalDataFetcher.h"
#import "JobDetailsCoreData.h"
#import "ProfileViewCoreData.h"
#import "NGMNJProfileCoreData.h"
#import "NGExceptionCoreData.h"
#import "NGServerErrorCoreData.h"
#import "NGServerErrorDataModel.h"

@implementation NGLocalDataFetcher


#pragma mark - Error Logging
-(void)saveException:(NSException*)exception withTopController:(NSString*)controller{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];


    [temporaryContext performBlockAndWait:^{
        
        NSError *error = nil;
        NSArray* allExceptions = [self fetchSavedExceptions:temporaryContext];
        if(allExceptions.count == 10)
            return;
    
        
        NSArray* stackTrace = [[exception callStackSymbols] subarrayWithRange:NSMakeRange(0, 10)];
        NSString*stackTraceStr = [NSString getStringsFromArray:stackTrace];
        if(controller)
            stackTraceStr = [stackTraceStr stringByAppendingString:[NSString stringWithFormat:@" TopVC %@",controller]];
        
        NGExceptionCoreData* exceptionObj = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_EXCEPTION   inManagedObjectContext: temporaryContext];
        exceptionObj.exceptionName = exception.name;
        exceptionObj.exceptionDebugDescription = [NSString stringWithFormat:@"%@ #Trace: %@",
                                                  exception.description,stackTraceStr];
      
        exceptionObj.timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
        
        exceptionObj.exceptionTag = controller;
        exceptionObj.exceptionType = K_CRASH_ERROR;
        
        if (![temporaryContext save:&error]) {
            
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([NGExceptionCoreData class])];
            if(error.localizedDescription!=nil)
                sedm.serverExceptionDescription = error.localizedDescription;
            else
                sedm.serverExceptionDescription = @"NA";
            
            sedm.serverExceptionClassName = NSStringFromClass([self class]);
            sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
            sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

            [NGExceptionHandler logServerError:sedm];

  
        }else{
            
            [self saveMainContext];
            
        }
        [NGCoreDataHelper saveDataContext];
        
    }];
    
}

//NOTE:Core data context relevant to this data corrected.
//As per team discussion
-(NSArray*)fetchSavedExceptions:(NSManagedObjectContext*) tempContext{
    
    if (tempContext == nil) {
        if(self.context==nil)
            tempContext = [self privateMoc];
        else
        tempContext = self.context;
    }
    __block NSArray *exceptions;
    [tempContext performBlockAndWait:^{
  
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_EXCEPTION];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        exceptions = [[NSArray alloc] initWithArray:[tempContext executeFetchRequest:fetchRequest error:nil]];
    }];
    
    return exceptions ;
}

- (void)saveErrorForServer:(NGServerErrorDataModel*)errorModal{
    
    NSManagedObjectContext *temporaryContext = [self privateMoc];
        
    [temporaryContext performBlockAndWait:^{
        
        NSError *error = nil;
        NSArray* allErrorsForServer = [self fetchSavedErrorsforServer:temporaryContext];
        if(allErrorsForServer.count == 10)
            return;
        
        NGServerErrorCoreData* errorReportingObj = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_ERRORS_FOR_SERVER inManagedObjectContext: temporaryContext];
        errorReportingObj.errorType  = errorModal.serverExceptionErrorType;
        errorReportingObj.errorTag  = errorModal.serverExceptionErrorTag;
        errorReportingObj.errorName  = errorModal.serverExceptionErrorTag;

        errorReportingObj.errorDesription = errorModal.serverExceptionDescription;
        errorReportingObj.timeStamp =[NSString stringWithFormat:@"%f",[errorModal.serverExceptionTimeStamp timeIntervalSince1970]];
        errorReportingObj.errorMethodName = errorModal.serverExceptionMethodName;
        errorReportingObj.errorClassName = errorModal.serverExceptionClassName;

        errorReportingObj.errorSignalType = errorModal.serverErrorSignalType;
        errorReportingObj.errorSingleStrength = errorModal.serverErrorSignalStrength;

        errorReportingObj.errorUserId = errorModal.serverErrorUserId;
        
        if (![temporaryContext save:&error]) {
            
            
            NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
            sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
            sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([NGServerErrorCoreData class])];
            if(error.localizedDescription!=nil)
            sedm.serverExceptionDescription = error.localizedDescription;
            else
            sedm.serverExceptionDescription = @"NA";
            
            sedm.serverExceptionClassName = NSStringFromClass([self class]);
            sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
            sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

            
            [NGExceptionHandler logServerError:sedm];
           
        }else{
            [self saveMainContext];
        }

    }];
    
    
}
//NOTE:Core data context relevant to this data corrected.
//As per team discussion
-(NSArray*)fetchSavedErrorsforServer:(NSManagedObjectContext*) tempContext{
    
    if (tempContext == nil) {
        if(self.context==nil)
            tempContext = [self privateMoc];
        else
            tempContext = self.context;
    }


    __block NSArray *exceptions = nil;
    
    [tempContext performBlockAndWait:^{
    
        NSEntityDescription *entity = [self initialiseCoreDataOperation:ENTITY_ERRORS_FOR_SERVER];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        exceptions = [[NSArray alloc] initWithArray:[tempContext executeFetchRequest:fetchRequest error:nil]];

    }];
    
    
    return exceptions;
}

- (void)deleteExceptions{
    
    //NOTE:Core data context relevant to this data corrected.
    //As per team discussion
    NSManagedObjectContext *temporaryContext = [self privateMoc];
    
    [temporaryContext performBlockAndWait:^{
  
        //NOTE:Code updated with try/catch block only as per discussion with team.
        @try {
            NSError *error = nil;
            
            NSArray* allExceptions = [self fetchSavedExceptions:temporaryContext];
            
            for (NGExceptionCoreData* exception in allExceptions){
                if (exception) {
                    [temporaryContext deleteObject:exception];
                }
                
            }
            
            NSArray* allErrorsForServer = [self fetchSavedErrorsforServer:temporaryContext];
            for (NGServerErrorCoreData* errorServer in allErrorsForServer){
                if (errorServer) {
                    [temporaryContext deleteObject:errorServer];
                }
                
            }
            
            
            if (![temporaryContext save:&error]) {
                NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
                sedm.serverExceptionErrorType = K_CORE_DATA_SAVE_EXCEPTION_ERROR;
                sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([NGExceptionCoreData class])];
                if(error.localizedDescription!=nil)
                    sedm.serverExceptionDescription = error.localizedDescription;
                else
                    sedm.serverExceptionDescription = @"NA";
                
                sedm.serverExceptionClassName = NSStringFromClass([self class]);
                sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
                sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

                [NGExceptionHandler logServerError:sedm];

               
            }else{
                
                [self saveMainContext];
            }
        }
        @catch (NSException *exception) {
            
        }
    }];
}


@end
