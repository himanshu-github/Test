//
//  BaseDataParser.h
//  NaukriGulf
//
//  Created by Arun Kumar on 10/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGAPIResponseModal.h"

/**
 *  Base Class of Data Parser. It is used to parse the data received locally or from the server.
 */
@interface BaseDataParser : NSObject

/**
 *  This method is used to parse the data received locally or from the server.
 *
 *  @param dataDict Represents the data received from the server.
 *
 *  @return Returns the data after parsing.
 */
-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict;
-(NSDictionary*)parseTextResponseData:(NSDictionary *)dataDict;

-(id)parseResponseDataFromServer:(NGAPIResponseModal *)dataDict;
-(id)parseErrorResponseDataFromServer:(NGAPIResponseModal *)dataDict;

@end
