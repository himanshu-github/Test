//
//  NGSpotLightModel.h
//  NaukriGulf
//
//  Created by Himanshu on 1/6/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGSpotLightModel : NSObject
@property(nonatomic,strong) NSString *keywords;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *contentDescription;
@property(nonatomic,strong) NSString *spotlightId;
@property(nonatomic)SPOTLIGHT_PAGES page;

@end
