//
//  AutocompletionTableView.h
//
//  Created by Gushin Arseniy on 11.03.12.
//  Copyright (c) 2012 Arseniy Gushin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Consts for AutoCompleteOptions:
//
// if YES - suggestions will be picked for display case-sensitive
// if NO - case will be ignored
#define ACOCaseSensitive @"ACOCaseSensitive"

// if "nil" each cell will copy the font of the source UITextField
// if not "nil" given UIFont will be used
#define ACOUseSourceFont @"ACOUseSourceFont"

// if YES substrings in cells will be highlighted with bold as user types in
// *** FOR FUTURE USE ***
#define ACOHighlightSubstrWithBold @"ACOHighlightSubstrWithBold"

// if YES - suggestions view will be on top of the source UITextField
// if NO - it will be on the bottom
// *** FOR FUTURE USE ***
#define ACOShowSuggestionsOnTop @"ACOShowSuggestionsOnTop"

@class AutocompletionTableView;

/**
 @protocol Delegate methods for AutocompletionTableView
 */
@protocol AutocompletionTableViewDelegate <NSObject>

@required
/**
 @method Ask delegate for the suggestions for the provided string - maybe need to ask DB, service, etc.
 @param string the "to-search" term
 @return an array of suggestions built dynamically
 */
- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string;

/**
 @method Invoked when user clicked an auto-complete suggestion UITableViewCell.
 @param index the index that was cicked
 */
- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText;

@optional
-(void)showingTheOptions:(BOOL)status;
- (void)updateAutoCompletionTableViewConstraintWithNewFrame:(CGRect)paramNewFrame;

@end

@interface AutocompletionTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
// Dictionary of NSStrings of your auto-completion terms
@property (nonatomic, strong) NSArray *suggestionsDictionary;
@property(nonatomic,assign) CGRect textFieldFrame;
@property(nonatomic,assign) BOOL isErrorViewVisibleInSearch;
@property(nonatomic,assign) BOOL isShowOptions;


@property(nonatomic,assign) BOOL isMultiSelect;
@property(nonatomic,assign) BOOL defaultView;

@property (nonatomic,assign)BOOL isEmailAddressSuggestor;

// Delegate for AutocompletionTableView
@property (nonatomic, weak) id<AutocompletionTableViewDelegate> autoCompleteDelegate;
// Dictionary of auto-completion options (check constants above)
@property (nonatomic, strong) NSDictionary *options;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *prevOptionsDictionary;
@property (nonatomic) NSInteger prevTextfieldTag;

// Call it for proper initialization
- (UITableView *)initWithTextField:(UITextField *)textField inViewController:(UIViewController *) parentViewController withOptions:(NSDictionary *)options withDefaultStyle:(BOOL)style;

-(void)setTopPositionForSuggestorView:(CGFloat)frame;
- (void)textFieldValueChanged:(UITextField *)textField;
- (void) hideOptionsView;
-(void)clearAutoCompletionTable;
@end
