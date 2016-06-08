//
//  DataFormatter.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseAPICaller.h"

@implementation BaseAPICaller

-(id)init{
    if (self=[super init]) {
        
    }
    
    return self;
}

-(void)getDataWithParams:(APIRequestModal *)requestParams
                 handler:(void(^)(NGAPIResponseModal * responseInfo))completionHandler{
    
}


@end
