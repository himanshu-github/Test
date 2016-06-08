//
//  NGEditBaseViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditBaseViewController.h"
#import "NGProfileEditCell.h"

@interface NGEditBaseViewController ()<UITableViewDataSource,UITableViewDelegate> {
    
    NGEditResuableTableViewController *editMNJTableController;
    
}
@end

@implementation NGEditBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //Reusable Table component
        editMNJTableController = [[NGHelper sharedInstance].editFlowStoryboard  instantiateViewControllerWithIdentifier:@"EditMNJReusableTable"];
        editMNJTableController.delegate = self;
        
        NSInteger heightMinusForiOS = 64;
        
        [editMNJTableController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-heightMinusForiOS)];
        
        [self.view addSubview:editMNJTableController.view];
        
        _editTableView = editMNJTableController.tblEditMNJ;
        
        _scrollHelper = [[NGRowScrollHelper alloc] init];
        _scrollHelper.tableViewToScroll = _editTableView;
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *btn = (UIButton*)[editMNJTableController.view viewWithTag:EDIT_MNJ_SAVE_BTN] ;
    self.saveBtn = btn;
    self.initialParamDict = [NSMutableDictionary dictionary];
}

-(void)updateInitialParams{

    
}
-(NSMutableDictionary*)updateTheRequestParameterForSendingInitialValueOfChanges:(NSMutableDictionary*)requestParams{
    
    BOOL isLoggingEnabled =[[NGSavedData LoggingEnabledKeyValue] intValue];
    
    
    if( isLoggingEnabled == 1){
        NSArray *keyArr = [requestParams allKeys];
        for (int i =0; i<keyArr.count; i++) {
            NSString *key = keyArr[i];
            if(self.initialParamDict[key]){
                //key is present
            if((![self.initialParamDict[key] isEqual:requestParams[key]]))
            {
                //the case when initial and final both have the keys but they are not equals by values
                
                if([self.initialParamDict[key] isKindOfClass:[NSString class]]||[self.initialParamDict[key] isKindOfClass:[NSNumber class]])
                [requestParams setCustomObject:self.initialParamDict[key] forKey:[NSString stringWithFormat:@"%@_initial",key]];
                else if([self.initialParamDict[key] isKindOfClass:[NSDictionary class]])
                {
                    id object = [requestParams[key] copy];
                    id obj = [self removeAllNullsFromDictionary:object];
                    [obj addEntriesFromDictionary:self.initialParamDict[key]];
                    [requestParams setCustomObject:obj forKey:[NSString stringWithFormat:@"%@_initial",key]];
                }
                else if ([self.initialParamDict[key] isKindOfClass:[NSArray class]])
                {
                    id object = [requestParams[key] copy];
                    id obj = [self removeAllNullsFromArray:object];
                    [requestParams setCustomObject:obj forKey:[NSString stringWithFormat:@"%@_initial",key]];
                }
                
            }
              else{
                //no need to add because no changes is made
                }
            }
            else{
                //key is not present then add the values from final parameters
                id object = [requestParams[key] copy];
                if([object isKindOfClass:[NSString class]]||[object isKindOfClass:[NSNumber class]]){
                    id obj = [self getNilObjectForString:object];
                    [requestParams setCustomObject:obj forKey:[NSString stringWithFormat:@"%@_initial",key]];
                }
                else if ([object isKindOfClass:[NSDictionary class]]){
                    id obj = [self removeAllNullsFromDictionary:object];
                    [requestParams setCustomObject:obj forKey:[NSString stringWithFormat:@"%@_initial",key]];
                }
                else if ([object isKindOfClass:[NSArray class]])
                {
                    id obj = [self removeAllNullsFromArray:object];
                    [requestParams setCustomObject:obj forKey:[NSString stringWithFormat:@"%@_initial",key]];
                
                }
            }
        }
        
        return requestParams;
    }
    else
        return requestParams;

}

#pragma mark - Remove  Null Methods

-(id)removeAllNullsFromDictionary:(NSDictionary *)tempValues{
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:tempValues];
    
    NSArray *arrayKeys = [tempDict allKeys];
    
    int keyCount = (int)[arrayKeys count];
    
    for(int i=0;i<keyCount;i++){
        
        NSString *objectKey = [arrayKeys objectAtIndex:i];
        
        id object = [tempDict valueForKey:objectKey];
        
        if([object isKindOfClass:[NSDictionary class]]){
            
            [tempDict setValue:[self removeAllNullsFromDictionary:object] forKey:objectKey];
            
        }
        
        else if ([object isKindOfClass:[NSArray class]]){
            
            [tempDict setValue:[self removeAllNullsFromArray:object] forKey:objectKey];
            
        }
        
        else{
            
            [tempDict setValue:object?(object == [NSNull null])?@"":[NSString stringWithFormat:@""]:@"" forKey:objectKey];
            
        }
        
    }
    
    return tempDict;
    
}

-(id)removeAllNullsFromArray:(NSArray *)myArray{
    
    NSMutableArray *arrayValues = [NSMutableArray arrayWithArray:myArray];
    
    int arrayCount = (int)[arrayValues count];
    
    for(int i=0;i<arrayCount;i++){
        
        id object = [arrayValues objectAtIndex:i];
        
        if([object isKindOfClass:[NSDictionary class]]){
            
            [arrayValues replaceObjectAtIndex:i withObject:[self removeAllNullsFromDictionary:object]];
            
        }
        
        else{
            
            [arrayValues replaceObjectAtIndex:i withObject:object?(object == [NSNull null])?@"":[NSString stringWithFormat:@""]:@""];
            
        }
        
    }
    
    return arrayValues;
    
}

-(id)getNilObjectForString:(NSString*)initialString{
    initialString = @"";
    return initialString;
}
-(id)getNilObjectForDictionary:(NSMutableDictionary*)initialDict{
    
    NSArray *subKeyArr = [initialDict allKeys];
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    for (int i = 0; i<subKeyArr.count; i++) {
        if([[initialDict objectForKey:subKeyArr[i]] isKindOfClass:[NSString class]]||[[initialDict objectForKey:subKeyArr[i]] isKindOfClass:[NSNumber class]]){
             id obj = [self getNilObjectForString:[initialDict objectForKey:subKeyArr[i]]];
            [subDict setObject:obj forKey:subKeyArr[i]];
        }

        else if([[initialDict objectForKey:subKeyArr[i]] isKindOfClass:[NSDictionary class]])
        {
            id obj = [self getNilObjectForDictionary:[initialDict objectForKey:subKeyArr[i]]];
            [subDict setObject:obj forKey:subKeyArr[i]];
        }
    }
    return subDict;
}
- (void)addAutoLayout{
    NSLayoutConstraint *constraintsTop = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:editMNJTableController.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *constraintsbottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:editMNJTableController.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *constraintsleading = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:editMNJTableController.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    NSLayoutConstraint *constraintstailing = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:editMNJTableController.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    
    [self.view addConstraint:constraintsleading];
    [self.view addConstraint:constraintstailing];
    [self.view addConstraint:constraintsTop];
    [self.view addConstraint:constraintsbottom];
}

- (void)reEnableSaveButton{
    [self setIsRequestInProcessing:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [NGDecisionUtility checkNetworkStatus];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeNavBarForBackOnlyButtonWithTitle:(NSString *)title{
    
    [self addNavigationBarWithBackBtnWithTitle:title];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)customizeNavBarForCancelOnlyButtonWithTitle:(NSString *)title{
    [self addNavigationBarTitleWithCancelAndSaveButton:title withLeftNavTilte:K_NAVBAR_LEFT_TITLE_CANCEL withRightNavTitle:nil];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}
-(void)saveButtonPressed{
    
    
}

- (void)addRightButtonForNavigationBarWithTitle:(NSString*)paramTitle AndFontSize:(float)paramFontSize AndColor : (UIColor*) color{
    if(navigationBarRightBtn)
        navigationBarRightBtn    =   nil;
    navigationBarRightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [navigationBarRightBtn setFrame:CGRectMake(0, 0, 70, 40)];
    [self setNavigationRightButtonEdgeInsect];
    [navigationBarRightBtn setTitle:paramTitle forState:UIControlStateNormal];
    navigationBarRightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [navigationBarRightBtn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:paramFontSize]];
    
    [navigationBarRightBtn setTitleColor:color forState:UIControlStateNormal];
    [navigationBarRightBtn addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [self createBarButtonItemWithButton:navigationBarRightBtn];
}





#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView* viewToReturn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [viewToReturn setBackgroundColor:Clr_Grey_SearchJob];
    return viewToReturn;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)hideKeyboard{
    
    [self.view endEditing:YES];
    
}

-(void) addNavigationBarWithBackAndRightButtonTitle:(NSString*)rightButtonTitle WithTitle: (NSString*)title {
    [self customizeNavigationTitleFont];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    [self addNavigationBarWithBackBtnWithTitle:title];
    if (rightButtonTitle) {
        [self addRightButtonForNavigationBarWithTitle:rightButtonTitle AndFontSize:15.0 AndColor:Clr_Edit_Profile_Blue];

    }
  }


-(void)customizeNavigationTitleFont{
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
      [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:19.0], NSFontAttributeName,nil]];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void) addNavigationBarWithBackAndPageNumber:(NSString*) pageNumberString withTitle: (NSString*)title{
    
     self.navigationItem.rightBarButtonItem = nil;
     [self addNavigationBarWithBackBtnWithTitle:title];
    if (pageNumberString) {
       
        [self addRightButtonForNavigationBarWithTitle:pageNumberString AndFontSize:15.0 AndColor:[UIColor grayColor] ];
        
    }
    
}

-(void) setColorForRightBarButton : (UIColor*) color{
    
    
}

-(void) setSaveButtonTitleAs : (NSString *) str {
    
   UIButton *btn = (UIButton*)[editMNJTableController.view viewWithTag:EDIT_MNJ_SAVE_BTN] ;
   [btn setTitle:str forState:UIControlStateNormal];
    
}

-(void) setEditTableInFullScreenMode {
    
    [editMNJTableController makeTableFullScreen];
}
-(void) setEditTableInReduceSizeWithSaveBtnHiddenBy:(NSInteger) height {
    
    [editMNJTableController reduceTableSizeWithSaveBtnHiddenBy:height];
}


-(void) reduceTableHeightBy:(NSInteger) height{
    
    [editMNJTableController makeTableShortInHeight:height];
    
    
}
-(void) addSkipButton {
    
    UIButton *btnSkip = [[UIButton alloc] init];
    
    [btnSkip setTitleColor:[UIColor colorWithRed:1/255.0 green:130/255.0 blue:206/255.0 alpha:1] forState:UIControlStateNormal];
    [btnSkip setTitleColor:[UIColor colorWithRed:1/255.0 green:80/255.0 blue:206/255.0 alpha:1] forState:UIControlStateHighlighted];
    
    [btnSkip.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:16.0f]];
    btnSkip.backgroundColor = [UIColor whiteColor];
    [btnSkip setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btnSkip setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    btnSkip.translatesAutoresizingMaskIntoConstraints = NO;
    
    [btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
    
    [btnSkip addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:btnSkip aboveSubview:self.editTableView];
    
    CGFloat btnWidth = 80.0;
    CGFloat xForButton = (SCREEN_WIDTH - btnWidth)/2;
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:btnSkip attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:xForButton];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:btnSkip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:btnWidth];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:btnSkip attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.saveBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:btnSkip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
    
    [self.view addConstraint:leadingConstraint];
    [self.view addConstraint:widthConstraint];
    [self.view addConstraint:bottomConstraint];
    [self.view addConstraint:heightConstraint];

}

@end
