//
//  WebDataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseDataFormatter.h"

/**
 *  The class works as a adaptor to convert data as a dictionary to xml/json format.
 */
@interface WebDataFormatter : BaseDataFormatter

/**
 *  This method is used to convert data as a dictionary to xml format.
 *
 *  @param paramsDict Represents the data to be converted.
 *
 *  @return Returns the converted data.
 */
-(NSString *)convertToXMLFromDict:(NSDictionary *)paramsDict;

/**
 *  This method is used to convert data as a dictionary to json format.
 *
 *  @param paramsDict Represents the data to be converted.
 *
 *  @return Returns the converted data.
 */
-(NSString *)convertToJSONFromDict:(NSDictionary *)paramsDict;

@end
