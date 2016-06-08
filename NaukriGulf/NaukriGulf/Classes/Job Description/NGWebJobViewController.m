//
//  NGWebJobViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 11/19/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGWebJobViewController.h"

@interface NGWebJobViewController (){
    
    IBOutlet UIView *closeWebJobView;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFld;


@end

@implementation NGWebJobViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _txtFld.returnKeyType = UIReturnKeyDone;
    
    // Do any additional setup after loading the view.
    if([[NGHelper sharedInstance] isUserLoggedIn]){
        
        NSString *emailID = [NGSavedData getEmailID];
        if (![emailID isEqual:@""]) {
            _txtFld.text = emailID;
        }
        
    }
    
    else{
        
        _txtFld.text = nil;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePage)];
    [closeWebJobView addGestureRecognizer:tapGesture];
    
    [UIAutomationHelper setAccessibiltyLabel:@"emailId_textfield" forUIElement:_txtFld withAccessibilityEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hidePage {
    
    [self closeTapped:nil];
}

- (IBAction)closeTapped:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeTapped)]){
    
        [self.view endEditing:YES];
        
        [self.delegate closeTapped];
    }
}


- (IBAction)emailThisJobTapped:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(emailJobTappedWithEmail:)]){
        
        [self.view endEditing:YES];
    [self.delegate emailJobTappedWithEmail:_txtFld.text];
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    float inset = IS_IPHONE5?165:155;
    
    CGRect frame = self.view.frame;
    
    [UIView animateWithDuration:.4f delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         
        self.view.frame = CGRectMake(0,frame.origin.y - inset, SCREEN_WIDTH, SCREEN_HEIGHT);
         
     } completion:nil];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    float inset = IS_IPHONE5?165:155;
   
    CGRect frame = self.view.frame;
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^
     {
         
         self.view.frame = CGRectMake(0,frame.origin.y + inset, SCREEN_WIDTH, SCREEN_HEIGHT);
         
     } completion:nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([string isEqualToString:@"\n"])
    {
        // Be sure to test for equality using the "isEqualToString" message
        [self.view endEditing:YES];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    
    return TRUE;

}


- (IBAction)applyJobsTapped:(id)sender {

    [self.view endEditing:YES];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(applyWebJobTapped)]){
        [self.delegate applyWebJobTapped];
        
    }
}


@end
