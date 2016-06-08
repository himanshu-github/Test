//
//  NGResmanExpProfessionalDetailsViewController.m
//  NaukriGulf
//
//  Created by Sandeep.Negi on 13/01/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanExpProfessionalDetailsViewController.h"
#import "NGValueSelectionViewController.h"
#import "NGResmanKeySkillsViewController.h"
#import "DDIndustryType.h"
#import "DDFArea.h"
#import "Designation.h"
#import "CompanyName.h"

typedef NS_ENUM(NSUInteger, kResmanExpProfessionalDetailType){
    kResmanExpProfessionalDetailTypeIndustry,
    kResmanExpProfessionalDetailTypeFA
};
typedef NS_ENUM(NSUInteger, kResmanExpProfessionalDetailFieldTag) {
    kResmanExpBasicDetailFieldTagIndustry=1,
    kResmanExpBasicDetailFieldTagIndustryOther,
    kResmanExpBasicDetailFieldTagFA,
    kResmanExpBasicDetailFieldTagFAOther
};


@interface NGResmanExpProfessionalDetailsViewController ()<ProfileEditCellDelegate,ValueSelectorDelegate>{
    
    NGResmanDataModel *resmanModel;
    NSMutableArray *ddContentArr;
    BOOL isValueSelectorExist; // Check isValueSelectorExist on right side of panel
    NSMutableDictionary *selectedIndustry;
    NSString *otherIndustry;
    BOOL isOtherIndustryExists;
    
    NSMutableDictionary *selectedFA;
    NSString *otherFA;
    BOOL isOtherFAExists;
    
    UIView *sectionFooterView;
}
@property (nonatomic, strong) NGValueSelectionViewController *valueSelector; // a selection View controller appears on right side

@end

@implementation NGResmanExpProfessionalDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isValueSelectorExist    =   NO;
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    

}
-(void)viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    
    [self.scrollHelper listenToKeyboardEvent:YES];
    self.scrollHelper.headerHeight = RESMAN_HEADER_CELL_HEIGHT;
    self.scrollHelper.rowHeight = 75;
    
    [[NGResmanNotificationHelper sharedInstance] setCurrentPage:NGResmanPageExperienceProfessionalDetails];
    
    [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_INDUSTRY_EXPERIENCED];
    
    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Step 2/4"];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    isOtherIndustryExists = NO;
    isOtherFAExists = NO;
    [self setSaveButtonTitleAs:@"Next"];
    
    if (resmanModel) {
        
        if ([resmanModel.industry objectForKey:KEY_ID]) {
            selectedIndustry = resmanModel.industry;
        }else{
            selectedIndustry = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_ID,@"",KEY_VALUE,@"",KEY_SUBVALUE, nil];
        }
        [self setOtherFieldForValue:selectedIndustry AndType:kResmanExpProfessionalDetailTypeIndustry];
        
        if ([resmanModel.functionalArea objectForKey:KEY_ID]) {
            selectedFA = resmanModel.functionalArea;
        }else{
            selectedFA = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",KEY_ID,@"",KEY_VALUE,@"",KEY_SUBVALUE, nil];
        }
        [self setOtherFieldForValue:selectedFA AndType:kResmanExpProfessionalDetailTypeFA];
    }

    [errorCellArr removeAllObjects];
    [self.editTableView reloadData];
    [NGDecisionUtility checkNetworkStatus];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.scrollHelper listenToKeyboardEvent:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    float sectionHeight = 0.0f;
    if (0 == section) {
        sectionHeight = 70;
    }
    return sectionHeight;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(sectionFooterView!=nil)
        sectionFooterView = nil;
    
    if (nil == sectionFooterView) {
        sectionFooterView = [[UIView alloc] init];
        sectionFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
        sectionFooterView.backgroundColor = [UIColor whiteColor];
        UILabel *lblBottomContent = [[UILabel alloc] init];
        lblBottomContent.frame = CGRectMake(15, 0, sectionFooterView.frame.size.width-30, sectionFooterView.frame.size.height);
        NSString *contentString = @"e.g. If you work as an Accountant in Bank, then\r\n Department is Accounts/Tax/CS/Audit \r\nIndustry is Banking/Broking/Financials";
        NSMutableAttributedString *stringToDisplay = [[NSMutableAttributedString alloc] initWithString:contentString];

        [stringToDisplay beginEditing];
        NSRange rangeVar = [contentString rangeOfString:@"Accountant in Bank,"];
        [stringToDisplay addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:12] range:rangeVar];
        [stringToDisplay addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:rangeVar];
        
        rangeVar = [contentString rangeOfString:@"Accounts/Tax/CS/Audit"];
        [stringToDisplay addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:12] range:rangeVar];
        [stringToDisplay addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:rangeVar];
        
        rangeVar = [contentString rangeOfString:@"Banking/Broking/Financials"];
        [stringToDisplay addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:12] range:rangeVar];
        [stringToDisplay addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:rangeVar];
        [stringToDisplay endEditing];
        
        CGFloat colorCode = 122.0f/255.0f;
        [lblBottomContent setTextColor:[UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f]];
        [lblBottomContent setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:12.0f]];
        [lblBottomContent setNumberOfLines:0];
        [lblBottomContent setLineBreakMode:NSLineBreakByWordWrapping];
        [lblBottomContent setBackgroundColor:[UIColor clearColor]];
        [lblBottomContent setTextAlignment:NSTextAlignmentCenter];
        [lblBottomContent setAttributedText:stringToDisplay];
        lblBottomContent.tag = 990;
        [sectionFooterView addSubview:lblBottomContent];
        self.scrollHelper.tableViewFooter = sectionFooterView;
    }
    return sectionFooterView;
}
-(void)setOtherFieldForValue:(NSMutableDictionary*)paramValue AndType:(kResmanExpProfessionalDetailType)paramType{
    BOOL resultFlag = NO;
    
    NSUInteger keyId = 0;
    @try {
        keyId = [[paramValue objectForKey:KEY_ID] intValue];
    }
    @catch (NSException *exception) {
    }
    
    if (1000 == keyId && [@"other" isEqualToString:((NSString*)[paramValue objectForKey:KEY_VALUE]).lowercaseString]) {
        resultFlag = YES;
    }
    
    if (kResmanExpProfessionalDetailTypeIndustry == paramType) {
        isOtherIndustryExists = resultFlag;
        if (!isOtherIndustryExists) {
            [selectedIndustry setCustomObject:@"" forKey:KEY_SUBVALUE];
        }
    }else if (kResmanExpProfessionalDetailTypeFA == paramType){
        isOtherFAExists = resultFlag;
        if (!isOtherFAExists) {
            [selectedFA setCustomObject:@"" forKey:KEY_SUBVALUE];
        }
    }else{
        //dummy
    }
}
- (NSMutableArray*)checkAllValidations{
    [errorCellArr removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    
    if (0 < [vManager validateValue:[selectedIndustry objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Industry Area"];
        [self setItem:kResmanExpBasicDetailFieldTagIndustry InErrorCollectionWithActionAdd:YES];
    }
    
    if (isOtherIndustryExists && 0 < [vManager validateValue:[selectedIndustry objectForKey:KEY_SUBVALUE] withType:ValidationTypeString].count){
        
        [arr addObject:@"Industry Area"];
        [self setItem:kResmanExpBasicDetailFieldTagIndustryOther InErrorCollectionWithActionAdd:YES];
    }
    
    if (0 < [vManager validateValue:[selectedFA objectForKey:KEY_ID] withType:ValidationTypeString].count){
        
        [arr addObject:@"Function/Department"];
        [self setItem:kResmanExpBasicDetailFieldTagFA InErrorCollectionWithActionAdd:YES];
    }
    
    if (isOtherFAExists && 0 < [vManager validateValue:[selectedFA objectForKey:KEY_SUBVALUE] withType:ValidationTypeString].count){
        
        [arr addObject:@"Function/Department"];
        [self setItem:kResmanExpBasicDetailFieldTagFAOther InErrorCollectionWithActionAdd:YES];
    }
    
    if([arr count]>3){
        for (int i =3; i< [arr count]; i++)[arr removeObjectAtIndex:i];
    }
    
    [self.editTableView reloadData];
    
    return arr;
}

- (void)setItem:(NSInteger)paramIndex InErrorCollectionWithActionAdd:(BOOL)paramIsAdd{
    NSInteger rowForItem = [self rowIndexForErrorBarForIndex:paramIndex];
    if (paramIsAdd) {
        [errorCellArr addObject:[NSNumber numberWithInteger:rowForItem]];
    }else{
        [errorCellArr removeObject:[NSNumber numberWithInteger:rowForItem]];
    }
}
-(NSInteger)rowIndexForErrorBarForIndex:(NSInteger)paramIndex{
    if (kResmanExpBasicDetailFieldTagFA == paramIndex || kResmanExpBasicDetailFieldTagFAOther == paramIndex) {
        if (!isOtherIndustryExists) {
            paramIndex--;
        }
    }
    return paramIndex;
}
-(void)saveButtonPressed
{
    [self.view endEditing:YES];
    
    NSString *errorTitle = @"Invalid Details";
    NSMutableArray *arrValidations = [self checkAllValidations];
    NSString *errorMessage = @"Please specify ";
    if([arrValidations count]){
        
        for (int i = 0; i< [arrValidations count]; i++) {
            
            if (i == [arrValidations count]-1)
                errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@",
                                                                      [arrValidations fetchObjectAtIndex:i]]];
            else
                errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@"%@, ",
                                                                      [arrValidations fetchObjectAtIndex:i]]];
        }
        
        [NGUIUtility showAlertWithTitle:errorTitle withMessage:
         [NSArray arrayWithObjects:errorMessage, nil]
                    withButtonsTitle:@"OK" withDelegate:nil];
        
        
    }else{
        //preventing double click of user on nav bar next button
        if (!self.isRequestInProcessing) {
            [self setIsRequestInProcessing:YES];
            
            resmanModel.industry = selectedIndustry;
            resmanModel.functionalArea = selectedFA;
            
            [self setIsRequestInProcessing:NO];
            
            [self extractPredictedIndustryForGA];
            
            [self extractPredictedFAForGA];
            
            [[DataManagerFactory getStaticContentManager] saveResmanFields:resmanModel];
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY_PREDICTOR_SELECTION withEventAction:K_GA_EVENT_INDUSTRY_SELECTED withEventLabel:nil withEventValue:nil];
            
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY_PREDICTOR_SELECTION withEventAction:K_GA_EVENT_FA_SELECTED withEventLabel:nil withEventValue:nil];
            
            NGResmanKeySkillsViewController *skillVc = [[NGResmanKeySkillsViewController alloc] init];
            [(IENavigationController*)self.navigationController pushActionViewController:skillVc Animated:YES];
            
        }
    }
    
}

-(void)extractPredictedFAForGA
{
    NSArray* ddDesignationArr = [NGDatabaseHelper searchForType:KEY_VALUE havingValue:resmanModel.designation andClass:[DDBase classForDDType:DDC_DESIGNATION]];
    if(ddDesignationArr.count>0){
        Designation *designationObj = [ddDesignationArr fetchObjectAtIndex:0];
        
        NSArray *predictedFAArr = [designationObj.sortedFA_ID componentsSeparatedByString:@","];
        NSNumber *selectedIndex = nil;
        
        for (int i = 0; i < [predictedFAArr count]; i++) {
            if ([predictedFAArr[i] isEqual:[selectedFA objectForKey:KEY_ID]])
            {
                selectedIndex = [NSNumber numberWithInt:i+1];
                break;
            }
        }
        
        if (selectedIndex) {
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY_PREDICTOR_SELECTION withEventAction:K_GA_EVENT_PREDICTED_FA_SELECTED withEventLabel:[NSString stringWithFormat:@"Value: %@ at index: %@", [selectedFA objectForKey:KEY_VALUE], selectedIndex] withEventValue:nil];
        }
    }
}

-(void)extractPredictedIndustryForGA
{
    NSArray* ddCompanyArr = [NGDatabaseHelper searchForType:KEY_VALUE havingValue:resmanModel.company andClass:[DDBase classForDDType:DDC_COMPANY]];
    if(ddCompanyArr.count>0){
        CompanyName *compObj = [ddCompanyArr fetchObjectAtIndex:0];
        
        NSArray *predictedIndustryArr = [compObj.sortedIA_ID componentsSeparatedByString:@","];
        NSNumber *selectedIndex = nil;
        
        for (int i = 0; i < [predictedIndustryArr count]; i++) {
            if ([predictedIndustryArr[i] isEqual:[selectedIndustry objectForKey:KEY_ID]])
            {
                selectedIndex = [NSNumber numberWithInt:i+1];
                break;
            }
        }
        
        if (selectedIndex) {
            [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY_PREDICTOR_SELECTION withEventAction:K_GA_EVENT_PREDICTED_INDUSTRY_SELECTED withEventLabel:[NSString stringWithFormat:@"Value: %@ at index: %@", [selectedIndustry objectForKey:KEY_VALUE], selectedIndex] withEventValue:nil];
        }
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger noOfRows = 0;
    if (isOtherIndustryExists && isOtherFAExists) {
        noOfRows = 5;
    }else if (isOtherIndustryExists || isOtherFAExists){
        noOfRows = 4;
    }else{
        noOfRows = 3;
    }
    return noOfRows;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        
        NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:@"" ];
        if (cell == nil)
        {
            cell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            txtLabel.textAlignment = NSTextAlignmentCenter;
            [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
            txtLabel.text =@"Your Professional Details";
            txtLabel.textColor = [UIColor darkGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:txtLabel];
            return cell;
        }
        
    }else{
        NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
        [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
        return cell;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0==indexPath.row) {
        return RESMAN_HEADER_CELL_HEIGHT;
    }
    return 75;
}
- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    static NSString* cellIndentifier = @"EditProfileCell";
    NGProfileEditCell* cell = [self.editTableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.editModuleNumber = k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL;
    cell.delegate = self;
    
    [cell.txtTitle setTextColor:[UIColor darkTextColor]];
    [cell.lblOtherTitle setTextColor:[UIColor darkGrayColor]];
    
    
    
    NSInteger rowIndex = [self rowIndexForIndexPath:indexPath];
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    cell.otherDataStr = nil;
    
    switch (rowIndex) {
        case kResmanExpBasicDetailFieldTagIndustry:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[selectedIndustry objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];

            
        }break;
            
        case kResmanExpBasicDetailFieldTagIndustryOther:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:isOtherIndustryExists?[selectedIndustry objectForKey:KEY_SUBVALUE]:@"" forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];

        }break;
            
        case kResmanExpBasicDetailFieldTagFA:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:[selectedFA objectForKey:KEY_VALUE] forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];


        }break;
            
        case kResmanExpBasicDetailFieldTagFAOther:{
            
            NSMutableDictionary *dictToPass = [NSMutableDictionary dictionary];
            [dictToPass setCustomObject:isOtherFAExists?[selectedFA objectForKey:KEY_SUBVALUE]:@"" forKey:@"data"];
            [dictToPass setCustomObject:[NSString stringWithFormat:@"%i",k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL] forKey:@"ControllerName"];
            cell.index = indexPath.row;
            [cell configureEditProfileCellWithData:dictToPass andIndex:rowIndex];

        }break;
        default:
            break;
    }
    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //We need to hide keyboard, hence we required this
    [self.view endEditing:YES];
    
    NSInteger rowSelected = [self rowIndexForIndexPath:indexPath];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    switch (rowSelected) {
        case kResmanExpBasicDetailFieldTagIndustry:{
            //industry
            isValueSelectorExist = YES;
            //_valueSelector = nil;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            
            if(0>=[vManager validateValue:[selectedIndustry objectForKey:KEY_ID] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[selectedIndustry objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_INDUSTRY_TYPE;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
            
        }break;
            
        case kResmanExpBasicDetailFieldTagFA:{
            //functional area
            //single value selector
            isValueSelectorExist = YES;
            //_valueSelector = nil;
            if (!_valueSelector){
                _valueSelector = [[NGHelper sharedInstance].genericStoryboard  instantiateViewControllerWithIdentifier:@"ValueSelectionView"];
                _valueSelector.delegate = self;
            }
            [APPDELEGATE.container setRightMenuViewController:_valueSelector];
            APPDELEGATE.container.rightMenuPanEnabled = NO;
            
            if(0>=[vManager validateValue:[selectedFA objectForKey:KEY_VALUE] withType:ValidationTypeString].count)
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:[selectedFA objectForKey:KEY_ID]];
            else
                _valueSelector.arrPreSelectedIds = [NSMutableArray arrayWithObject:
                                                    @""];

            _valueSelector.dropdownType = DDC_FAREA;
            [_valueSelector displayDropdownData];

            [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
            
        }
            break;
            
        default:
            break;
    }
    vManager = nil;
    
}

#pragma mark ValueSelector Delegate
/**
 *  @name Value Selector Delegate
 */
-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag{
    if (successFlag) {
        [self handleDDOnSelection:responseParams];
    }

    [APPDELEGATE.container toggleRightSideMenuCompletion:nil];
    //[delegate.container setRightMenuViewController:nil];
    [self.editTableView reloadData];
    
}
/**
 *  method created for updating the textField  with response
 *
 *  @param responseParams NSDictionary class
 */
-(void)handleDDOnSelection:(NSDictionary *)responseParams{
    
    NSInteger ddType = [[responseParams objectForKey:K_DROPDOWN_TYPE]integerValue];
    NSArray *arrSelectedIds = [responseParams objectForKey:K_DROPDOWN_SELECTEDIDS];
    NSArray* arrSelectedValues = [responseParams objectForKey:K_DROPDOWN_SELECTEDVALUES];
    switch (ddType) {
        case DDC_INDUSTRY_TYPE:{
        
            if (arrSelectedIds.count>0) {
                [selectedIndustry setValue:[arrSelectedValues fetchObjectAtIndex:0] forKey:KEY_VALUE];
                [selectedIndustry setValue:[arrSelectedIds fetchObjectAtIndex:0] forKey:KEY_ID];
                [self setItem:kResmanExpBasicDetailFieldTagIndustry InErrorCollectionWithActionAdd:NO];
            }else{
                [selectedIndustry setValue:@"" forKey:KEY_ID];
                [selectedIndustry setValue:@"" forKey:KEY_VALUE];
            }
            [self setOtherFieldForValue:selectedIndustry AndType:kResmanExpProfessionalDetailTypeIndustry];
            [resmanModel setIndustry:selectedIndustry];
            break;
        }
            
        case DDC_FAREA:{
     
         
            if (arrSelectedIds.count>0) {
                [selectedFA setValue:[arrSelectedValues fetchObjectAtIndex:0] forKey:KEY_VALUE];
                [selectedFA setValue:[arrSelectedIds fetchObjectAtIndex:0] forKey:KEY_ID];
                
                [self setItem:kResmanExpBasicDetailFieldTagFA InErrorCollectionWithActionAdd:NO];
                
            }else{
                [selectedFA setValue:@"" forKey:KEY_ID];
                [selectedFA setValue:@"" forKey:KEY_VALUE];
            }
            
            [self setOtherFieldForValue:selectedFA AndType:kResmanExpProfessionalDetailTypeFA];
            [resmanModel setFunctionalArea:selectedFA];
            break;
        }
            
        default:
            break;
    }
}
- (void)textFieldDidStartEditing:(UITextField*)textField havingIndex:(NSInteger)index{
    if(textField.tag == kResmanExpBasicDetailFieldTagIndustryOther || textField.tag == kResmanExpBasicDetailFieldTagFAOther){
        self.scrollHelper.rowType = NGScrollRowTypeNormal;
        self.scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:index inSection:0];
    }else{
        //dummy
    }
}
- (void)textFieldDidEndEditing:(UITextField*)textField WithValue:(NSString *)textFieldValue havingIndex:(NSInteger)index{
    [self saveOtherValueForTextField:textField];
}
- (void)textFieldDidReturn:(UITextField*)textField forIndex:(NSInteger)index{
    [self saveOtherValueForTextField:textField];
}
-(void)saveOtherValueForTextField:(UITextField*)paramTextField{
    if(paramTextField.tag == kResmanExpBasicDetailFieldTagIndustryOther && isOtherIndustryExists){
        [selectedIndustry setCustomObject:[NSString stripTags:paramTextField.text] forKey:KEY_SUBVALUE];
    }else if(paramTextField.tag == kResmanExpBasicDetailFieldTagFAOther && isOtherFAExists){
        [selectedFA setCustomObject:[NSString stripTags:paramTextField.text] forKey:KEY_SUBVALUE];
    }else{
        //dummy
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)rowIndexForIndexPath:(NSIndexPath*)paramIndexPath{
    NSInteger rowToShow = [paramIndexPath row];
    if(isOtherIndustryExists && isOtherFAExists){
        return rowToShow;
    }else if (rowToShow>=2 && (!isOtherIndustryExists||isOtherFAExists)) {
        rowToShow++;
    }
    return rowToShow;
}
@end
