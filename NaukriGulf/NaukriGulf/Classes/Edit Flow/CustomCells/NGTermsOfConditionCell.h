//
//  NGTermsOfConditionCell.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/3/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//


@protocol TermsOfConditionDelegate <NSObject>

-(void) tocClicked;

@end
@interface NGTermsOfConditionCell : NGCustomValidationCell

@property(nonatomic,weak) id <TermsOfConditionDelegate> delegate;
@property(nonatomic,readwrite) int index;
@end
