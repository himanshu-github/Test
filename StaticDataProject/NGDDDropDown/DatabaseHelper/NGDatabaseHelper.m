//
//  NGDatabaseHelper.m
//  NaukriGulf
//
//  Created by Ayush Goel on 17/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGDatabaseHelper.h"
#import "NGDropDownModel.h"
#import "DDBase.h"
#import "NSDictionary+SetObject.h"
#import "NSString+Extra.h"



@implementation NGDatabaseHelper

+(NSManagedObjectContext*)privateMoc{
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [[NGDropDownModel sharedInstance] managedObjectContext];
    return temporaryContext;
}


+(NSArray *)getAllClassData:(Class) myClass
{
   
    NSManagedObjectContext *temporaryContext =  [NGDatabaseHelper privateMoc];
    __block NSArray *allObjects =[NSArray array];
    [temporaryContext performBlockAndWait:^{
        NSManagedObjectContext *context =  [[NGDropDownModel sharedInstance] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([myClass class])inManagedObjectContext:context];
        if(entity!=nil)
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            NSError *error;
            allObjects =  [context executeFetchRequest:fetchRequest error:&error];
        }
    }];
    return  allObjects;
}

+(NSArray*)getAllSortedData:(Class) myClass
{
    NSManagedObjectContext *temporaryContext =  [NGDatabaseHelper privateMoc];
    __block NSArray *allObjects =[NSArray array];
    [temporaryContext performBlockAndWait:^{
    NSManagedObjectContext *context =  [[NGDropDownModel sharedInstance] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([myClass class])inManagedObjectContext:context];
    if(entity!=nil)
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"valueID" ascending:YES];
            [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
            NSError *error;
            allObjects =  [context executeFetchRequest:fetchRequest error:&error];
        }
    }];
    return  allObjects;
}

+(BOOL)emptyTable:(Class) myClass  andContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([myClass class]) inManagedObjectContext:context];
    NSError *error = nil;
    if(entity!=nil)
    {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSArray *tempArr = [context executeFetchRequest:fetchRequest error:&error];
    for (id obj in tempArr)
        [context deleteObject:obj];
    }
    return YES;
}

+(NSArray*)searchForType:(NSString*)type  havingValue:(NSString*)value
                                            andClass:(Class) myClass
{
    NSManagedObjectContext *temporaryContext =  [NGDatabaseHelper privateMoc];
    __block NSArray *allObjects =[NSArray array];
    [temporaryContext performBlockAndWait:^{
        NSManagedObjectContext *context =  [[NGDropDownModel sharedInstance] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([myClass class]) inManagedObjectContext:context];
        
        if(entity!=nil)
        {
            NSPredicate* myPredicate;
            if ([type isEqualToString:KEY_VALUE])
                myPredicate = [NSPredicate predicateWithFormat:@"valueName ==[c] %@",value];
            else
                myPredicate = [NSPredicate predicateWithFormat:@"valueID ==[c] %@",value];

            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:myPredicate];
            NSError *error;
            allObjects = [context executeFetchRequest:fetchRequest error:&error];
        }
        
    }];
    return  allObjects;
}


+(NSArray*)searchForType:(NSString*)type  havingValue:(NSString*)value
                andClass:(Class) myClass inArray:(NSArray *)dataArray
{
    
    NSPredicate* myPredicate;
    if ([type isEqualToString:KEY_VALUE])
        myPredicate = [NSPredicate predicateWithFormat:@"self.valueName == %@",value];
    else
        myPredicate = [NSPredicate predicateWithFormat:@"self.valueID == %d",value.intValue];
    NSArray *result = [ dataArray filteredArrayUsingPredicate:myPredicate];
    return result;
}


+(NSArray*)getAllDDData:(int) ddType
{
    
    Class myclass =[DDBase classForDDType:ddType];
    if (myclass != nil) {
        
    switch (ddType) {
       
        case DDC_WORK_STATUS:
            return [NGDatabaseHelper getSortedDataWhereKey:DROPDOWN_VALUE_ID
                                                  andClass:myclass];
        case DDC_FAREA:
        case DDC_INDUSTRY_TYPE:
        case DDC_NOTICE_PERIOD:
        case DDC_WORK_LEVEL:
        case DDC_COUNTRY:
        case DDC_UGCOURSE:
        case DDC_PGCOURSE:
        case DDC_PPGCOURSE:
        case DDC_NATIONALITY:
        case DDC_PREFRENCE_LOCATION:
            
        case DDC_DESIGNATION:
        case DDC_COMPANY:

            return [NGDatabaseHelper getSortedDataWhereKey:DROPDOWN_SORTED_ID
                                                  andClass:myclass];
        case DDC_ALERT:{
            
            NSMutableArray* arrToReturn = [NSMutableArray array];
            NSArray* arrLocal = [NGDatabaseHelper getAllSortedData:myclass];
            for (int i = 0; i< arrLocal.count; i++) {
                DDBase* obj = arrLocal[i];

                if (i == arrLocal.count-1)
                    obj.descriptionText = @"It's recommended to keep these alerts ON. It is required for receiving matching Jobs";
                else
                    obj.descriptionText = @"";
                [arrToReturn addObject:obj];

            }
            return arrToReturn;
        }
            break;
        default:
           return [NGDatabaseHelper getAllSortedData:myclass];
     }
    }
    return [NSArray array];
}

+(NSArray*)searchForType:(NSString*)type  havingValue:(NSString*)value
               andDDType:(int)ddType
{
    Class myclass =[DDBase classForDDType:ddType];
    return [NGDatabaseHelper searchForType:type havingValue:value andClass:myclass];
}

+(NSArray*)searchForType:(NSString*)type  havingValue:(NSString*)value
               inArray:(NSArray *)dataArray andDDType:(int)ddType
{
    Class myclass =[DDBase classForDDType:ddType];
    return [NGDatabaseHelper searchForType:type havingValue:value andClass:myclass inArray:dataArray];
}

+(NSArray *)sortArray:(NSString *)key onArray:(NSArray *)resultArray
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]];
    return [resultArray sortedArrayUsingDescriptors:sortDescriptors];
}
+(NSArray*)sortArrayOfCountryCityWithOtherListAtEnd:(NSString *)key onArray:(NSArray *)resultArray{
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]];
    NSMutableArray *sortedArray= [NSMutableArray arrayWithArray:[resultArray sortedArrayUsingDescriptors:sortDescriptors]];
    NSArray *anyMatch = [sortedArray filteredArrayUsingPredicate:
                         [NSPredicate predicateWithFormat:
                          @"valueName CONTAINS[cd] 'other'"]];
    
    NSManagedObject *obj = [anyMatch firstObject];
    if(obj)
    {
        [sortedArray removeObject:obj];
        [sortedArray insertObject:obj atIndex:sortedArray.count];
    }
    
    return (NSArray *)sortedArray;
}

+(NSArray*)sortEducationSpec:(NSString *)key onArray:(NSArray *)resultArray{
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]];
    NSMutableArray *sortedArray= [NSMutableArray arrayWithArray:[resultArray sortedArrayUsingDescriptors:sortDescriptors]];
    NSArray *anyMatch = [sortedArray filteredArrayUsingPredicate:
                         [NSPredicate predicateWithFormat:
                          @"valueName CONTAINS[cd] 'other'"]];
    
    NSManagedObject *obj = [anyMatch firstObject];
    if(obj)
    {
        [sortedArray removeObject:obj];
        [sortedArray insertObject:obj atIndex:sortedArray.count];
    }
    
    return (NSArray *)sortedArray;
}

+(NSArray*)sortCountryCityForSuggestor:(NSString*)key onArray:(NSArray*)resultArray{
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]];
    NSMutableArray *sortedArray= [NSMutableArray arrayWithArray:[resultArray sortedArrayUsingDescriptors:sortDescriptors]];
    NSArray *anyMatch = [sortedArray filteredArrayUsingPredicate:
                         [NSPredicate predicateWithFormat:
                          @"valueName CONTAINS[cd] 'other'"]];
    
    NSManagedObject *obj = [anyMatch firstObject];
    if(obj)
        [sortedArray removeObject:obj];
    
    
    return (NSArray *)sortedArray;
}

+(NSArray*)getSortedDataWhereKey:(NSString*)keyName andClass:(Class) myClass
{
    NSManagedObjectContext *temporaryContext =  [NGDatabaseHelper privateMoc];
    __block NSArray *allObjects =[NSArray array];
    [temporaryContext performBlockAndWait:^{
        NSManagedObjectContext *context =  [[NGDropDownModel sharedInstance] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([myClass class])inManagedObjectContext:context];
        if(entity!=nil)
        {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:keyName ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
        NSError *error;
        allObjects =  [context executeFetchRequest:fetchRequest error:&error];
        }
    }];
    return allObjects;
}

+ (void)decodeUTFDict:(NSMutableDictionary *)dict keyStack:(NSArray *)keys{
    if (keys == nil) {
        keys = [NSArray array];
    }
    
    for (id key in dict.allKeys) {
        id value = dict[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self decodeUTFDict:value keyStack:[keys arrayByAddingObject:key]];
        } else {
            if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *arr = [NSMutableArray array];
                for (id val in value) {
                    if ([val isKindOfClass:[NSDictionary class]]) {
                        [self decodeUTFDict:val keyStack:[keys arrayByAddingObject:key]];
                    }else{
                        NSString *decodedValue = [NSString stringWithCString:[val cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
                        [arr addObject:decodedValue];
                        [dict setCustomObject:arr forKey:key];
                    }
                    
                }
            }else{
                NSString *decodedValue = [NSString stringWithCString:[value cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
                [dict setCustomObject:decodedValue forKey:key];
            }
            
            
        }
    }
}

+ (void)encodeURLDict:(NSMutableDictionary *)dict keyStack:(NSArray *)keys{
    if (keys == nil) {
        keys = [NSArray array];
    }
    
    for (id key in dict.allKeys) {
        id value = dict[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self encodeURLDict:value keyStack:[keys arrayByAddingObject:key]];
        } else {
            if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *arr = [NSMutableArray array];
                for (id val in value) {
                    if ([val isKindOfClass:[NSDictionary class]]) {
                        [self encodeURLDict:val keyStack:[keys arrayByAddingObject:key]];
                    }else if ([val isKindOfClass:[NSString class]]) {
                        NSString *encodedValue = [NSString encodeSpecialCharacter:val];
                        [arr addObject:encodedValue];
                        [dict setCustomObject:arr forKey:key];
                    }
                    
                }
            }else if ([value isKindOfClass:[NSString class]]){
                NSString *encodedValue = [NSString encodeSpecialCharacter:value];
                [dict setCustomObject:encodedValue forKey:key];
            }
            
        }
    }
}


#pragma mark-- my methods
+(NSString *)getDataFromFile:(NSString *)fileName{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    
    NSString* str=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    
    return str;
}


@end
