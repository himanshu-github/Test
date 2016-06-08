//
//  NGLoader.h
//  NaukriGulf
//
//  Created by Arun Kumar on 11/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGLoader : UIView

@property (nonatomic, assign) BOOL isLoaderAvail;

-(void)showAnimation:(UIView *)shoWView;
-(void)hideAnimatior:(UIView *)showView;

@end
