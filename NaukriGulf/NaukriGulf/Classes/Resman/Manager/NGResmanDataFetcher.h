//
//  NGResmanDataFetcher.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 1/14/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGLocalDataFetcher.h"
#import "NGResmanDataModel.h"
@interface NGResmanDataFetcher : NGLocalDataFetcher
-(void)saveResmanFields:(NGResmanDataModel*)modalFieldObj;
-(NGResmanDataModel*)getResmanFields;

@end
