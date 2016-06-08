//
//  DDCountry.m
//  NaukriGulf
//
//  Created by Ayush Goel on 03/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//
#import "DDCountry.h"
#import "DDCity.h"


@implementation DDCountry

@dynamic cities;

+(DDCountry*)localObjectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    static int i = 0;
    DDCountry *obj = [NSEntityDescription
                             insertNewObjectForEntityForName:@"DDCountry"
                             inManagedObjectContext: context];
    
    obj.valueName = [dict objectForKey:@"CountryName"];
    obj.valueID = [NSNumber numberWithInt:[[dict objectForKey:@"CountryID"] intValue]];
    obj.sortedID = [NSNumber numberWithInt:i++];
    obj.headerName = @"Country";
    obj.selectionLimit = [NSNumber numberWithInt:1];
    return obj;
}

+(void)updateDataFromTextFile
{
    NSManagedObjectContext *temporaryContext = [NGDatabaseHelper privateMoc];
    
    [temporaryContext performBlockAndWait:^
    {
        NSError* error = nil;
        NSArray *arr = [NGStaticContentManager getNewDropDownData:DDC_COUNTRY];
        for(NSDictionary *dict in arr)
        {
            DDCountry *countryObj = (DDCountry *)[DDCountry localObjectWithDict:dict andContext:temporaryContext];
            [countryObj addCities: [DDCity cities: [dict objectForKey:@"CityList"] andContext:temporaryContext]];
        }
        if ([temporaryContext save:&error])
            [NGDropDownModel saveDataContext];
    }];
}


@end
