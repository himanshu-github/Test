//
//  NGShortCutHandler.h
//  NaukriGulf
//
//  Created by Himanshu on 2/3/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGShortCutHandler : NSObject
@property(nonatomic,strong)NSString *shotcutIdentifier;
+(NGShortCutHandler *)sharedInstance;
-(void)handleShortcutWithIdentifier:(NSString *)shortcutType;
-(void)navigateToScreensAccordingToIdentifier;
@end

