//
//  NGSearchJobParametersTupple.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 18/08/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NGSearchJobParameterDelegate <NSObject>
- (void)textFieldValue:(NSString *)textFieldValue;
- (void)searchJobButtonClicked:(UIButton *)sender;
@end

/**
 *  This class is used for creating custom tupple of search job parameters.
 */
@interface NGSearchJobParametersTupple : NGCustomValidationCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, weak)  id<NGSearchJobParameterDelegate>delegate;
/**
 *  This variable holds cell text.
 */
@property(weak, nonatomic) IBOutlet UITextField* txtParameter;


- (void)setKeyboardReturnKeyTypeForTextField:(UIReturnKeyType)paramReturnKeyType;
- (void)hideTxtParameterField:(BOOL)status;
- (void)setTextFieldHeight:(int)height;
-(void)configureCellForModifySearchWithData:(NSMutableDictionary*)dataDict andIndexPath:(NSIndexPath*)index;
-(void)configureCellForSearchWithData:(NSMutableDictionary*)dataDict andIndex:(int)index;

@end
