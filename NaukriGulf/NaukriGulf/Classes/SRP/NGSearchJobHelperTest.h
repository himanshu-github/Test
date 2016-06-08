//
//  NGSearchJobHelperTest.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGSearchJobHelperTest : NSObject

+(instancetype)sharedInstance;
-(NSInteger)jobDownloadLimitForTest;
-(void)fetchNonAppliedJDWithHandler:(void(^)(NGJobDetails * jobDetail))completionHandler;
-(void)fetchAppliedJDWithHandler:(void(^)(NGJobDetails* jobDetail))completionHandler;
-(void)fetchJDWithHandler:(void(^)(NGJobDetailModel* jobDetailModel))completionHandler;
-(void)fetchJDWithParams:(NSMutableDictionary*)params AndHandler:(void(^)(NGJobDetailModel* jobDetailModel))completionHandler;
@end
