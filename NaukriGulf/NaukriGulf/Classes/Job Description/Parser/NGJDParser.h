//
//  NGJDParser.h
//  NaukriGulf
//
//  Created by Arun Kumar on 16/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseDataParser.h"

@interface NGJDParser : BaseDataParser

-(NSDictionary*)parseResponseData:(NSDictionary *)dataDict;


@end
