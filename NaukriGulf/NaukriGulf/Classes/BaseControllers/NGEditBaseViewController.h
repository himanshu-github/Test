//
//  NGEditBaseViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditResuableTableViewController.h"
#import "NGProfileEditCell.h"

#define EDIT_MNJ_SAVE_BTN 9876

@interface NGEditBaseViewController : NGBaseViewController<UITableViewDataSource,UITableViewDelegate, EditViewSaveButtonProtocol>


-(void)customizeNavBarForCancelOnlyButtonWithTitle:(NSString *)title;
-(void) addNavigationBarWithBackAndPageNumber:(NSString*) pageNumberString withTitle: (NSString*)title;


@property (nonatomic,strong) NGRowScrollHelper *scrollHelper;
@property (nonatomic,strong) UIButton *saveBtn;
@property (weak, nonatomic) UITableView *editTableView;

@property (nonatomic,strong) NSMutableDictionary *initialParamDict;

- (void)reEnableSaveButton;

-(void) setSaveButtonTitleAs : (NSString *) str;
-(void) addNavigationBarWithBackAndRightButtonTitle:(NSString*)rightButtonTitle WithTitle: (NSString*)title;
-(void)setEditTableInFullScreenMode;
-(void) reduceTableHeightBy:(NSInteger) height;
-(void) setEditTableInReduceSizeWithSaveBtnHiddenBy:(NSInteger) height;

-(void) addSkipButton ;
- (void)customizeNavBarForBackOnlyButtonWithTitle:(NSString *)title;
-(void)updateInitialParams;
-(NSMutableDictionary*)updateTheRequestParameterForSendingInitialValueOfChanges:(NSMutableDictionary*)requestParams;
@end
