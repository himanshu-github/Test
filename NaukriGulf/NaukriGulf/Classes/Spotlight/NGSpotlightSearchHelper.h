//
//  NGSpotlightSearchHelper.h
//  NaukriGulf
//
//  Created by Arun on 11/18/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGSpotLightModel.h"

NS_ENUM(NSUInteger, NGSpotlightPage){
    NGSpotlightPageNone,
    NGSpotlightPageSRP,
    NGSpotlightPageJD
};

NS_ENUM(NSUInteger, NGSpotlightAppState){
    NGSpotlightAppStateNone,
    NGSpotlightAppStateLaunch,
    NGSpotlightAppStateBackground
};

@interface NGSpotlightSearchHelper : NSObject

+(NGSpotlightSearchHelper *)sharedInstance;

@property(nonatomic,strong) NSUserActivity* spotlightUserActivity;
@property(nonatomic,readwrite) enum NGSpotlightPage spotlightAppPage;
@property(nonatomic,readwrite) enum NGSpotlightAppState spotlightAppState;
@property(nonatomic) BOOL isComingFromSpotlightSearch;


-(void)handleSpotlightItemClick;
-(void)setSpotlightConfigFromLaunchOption:(NSDictionary*)paramLaunchOption;

-(void)setDataOnSpotlightWithModel:(NGSpotLightModel*)model;
-(NGSpotLightModel*)getSpotlightModelForVC:(SPOTLIGHT_PAGES)pageId withModel:(id)param;

@end
