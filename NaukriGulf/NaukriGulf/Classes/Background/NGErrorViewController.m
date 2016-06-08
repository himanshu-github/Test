//
//  NGErrorViewController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 19/08/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGErrorViewController.h"

@interface NGErrorViewController (){
    
    IBOutlet UIView* optionBtnsView;
}

@property(nonatomic, weak) IBOutlet UIView* baseView;
@property(nonatomic, weak) IBOutlet UIImageView* alertImageType;
@property(nonatomic, weak) IBOutlet UIButton* cancelBtn;
@property(nonatomic, weak) IBOutlet UIButton* okBtn;
@property(nonatomic, weak) IBOutlet UIButton* okDefaultBtn;
@property(nonatomic, weak) IBOutlet UILabel* titleLabel;
@property(nonatomic, weak) IBOutlet UILabel* messageLabel;
@property(nonatomic, weak) IBOutlet UILabel* errorMsgLabel1;
@property(nonatomic, weak) IBOutlet UILabel* errorMsgLabel2;
@property(nonatomic, weak) IBOutlet UILabel* errorMsgLabel3;
@property(nonatomic, weak) IBOutlet UILabel* okCancelBtnSeparatorLabel;

@end

@implementation NGErrorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.baseView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self setAlertImageForDelete:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setaccessibility{
    [self.baseView setAccessibilityLabel:@"error_view"];
    [UIAutomationHelper setAccessibiltyLabel:@"erroralertImage_imageview" forUIElement:self.alertImageType];
    [UIAutomationHelper setAccessibiltyLabel:@"errorcancel_btn" forUIElement:self.cancelBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"errorokWithCancel_btn" forUIElement:self.okBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"errorok_btn" forUIElement:self.okDefaultBtn];
    [UIAutomationHelper setAccessibiltyLabel:@"errortitle_lbl" value:self.titleLabel.text forUIElement:self.titleLabel];
    [UIAutomationHelper setAccessibiltyLabel:@"errormessage_lbl" value:self.messageLabel.text forUIElement:self.messageLabel];
    [UIAutomationHelper setAccessibiltyLabel:@"errorMsg1_lbl" value:self.errorMsgLabel1.text forUIElement:self.errorMsgLabel1];
    [UIAutomationHelper setAccessibiltyLabel:@"errorMsg2_lbl" value:self.errorMsgLabel2.text forUIElement:self.errorMsgLabel2];
    [UIAutomationHelper setAccessibiltyLabel:@"errorMsg3_lbl" value:self.errorMsgLabel3.text forUIElement:self.errorMsgLabel3];
    [UIAutomationHelper setAccessibiltyLabel:@"errorokCancelBtnSeparator_lbl" value:self.okCancelBtnSeparatorLabel.text forUIElement:self.okCancelBtnSeparatorLabel];
    
}
-(void)setAlertImageForDelete:(BOOL)forDelete{
    if(forDelete)
    {
        [_alertImageType setImage:[UIImage imageNamed:@"puzzle"]];
    }
    else
    {
        [_alertImageType setImage:[UIImage imageNamed:@"error_blue"]];
    }
    
}
- (void)showDeleteScreenWithTitle:(NSString*)title withMessage:(NSArray*)messageArray withButtonsTitle:(NSString *)btnTitles withDelegate:(id)delegate{
    
    [self showErrorScreenWithTitle:nil withMessage:messageArray withButtonsTitle:btnTitles withDelegate:delegate];
    [self setAlertImageForDelete:YES];
    
    [self setaccessibility];
}
- (void)showErrorScreenWithTitle:(NSString*)title withMessage:(NSArray*)messageArray withButtonsTitle:(NSString *)btnTitles withDelegate:(id)delegate {
    
    NSArray *errorMsgArray  = [NSArray arrayWithObject:[messageArray fetchObjectAtIndex:0]];
    NSInteger numberOfError;
    if([errorMsgArray count]){
        
        numberOfError = [errorMsgArray count];
        
        if(numberOfError < 4 && numberOfError > 1){
            
            [self.messageLabel setHidden:YES];
            
            [errorMsgArray enumerateObjectsUsingBlock:^(id anObject, NSUInteger idx, BOOL *stop) {
                
                switch (idx) {
                    case 0:
                        
                        self.errorMsgLabel1.text = (NSString *)anObject;
                        [self.errorMsgLabel1 setHidden:NO];
                        break;
                    case 1:
                        
                        self.errorMsgLabel2.text = (NSString *)anObject;
                        [self.errorMsgLabel2 setHidden:NO];
                        break;
                    case 2:
                        
                        self.errorMsgLabel3.text = (NSString *)anObject;
                        [self.errorMsgLabel3 setHidden:NO];
                        break;
                        
                    default:
                        break;
                }
                
            }];
        }
        else{
            
            if([errorMsgArray count]){
                
                self.errorMsgLabel1.hidden = YES;
                self.errorMsgLabel2.hidden = YES;
                self.errorMsgLabel3.hidden = YES;
                
                self.messageLabel.text = [errorMsgArray fetchObjectAtIndex:0];
                [self.messageLabel getDynamicHeight];
                
            }
            
            
        }
        
    }
    
    self.delegate = delegate;
    if(title){
        self.titleLabel.text = title;
    }
    else{
        [self.titleLabel setHidden:YES];
    }
    if([btnTitles length]){
        
        NSArray *titleArray= [NSArray stringSeparateByComma:btnTitles];
        NSInteger btnTitleCount = [titleArray count];
        if (btnTitleCount >1) {
            
            _cancelBtn.hidden = NO;
            _okBtn.hidden = NO;
            _okDefaultBtn.hidden = YES;
            [self.okCancelBtnSeparatorLabel setHidden:NO];
            NSString *okBtnTitle = [titleArray fetchObjectAtIndex:0];
            
            NSString *cancelBtnTitle = [titleArray fetchObjectAtIndex:1];
            [self.okBtn setTitle:okBtnTitle forState:UIControlStateNormal];
            [self.okBtn setTitle:okBtnTitle forState:UIControlStateHighlighted];
            [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
            [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateHighlighted];
            
        }else{
            _cancelBtn.hidden = YES;
            _okBtn.hidden = YES;
            _okDefaultBtn.hidden = NO;
            [self.okCancelBtnSeparatorLabel setHidden:YES];
        }
        
    }
    [self setaccessibility];
    
    

    
    CGSize contentViewSize = [[self view] systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    
    contentViewSize.height = 51+20+(_messageLabel.frame.size.height)+50+(4*20);//+20 padding for bottom
    
    [_contentViewHeightConstraint setConstant:contentViewSize.height];
    [[self view] setNeedsLayout];
    [[self view] layoutIfNeeded];
}
#pragma mark
#pragma mark Actions

- (IBAction)okButtonClicked:(UIButton *)sender{
    
    [self.view removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(customAlertbuttonClicked:)])
        [_delegate customAlertbuttonClicked:sender.tag];
    
}
- (IBAction)cancelButtonClicked:(UIButton *)sender{
    
    [self.view removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(customAlertbuttonClicked:)])
        [_delegate customAlertbuttonClicked:sender.tag];
}
- (IBAction)okDefaultButtonClicked:(UIButton *)sender{
    
    [self.view removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(customAlertbuttonClicked:)])
        [_delegate customAlertbuttonClicked:sender.tag];
    
}

@end
