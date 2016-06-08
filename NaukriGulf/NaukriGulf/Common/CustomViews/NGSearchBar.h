//
//  NGSearchBar.h
//  NaukriGulf
//
//  Created by Arun Kumar on 7/3/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NGSearchBarDelegate <NSObject>

-(void)didBeginSearch:(NSString*)searchStr;
-(void)didEndSearch;

@end

@interface NGSearchBar : NSObject <UITextFieldDelegate>{
    
}

@property(nonatomic, weak) id<NGSearchBarDelegate> delegate;
@property(nonatomic, assign) BOOL bIsSearchModeOn;
@property(nonatomic, strong) UITextField *searchTextField;

-(void)addSearchBarOnView:(UIView*)viewToAdd;
-(void)addSearchBarOnClusteredView:(UIView*)viewToAdd;

@end

