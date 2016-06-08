//
//  NGGoogleLoginParser.h
//  NaukriGulf
//
//  Created by Himanshu on 3/16/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGGoogleLoginParser : NSObject
+(NGResmanDataModel*)parseTheGoogleData:(NSDictionary*)userDictionary inResmanModel:(NGResmanDataModel*)resmanModel;

@end
