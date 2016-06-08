//
//  DDBaseIndepenndent.h
//  NaukriGulf
//
//  Created by Ayush Goel on 08/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>


@interface DDBase: NSManagedObject

@property (nonatomic, retain) NSString * valueName;
@property (nonatomic, retain) NSNumber * valueID;
@property (nonatomic, retain) NSNumber * selectionLimit;
@property (nonatomic, retain) NSString * headerName;
@property (nonatomic, retain) NSNumber * sortedID;
@property (nonatomic, retain) NSString * descriptionText;

+(void)updateDataFromTextFile;
+(void)updateDataFromTextFile:(int) ddType andContext:(NSManagedObjectContext *)context;
+(void)fetchDataFromServer:(NSDictionary *) modifiedDict;
+ (Class) classForDDType:(int)ddType;

+(void) insertSeverIndependentData:(NSArray *)responseArray forClass:(Class )className andContext:(NSManagedObjectContext *)context;
+(void) insertChildData:(NSArray *)childArray forChild:(Class )childClass andParent:(Class )parentClass andContext:(NSManagedObjectContext *)context;
-(NSString *) selectedValueID:(int) ddType;
+ (NSArray *)getValuesForSelectedIds:(NSArray *)selectedArr inContents:(NSArray *)dataArr;
+(NSMutableDictionary*)updateUNRegModel:(NSMutableDictionary *)dict havingType:(int)ddType;
+(NSMutableDictionary*)updateUNRegModel:(NSMutableDictionary *)dict havingType:(int)ddType inArray:(NSArray *)parentArray;
@end
