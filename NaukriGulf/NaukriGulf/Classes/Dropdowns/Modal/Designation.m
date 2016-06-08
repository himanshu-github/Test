//
//  Designation.m
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//

#import "Designation.h"
#import "FAMapped.h"

@implementation Designation

// Insert code here to add functionality to your managed object subclass
+(Designation*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    Designation *obj = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Designation"
                      inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"Designation"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
    obj.sortedID = [dict objectForKey:@"Frequency"];
    obj.headerName = @"Designation";
    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
}

+(void)updateDataFromTextFile
{
    NSManagedObjectContext *temporaryContext = [NGDatabaseHelper privateMoc];
    
    [temporaryContext performBlockAndWait:^
     {
         NSError* error = nil;
         NSArray *arr = [NGStaticContentManager getNewDropDownData:DDC_DESIGNATION];
         for(NSDictionary *dict in arr)
         {
    
             Designation *desigObj = (Designation *)[Designation localObjectWithDict:dict andContext:temporaryContext];
             NSString *sortedFA_ID = @"";

             
             NSMutableArray *faMappedArr = [NSMutableArray array];
             if([[dict objectForKey:@"id1"] intValue]){
                 [faMappedArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"FA1"],@"FA",[dict objectForKey:@"id1"],@"id",[NSNumber numberWithInt:1],@"sortedID" ,nil]];
                 sortedFA_ID = [sortedFA_ID stringByAppendingString:sortedFA_ID.length>0?[NSString stringWithFormat:@",%@",[[dict objectForKey:@"id1"] stringValue]]:[[dict objectForKey:@"id1"] stringValue]];

             }
             if([[dict objectForKey:@"id2"] intValue]){
                 [faMappedArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"FA2"],@"FA",[dict objectForKey:@"id2"],@"id",[NSNumber numberWithInt:2],@"sortedID" , nil]];
                 sortedFA_ID = [sortedFA_ID stringByAppendingString:sortedFA_ID.length>0?[NSString stringWithFormat:@",%@",[[dict objectForKey:@"id2"] stringValue]]:[[dict objectForKey:@"id2"] stringValue]];

             }
             if([[dict objectForKey:@"id3"] intValue]){
                 [faMappedArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"FA3"],@"FA",[dict objectForKey:@"id3"],@"id",[NSNumber numberWithInt:3],@"sortedID" , nil]];
                 sortedFA_ID = [sortedFA_ID stringByAppendingString:sortedFA_ID.length>0?[NSString stringWithFormat:@",%@",[[dict objectForKey:@"id3"] stringValue]]:[[dict objectForKey:@"id3"] stringValue]];

             }
             desigObj.sortedFA_ID = sortedFA_ID;

             [desigObj addFamappings: [FAMapped famappings: faMappedArr andContext:temporaryContext]];
         }
         if (![temporaryContext save:&error]){
             NGServerErrorDataModel *sedm = [NGServerErrorDataModel new];
             sedm.serverExceptionErrorType =K_CORE_DATA_SAVE_EXCEPTION_ERROR;
             sedm.serverExceptionErrorTag = [NSString stringWithFormat:@"ENTITY: %@",NSStringFromClass([self class])];
             if(error.localizedDescription!=nil)
                 sedm.serverExceptionDescription = error.localizedDescription;
             else
                 sedm.serverExceptionDescription = @"NA";
             
             sedm.serverExceptionClassName = NSStringFromClass([self class]);
             sedm.serverExceptionMethodName = NSStringFromSelector(_cmd);
             sedm.serverErrorUserId = [NGSavedData getEmailID]?[NGSavedData getEmailID]:@"NA";

             [NGExceptionHandler logServerError:sedm];

         
         }
         else
             [NGStaticDDCoreDataLayer saveDataContext];
     }];
}


@end
