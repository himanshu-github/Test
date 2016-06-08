//
//  NGContactDetailMobileCell.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/17/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactDetailMobileCell <NSObject>
@optional
- (void)textFieldValue:(NSString *)textFieldValue havingIndex:(NSInteger)index;
- (void)textField:(UITextField *)textFieldValue havingIndex:(NSInteger)index;
- (void)textFieldDidStartEditing:(UITextField *)textFieldValue havingIndex:(NSInteger)index;
- (void)textFieldDidStartEditing:(NSInteger)index;
- (BOOL)textFieldShouldStartEditing:(NSInteger)index;
- (void)textFieldDidReturn:(NSInteger)index;
- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index;
- (void)textFieldDidEndEditing:(UITextField *)textField havingIndex:(NSInteger)index;
- (void)textFieldDidEndEditing:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string;
- (void)keyboardToolBarButtonPressed:(id)sender;
@end

@interface NGContactDetailMobileCell : NGCustomValidationCell<UITextFieldDelegate>{
    
    UITextField* selectedTF;
}

@property(nonatomic, weak) IBOutlet NGTextField* countryCode;

@property(nonatomic, weak) IBOutlet NGTextField* mobileCode;

@property (nonatomic, assign) id<ContactDetailMobileCell> delegate;

@property (weak, nonatomic) IBOutlet NGLabel *lblPlaceHolder;

@property(nonatomic,readwrite) NSInteger index;


-(void)configureMobileCellWithData:(NSMutableDictionary*)data andIndexPath:(NSIndexPath*)indexpath;

@end
