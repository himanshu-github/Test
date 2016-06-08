//
//  FAMapped.m
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//

#import "FAMapped.h"

@implementation FAMapped

// Insert code here to add functionality to your managed object subclass
+(FAMapped*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FAMapped" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"valueID==%@", [dict objectForKey:@"id"]];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    FAMapped *obj = nil;
    if(fetchedObjects.count==1)
        obj = fetchedObjects[0];
    
    if(obj == nil){
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"FAMapped"
               inManagedObjectContext: context];
        
        obj.valueName = [dict objectForKey:@"FA"];
        obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
        obj.headerName = @"Functional Area";
        obj.sortedID = [dict objectForKey:@"sortedID"];
        
        obj.selectionLimit = [NSNumber numberWithInt:1];
    }
    return obj;
}


+(NSSet *) famappings:(NSArray *)faArray andContext:(NSManagedObjectContext *)context
{
    NSMutableSet *faSet = [NSMutableSet new];
    for(NSDictionary *dict in faArray)
    {
        FAMapped *cityObj = (FAMapped *)[FAMapped localObjectWithDict:dict andContext:context];
        [faSet addObject:cityObj];
    }
    return faSet;
}

@end
