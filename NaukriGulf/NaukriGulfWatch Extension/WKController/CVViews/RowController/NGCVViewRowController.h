//
//  NGCVViewRowController.h
//  NaukriGulf
//
//  Created by Himanshu on 2/7/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NGCVViewRowControllerDelegate<NSObject>
-(void)loadMoreTapped:(NSInteger)index;
@end

@interface NGCVViewRowController : NSObject

@property(nonatomic, weak) id<NGCVViewRowControllerDelegate>delegate;
-(void)configureCVViewCell:(NSDictionary*)dictJob forIndex:(NSInteger)index;
-(void)configureCVViewCellForLoadMore;
-(void)configureCVForShowingLoadMore;
@property(nonatomic) NSInteger iTag;

@end
