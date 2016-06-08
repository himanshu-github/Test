//
//  CompanyName.m
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//

#import "CompanyName.h"
#import "IndustryAreaMapped.h"

@implementation CompanyName

// Insert code here to add functionality to your managed object subclass
+(CompanyName*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    CompanyName *obj = [NSEntityDescription
                        insertNewObjectForEntityForName:@"CompanyName"
                        inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"Company"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
    obj.sortedID = [dict objectForKey:@"Frequency"];
    obj.headerName = @"Company";
    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
}

+(void)updateDataFromTextFile
{
    NSManagedObjectContext *temporaryContext = [NGDatabaseHelper privateMoc];
    
    [temporaryContext performBlockAndWait:^
     {
         NSError* error = nil;
         NSArray *arr = [NGStaticContentManager getNewDropDownData:DDC_COMPANY];
         for(NSDictionary *dict in arr)
         {
             
             CompanyName *compObj = (CompanyName *)[CompanyName localObjectWithDict:dict andContext:temporaryContext];
             NSString *sortedIA_ID = @"";
             
             NSMutableArray *iAMappedArr = [NSMutableArray array];
             if([[dict objectForKey:@"id1"] intValue]){
                 [iAMappedArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"IA1"],@"IA",[dict objectForKey:@"id1"],@"id",[NSNumber numberWithInt:1],@"sortedID", nil]];
                 sortedIA_ID = [sortedIA_ID stringByAppendingString:sortedIA_ID.length>0?[NSString stringWithFormat:@",%@",[[dict objectForKey:@"id1"] stringValue]]:[[dict objectForKey:@"id1"] stringValue]];

             }
             if([[dict objectForKey:@"id2"] intValue]){
                 [iAMappedArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"IA2"],@"IA",[dict objectForKey:@"id2"],@"id",[NSNumber numberWithInt:2],@"sortedID",nil]];
                 sortedIA_ID = [sortedIA_ID stringByAppendingString:sortedIA_ID.length>0?[NSString stringWithFormat:@",%@",[[dict objectForKey:@"id2"] stringValue]]:[[dict objectForKey:@"id2"] stringValue]];

             }
             if([[dict objectForKey:@"id3"] intValue]){
                 [iAMappedArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"IA3"],@"IA",[dict objectForKey:@"id3"],@"id",[NSNumber numberWithInt:3],@"sortedID", nil]];
                 sortedIA_ID = [sortedIA_ID stringByAppendingString:sortedIA_ID.length>0?[NSString stringWithFormat:@",%@",[[dict objectForKey:@"id3"] stringValue]]:[[dict objectForKey:@"id3"] stringValue]];

             }
             
             compObj.sortedIA_ID = sortedIA_ID;
            [compObj addIamappings: [IndustryAreaMapped IAmappings: iAMappedArr andContext:temporaryContext]];
         }
         if ([temporaryContext save:&error])
             [NGDropDownModel saveDataContext];
     }];
}

@end
