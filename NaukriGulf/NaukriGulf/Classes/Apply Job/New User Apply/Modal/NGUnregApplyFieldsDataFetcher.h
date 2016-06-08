//
//  NGUnregApplyFieldsDataFetcher.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/28/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGLocalDataFetcher.h"
@interface NGUnregApplyFieldsDataFetcher : NGLocalDataFetcher

-(void)saveApplyFields:(NGApplyFieldsModel*)modalFieldObj;
-(NGApplyFieldsModel*)getApplyFields;

@end
