//
//  NGDropDownCoreData.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DropDown.h"
#import "DDCountry.h"
#import "DDPPGCourse.h"
#import "DDPGCourse.h"
#import "DDUGCourse.h"
#import "Designation+CoreDataProperties.h"
#import "FAMapped+CoreDataProperties.h"
#import "IndustryAreaMapped+CoreDataProperties.h"
#import "CompanyName+CoreDataProperties.h"



@implementation DropDown

@dynamic dropdownID;
@dynamic name;
@dynamic dependentClassName;
@dynamic serviceName;
@dynamic lastUpdated;
@dynamic parentName;
@dynamic serverData;

+(DropDown*)objectWithDict:(NSDictionary*)dict withContext:(NSManagedObjectContext*)context{
    
    DropDown *dropDownObj = [NSEntityDescription
                             insertNewObjectForEntityForName:NSStringFromClass([DropDown class])
                             inManagedObjectContext: context];
    
    dropDownObj.name = [dict objectForKey:@"name"];
    dropDownObj.serviceName = [dict objectForKey:@"serviceName"];
    dropDownObj.dependentClassName = [dict objectForKey:@"dependentClassName"];
    dropDownObj.parentName = [dict objectForKey:@"parentName"];
    dropDownObj.lastUpdated = [NSDate date];
    dropDownObj.serverData = nil;
    return dropDownObj;
    
}
+(void) createDropDownData
{
    NSArray *tempArray = [NGDatabaseHelper getAllClassData:[DropDown class]];
    NSManagedObjectContext *temporaryContext = [NGDatabaseHelper privateMoc];
    if (tempArray.count == 0)
    {
        [temporaryContext performBlockAndWait:^
         {
             NSError* error = nil;
             NSArray* allKeys = [NGConfigUtility getAppDropDownArray];
             int count = 0;
             for (NSDictionary* dict in allKeys)
             {
                 DropDown *dropDownObj = [DropDown objectWithDict:dict withContext:temporaryContext];
                 dropDownObj.dropdownID = [NSNumber numberWithInt:count];
                 Class theClass = NSClassFromString(dropDownObj.name);
                 if([theClass isSubclassOfClass:[DDBase class]])
                     [theClass updateDataFromTextFile:count andContext:temporaryContext];
                 count++;
             }
             if ([temporaryContext save:&error])
                 [NGDropDownModel saveDataContext];
         }];
        
        [DDCountry updateDataFromTextFile];
        [DDUGCourse updateDataFromTextFile];
        [DDPGCourse updateDataFromTextFile];
        [DDPPGCourse updateDataFromTextFile];
        
        [Designation updateDataFromTextFile];
        [CompanyName updateDataFromTextFile];
        
        
        [NGDropDownModel saveDataContext];
    }
}
+(void) updateDropDownData
{
    
    /*
    NSArray *tempArray = [DropDown dropDownServerData];
    NSMutableArray *updateArray = [[NSMutableArray alloc]initWithCapacity:tempArray.count];
    if(tempArray.count!=0)
    {
        NSManagedObjectContext *temporaryContext = [NGDatabaseHelper privateMoc];
        [temporaryContext performBlockAndWait:^
         {
         NSError* error = nil;
         for(DropDown *dropdownObj in tempArray)
         {
                if([dropdownObj.parentName isEqualToString:@""])
                {
                    Class parentClass = NSClassFromString(dropdownObj.name);
                    [NGDatabaseHelper emptyTable:parentClass andContext:temporaryContext];
                    [DDBase insertSeverIndependentData:dropdownObj.serverData forClass:parentClass andContext:temporaryContext];
                    dropdownObj.serverData =nil;
                    [updateArray addObject:dropdownObj.dropdownID];
                    if(![dropdownObj.dependentClassName isEqualToString:@""])
                    {
                        DropDown *childObj = [DropDown dropDownObjectonClassName:dropdownObj.dependentClassName];
                        Class childClass = NSClassFromString(childObj.name);
                        [DDBase insertChildData:childObj.serverData forChild:childClass andParent:parentClass andContext:temporaryContext];
                        childObj.serverData =nil;
                        [updateArray addObject:childObj.dropdownID];

                    }
                }
                else if(dropdownObj.serverData!=nil)
                {
                    Class childClass = NSClassFromString(dropdownObj.name);
                    DropDown *parentObj = [DropDown dropDownObjectonServiceName:dropdownObj.parentName];
                    if(parentObj.serverData == nil)
                    {
                        [NGDatabaseHelper emptyTable:childClass andContext:temporaryContext];
                        Class parentClass = NSClassFromString(parentObj.name);
                       [DDBase insertChildData:dropdownObj.serverData forChild:childClass andParent:parentClass andContext:temporaryContext];
                        dropdownObj.serverData =nil;
                        [updateArray addObject:dropdownObj.dropdownID];

                    }
                }
         }
         if ([temporaryContext save:&error])
         {
             [NGDropDownModel saveDataContext];
            NSDictionary* dictToPass= [NSDictionary dictionaryWithObject:updateArray
                                         forKey:@"updated_dropdown"];
             [[NSNotificationCenter defaultCenter] postNotificationName:DropDownServerUpdate object:nil userInfo:dictToPass];
             [NGApplyFieldsCoreData updateUnregApplyCoreDataFields:dictToPass];
             [updateArray removeAllObjects];
         }
     }];
    }
     */
}


-(void) saveServerData:(NSArray *)dataArray time:(NSString *)time
{
    NSDate *ldate = [NGDateManager UTCDateFromString:time WithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    if(ldate!=nil)
        self.lastUpdated = ldate;
    if(dataArray.count!=0)
        self.serverData = dataArray;
}

+(DropDown *) dropDownObjectonServiceName:(NSString *)serviceName
{
    NSManagedObjectContext *temporaryContext =  [NGDatabaseHelper privateMoc];
    __block NSArray *allObjects =[NSArray array];
    [temporaryContext performBlockAndWait:^{
        NSManagedObjectContext *context =  [[NGDropDownModel sharedInstance] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([DropDown class]) inManagedObjectContext:context];
        if(entity!=nil)
        {
            NSPredicate* myPredicate = [NSPredicate predicateWithFormat:@"serviceName == %@",serviceName];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:myPredicate];
            NSError *error;
            allObjects =  [context executeFetchRequest:fetchRequest error:&error];
        }
    }];
    return [allObjects firstObject];
}

+(DropDown *) dropDownObjectonClassName:(NSString *)className
{
    
    NSManagedObjectContext *temporaryContext =  [NGDatabaseHelper privateMoc];
    __block NSArray *allObjects =[NSArray array];
    [temporaryContext performBlockAndWait:^{
        NSManagedObjectContext *context =  [[NGDropDownModel sharedInstance] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([DropDown class]) inManagedObjectContext:context];
        if(entity!=nil)
        {
            NSPredicate* myPredicate = [NSPredicate predicateWithFormat:@"name == %@",className];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:myPredicate];
            NSError *error;
            allObjects =  [context executeFetchRequest:fetchRequest error:&error];
        }
    }];
    return [allObjects firstObject];
}

+(NSArray *) dropDownServerData
{
    NSManagedObjectContext *temporaryContext =  [NGDatabaseHelper privateMoc];
    __block NSArray *allObjects =[NSArray array];
    [temporaryContext performBlockAndWait:^{
        NSManagedObjectContext *context =  [[NGDropDownModel sharedInstance] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([DropDown class]) inManagedObjectContext:context];
        if(entity!=nil)
        {
            NSPredicate* myPredicate = [NSPredicate predicateWithFormat:@"serverData != %@",nil];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:myPredicate];
            NSError *error;
            allObjects =  [context executeFetchRequest:fetchRequest error:&error];
        }
    }];
    return allObjects;
}

@end
