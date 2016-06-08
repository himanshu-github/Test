//
//  NGCriticalSectionHelper.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 8/21/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGCriticalSectionHelper : NSObject

-(NSMutableArray*)configureSectionsArr;
+(NGCriticalSectionHelper *)sharedInstance;
-(NSMutableArray*) orderProfileSectionArray : (NSArray*) arr ;

@end
