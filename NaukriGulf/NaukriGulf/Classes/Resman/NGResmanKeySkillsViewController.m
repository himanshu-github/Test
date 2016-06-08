//
//  NGEditKeySkillsViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGResmanKeySkillsViewController.h"
#import "NGEditKeySkillsCell.h"
#import "NGEditKeySkillInputCell.h"
#import "NGResmanPersonalDetailsViewController.h"


NS_ENUM(NSUInteger, NGResmanKeySkillsRow){
    NGEditKeySkillsRowInput = 111
};

@interface NGResmanKeySkillsViewController ()<AutocompletionTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,EditKeySkillsCellDelegate>{
    NSString *editFieldTextValue;//txtFld value will be this variable
    
    AutocompletionTableView *autoCompleter;
    NSArray *suggesterDataKeySkills;
    
    NGResmanDataModel *resmanModel;
    
    BOOL isErrorInKeySkill;

}

@property (nonatomic) NSInteger editKeySkillIndex;
@property (strong, nonatomic) NGLoader* loader;
@property (strong, nonatomic) NSMutableArray *keySkillsArr;

@end

@implementation NGResmanKeySkillsViewController{
    NSLayoutConstraint *autoCompletionHeightConstraints;
    UIView *blurView;
    BOOL isEditSkillModeActive;
}

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isEditSkillModeActive = NO;
    
    [self setSaveButtonTitleAs:@"Next"];
    
    [self hideKeyboardOnTapAtView:self.editTableView];
    
    suggesterDataKeySkills = [self getSuggestors];
    
    [self.editTableView setAllowsMultipleSelectionDuringEditing:NO];
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;

}

-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    [NGHelper sharedInstance].appState = APP_STATE_EDIT_FLOW;
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    [super viewWillAppear:animated];
    

    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 3/4"];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    
    if (resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_SKILLS_FRESHER];
        self.title = @"Step 2/3";
        
        [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageFresherKeySkills];
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_SKILLS_EXPERIENCED];
        self.title = @"Step 3/4";
        
        [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageExperienceKeySkills];
    }
    
    
    [self updateDataFromModel];
    [self.editTableView reloadData];
    [NGDecisionUtility checkNetworkStatus];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.loader isLoaderAvail]) {
        [self.loader hideAnimatior:self.view];
    }
}
#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self releaseMemory];
}
- (void)releaseMemory {
    
    self.editTableView = nil;
    self.editTableView.delegate = nil;
    if ([_keySkillsArr count]) {
        [_keySkillsArr removeAllObjects];
    }
    
    _keySkillsArr = nil;
    
    _loader =  nil;
}

#pragma mark UITableview Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
            
            break;
            
        case 1:
            
            return _keySkillsArr.count;
            
            break;
            
        default:
            break;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self configureCell:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    float sectionHeight = 0.0f;
    if (1 == section) {
        sectionHeight = 70;
    }
    return sectionHeight;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionFooterView = [[UIView alloc] init];
    [sectionFooterView setAutoresizesSubviews:NO];
    sectionFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    sectionFooterView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *lblHelpText = [[UILabel alloc] init];
    [lblHelpText setAutoresizesSubviews:NO];
    [lblHelpText setNumberOfLines:0];
    [lblHelpText setLineBreakMode:NSLineBreakByWordWrapping];
    [lblHelpText setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_LIGHT size:12.0f]];
    [lblHelpText setTextAlignment:NSTextAlignmentCenter];
    CGFloat colorCode = 122.0f/255.0f;
    [lblHelpText setTextColor:[UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f]];
    [lblHelpText setText:@"e.g. Adding more such skills improves your chances of appearing in Employers' search results. E.g. Financial Modeling, Structural Design, Java, AutoCAD, Social Marketing etc."];
    
    lblHelpText.frame = CGRectMake(15, 0, sectionFooterView.frame.size.width-30, sectionFooterView.frame.size.height);
    
    [sectionFooterView addSubview:lblHelpText];
    
    return sectionFooterView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NGEditKeySkillsCell *cell = (NGEditKeySkillsCell*)[self configureCell:indexPath];
    
    switch (indexPath.section) {
        case 0:
            return 56;
            break;
            
        case 1:{
            float height = [UITableViewCell getCellHeight:cell];
            return height;
            break;
        }
        default:
            break;
    }
    
    return 56;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
    
    if (indexPath.section==1) {
        self.editKeySkillIndex = indexPath.row;
        
    }
}

#pragma mark -
#pragma mark TextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag == NGEditKeySkillsRowInput){
        
        autoCompleter.isErrorViewVisibleInSearch= NO;
        autoCompleter.textField = textField;
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag == NGEditKeySkillsRowInput){
        [self hideKeyboardAndSuggester];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    editFieldTextValue = [textField.text stringByAppendingString:string];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    editFieldTextValue = textField.text;
    
    if (isEditSkillModeActive) {
        [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 3/4"];
    }
    [self txtFldRightViewTapped:nil];
    [self hideKeyboardAndSuggester];
    return YES;
}

#pragma mark EditKeysSkillModal  delegate

-(void)didEditSkill:(NSString *)skillStr cancelFlag:(BOOL)cancelFlag{
    
    if (!cancelFlag) {
        skillStr = [NSString stripTags:skillStr];
        skillStr = [NSString formatSpecialCharacters:skillStr];
        NSArray *keySkills = [skillStr componentsSeparatedByString:@","];
        
        NSInteger i = self.editKeySkillIndex ;
        
        NSInteger count = _keySkillsArr.count;
        
        NSArray *tempArr = [_keySkillsArr copy];
        
        for (NSString *str in keySkills) {
            NSString *trimmedString = [str trimCharctersInSet :
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if(trimmedString)
            if (![trimmedString isEqualToString:@""]) {
                if(i==self.editKeySkillIndex){
                    [_keySkillsArr replaceObjectAtIndex:i withObject:trimmedString];
                }else if (i<count) {
                    [_keySkillsArr insertObject:trimmedString atIndex:i];
                }else{
                    [_keySkillsArr addObject:trimmedString];
                }
                
                
                i++;
            }
            
        }
        
        if ([self isValidKeySkills]) {
            [self.editTableView reloadData];
        }else{
            [_keySkillsArr removeAllObjects];
            [_keySkillsArr addObjectsFromArray:tempArr];
            [self showError];
        }
        
    }
}


#pragma mark Edit keyskills Delegate

-(void)deleteKeySkillAtIndex:(NSInteger)index{
    
    if (0 < [_keySkillsArr count]) {
        
        [_keySkillsArr removeObjectAtIndex:index];
        
        [self.editTableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)editKeySkillAtIndex:(NSInteger)index{
    
    if (!isEditSkillModeActive) {
        
        isEditSkillModeActive = YES;
        
        self.editKeySkillIndex = index;
        
        [self customizeNavBarForBackOnlyButtonWithTitle:@"Step 3/4"];
        
        if([_keySkillsArr count] > index){
            NSString *selectedStr = [_keySkillsArr fetchObjectAtIndex:index];
            editFieldTextValue = selectedStr?selectedStr:@"";
        }
        [self addBlurViewWithAnimation];
        
        [self.editTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.editTableView reloadData];
    }
    
}
/**
 *  To add blur animation
 */
-(void)addBlurViewWithAnimation{
    
    CGRect tempFrame        =   self.view.frame;
    tempFrame.origin.y      =   self.editTableView.frame.origin.y + 56;//height of first cell
    tempFrame.size.height   =     self.view.frame.size.height - (self.editTableView.frame.origin.y+56);
    if(!blurView){
        blurView = [[UIView alloc] initWithFrame:tempFrame];
        blurView.backgroundColor = [UIColor whiteColor];
        [self addTapGestureToBlurView];
        [self.view insertSubview:blurView belowSubview:autoCompleter];
        
        blurView.alpha = 0.0f;
        [UIView animateWithDuration:0.5 animations:^() {
            blurView.alpha = 0.9f;
            
        }];
    }
    
}
/**
 *  Remove blur animation
 */
-(void)removeBlurViewWithAnimation{
    if(blurView) {
        [UIView animateWithDuration:3.2
                         animations:^{}
                         completion:^(BOOL finished){
                             blurView.alpha = 0.0;
                             [blurView removeFromSuperview];
                             blurView = nil;
                         }];
    }
}
-(void)addTapGestureToBlurView{
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnBlurView)];
    [blurView addGestureRecognizer:singleFingerTap];
    
}
-(void)handleSingleTapOnBlurView{
    editFieldTextValue = nil;
    [self.view endEditing:YES];
    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 3/4"];
    autoCompleter.hidden = YES;
    [self.editTableView reloadData];
    [self removeBlurViewWithAnimation];
    isEditSkillModeActive = NO;
}

#pragma mark - Private Methods
/**
 *  @name Private Methods
 */
/**
 *  Method used for dismissing Keyboard
 */

-(void)dismissKeyboardOnTap {
    [self.view endEditing:YES];
    autoCompleter.hidden = YES;
}
/**
 *   Method trigger to pop class
 *
 *  @param sender NGButton class
 */
- (void)backButtonClicked:(id)sender{
    
    if (isEditSkillModeActive) {
        isEditSkillModeActive = NO;
        [self removeBlurViewWithAnimation];
        [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 3/4"];
        autoCompleter.hidden = YES;
        editFieldTextValue= nil;
        [self.editTableView reloadData];
        return;
        
    }
    else{
        [super backButtonClicked:sender];
        
    }
    
}
/**
 *  Method is called on pressing the save Button and initiate a service request for saving this information to server.
 *
 *  @param sender NGButton
 */
-(void)staticTapped:(id)sender{
    
    [self.view endEditing:YES];

    if (_keySkillsArr.count>0 && !self.isRequestInProcessing) {
        
        [self setIsRequestInProcessing:YES];
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_EDIT_PROFILE withEventLabel:K_GA_EVENT_EDIT_PROFILE withEventValue:nil];
        
        NSString *keySkillStringForServer = [NSString getStringsFromArray:_keySkillsArr];
        //check forr 255 char limit in keyskill string
        ValidatorManager *vManager = [ValidatorManager sharedInstance];
        BOOL isValidKeySkills = (0 >= [vManager validateValue:keySkillStringForServer withType:ValidationTypeString].count);
        if (isValidKeySkills) {
            
            if (KEY_SKILL_LIMIT < keySkillStringForServer.length) {
                
                [self showError];
                
                vManager = nil;
                
                [self setIsRequestInProcessing:NO];
                return;
            }
            
            resmanModel.keySkills = keySkillStringForServer;
            [[DataManagerFactory getStaticContentManager]saveResmanFields:resmanModel];
            
            [self setIsRequestInProcessing:NO];
            
            NGResmanPersonalDetailsViewController *vc  =  [[NGResmanPersonalDetailsViewController alloc] init];
            [(IENavigationController*)self.navigationController pushActionViewController:vc Animated:YES];
            
        }else{
            
            [self setItem:0 InErrorCollectionWithActionAdd:YES];
            [self.editTableView reloadData];
            
            [NGUIUtility showAlertWithTitle:@"Incomplete Details!" withMessage:[NSArray arrayWithObjects:@"Please specify Key Skills", nil] withButtonsTitle:@"OK" withDelegate:nil] ;
            
            vManager = nil;
        }
    }else{
        [self setItem:0 InErrorCollectionWithActionAdd:YES];
        [self.editTableView reloadData];
        
        [NGUIUtility showAlertWithTitle:@"Incomplete Details!" withMessage:[NSArray arrayWithObjects:@"Please specify Key Skills", nil] withButtonsTitle:@"OK" withDelegate:nil] ;
    }
}

- (void)setItem:(NSInteger)paramIndex InErrorCollectionWithActionAdd:(BOOL)paramIsAdd{
    NSInteger rowForItem = paramIndex;
    if (paramIsAdd) {
        [errorCellArr addObject:[NSNumber numberWithInteger:rowForItem]];
    }else{
        [errorCellArr removeObject:[NSNumber numberWithInteger:rowForItem]];
    }
}
/**
 *  Method for creating TableView Cell at particular indexPath
 *
 *  @param indexPath indexPath
 *
 *  @return UITableViewCell
 */

-(UITableViewCell *)configureCell:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"editKeySkillInputCell";
        NGEditKeySkillInputCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.txtField.delegate = self;
        cell.txtField.tag = NGEditKeySkillsRowInput;
        [cell configureCell:editFieldTextValue];
        [cell.txtField setRightViewAsButtonImageAs:@"add" bounds:CGRectMake(0, 5, 35, 40) target:self];

        [cell.txtField removeTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addAutoCompleterForTextField:cell.txtField];
        if (isEditSkillModeActive)
            [cell.txtField becomeFirstResponder];
        [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];

        return cell;
    }else{
        static NSString *CellIdentifier = @"EditKeySkillsCell";
        
        NGEditKeySkillsCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil){
            cell = [[NGEditKeySkillsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
        }
        
        cell.delegate = self;
        cell.index = indexPath.row;
        [cell configureCell:[_keySkillsArr fetchObjectAtIndex:indexPath.row]];
        return cell;
    }
    
}

/**
 *  Method checks for valid key skill from _keySkillsArr value
 *
 *  @param keySkillStr NSString containing the skill
 *
 *  @return Boolean Value , If Yes  keys are valid
 */
-(BOOL)isValidKeySkill:(NSString *)keySkillStr{
    BOOL isValid = TRUE;
    
    if (keySkillStr.length>256) {
        isValid = FALSE;
    }
    
    return isValid;
    
}

/**
 *  Method uses  isValidKeySkill:(NSString *)keySkillStr
 *
 *  @return If Yes, the keys skill are Valid
 */
-(BOOL)isValidKeySkills{
    BOOL isValid = TRUE;
    
    isValid = [self isValidKeySkill:[NSString getStringsFromArray:_keySkillsArr]];
    
    return isValid;
}
/**
 *   UIAlertView  show error message on trigger of this method
 */
-(void)showError{
    
    [NGUIUtility showAlertWithTitle:@"Oops!!!" withMessage:[NSArray arrayWithObjects:@"You have exceeded the maximum length of 255 characters for Key Skills", nil] withButtonsTitle:@"OK" withDelegate:nil];
    isErrorInKeySkill = YES;

    
}
-(BOOL)isKeySkillLengthExceedByNewSkillArray:(NSArray*)paramNewArray{
    
    if (nil == paramNewArray) {
        return NO;
    }
    
    NSMutableArray *tmpKeySkillArray = [NSMutableArray arrayWithArray:paramNewArray];
    [tmpKeySkillArray addObjectsFromArray:_keySkillsArr];
    NSString *keySkillStringForValidation = [NSString getStringsFromArray:tmpKeySkillArray];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    BOOL isValidKeySkills = (0 >= [vManager validateValue:keySkillStringForValidation withType:ValidationTypeString].count);
    vManager = nil;
    
    if (isValidKeySkills) {
        if (KEY_SKILL_LIMIT < keySkillStringForValidation.length) {
            return YES;
        }
    }else{
        return NO;
    }
    
    return NO;
}
/**
 *  This method allows  adding of new skills in keySkills Array
 *
 *  @param sender  NGButton is added in TextField for editiing
 */
-(void)txtFldRightViewTapped:(id)sender{
    
    NSString *txt = editFieldTextValue;
    editFieldTextValue = @"";
    
    if (txt && ![txt isEqualToString:@""]){
        
        [self.view endEditing:YES];
        
        txt = [NSString stripTags:txt];
        txt = [NSString formatSpecialCharacters:txt];
        
        NSArray *keySkills = [txt componentsSeparatedByString:@","];
        
        //show error msg + maintain user string in text field
        BOOL isLengthExceed = [self isKeySkillLengthExceedByNewSkillArray:keySkills];
        if (YES == isLengthExceed) {
            
            editFieldTextValue = txt;
            
            [self showError];
            
            return;
        }
        
        keySkills = [self refineNewSkillsOnlyFromArray:keySkills];
        
        if (nil == keySkills) {
            if (isEditSkillModeActive) {
                isEditSkillModeActive = NO;
                [self removeBlurViewWithAnimation];
                [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 3/4"];
            }
            autoCompleter.hidden = YES;
            [self.editTableView reloadData];
            return;
        }else{
            if (isEditSkillModeActive) {
                if (2 <= [keySkills count]) {
                    NSString *newValueForEditedSkill = [keySkills firstObject];
                    
                    if (0>=[[ValidatorManager sharedInstance] validateValue:newValueForEditedSkill withType:ValidationTypeString].count) {
                        [_keySkillsArr replaceObjectAtIndex:_editKeySkillIndex withObject:newValueForEditedSkill];
                    }
                    NSArray *newKeySkills = [keySkills subarrayWithRange:NSMakeRange(1, [keySkills count]-1)];
                    if (nil != newKeySkills) {
                        [self addNewKeySkillsFromArray:keySkills];
                    }
                }else{
                    NSString *newValueForEditedSkill = [keySkills firstObject];
                    if (0>=[[ValidatorManager sharedInstance] validateValue:newValueForEditedSkill withType:ValidationTypeString].count) {
                        [_keySkillsArr replaceObjectAtIndex:_editKeySkillIndex withObject:newValueForEditedSkill];
                    }
                }
                
                isEditSkillModeActive = NO;
                [self removeBlurViewWithAnimation];
                [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 3/4"];
                
            }else{
                [self addNewKeySkillsFromArray:keySkills];
            }
            editFieldTextValue = nil;
            [_keySkillsArr removeDuplicateObjects];
            autoCompleter.hidden = YES;
            [self.editTableView reloadData];
        }
        
    }else{
        if (isEditSkillModeActive) {
            isEditSkillModeActive = NO;
            editFieldTextValue = nil;
            [self removeBlurViewWithAnimation];
            [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 3/4"];
        }
        autoCompleter.hidden = YES;
        [self.editTableView reloadData];
    }
    
    if (0 < [_keySkillsArr count]) {
        [self setItem:0 InErrorCollectionWithActionAdd:NO];
    }
}
- (void)addNewKeySkillsFromArray:(NSArray*)paramNewKeySkills{
    NSMutableArray *indexPathArr = [[NSMutableArray alloc]init];
    
    NSInteger i = 0;
    
    NSArray *tempArr = [_keySkillsArr copy];
    
    for (NSString *str in paramNewKeySkills) {
        
        NSString *trimmedString = [str trimCharctersInSet :
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(trimmedString)
        if (![trimmedString isEqualToString:@""] && ![_keySkillsArr containsObject:trimmedString]) {
            [_keySkillsArr insertObject:trimmedString atIndex:0];
            
            [indexPathArr addObject:[NSIndexPath indexPathForRow:i inSection:1]];
            i++;
        }
        
    }
    
    if ([self isValidKeySkills]) {
        [self.editTableView reloadData];
    }else{
        [_keySkillsArr removeAllObjects];
        [_keySkillsArr addObjectsFromArray:tempArr];
        [self showError];
    }
}
- (NSArray*)refineNewSkillsOnlyFromArray:(NSArray*)paramNewSkill{
    NSMutableArray *uniqueSkills = [NSMutableArray new];
    for (NSString *tmpSkill in paramNewSkill) {
        NSString *tmpSkillNew = [tmpSkill trimCharctersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![@"" isEqualToString:tmpSkillNew] && ![self isKeySkillAlreadyPresent:tmpSkillNew]) {
            [uniqueSkills addObject:tmpSkillNew];
        }
        tmpSkillNew = nil;
    }
    if (0 >= [uniqueSkills count]) {
        uniqueSkills = nil;
    }
    return uniqueSkills;
}
-(BOOL)isKeySkillAlreadyPresent:(NSString*)paramNewKeySkill{
    BOOL isPresentFlag = NO;
    paramNewKeySkill = paramNewKeySkill.lowercaseString;
    
    for (NSString *newKeySkill in _keySkillsArr) {
        if ([newKeySkill.lowercaseString isEqualToString:paramNewKeySkill]) {
            isPresentFlag = YES;
            break;
        }
    }
    
    return isPresentFlag;
}
#pragma mark - Puclic Methods
/**
 *  @name Public Method
 */
/**
 *  Public Method initiated on  view appear and updates the textfield Values with NGMNJProfileModalClass object
 *
 *  @param obj a JsonModelObject contains predefined value for textField
 */

-(void)updateDataFromModel{
    _keySkillsArr = nil;
    
    _keySkillsArr = [NSMutableArray arrayWithArray:[resmanModel.keySkills componentsSeparatedByString:@", "]];
}
-(void)saveButtonPressed{
    
    
    editFieldTextValue = autoCompleter.textField.text;
    
    [self txtFldRightViewTapped:nil];
    [self hideKeyboardAndSuggester];
    
    if(isErrorInKeySkill == NO){
        [self staticTapped:nil];
    }
    else
        isErrorInKeySkill = NO;
}
#pragma Mark -
#pragma AutoCompletion code
- (AutocompletionTableView *)addAutoCompleterForTextField:(UITextField*)paramTextField{
    
    if (!autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        autoCompleter = [[AutocompletionTableView alloc] initWithTextField:paramTextField inViewController:self withOptions:options withDefaultStyle:NO];
        autoCompleter.autoCompleteDelegate = self;
        autoCompleter.isEmailAddressSuggestor = NO;
        autoCompleter.suggestionsDictionary = suggesterDataKeySkills;//will be same for both search and modify search
        
        [self.view addSubview:autoCompleter];
        
        [self addAutoCompletionConstaint];
        
        autoCompleter.isMultiSelect = YES;
        [paramTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    
    if (NO == [paramTextField respondsToSelector:@selector(textFieldValueChanged:)]) {
        [paramTextField addTarget:autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return autoCompleter;
}
-(NSArray *)getSuggestors
{
    NGStaticContentManager* staticContentManager=[DataManagerFactory getStaticContentManager];
    NSArray* suggestors = [staticContentManager getSuggestedKeySkillsWithFrequency:K_KEYWORDS_SUGGESTOR_KEY];
    return suggestors;
    
}-(void) addAutoCompletionConstaint {
    
    NSLayoutConstraint *autoCompletionLeftConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSInteger yForAutoCompletionTable = 49;
    NSLayoutConstraint *autoCompletionTopConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:yForAutoCompletionTable];
    
    NSLayoutConstraint *autoCompletionRightConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *autoCompletionWidthConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    autoCompletionHeightConstraints = [NSLayoutConstraint constraintWithItem:autoCompleter attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:600.0];
    
    
    [self.view addConstraint:autoCompletionLeftConstraints];
    [self.view addConstraint:autoCompletionTopConstraints];
    
    [self.view addConstraint:autoCompletionRightConstraints];
    [self.view addConstraint:autoCompletionWidthConstraints];
    [self.view addConstraint:autoCompletionHeightConstraints];
    
    [self.view setNeedsLayout];
}
- (void)updateAutoCompletionTableViewConstraintWithNewFrame:(CGRect)paramNewFrame{
    
    if (CGRectEqualToRect(CGRectZero, paramNewFrame)) {
        autoCompletionHeightConstraints.constant = 600;
    }else{
        autoCompletionHeightConstraints.constant = paramNewFrame.size.height;
    }
    [autoCompleter updateConstraints];
    [[self view] setNeedsLayout];
}
- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    
    return  suggesterDataKeySkills;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withSelectedtext:(NSString *)selectedText {
    
    editFieldTextValue = selectedText;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    
    if([indexPath section] == 0 || [_keySkillsArr count] == 0){
        return NO;
    }else{
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteKeySkillAtIndex:[indexPath row]];
    }
}
-(void)hideKeyboardAndSuggester{
    
    [self.view endEditing:YES];
    [self hideSuggesterBackGrndView:YES];
    
    //auto completion row to 0, so that
    //pre-populated values dont get visible
    [autoCompleter clearAutoCompletionTable];
}
-(void)hideSuggesterBackGrndView:(BOOL)status{
    [autoCompleter setHidden:status];
}
@end