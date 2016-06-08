//
//  NGBaseViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 05/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutocompletionTableView.h"
#import "NGCustomValidationCell+ShowValidationError.h"
#import "NGLabel.h"
#import "IENavigationController.h"
#import "NGRowScrollHelper.h"
#import "NGAPIResponseModal.h"

#define USER_PHOTO_TAG 500
#define USER_NAME_TAG 502
#define USER_DESIGNATION_TAG 501

@interface NGBaseViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDelegate>
{
    UIBarButtonItem *doneButton;
    UIBarButtonItem *prevButton;
    UIBarButtonItem *nextButton;
    
    UIButton *navigationBarLeftBtn;
    UIButton *navigationBarRightBtn;
    
    NSMutableArray *errorCellArr;
    
    float errorFieldIndex;  // Denotes the index of textfield whose validation get failed
    
    UIButton *filterBtnForSRP;
}

@property(strong,nonatomic) NGLabel* countLbl;
@property(strong,nonatomic)NSArray* fieldsArray;

@property (strong, nonatomic) UIView *networkView ;
@property (assign, nonatomic) BOOL isRequestInProcessing;
@property (assign, nonatomic) BOOL isSwipePopGestureEnabled;
@property (assign, nonatomic) BOOL isSwipePopDuringTransition;


@property (strong,nonatomic) IENavigationAction *navigationAction;
/**
 *  MIS service parameter
 */
@property (nonatomic, strong)NSString *xzMIS;


-(void)setBackgroundOfView;
-(void)setBackgroundOfTableView:(UITableView*)tableView;
-(void)showSingletonNetworkErrorLayer;
-(void)removeSingletonNetworkErrorLayer;
-(void)updateMenuPushCount;

-(void)downloadJobsWithParams:(NSDictionary *)requestParams;
-(void)downloadJDWithParams:(NSDictionary *)requestParams;

-(void)customizeNavigationTitleFont;

//Adding Custom layer in KeyBoard
-(void)initilizaArrayForTextfields:(NSArray*)fieldsArray;
-(void)customTextFieldDidBeginEditing:(UITextField*)textField;
-(void)customTextViewDidBeginEditing:(UITextView*)textView;
-(UIView*)customToolBarForKeyBoard;
-(void)dismissKeyboardOnTap;
-(void)hideKeyboardOnTapOutsideKeyboard;
-(void)hideKeyboardOnTapAtView:(UIView*)paramView;

- (AutocompletionTableView *)getSuggestorForDD:(NSString *)ddKey textField:(UITextField *)txtFld;

-(void)releaseMemory;

/**
 *  Sets the index of error proned topmost textfield.
 *
 *  @param index Index of textfield.
 */
-(void)setErrorIndexAs:(float)index;

-(void)closeTapped:(id)sender;
-(void)staticTapped:(id)sender;
-(void)feviconTapped:(id)sender;
-(void) ClearButtonClicked;
-(void)saveButtonPressed;
//new menthods

-(void) addNavigationBarWithTitle : (NSString *) title;
-(void) addNavigationBarWithTitleAndClearButton : (NSString *) title ;
-(void) addNavigationBarWithCloseBtnWithTitle:(NSString *)navigationTitle;
-(void) addCloseButtonOnNavigationBar;
-(void) addNavigationBarWithBackBtnWithTitle:(NSString *)navigationTitle;
-(void) addNavigationBarWithTitleAndHamBurger:(NSString*) navigationTitle;
- (void)addLogoToNavigationBarWithUnTappableImageName:(NSString*)paramImageFilename;

-(void)setCustomTitle:(NSString *)customTitle;
-(void) customizeValidationErrorUIForIndexPath:(NSIndexPath *)indexPath cell:(NGCustomValidationCell *)cell;
- (void)addClearButtonAtRightOfNavigationBar;
- (void)addNavigationBarForSRPWithTitle:(NSString*)paramTitle;
-(void) showAnimator;
-(void) hideAnimator;
-(void) setLeftHamBurgerCount ;
- (void)setCustomFontForSRPPageNavigationBar:(BOOL)paramIsJobsFound;
- (void)removeAllRightSideItemsOfNavigationBar;
-(void)setNavigationLeftButtonEdgeInset;
-(void)setNavigationRightButtonEdgeInsect;
-(UIBarButtonItem *)createBarButtonItemWithButton:(UIButton *)button;
-(void)changeHamburgerToBackButton;
- (void)setNavigationBarWithTitle:(NSString *)navigationTitle;
-(void)gotoMenu:(id)sender;
-(void)disbaleLeftAndRightPanOnPage;
-(void)enableLeftAndRightPanOnPage;
-(void)closeButtonClicked:(id)sender;
-(void)customizeNavBarWithTitle:(NSString *)title;
- (void)addNavigationBarTitleWithCancelAndSaveButton:(NSString*)navigationTitle withLeftNavTilte:(NSString *)leftNavTitle withRightNavTitle:(NSString *)rightNavTilte;
- (void)backButtonClicked:(UIButton*)sender;
- (void)cancelButtonTapped:(id)sender;
-(void)addNavigationBarWithTitleOnly:(NSString *)paramTitle;
-(void)listenForAppNotification:(NSString*)paramNotificationName WithAction:(BOOL)paramAction;

-(void)changeTitle:(NSString *)title;
-(void)fetchJDFromServer:(NSDictionary*)requestParams withCallback:(void (^)(NGAPIResponseModal* modal))callback;


@end
