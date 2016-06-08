//
//  WebDataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseLocalDataFetcher.h"
#import "NGMNJProfileModalClass.h"
/**
 *  The class used to fetch data from the local database.
 */

@interface NGLocalDataFetcher : BaseLocalDataFetcher


-(void)saveErrorForServer:(id)errorModal;
-(NSArray*)fetchSavedExceptions:(NSManagedObjectContext*) tempContext;
-(NSArray*)fetchSavedErrorsforServer:(NSManagedObjectContext*) tempContext;
- (void)deleteExceptions;
-(void)saveException:(NSException*)exception withTopController:(NSString*)controller;

@end
