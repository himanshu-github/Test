//
//  JDTableRowController.h
//  NaukriGulf
//
//  Created by Arun on 9/28/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>


@protocol RecoTableRowControllerDelegate<NSObject>

-(void)unSaveClicked:(NSInteger)index;
-(void)saveClicked:(NSInteger)index;
-(void)applyClickedAtIndex:(NSInteger)index;
-(void)loadMoreTapped:(NSInteger)index;

@end


@interface RecoTableRowController : NSObject


@property (nonatomic, strong) NSMutableDictionary* dictInfo;

@property(nonatomic, weak) id<RecoTableRowControllerDelegate>delegate;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imgSpinner;
@property(nonatomic) NSInteger iTag;

-(void)configureRecoCell:(NSDictionary*)dictJob forIndex:(NSInteger)index;

-(void)configureRecoCellForApply;
-(void)configureRecoForAlreadyApplied;
-(void)configureRecoForSaving;
-(void)configureRecoForAlreadySaved;
-(void)configureRecoForUnsaving;
-(void)configureRecoForSave;
-(void)configureRecoCellForLoadMore;
-(void)configureRecoCellForShowingLoadMore;
-(void)hideLoader:(NSDictionary*)dictJob forIndex:(NSInteger)index;

@end
