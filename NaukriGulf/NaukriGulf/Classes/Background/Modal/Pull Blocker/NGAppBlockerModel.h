//
//  NGAppBlockerModel.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

@interface NGAppBlockerModel : JSONModel
@property (nonatomic, strong)NSString *appMinVersion;
@property (nonatomic, strong)NSString *appNewVersion;
@property (nonatomic) enum AppBlockerFlag flag;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)NSString *href;


@end
