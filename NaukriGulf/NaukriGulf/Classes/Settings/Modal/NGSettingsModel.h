//
//  NGSettingsModel.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 07/11/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

@interface NGSettingsModel : JSONModel

@property (nonatomic, strong) NSNumber *localRecoInterval;
@property (nonatomic, strong) NSNumber *willShowCelebrationImage;
@property (nonatomic, strong) NSNumber *isLoggingEnabled;

-(void)setDropDownModifiedListFromDic:(NSDictionary*)paramDic;
@end
