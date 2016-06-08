//
//  WebDataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseFileDataFetcher.h"

/**
 *   The class used to fetch data from the file like .txt .
 */
@interface NGFileDataFetcher : BaseFileDataFetcher

/**
 *  This method is used to get data from the file like .txt .
 *
 *  @param fileName Denotes the name of file from which data is to be fetched.
 *
 *  @return Returns the fetched data.
 */
-(NSString *)getDataFromFile:(NSString *)fileName;

@end
