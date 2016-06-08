//
//  DataManagerFactory.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "DataManagerFactory.h"

@implementation DataManagerFactory


+(NGStaticContentManager *)getStaticContentManager{
    return [[NGStaticContentManager alloc]init];
}

+(NGWebDataManager *)getWebDataManagerWithServiceType:(NSInteger)serviceType{
    return [[NGWebDataManager alloc]initWithServiceType:serviceType];
}

@end
