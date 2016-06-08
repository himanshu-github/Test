//
//  DDCity.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDCity.h"
#import "DDCountry.h"


@implementation DDCity


@dynamic country;

+(DDCity*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    DDCity *obj = [NSEntityDescription
                      insertNewObjectForEntityForName:@"DDCity"
                      inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"cityName"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"cityID"] intValue]];
    obj.headerName = @"City";
    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
    
}


+(NSSet *) cities:(NSArray *)cityArray andContext:(NSManagedObjectContext *)context
{
    NSMutableSet *citiesSet = [NSMutableSet new];
    for(NSDictionary *dict in cityArray)
    {
        DDCity *cityObj = (DDCity *)[DDCity localObjectWithDict:dict andContext:context];
        [citiesSet addObject:cityObj];
    }
    return citiesSet;
}


@end
