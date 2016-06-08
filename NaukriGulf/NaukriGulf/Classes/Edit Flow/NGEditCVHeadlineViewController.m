//
//  NGEditCVHeadlineViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 13/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGEditCVHeadlineViewController.h"

@interface NGEditCVHeadlineViewController (){
    NSString* resumeHeadline;
    NSInteger characterLeft;
    NSString* errorTitle;
    BOOL isInitialParamDictUpdated;
}


/**
 *  a Custom animation appears on loading operations
 */
@property (strong, nonatomic) NGLoader* loader;
@end

@implementation NGEditCVHeadlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma marks - ViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self customizeNavBarWithTitle:@"CV Headline"];
    
    [self hideKeyboardOnTapOutsideKeyboard];
    
    isInitialParamDictUpdated = NO;
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    [super viewWillAppear:animated];
    [self.editTableView setScrollEnabled:NO];
    [self.editTableView setBounces:NO];
    
    [self addStaticLabel];
    [NGDecisionUtility checkNetworkStatus];

}
#pragma mark - Update Initial Params
-(void)updateInitialParams{
    if(!isInitialParamDictUpdated){
        self.initialParamDict  = [self getParametersInDictionary];
        isInitialParamDictUpdated = YES;
    }
}
-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:@"editCVHeadline_table" forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    [NGHelper sharedInstance].appState = APP_STATE_EDIT_FLOW;
    [super viewDidAppear:animated];
    [self setAutomationLabel];
    [self updateInitialParams];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([self.loader isLoaderAvail]) {
        [self.loader hideAnimatior:self.view];
    }
    
}


#pragma mark - Memory Management

- (void)dealloc {
    
    [self releaseMemory];
}

-(void)releaseMemory{
    self.loader =  nil;
    self.modalClassObj =  nil;
    self.editDelegate =  nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark JobManager Delegate

-(void)receivedSuccessFromServer:(NGAPIResponseModal *)responseData{
    
    [(IENavigationController*)self.navigationController popActionViewControllerAnimated:YES];
    [self.editDelegate editedCVHeadlineWithSuccess:YES];
    [self.loader hideAnimatior:self.view];
    
}
-(void)receivedErrorFromServer:(NGAPIResponseModal *)responseData{
    [self.loader hideAnimatior:self.view];
}
-(NSMutableDictionary*)getParametersInDictionary{
    NSString *cvHeadline = resumeHeadline;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setCustomObject:cvHeadline forKey:@"default"];
    [dict setCustomObject:cvHeadline forKey:@"EN"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:dict,@"headline", nil];
    
    [params setCustomObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"resId", nil] forKey:OTHER_PARAMS];
    return params;

}
#pragma mark - Private Methods

/**
 *   Method initialized when the save Button is tapped, This method creates the service request WithServiceType:SERVICE_TYPE_UPDATE_RESUME and initialize the loader .
 *
 *  @param sender
 */
-(void)saveCVHeadline{
    [self.view endEditing:YES];
    
    NSMutableArray* arrValidations = [self checkAllValidations];
    if (!errorTitle.length) errorTitle = @"Error!";
    NSString * errorMessage = @"";
    
    //check character limit value
    if (K_RESUME_HEADLINE_LIMIT < resumeHeadline.length) {
        characterLeft = 0;
    }
    
    if([arrValidations count] >0){
        
        for (int i = 0; i< [arrValidations count]; i++) {
            
            if (i == [arrValidations count]-1)
                errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@",
                                                                      [arrValidations fetchObjectAtIndex:i]]];
            else
                errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@,",
                                                                      [arrValidations fetchObjectAtIndex:i]]];
        }
        
        [NGUIUtility showAlertWithTitle:errorTitle withMessage:
         [NSArray arrayWithObjects:errorMessage, nil]
                    withButtonsTitle:@"OK" withDelegate:nil];
    }
    else{
  
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EDIT_PROFILE withEventLabel:K_GA_EVENT_EDIT_PROFILE withEventValue:nil];
        
        self.loader = [[NGLoader alloc] initWithFrame:self.view.frame];
        [self.loader showAnimation:self.view];
        
        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
       
        
        __weak NGEditCVHeadlineViewController *weakSelf = self;
        NSMutableDictionary *params =[self updateTheRequestParameterForSendingInitialValueOfChanges:[self getParametersInDictionary]];

        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (responseInfo.isSuccess) {
                    [(IENavigationController*)weakSelf.navigationController popActionViewControllerAnimated:YES];
                    [weakSelf.editDelegate editedCVHeadlineWithSuccess:YES];
                    [weakSelf.loader hideAnimatior:weakSelf.view];
                }else{
                    [weakSelf.loader hideAnimatior:weakSelf.view];
                }
                
            });
            
            
        }];
    }

}

-(void)saveButtonPressed{
    [self saveCVHeadline];
}

- (void)editMNJSaveButtonTapped:(id)sender{
    [self saveCVHeadline];
}

- (void)addStaticLabel{
    
    float OriginY = 0;
    if (IS_IPHONE5){
        OriginY = K_RESUME_HEADLINE_ROW_HEIGHT+5;
    }else if (IS_IPHONE4){
        OriginY = K_RESUME_HEADLINE_ROW_HEIGHT+5;
        //incase for any further changes in iPhone4 UI,change value in this case
    }else if(IS_IPHONE6){
        //dummy testing
        OriginY = K_RESUME_HEADLINE_ROW_HEIGHT+5;

    }
    else if (IS_IPHONE6_PLUS)
    {
        OriginY = K_RESUME_HEADLINE_ROW_HEIGHT+5;

    
    }
        
    NGLabel* staticLabel= [[NGLabel alloc] initWithFrame:CGRectMake(10,OriginY, self.view.bounds.size.width-20, 80)];
    [staticLabel setText:K_EDIT_RESUME_HEADLINE_STATIC_LABEL];
    [staticLabel setNumberOfLines:0];
    [staticLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [staticLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE size:13.0]];
    [staticLabel setTextAlignment:NSTextAlignmentCenter];
    [staticLabel setTextColor:[UIColor lightGrayColor]];
    [staticLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [staticLabel setBackgroundColor:[UIColor clearColor]];
    [self.view insertSubview:staticLabel aboveSubview:self.editTableView];
    
}




/**
 *  Method checks if validation are applicable on headlineTxtView and return result in Boolean format
 *
 *  @return If Yes , the validations are applied
 */
-(NSMutableArray *)checkAllValidations{
    [errorCellArr removeAllObjects];
    
    errorTitle = @"";
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if (0<[[ValidatorManager sharedInstance] validateValue:resumeHeadline withType:ValidationTypeString].count){
        
        errorTitle = @"Incomplete Details!";
        [arr addObject:ERROR_MESSAGE_EMPTY_CV_HEADLINE];
        [errorCellArr addObject:[NSNumber numberWithInteger:0]];
        
    }
    
    [self.editTableView reloadData];
    return arr;
}

/**
 *   Public Method initiated on  view appear and updates the textfield Values with NGMNJProfileModalClass object
 *
 *  @param obj A Json Model object containing objects
 */
-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj{
    self.modalClassObj = obj;
    
    resumeHeadline = self.modalClassObj.headline;
    if (!resumeHeadline)
        resumeHeadline = @"";
    
    if (resumeHeadline.length > K_RESUME_HEADLINE_LIMIT)
        resumeHeadline = [resumeHeadline substringToIndex:K_RESUME_HEADLINE_LIMIT];
    
    characterLeft = K_RESUME_HEADLINE_LIMIT - resumeHeadline.length;
    [self.editTableView reloadData];

}

#pragma mark - Profile edit cell delegate

- (void)textViewDidEndEditing:(NSString *)textViewValue havingIndex:(NSInteger)index{
    
    resumeHeadline = textViewValue;
    resumeHeadline = [NSString stripTags:textViewValue];;
}

#pragma mark -
#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float fHeight = K_RESUME_HEADLINE_ROW_HEIGHT;
    return fHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    NSString* cellIndentifier = @"EditProfileTextViewCell";
    NGEditProfileTextviewCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.editModuleNumber = CV_HEADLINE;
    cell.delegate = self;
    
    NSMutableDictionary* dictToPass = [NSMutableDictionary dictionary];
    
    [dictToPass setCustomObject:@"CV Headline" forKey:K_KEY_EDIT_PLACEHOLDER];
    [dictToPass setCustomObject:[NSString stringWithFormat:@"%ld Characters Left", (long)characterLeft] forKey:K_KEY_EDIT_PLACEHOLDER2];
    [dictToPass setCustomObject:[NSNumber numberWithInteger:K_RESUME_HEADLINE_LIMIT] forKey:@"limit"];
    [dictToPass setCustomObject:resumeHeadline forKey:K_KEY_EDIT_TITLE];
    cell.index = indexPath.row;
    if (IS_IPHONE5)
        [dictToPass setCustomObject:[NSNumber numberWithInteger:K_RESUME_HEADLINE_ROW_HEIGHT -45] forKey:K_KEY_TEXTVIEW_HEIGHT];
    else
        [dictToPass setCustomObject:[NSNumber numberWithInt:120 -45] forKey:K_KEY_TEXTVIEW_HEIGHT];
    [UIAutomationHelper setAccessibiltyLabel:@"resumeHeadline_txtFld" forUIElement:cell.txtview];
    [UIAutomationHelper setAccessibiltyLabel:@"resumeHeadlineLimit_lbl" value:cell.lblPlaceholder2.text forUIElement:cell.lblPlaceholder2];
    [cell setAccessibilityLabel:@"resumeHeadline_cell"];
    [cell configureEditProfileTextviewCell:dictToPass];
    dictToPass = nil;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NGEditProfileTextviewCell* cell = (NGEditProfileTextviewCell*)[self.editTableView
                                                                   cellForRowAtIndexPath:indexPath];
    [cell.txtview becomeFirstResponder];
}



@end
