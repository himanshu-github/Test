//
//  NGServerErrorDataModel.m
//  NaukriGulf
//
//  Created by Himanshu on 5/9/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGServerErrorDataModel.h"
#import "NGNetworkInfo.h"

@implementation NGServerErrorDataModel
- (id)init{
    self = [super init];
    if (self) {
        NGNetworkInfo *netInfoObj = [NGNetworkInfo new];
        _serverErrorSignalType = netInfoObj.type;
        _serverErrorSignalStrength = netInfoObj.strength;
        _serverExceptionTimeStamp = [NSDate date];

    }
    return self;
}

@end
