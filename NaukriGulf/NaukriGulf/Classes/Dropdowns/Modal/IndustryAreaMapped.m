//
//  IndustryAreaMapped.m
//  NGDDDropDown
//
//  Created by Himanshu on 4/11/16.
//  Copyright © 2016 Himanshu. All rights reserved.
//

#import "IndustryAreaMapped.h"
#import "CompanyName.h"

@implementation IndustryAreaMapped

// Insert code here to add functionality to your managed object subclass
+(IndustryAreaMapped*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IndustryAreaMapped" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"valueID==%@", [dict objectForKey:@"id"]];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    IndustryAreaMapped *obj = nil;
    if(fetchedObjects.count==1)
        obj = fetchedObjects[0];
    
    if(obj == nil){
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"IndustryAreaMapped"
               inManagedObjectContext: context];
        
        obj.valueName = [dict objectForKey:@"IA"];
        obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
        obj.sortedID = [dict objectForKey:@"sortedID"];
        
        obj.headerName = @"Industry Type";
        obj.selectionLimit = [NSNumber numberWithInt:1];
    }
    return obj;
    
}


+(NSSet *) IAmappings:(NSArray *)faArray andContext:(NSManagedObjectContext *)context
{
    NSMutableSet *faSet = [NSMutableSet new];
    for(NSDictionary *dict in faArray)
    {
        IndustryAreaMapped *cityObj = (IndustryAreaMapped *)[IndustryAreaMapped localObjectWithDict:dict andContext:context];
        [faSet addObject:cityObj];
    }
    return faSet;
}

@end
