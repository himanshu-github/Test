//
//  NGDatabaseHelper.h
//  NaukriGulf
//
//  Created by Ayush Goel on 17/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGDatabaseHelper : NSObject


+(NSArray *)getAllClassData:(Class) myClass;
+(NSArray*)getAllSortedData:(Class) myClass;
+(BOOL)emptyTable:(Class) myClass andContext:(NSManagedObjectContext *)context;
+(NSArray*)searchForType:(NSString*)type  havingValue:(NSString*)value
                                                andClass:(Class) myClass;
+(NSArray*)searchForType:(NSString*)type  havingValue:(NSString*)value
                                                andDDType:(int)ddType;
+(NSArray*)searchForType:(NSString*)type  havingValue:(NSString*)value
                 inArray:(NSArray *)dataArray andDDType:(int)ddType;
+(NSArray*)getAllDDData:(int) ddType;
+(NSArray *)sortArray:(NSString *)key onArray:(NSArray *)resultArray;
+(NSArray*)getSortedDataWhereKey:(NSString*)keyName andClass:(Class) myClass;
+(NSManagedObjectContext*)privateMoc;
+(NSArray*)sortEducationSpec:(NSString *)key onArray:(NSArray *)resultArray;
+(NSArray*)sortCountryCityForSuggestor:(NSString*)key onArray:(NSArray*)resultArray;
+ (void)decodeUTFDict:(NSMutableDictionary *)dict keyStack:(NSArray *)keys;
+ (void)encodeURLDict:(NSMutableDictionary *)dict keyStack:(NSArray *)keys;
+(NSArray*)sortArrayOfCountryCityWithOtherListAtEnd:(NSString *)key onArray:(NSArray *)resultArray;

@end
