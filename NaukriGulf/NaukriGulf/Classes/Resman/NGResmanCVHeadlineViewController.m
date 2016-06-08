//
//  NGResmanCVHeadlineViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/4/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanCVHeadlineViewController.h"
#import "NGEditProfileTextviewCell.h"
#import "NGResmanPhotoViewController.h"

#define CV_HEADLINE_LABEL 123

@interface NGResmanCVHeadlineViewController ()<EditProfileTextViewCellDelegate>{
    
    NSInteger characterLeft;
    NSString *resumeHeadline;
    NGResmanDataModel *resmanModel;
    BOOL editMode;
    UIPlaceHolderTextView *txtView;
    UIButton *lblBottomContent;
    
}

@end


@implementation NGResmanCVHeadlineViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    [self setSaveButtonTitleAs:@"Next"];
    if (self.isRemindMeLaterSuccessful) {
       
        [NGMessgeDisplayHandler showSuccessBannerFromTopWindow:[UIApplication sharedApplication].keyWindow title:@"" subTitle:@"Reminder email sent successfully" animationTime:5 showAnimationDuration:0];
        
    }
    self.editTableView.alwaysBounceVertical = NO;
    self.editTableView.scrollEnabled= FALSE;
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(self.isSwipePopDuringTransition)
        return;
    
    [self addNavigationBarWithBackAndRightButtonTitle:@"Next" WithTitle:@"Review Headline"];
    
    editMode = FALSE;
    [self setDefaultValues];
    [self addBottomView];
    [self addHelpText];
    [NGDecisionUtility checkNetworkStatus];

}

-(void) viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;

    [super viewDidAppear:animated];
    
    if (resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_CV_HEADLINE_FRESHER];
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_CV_HEADLINE_EXPERIENCED];
    }
    
    [self setAutomationLabel];

}



-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"edit_CVHeadline_table"] forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
}

-(void) setDefaultValues {
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    resumeHeadline = resmanModel.cvHeadline;
    characterLeft = K_RESUME_HEADLINE_LIMIT - resumeHeadline.length;
    
    characterLeft = characterLeft<0?0:characterLeft;
    
    [self.editTableView reloadData];
}

-(void) addHelpText {
    
       UILabel *lblBottom = [[UILabel alloc] init];
        NSString *contentString = @"This will be visible on your Profile to Employers. A good CV Headline can get you Shortlisted";

        [lblBottom setText:contentString];
    
        CGFloat colorCode = 122.0f/255.0f;
        [lblBottom setTextColor:[UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f]];
    
        [lblBottom setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:12.0f]];
        [lblBottom setNumberOfLines:0];
        [lblBottom setLineBreakMode:NSLineBreakByWordWrapping];
        [lblBottom setBackgroundColor:[UIColor clearColor]];
        [lblBottom setTextAlignment:NSTextAlignmentCenter];
        [lblBottom setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view insertSubview:lblBottom aboveSubview:self.editTableView];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:lblBottom attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:lblBottom attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_WIDTH-20];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:lblBottom attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.saveBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:lblBottom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:70];
        
        [self.view addConstraint:leadingConstraint];
        [self.view addConstraint:widthConstraint];
        [self.view addConstraint:bottomConstraint];
        [self.view addConstraint:heightConstraint];
        
        [self.view layoutIfNeeded];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NGCustomValidationCell *cell = (NGCustomValidationCell*)[self configureCell:indexPath];
    [self customizeValidationErrorUIForIndexPath:indexPath cell:cell];
    
    return cell;
}

-(void)addBottomView{
    
    if (nil == lblBottomContent) {
        lblBottomContent = [[UIButton alloc] init];
        
        NSString *contentString = @"Edit CV Headline";
        
        
        [lblBottomContent setTitleColor:[UIColor colorWithRed:2.0/255.0 green:102.0/255.0 blue:190/255.0 alpha:1.0] forState:UIControlStateNormal];
        [lblBottomContent setBackgroundColor:[UIColor clearColor]];
        [lblBottomContent setTranslatesAutoresizingMaskIntoConstraints:NO];
        [lblBottomContent addTarget:self action:@selector(editHeadlineClicked:) forControlEvents:UIControlEventTouchUpInside];
        lblBottomContent.userInteractionEnabled = YES;
        lblBottomContent.titleLabel.font =[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0f];
        [lblBottomContent setTitle:contentString forState:UIControlStateNormal];
        
        [self.view insertSubview:lblBottomContent aboveSubview:self.editTableView];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:lblBottomContent attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:lblBottomContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_WIDTH-40];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:lblBottomContent attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:190];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:lblBottomContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:25];
        
        [self.view addConstraint:leadingConstraint];
        [self.view addConstraint:widthConstraint];
        [self.view addConstraint:bottomConstraint];
        [self.view addConstraint:heightConstraint];
        
        [self.view layoutIfNeeded];
    }
    else{
    
        NSString *contentString = @"Edit CV Headline";
        [lblBottomContent setTitle:contentString forState:UIControlStateNormal];
    }
}

-(void)editHeadlineClicked : (id) sender{
    
    [self.view endEditing:YES];
    UIButton *editBtn = (UIButton*) sender;
    editMode = !editMode;
    if (editMode) {
        
        [editBtn setTitle:@"Undo Changes" forState:UIControlStateNormal];
    }
    else{
        resumeHeadline = resmanModel.cvHeadline;
        [editBtn setTitle:@"Edit CV Headline" forState:UIControlStateNormal];
        
    }
    [self.editTableView reloadData];
    
}
- (UITableViewCell*)configureCell:(NSIndexPath*)indexPath{
    
    
    NSInteger row =[self getRowForIndexpath:indexPath];
    
    switch (row) {
        case 0: {
            
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
   
            [cell configureEditProfileTextviewCell:dictToPass];
            dictToPass = nil;
            txtView = cell.txtview;
            [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:.1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [UIAutomationHelper setAccessibiltyLabel:@"resumeHeadline_cell" forUIElement:cell withAccessibilityEnabled:NO];
            [UIAutomationHelper setAccessibiltyLabel:@"resumeHeadline_txtView" value:cell.txtview.text forUIElement:cell.txtview];
            
            return cell;
            break;
        }
            
            
         case 1:
        {
            
            static NSString *CellIdentifier = @"Description";
            UILabel *alertLabel;
            NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:CellIdentifier];
           
            if(cell==nil){
                cell = [[NGCustomValidationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,300,120)];
                alertLabel.numberOfLines = 0;
                alertLabel.font= [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                alertLabel.tag = CV_HEADLINE_LABEL;
                [cell.contentView addSubview:alertLabel];
                }
            alertLabel = (UILabel*) [cell.contentView viewWithTag:CV_HEADLINE_LABEL];
            
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\u201C  %@  \u201D",resmanModel.cvHeadline]];
            alertLabel.attributedText = string;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [UIAutomationHelper setAccessibiltyLabel:@"resumeHeadlineDesc_cell" forUIElement:cell withAccessibilityEnabled:NO];
            [UIAutomationHelper setAccessibiltyLabel:@"resumeHeadline_lbl" value:alertLabel.text forUIElement:alertLabel];
 
            
            return cell;
        }
            
        default:
            break;
    }
    
    return nil;
}

-(void) showKeyboard {
    
    [txtView becomeFirstResponder];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
 
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

-(NSInteger) getRowForIndexpath:(NSIndexPath*) index {
    
         if (editMode) {
            
            return index.row;
        }
        
        return (index.row +1 );
    
}

- (void)textViewDidEndEditing:(NSString *)textViewValue havingIndex:(NSInteger)index{
    
    if (textViewValue.length > K_RESUME_HEADLINE_LIMIT){
            resumeHeadline = [textViewValue substringToIndex:K_RESUME_HEADLINE_LIMIT];
    }else {
    
        resumeHeadline = textViewValue;
  
        [UIAutomationHelper setAccessibiltyLabel:@"resumeHeadline_txtView" value:resumeHeadline forUIElement:txtView];
        
    }
    resumeHeadline = [NSString stripTags:textViewValue];
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
-(void)saveButtonPressed {
    
    [self saveButtonTapped:nil];
    
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
        
        [NGUIUtility showAlertWithTitle:@"Incomplete Details" withMessage:
         [NSArray arrayWithObjects:errorMessage, nil]
                    withButtonsTitle:@"OK" withDelegate:nil];
        
        
    }else {
        
        [self showAnimator];

        NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_UPDATE_RESUME];
         __weak NGResmanCVHeadlineViewController *weakSelf = self;
        NSMutableDictionary *params = [self getParametersInDictionary];

        [obj getDataWithParams:params handler:^(NGAPIResponseModal *responseInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf hideAnimator];
                
                if (responseInfo.isSuccess) {
                    
                    if (resmanModel.isFresher) {
                        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_CV_HEADLINES_EDITED_FRESHER withEventLabel:K_GA_RESMAN_EVENT_CV_HEADLINES_EDITED_FRESHER withEventValue:nil];
                    }else{
                        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_CV_HEADLINES_EDITED_EXPERIENCED withEventLabel:K_GA_RESMAN_EVENT_CV_HEADLINES_EDITED_EXPERIENCED withEventValue:nil];
                    }
                 
                    resmanModel.cvHeadline = resumeHeadline;
                    [[DataManagerFactory getStaticContentManager]saveResmanFields:resmanModel];

                    NGResmanPhotoViewController* vc = [[NGHelper sharedInstance].editFlowStoryboard instantiateViewControllerWithIdentifier:@"ResmanProfilePhoto"];
                    
                    [(IENavigationController*)self.navigationController pushActionViewController:vc Animated:YES];
                    
                
                }else{
               
                    NSString *errorMsg = @"Some problem occurred at server";
                    
                    [NGUIUtility showAlertWithTitle:@"Error" withMessage:[NSArray arrayWithObject:errorMsg] withButtonsTitle:@"Ok" withDelegate:nil];
                    
                }
                
            });
            
            
        }];
        
    
    }
    
}

- (void)saveButtonTapped:(id)sender{
    
    [self.view endEditing:YES];
    
}

-(NSMutableArray*) checkAllValidations {
    
    NSMutableArray *arr = [NSMutableArray array];
    [errorCellArr removeAllObjects];
    ValidatorManager *vManager = [ValidatorManager sharedInstance];
    if (0 < [vManager validateValue:resumeHeadline withType:ValidationTypeString].count) {
        
        [arr addObject:@"CV Headline"];
        [errorCellArr addObject:[NSNumber numberWithInt:1]];
        
    }
 
    return arr;
}

@end
