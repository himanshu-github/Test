//
//  DataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Base Class of Local Data Fetcher. It is used to fetch data from the local database.
 */
@interface BaseLocalDataFetcher : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

/**
 *  This method is used to make settings of core data required for specific entity.
 *
 *  @param entityName Denotes the name of entity for which core data settings is required.
 *
 *  @return Returns the NSEntityDescription object.
 */
- (NSEntityDescription *) initialiseCoreDataOperation : (NSString *) entityName;
-(NSManagedObjectContext*)privateMoc;
-(void)saveMainContext;

@end
