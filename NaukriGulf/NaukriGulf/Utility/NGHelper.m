//
//  NGHelper.m
//  NaukriGulf
//
//  Created by Arun Kumar on 05/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGHelper.h"


@interface NGHelper ()
@end

@implementation NGHelper

static NGHelper *singleton;

+(NGHelper *)sharedInstance
{
    @synchronized(self)
    {
        if (singleton==nil){
            singleton = [[NGHelper alloc]init];
        }
        
    }
    
    return singleton;
}

-(id)init{
    
    if (self=[super init]) {
        self.appConfigDict = [NGConfigUtility getAppConfigDictionary];
        self.appStateConfigArr = [NGConfigUtility getAppStateConfigDictionary];
        _valueSelectionLayerArray = [[NSMutableArray alloc] init];
        [self createStoryboards];
        _isAlertShowing = FALSE;
        self.serverSettingsRunning = NO;
    }
    
    return self;
}

-(void) createStoryboards {
    
    self.jobSearchstoryboard = [UIStoryboard storyboardWithName:STORYBOARD_JOB_SEARCH bundle:[NSBundle mainBundle]];
    
    self.genericStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_GENERIC_COMPONENT bundle:[NSBundle mainBundle]];
    
    self.jobsForYouStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_JOBS_FOR_YOU bundle:[NSBundle mainBundle]];
    
    self.othersStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_OTHERS bundle:[NSBundle mainBundle]];
    
    self.editFlowStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_EDIT bundle:[NSBundle mainBundle]];
    
    self.mNJStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_MNJ bundle:[NSBundle mainBundle]];
    
    self.profileStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_PROFILE bundle:[NSBundle mainBundle]];
}

-(void) serverSettingsISRunning
{
    self.serverSettingsRunning = YES;
    [self performSelector:@selector(resetSettingsFlag) withObject:nil afterDelay:10.0f];
}

-(void) resetSettingsFlag
{
    self.serverSettingsRunning = NO;
   
}

@end
