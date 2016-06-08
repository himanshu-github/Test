//
//  DataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Base class of DataFormatter. It works as a adaptor to convert data as a dictionary to xml/json format.
 */
@interface BaseDataFormatter : NSObject

/**
 *  This method is used to convert data as a dictionary to xml/json format.
 *
 *  @param paramsDict Represents the data to be converted.
 *
 *  @return Returns the converted data.
 */
-(id)convertFromDict:(NSDictionary *)paramsDict;

@end
