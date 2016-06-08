//
//  NIProfileEditCell.m
//  Naukri
//
//  Created by Arun Kumar on 2/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
#import "NGProfileEditCell.h"


typedef enum{
    BasicDetailsTagName = 1,
    BasicDetailsTagDesignation,
    BasicDetailsTagLocation,
    BasicDetailsTagOtherLocation,
    BasicDetailsTagVisaStatus,
    BasicDetailsTagVisaDate,
    BasicDetailsTagExperience,
    BasicDetailsTagSalary,
    BasicDetailsTagCurrency
}BasicDetailsTag;


enum {
    
    ROW_TYPE_COURSE_TYPE = 0,
    ROW_TYPE_OTHER_COURSE_TYPE,
    ROW_TYPE_SPECIALISATION,
    ROW_TYPE_OTHER_SPECIALISATION,
    ROW_TYPE_YEAR_OF_GRAD,
    ROW_TYPE_COUNTRY,
    
    
};

enum {
    
    ROW_TYPE_DESIGNATION = 0,
    ROW_TYPE_ORGANISATOIN,
    ROW_TYPE_CURRENT_COMPANY,
    ROW_TYPE_START_DATE,
    ROW_TYPE_TILL_DATE,
    ROW_TYPE_JOB_PROFILE,
    ROW_TYPE_REMOVE_EXPERIENCE
    
};//editworkexperience

typedef NS_ENUM(NSUInteger, kResmanExpBasicDetailFieldTag) {
    kResmanExpBasicDetailFieldTagPageHeader=0,
    kResmanExpBasicDetailFieldTagTotalExp,
    kResmanExpBasicDetailFieldTagDesignation,
    kResmanExpBasicDetailFieldTagCompany,
    kResmanExpBasicDetailFieldTagCurrency,
    kResmanExpBasicDetailFieldTagCurrentSalary
};//resmanexpbasicdetails

typedef NS_ENUM(NSUInteger, kResmanExpProfessionalDetailFieldTag) {
    kResmanExpBasicDetailFieldTagIndustry=1,
    kResmanExpBasicDetailFieldTagIndustryOther,
    kResmanExpBasicDetailFieldTagFA,
    kResmanExpBasicDetailFieldTagFAOther
};//resmanexpprofessionaldetails

typedef enum : NSUInteger {
    CellTypePageHeading=0,
    CellTypeHighestEducation,
    CellTypePPGCourse,
    CellTypePPGSpecialization,
    CellTypePGCourse,
    CellTypePGSpecialization,
    CellTypeUGCourse,
    CellTypeUGSpecialization,
} CellType;//resmanfresshereducation

enum{
    
    ROW_TYPE_PREFERRED_LOCATION,
    ROW_TYPE_AVAILIBILITY_TO_JOIN
};//resmanjobpreferencsevc

enum {
    
    ROW_TYPE_CELL_HEADING = 0,
    ROW_TYPE_USERNAME ,
    ROW_TYPE_PASSWORD,
    
};//resmanlogindetailsvc

typedef NS_ENUM(NSUInteger, kResmanPreviousWorkExpFieldTag) {
    kResmanPreviousWorkExpFieldTagDesignation=1,
    kResmanPreviousWorkExpFieldTagPreviousCompany=2
};//resmanpreviousworkexpVC

enum{
    
    ROW_TYPE_BASIC_EDUCATION_UNREG,
    ROW_TYPE_MASTER_EDUCATION_UNREG,
    ROW_TYPE_DOCTORATE_EDUCATION_UNREG,
    ROW_TYPE_CURRENT_LOCATION_UNREG,
    ROW_TYPE_NATIONALITY_UNREG,
    ROW_TYPE_DESIGNATION_UNREG
    
};//unregApplyForFresherAndExperience


typedef enum{
    
    ROW_TYPE_NAME,
    ROW_TYPE_EMAIL,
    ROW_TYPE_MOBILE_NO,
    ROW_TYPE_GENDER,
    ROW_TYPE_WORK_EXP
    
}UnRegApplyRowType;//unregapplyviewcontroller

enum{
    
    ROW_TYPE_PREFERRED_LOCATION_DESIRED_JOB=0,
    ROW_TYPE_EMPLOYMENT_STATUS_DESIRED_JOB,
    ROW_TYPE_EMPLOYMENT_TYPE_DESIRED_JOB
    
};//editdesiredjobs
enum {
    
    ROW_TYPE_INDUSTRY_TYPE = 0,
    ROW_TYPE_OTHER_INDUSTRY ,
    ROW_TYPE_FUNC_DEPT,
    ROW_TYPE_OTHER_FUNC_DEPT,
    ROW_TYPE_WORK_LEVEL,
    ROW_TYPE_AVAILIBILITY_JOIN
    
};//editindustryinformation
enum CellType : NSInteger{
    DATE_OF_BIRTH = 0,
    GENDER = 1,
    NATIONALITY = 2,
    RELIGION = 3,
    MARITAL_STATUS = 4,
    DRIVING_LICENSE = 7,
    DRIVING_LICENSE_LOCATION = 5,
    LANGUAGES = 6
};//editpersonaldetailVC

typedef enum {
    
    K_ROW_TYPE_INFO = 0,
    K_ROW_TYPE_DOB,
    K_ROW_TYPE_ALTERNATE_EMAIL,
    K_ROW_TYPE_RELIGION,
    K_ROW_TYPE_OTHER_RELIGION,
    K_ROW_TYPE_MARITAL_STATUS,
    K_ROW_TYPE_LANGUAGES,
    
}rowType;//resmanlaststeppersonaldetail

typedef enum : NSUInteger {
    
    CellTypeGeneralDesc,
    CellTypeVisaStatus,
    CellTypeVisaValidity,
    CellTypeDL,
    CellTypeDLIssued
    
}CellTypeDLVisaVC;//resmanDLVisa

typedef enum {
    
    K_ROW_TYPE_GENDER = 0,
    K_ROW_TYPE_NAME,
    K_ROW_TYPE_MOBILE_NUMBER,
    K_ROW_TYPE_NATIONALITY,
    K_ROW_TYPE_CITY,
    K_ROW_TYPE_COUNTRY,
    K_ROW_TYPE_ALERT_SETTINGS,
    K_ROW_TYPE_TERMS_OF_SERVICE
    
}rowTypeResmanPersonalDetail;//resmanpersonaldetail

@interface NGProfileEditCell ()
{
    NSInteger iLimit;
    UITextField* selectedTF;
    IBOutlet UIView* seperatorView;
    IBOutlet UIButton* deleteBtn;
    
    
    
    NSString* titleStr;
    NSString* titlePlaceholderStr;
    NSString* titleLableStr;
    BOOL isDeletable;
    BOOL shouldHide;
    NSNumber* keyTxtCharLimit;
    BOOL showAccessoryView;
    BOOL showCharLimit;
    
    
    
    
}

@property(nonatomic, weak) IBOutlet UIImageView* imgRightAccessory;
@property(nonatomic,strong) IBOutlet UILabel *charLimitLabel;


@end

@implementation NGProfileEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}
-(void)awakeFromNib{
    iLimit = -1;//default
    seperatorView.hidden = YES;
    _charLimitLabel.hidden = TRUE;
    _txtTitle.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
}

- (void)showOtherTextField{
    
    _lblOtherTitle.hidden = NO;
    _lblOtherTitle.text = _otherDataStr;
}

- (void)hideOtherTextField{
    
    _lblOtherTitle.hidden = YES;
}
#pragma mark - Public Methods

-(void)configureEditProfileCellWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index{

    NSString *controller = [data objectForKey:@"ControllerName"];
     
    
    int enumValue = 0;
    if(controller.intValue == K_EDIT_BASIC_DETAIL_PAGE)
        enumValue = K_EDIT_BASIC_DETAIL_PAGE;
    else if (controller.intValue == K_EDIT_EDUCATION_DETAIL_PAGE)
        enumValue = K_EDIT_EDUCATION_DETAIL_PAGE;
    else if (controller.intValue == K_EDIT_WORK_EXPERIENCE)
        enumValue = K_EDIT_WORK_EXPERIENCE;
    else if (controller.intValue == k_RESMAN_PAGE_EXP_BASIC_DETAIL)
        enumValue = k_RESMAN_PAGE_EXP_BASIC_DETAIL;
    else if (controller.intValue == k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL)
        enumValue = k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL;
    else if (controller.intValue == k_RESMAN_PAGE_EDUCATION)
        enumValue = k_RESMAN_PAGE_EDUCATION;
    else if (controller.intValue == k_RESMAN_JOB_PREFERENCES_VC)
        enumValue = k_RESMAN_JOB_PREFERENCES_VC;
    else if (controller.intValue == k_RESMAN_PAGE_LOGIN_DETAIL)
        enumValue = k_RESMAN_PAGE_LOGIN_DETAIL;
    else if (controller.intValue == k_RESMAN_PAGE_PREVIOUS_WORK_EXP)
        enumValue = k_RESMAN_PAGE_PREVIOUS_WORK_EXP;
    else if (controller.intValue == K_EDIT_UNREG_APPLY_FRESHERS)
        enumValue = K_EDIT_UNREG_APPLY_FRESHERS;
    else if (controller.intValue == K_EDIT_UNREG_APPLY)
        enumValue = K_EDIT_UNREG_APPLY;
    else if (controller.intValue == K_EDIT_DESIRED_JOB)
        enumValue = K_EDIT_DESIRED_JOB;
    else if (controller.intValue == K_EDIT_INDUSTRY_INFORMATION)
        enumValue = K_EDIT_INDUSTRY_INFORMATION;
    else if (controller.intValue == K_EDIT_PERSONAL_DETAILS)
        enumValue = K_EDIT_PERSONAL_DETAILS;
    else if (controller.intValue == k_RESMAN_LAST_STEP_PERSONAL_DETAILS)
        enumValue = k_RESMAN_LAST_STEP_PERSONAL_DETAILS;
    else if (controller.intValue == k_RESMAN_DLVISA_VC)
        enumValue = k_RESMAN_DLVISA_VC;
    else if (controller.intValue == K_RESMAN_PAGE_PERSONAL_DETAILS)
        enumValue = K_RESMAN_PAGE_PERSONAL_DETAILS;
    
    
    switch (enumValue) {
        case K_EDIT_BASIC_DETAIL_PAGE:
        {
            [self configureCellForEditBasicDetailPageVCWithData:data andIndex:index];
            break;
        
        }
        case K_EDIT_EDUCATION_DETAIL_PAGE:
        {
            [self configureCellForEditEducationDetailPageVCWithData:data andIndex:index];
        
            break;
            
        }
        case K_EDIT_WORK_EXPERIENCE:
        {
            [self configureCellForWorkExperiencePageVCWithData:data andIndex:index];
            
            break;
            
        }
        case k_RESMAN_PAGE_EXP_BASIC_DETAIL:
        {
            [self configureCellForResmanExpBasicDeatilsPageVCWithData:data andIndex:index];
            
            break;
            
        }
        case k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL:
        {
            [self configureCellForResmanExpProfessionalDeatilsPageVCWithData:data andIndex:index];
            
            break;
            
        }
        case k_RESMAN_PAGE_EDUCATION:
        {
            [self configureCellForResmanFresherEducationVCWithData:data andIndex:index];
            
            break;
            
        }
        case k_RESMAN_JOB_PREFERENCES_VC:
        {
            [self configureCellForResmanJobPreferencesVCWithData:data andIndex:index];
            
            break;
            
        }
        case k_RESMAN_PAGE_LOGIN_DETAIL:
        {
            [self configureCellForResmanLoginDetailsVCWithData:data andIndex:index];
            
            break;
            
        }
        case k_RESMAN_PAGE_PREVIOUS_WORK_EXP:
        {
            [self configureCellForResmanPrevExperienceVCWithData:data andIndex:index];
            
            break;
            
        }

        case K_EDIT_UNREG_APPLY_FRESHERS:
        {
            [self configureCellForEditUnregApplyFreshersVCWithData:data andIndex:index];
            
            break;
            
        }
        case K_EDIT_UNREG_APPLY:
        {
            [self configureCellForUnregApplyVCWithData:data andIndex:index];
            
            break;
            
        }
        case K_EDIT_DESIRED_JOB:
        {
            [self configureCellForEditDesiredJobVCWithData:data andIndex:index];
            
            break;
            
        }
        case K_EDIT_INDUSTRY_INFORMATION:
        {
            [self configureCellForEditIndustryInformationVCWithData:data andIndex:index];
            
            break;
            
        }
        case K_EDIT_PERSONAL_DETAILS:
        {
            [self configureCellForEditPersonalDetailWithData:data andIndex:index];
            
            break;
            
        }
        case k_RESMAN_LAST_STEP_PERSONAL_DETAILS:
        {
            [self configureCellForResmanLastStepPersonalDetailWithData:data andIndex:index];
            
            break;
            
        }
        case k_RESMAN_DLVISA_VC:
        {
            [self configureCellForResmanDLVisaWithData:data andIndex:index];
            
            break;
            
        }
        case K_RESMAN_PAGE_PERSONAL_DETAILS:
        {
            [self configureCellForResmanPersonalDetailWithData:data andIndex:index];
            
            break;
            
        }
          
        default:
            break;
        }
    
    [self configureEditProfileCell];

    
}
#pragma mark - VC_CELL_Configure methods

-(void)configureCellForEditBasicDetailPageVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    
        
        if(index == 0)
        {
            titleLableStr = @"Name";
            titlePlaceholderStr = K_BASIC_DETAIL_PLACEHOLDER_NAME;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag  = BasicDetailsTagName;
            _isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit =[NSNumber numberWithInteger:50];
            [self setAccessibilityLabel:@"name_cell"];
            self.txtTitle.accessibilityLabel = @"name_txtFld";
        }
        else if (index == 1)
        {
            
            titleLableStr = @"Current Designation";
            _otherDataStr  = @"Please edit your Current Designation from Work Experience section";
            titlePlaceholderStr = NOT_MENTIONED;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag  = BasicDetailsTagDesignation;
            _isEditable = NO;
            showAccessoryView = NO;
            [self setAccessibilityLabel:@"designation_cell"];
            self.txtTitle.accessibilityLabel = @"designation_txtFld";
            [self.txtTitle setTextColor:RGBCOLOR(164, 164, 164)];
            [self.lblOtherTitle setTextColor:RGBCOLOR(164, 164, 164)];
        }
        else if (index == 2)
        {
            
            titleLableStr = @"Current Location";
            titlePlaceholderStr = K_BASIC_DETAIL_PLACEHOLDER_LOCATION;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag  = BasicDetailsTagLocation;
            _isEditable = NO;
            showAccessoryView = YES;
            [self setAccessibilityLabel:@"location_cell"];
            self.txtTitle.accessibilityLabel = @"location_txtFld";
            
        }
        else if (index == 3)
        {
            
            
            titleLableStr = @"Enter Other City";
            titlePlaceholderStr = K_BASIC_DETAIL_PLACEHOLDER_OTHER_LOCATION;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag  = BasicDetailsTagOtherLocation;
            keyTxtCharLimit =[NSNumber numberWithInteger:50];
            showAccessoryView = NO;
            [self setAccessibilityLabel:@"otherCity_cell"];
            self.txtTitle.accessibilityLabel = @"otherCity_txtFld";
            
            
        }
        else if (index == 4)
        {
            
            titleLableStr = @"Visa Status for Current Location";
            titleStr = [data objectForKey:@"data"];
            titlePlaceholderStr = K_BASIC_DETAIL_PLACEHOLDER_VISA_STATUS;
            self.txtTitle.tag  = BasicDetailsTagVisaStatus;
            showAccessoryView = YES;
            _isEditable = NO;
            [self setAccessibilityLabel:@"visaStatus_cell"];
            self.txtTitle.accessibilityLabel = @"visaStatus_txtFld";
            
        }
        else if(index == 5)
        {
            titleLableStr = @"Visa Valid Till";
            titlePlaceholderStr = K_BASIC_DETAIL_PLACEHOLDER_VISA_VALID_DATE;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = BasicDetailsTagVisaDate;
            showAccessoryView = YES;
            _isEditable = NO;
            [self setAccessibilityLabel:@"visaValidTill_cell"];
            self.txtTitle.accessibilityLabel = @"visaValidTill_txtFld";
            
        }
        else if (index == 6)
        {
            titleLableStr = @"Total Experience";
            titlePlaceholderStr = K_BASIC_DETAIL_PLACEHOLDER_EXPERIENCE;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = BasicDetailsTagExperience;
            showAccessoryView = YES;
            _isEditable = NO;
            [self setAccessibilityLabel:@"experience_cell"];
            self.txtTitle.accessibilityLabel = @"experience_txtFld";
            
        }
        else if (index == 7)
        {
            
            titleLableStr = @"Current Monthly Salary";
            titlePlaceholderStr = K_BASIC_DETAIL_PLACEHOLDER_SALARY;
            titleStr = [data objectForKey:@"data"];
            keyTxtCharLimit =[NSNumber numberWithInteger:8];
            self.txtTitle.tag = BasicDetailsTagSalary;
            showAccessoryView = NO;
            _isEditable = YES;
            [_txtTitle setKeyboardType:UIKeyboardTypeNumberPad];
            [self customTextFieldDidBeginEditing:_txtTitle];
            [self setAccessibilityLabel:@"salary_cell"];
            self.txtTitle.accessibilityLabel = @"salary_txtFld";
            
        }
        else if (index == 8)
        {
            
            titleLableStr = @"Currency Type";
            titlePlaceholderStr = K_BASIC_DETAIL_PLACEHOLDER_CURRENCY_TYPE;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = BasicDetailsTagCurrency;
            self.txtTitle.userInteractionEnabled = NO;
            showAccessoryView = YES;
            _isEditable = NO;
            [self setAccessibilityLabel:@"currency_cell"];
            self.txtTitle.accessibilityLabel = @"currency_txtFld";
            
        }


}
-(void)configureCellForEditEducationDetailPageVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    
    switch (index) {
            
        case ROW_TYPE_COURSE_TYPE:{
            
            
            titleLableStr = @"Course";
            titlePlaceholderStr = @"Specify Course";
            titleStr = [data objectForKey:@"data"];
            _isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag = ROW_TYPE_COURSE_TYPE;
            self.txtTitle.accessibilityLabel = @"course_txtFld";
            
            break;
        }
        case ROW_TYPE_OTHER_COURSE_TYPE:{
            
            titleLableStr = @"Other Course" ;
            titlePlaceholderStr = @"Specify Other Course";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = ROW_TYPE_OTHER_COURSE_TYPE;
            _isEditable = YES;
            showAccessoryView = NO;
            [self setAccessibilityLabel:@"name_cell"];
            self.txtTitle.accessibilityLabel = @"other_course_txtFld";
            break;
        }
        case ROW_TYPE_SPECIALISATION:{
            
            titleLableStr = @"Specialization";
            titlePlaceholderStr = @"Specify Specialization";
            titleStr = [data objectForKey:@"data"];
            _isEditable = NO;
            if([[data objectForKey:@"courseType"] isEqualToString:@""] || [[data objectForKey:@"courseType"] isEqualToString:@"Other"]){
                showAccessoryView = NO;
            }else {
                showAccessoryView = YES;
            }
            self.txtTitle.accessibilityLabel = @"specialization_txtFld";
            self.txtTitle.tag = ROW_TYPE_SPECIALISATION;
            
            break;
            
        }
        case ROW_TYPE_OTHER_SPECIALISATION:{
            
            titleLableStr = @"Other Specialization" ;
            titlePlaceholderStr = @"Specify Other Specialization";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = ROW_TYPE_OTHER_SPECIALISATION;
            _isEditable = YES;
            showAccessoryView = NO;
            self.txtTitle.accessibilityLabel = @"other_specialisation_txtFld";
            
            break;
        }
            
        case ROW_TYPE_YEAR_OF_GRAD:{
            
            titleLableStr = @"Year Of Passing";
            titlePlaceholderStr = @"Specify Year Of Passing";
            titleStr = [data objectForKey:@"data"];
            _isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"year_of_grad_txtFld";
            self.txtTitle.tag = ROW_TYPE_YEAR_OF_GRAD;
            
            
            break;
        }
            
        case ROW_TYPE_COUNTRY : {
            
            titleLableStr = @"Country";
            titlePlaceholderStr = @"Specify Country";
            titleStr = [data objectForKey:@"data"];
            _isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"country_txtFld";
            self.txtTitle.tag = ROW_TYPE_COUNTRY;
            
            
            break;
        }
            
        default:
            break;
    }

}
-(void)configureCellForWorkExperiencePageVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    
    switch (row) {
            
        case ROW_TYPE_DESIGNATION:{
            
            titleLableStr = @"Designation";
            titlePlaceholderStr = @"Specify Designation";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = YES;
            showAccessoryView = NO;
            self.txtTitle.accessibilityLabel = @"Designation_txtFld";
            keyTxtCharLimit = [NSNumber numberWithInt:50];
            self.txtTitle.tag = ROW_TYPE_DESIGNATION;

            
            
            break;

        }
        case ROW_TYPE_ORGANISATOIN:{
            
            titleLableStr = @"Organisation" ;
            titlePlaceholderStr = @"Specify Organisation";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = YES;
            showAccessoryView = NO;
            self.txtTitle.accessibilityLabel = @"organisation_txtFld";
            keyTxtCharLimit = [NSNumber numberWithInt:50];
            self.txtTitle.tag  = ROW_TYPE_ORGANISATOIN;
            
            break;
        }
            
        case ROW_TYPE_START_DATE:{
            
            titleLableStr = @"Started Working From";
            titlePlaceholderStr = @"Month, Year";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag  = ROW_TYPE_START_DATE;

            self.txtTitle.accessibilityLabel = @"startdate_txtFld";
            
            break;
            
            
        }
        case ROW_TYPE_TILL_DATE:{
            
            titleLableStr = @"Till";
            titlePlaceholderStr = @"Month, Year";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag  = ROW_TYPE_TILL_DATE;

            self.txtTitle.accessibilityLabel = @"tillDate_txtFld";
            if ([[data objectForKey:@"currentCompany"] isEqualToString:CURRENT_COMPANY_YES]) {
                showAccessoryView = FALSE;
            }
            
            break;
        }
        default:
            break;
    }
}
-(void)configureCellForResmanExpBasicDeatilsPageVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;

    switch (row) {
            
        case kResmanExpBasicDetailFieldTagTotalExp:{
            
            titleLableStr = @"Total Experience";
            self.txtTitle.userInteractionEnabled = FALSE;
            titlePlaceholderStr = K_RESMAN_EXPBASICDETAIL_PLACEHOLDER_EXP;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagTotalExp;
            self.isEditable = NO;
            showAccessoryView = YES;

            [UIAutomationHelper setAccessibiltyLabel:@"totalExp_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"totalExp_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            
        }
            break;
            
        case kResmanExpBasicDetailFieldTagDesignation:{
            
            titleLableStr = @"Current Designation";
            titlePlaceholderStr = K_RESMAN_EXPBASICDETAIL_PLACEHOLDER_DESIGNATION;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagDesignation;
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = @50;

            [UIAutomationHelper setAccessibiltyLabel:@"designation_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"designation_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            
        }
            break;
            
        case kResmanExpBasicDetailFieldTagCompany:{
            
            titleLableStr = @"Current Employer";
            titlePlaceholderStr = K_RESMAN_EXPBASICDETAIL_PLACEHOLDER_COMPANY;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagCompany;
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = @50;

            [UIAutomationHelper setAccessibiltyLabel:@"company_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"company_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            
            
        }break;
            
        case kResmanExpBasicDetailFieldTagCurrentSalary:{
            
            titleLableStr = @"Monthly Salary";
            titleStr = [data objectForKey:@"data"];
            titlePlaceholderStr = K_RESMAN_EXPBASICDETAIL_PLACEHOLDER_CURRENTSALARY;
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagCurrentSalary;
            self.txtTitle.keyboardType = UIKeyboardTypeNumberPad;
            showAccessoryView = NO;
            self.isEditable = YES;
            keyTxtCharLimit = @8;

            [UIAutomationHelper setAccessibiltyLabel:@"currentSalary_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"currentSalary_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            
            
        }
            break;
            
        case kResmanExpBasicDetailFieldTagCurrency :{
            
            titleLableStr = @"Currency (for monthly salary)";
            titlePlaceholderStr = @"Select Currency";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.userInteractionEnabled = NO;
            showAccessoryView = YES;
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagCurrency;

            [UIAutomationHelper setAccessibiltyLabel:@"currency_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"currency_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
            
        }
            
        default:
            break;
    }
}
-(void)configureCellForResmanExpProfessionalDeatilsPageVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    
    switch (row) {
        case kResmanExpBasicDetailFieldTagIndustry:{
            
            titleLableStr = @"Industry Area";
            titlePlaceholderStr = K_RESMAN_EXPPROFESSIONALDETAIL_PLACEHOLDER_INDUSTRY;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagIndustry;
            self.isEditable = NO;
            showAccessoryView = YES;

            [UIAutomationHelper setAccessibiltyLabel:@"industry_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"industry_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            
        }break;
            
        case kResmanExpBasicDetailFieldTagIndustryOther:{
            
            titleLableStr = @"Other Industry Area";
            titlePlaceholderStr = @"Specify Other Industry";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagIndustryOther;
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = @40;

            [UIAutomationHelper setAccessibiltyLabel:@"other_industry_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"other_industry_cell" forUIElement:self withAccessibilityEnabled:NO];

            
        }break;
            
        case kResmanExpBasicDetailFieldTagFA:{
            titleLableStr = @"Function/Department";
            titlePlaceholderStr = @"Your Function/Department in the Company";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagFA;
            self.isEditable = NO;
            showAccessoryView = YES;
            [UIAutomationHelper setAccessibiltyLabel:@"functionalArea_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"functionalArea_cell" forUIElement:self withAccessibilityEnabled:NO];
            
        }break;
            
        case kResmanExpBasicDetailFieldTagFAOther:{
            
            titleLableStr = @"Other Functional Area";
            titlePlaceholderStr = @"Specify Other Functional Area";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanExpBasicDetailFieldTagFAOther;
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = @40;

            [UIAutomationHelper setAccessibiltyLabel:@"other_fa_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"other_fa_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            
        }break;
        default:
            break;
    }

}
-(void)configureCellForResmanFresherEducationVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    CellType type = index;

    switch (type) {
        case CellTypeHighestEducation:{
            
            self.userInteractionEnabled = TRUE;
            self.lblPlaceHolder.textColor = [UIColor blackColor];
            titleLableStr = @"Highest Education";
            titlePlaceholderStr = K_RESMAN_EDUCATION_PLACEHOLDER_HIGHEST_EDUCATION;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = type;
            self.isEditable = NO;
            showAccessoryView = YES;
            
            [UIAutomationHelper setAccessibiltyLabel:@"highesteducation_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"highesteducation_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
        }
            
        case CellTypePPGCourse:{
            
            self.userInteractionEnabled = TRUE;
            self.lblPlaceHolder.textColor = [UIColor blackColor];
            titleLableStr = @"Doctorate Course";
            titlePlaceholderStr = K_RESMAN_EDUCATION_PLACEHOLDER_PPG_COURSE;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = type;
            self.isEditable = NO;
            showAccessoryView = YES;
            [UIAutomationHelper setAccessibiltyLabel:@"ppgCourse_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"ppgCourse_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            
            
            break;
        }
            
        case CellTypePPGSpecialization:{
            
            titleLableStr = @"Doctorate Specialization";
            titlePlaceholderStr = K_RESMAN_EDUCATION_PLACEHOLDER_PPG_SPECIALIZATION;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = type;
            self.isEditable = NO;
            showAccessoryView = YES;
            
            if (((NSString*)[data objectForKey:@"ppgCourse"]).length == 0) {
                
                self.userInteractionEnabled = FALSE;
                self.lblPlaceHolder.textColor = DISABLED_CELL_COLOR;
            }else{
                
                self.userInteractionEnabled = TRUE;
                self.lblPlaceHolder.textColor = [UIColor blackColor];
            }
            
            [UIAutomationHelper setAccessibiltyLabel:@"ppgspec_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"ppgspec_cell" forUIElement:self withAccessibilityEnabled:NO];

            break;
        }
            
        case CellTypePGCourse:{
            
            self.userInteractionEnabled = TRUE;
            self.lblPlaceHolder.textColor = [UIColor blackColor];
            titleLableStr = @"Masters Course";
            titlePlaceholderStr = K_RESMAN_EDUCATION_PLACEHOLDER_PG_COURSE;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = type;
            self.isEditable = NO;
            showAccessoryView = YES;

            [UIAutomationHelper setAccessibiltyLabel:@"pgCourse_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"pgCourse_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            
            break;
        }
            
        case CellTypePGSpecialization:{
            
            titleLableStr = @"Masters Specialization";
            titlePlaceholderStr = K_RESMAN_EDUCATION_PLACEHOLDER_PG_SPECIALIZATION;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = type;
            self.isEditable = NO;
            showAccessoryView = YES;
            
            if (((NSString*)[data objectForKey:@"pgCourse"]).length == 0) {
                
                self.userInteractionEnabled = FALSE;
                self.lblPlaceHolder.textColor = DISABLED_CELL_COLOR;
            }else{
                self.userInteractionEnabled = TRUE;
                self.lblPlaceHolder.textColor = [UIColor blackColor];
                
            }
            [UIAutomationHelper setAccessibiltyLabel:@"pgspec_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"pgspec_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
        }
            
        case CellTypeUGCourse:{
            
            self.userInteractionEnabled = TRUE;
            self.lblPlaceHolder.textColor = [UIColor blackColor];
            
            titleLableStr = @"Graduation Course";
            titlePlaceholderStr = K_RESMAN_EDUCATION_PLACEHOLDER_UG_COURSE;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = type;
            self.isEditable = NO;
            showAccessoryView = YES;
            [UIAutomationHelper setAccessibiltyLabel:@"ugCourse_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"ugcourse_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
        }
            
        case CellTypeUGSpecialization:{
            
            titleLableStr = @"Graduation Specialization";
            titlePlaceholderStr = K_RESMAN_EDUCATION_PLACEHOLDER_UG_SPECIALIZATION;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = type;
            self.isEditable = NO;
            showAccessoryView = YES;

            if (((NSString*)[data objectForKey:@"ugCourse"]).length == 0) {
                
                self.userInteractionEnabled = FALSE;
                self.lblPlaceHolder.textColor = DISABLED_CELL_COLOR;
            }else{
                self.userInteractionEnabled = TRUE;
                self.lblPlaceHolder.textColor = [UIColor blackColor];
                
            }
            [UIAutomationHelper setAccessibiltyLabel:@"ugspec_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"ugspec_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            
            break;
        }
            
        default:
            break;
    }

}
-(void)configureCellForResmanJobPreferencesVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    switch (row) {
            
        case ROW_TYPE_PREFERRED_LOCATION:{
            
            titleLableStr = @"Preferred Job Location";
            titlePlaceholderStr = @"Choose upto 3 Locations";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"location_txtFld";
            self.txtTitle.tag = ROW_TYPE_PREFERRED_LOCATION;

            break;

        }
            
        case ROW_TYPE_AVAILIBILITY_TO_JOIN :{
            
            titleLableStr = @"Notice Period";
            titlePlaceholderStr = @"Select Your Notice Period";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"availability_txtFld";
            self.txtTitle.tag = ROW_TYPE_AVAILIBILITY_TO_JOIN;
            
            break;

        }
        default:
            break;
    }
            
    
}
-(void)configureCellForResmanLoginDetailsVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    
    switch (row){
            
        case ROW_TYPE_USERNAME:{
            
            titleLableStr = @"Email Id (This will be your username)";
            titlePlaceholderStr = @"Enter Your Personal Email Id";
            self.txtTitle.tag = ROW_TYPE_USERNAME;
            self.isEditable = YES;
            titleStr = [data objectForKey:@"data"];
            keyTxtCharLimit = [NSNumber numberWithInteger:80];
            self.txtTitle.keyboardType=UIKeyboardTypeEmailAddress;
            self.txtTitle.returnKeyType = UIReturnKeyNext;
            self.txtTitle.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [UIAutomationHelper setAccessibiltyLabel:@"username_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"username_cell" forUIElement:self withAccessibilityEnabled:NO];
          
            break;
        }
            
        case ROW_TYPE_PASSWORD:{
            
            titleLableStr = @"Password" ;
            titlePlaceholderStr = @"Create Password for Your Account";
            self.txtTitle.tag = ROW_TYPE_PASSWORD;
            titleStr = [data objectForKey:@"data"];
            self.isEditable = YES;
            keyTxtCharLimit = [NSNumber numberWithInteger:50];
            self.txtTitle.returnKeyType = UIReturnKeyDone;
            self.txtTitle.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.otherDataStr = @"Min 6 characters. Only A-Z a-z 0-9 _ . @ - allowed";
            [UIAutomationHelper setAccessibiltyLabel:@"pwd_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"pwd_cell" forUIElement:self withAccessibilityEnabled:NO];

            break;
        }
    }
    
    
}
-(void)configureCellForResmanPrevExperienceVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    
    switch (row){
        case kResmanPreviousWorkExpFieldTagDesignation:{
            titleLableStr = @"Previous Designation";
            titlePlaceholderStr = K_RESMAN_PREVIOUS_WORKEXP_PLACEHOLDER_DESIGNATION;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanPreviousWorkExpFieldTagDesignation;
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = @50;

            [UIAutomationHelper setAccessibiltyLabel:@"designation_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"designation_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
        }
        case kResmanPreviousWorkExpFieldTagPreviousCompany:{
            
            titleLableStr = @"Previous Employer";
            titlePlaceholderStr = K_RESMAN_PREVIOUS_WORKEXP_PLACEHOLDER_PREV_COMPANY;
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = kResmanPreviousWorkExpFieldTagPreviousCompany;
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = @50;

            [UIAutomationHelper setAccessibiltyLabel:@"company_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"company_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
        }
    }
    
}
-(void)configureCellForEditUnregApplyFreshersVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    
    switch (row) {
            
        case ROW_TYPE_BASIC_EDUCATION_UNREG:{
            
            
            titleLableStr = @"Basic Education Details";
            titlePlaceholderStr = @"Select Course, Specialization";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"basic_txtFld";
            
            break;
        }
        case ROW_TYPE_MASTER_EDUCATION_UNREG:{
            
            titleLableStr = @"Post Graduation Details" ;
            titlePlaceholderStr = @"Select Course, Specialization";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"master_txtFld";
            
            
            break;
        }
        case ROW_TYPE_DOCTORATE_EDUCATION_UNREG:{
            
            titleLableStr = @"Doctorate Details";
            titlePlaceholderStr = @"Select Course, Specialization";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"doctorate_txtFld";
            
            break;
            
        }
        case ROW_TYPE_CURRENT_LOCATION_UNREG:{
            
            titleLableStr = @"Where are you currently Located";
            titlePlaceholderStr = @"Select Country, City";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"location_txtFld";

            
            break;
        }
            
            
        case ROW_TYPE_NATIONALITY_UNREG:{
            
            titleLableStr = @"What is your Nationality";
            titlePlaceholderStr = @"Select Nationality";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"nationality_func_txtFld";

            
            
            break;
        }
            
        case ROW_TYPE_DESIGNATION_UNREG:{
            
            
            titleLableStr = @"Designation";
            titlePlaceholderStr = @"What is your Current Designation";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = YES;
            showAccessoryView = NO;
            self.txtTitle.accessibilityLabel = @"Designation_txtFld";
            keyTxtCharLimit = [NSNumber numberWithInt:50];

            
            
            
            break;
        }
            
        default:
            break;
    }

    
}
-(void)configureCellForUnregApplyVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    switch (row) {
            
        case ROW_TYPE_NAME:{
            
            titleLableStr = @"Name";
            titlePlaceholderStr = @"Please mention your full name";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = [NSNumber numberWithInteger:50];
            self.txtTitle.accessibilityLabel = @"name_txtFld";
            [self setAccessibilityLabel:@"name_cell"];
            
            break;
        }
        case ROW_TYPE_EMAIL:{
            titleLableStr = @"Email" ;
            titlePlaceholderStr = @"Your Email ID";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = [NSNumber numberWithInteger:80];
            self.txtTitle.keyboardType = UIKeyboardTypeEmailAddress;
            self.txtTitle.accessibilityLabel = @"email_txtFld";
            [self setAccessibilityLabel:@"email_cell"];
            
            break;
        }
    
        case ROW_TYPE_WORK_EXP:{
            titleLableStr = @"How much Work Experience do you have?";
            titlePlaceholderStr = @"Years, Months";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"work_exp_txtFld";
            
            break;
        }
        default:
            break;
    }


}
-(void)configureCellForEditDesiredJobVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    switch (row) {
            
        case ROW_TYPE_PREFERRED_LOCATION_DESIRED_JOB:{
            
            titleLableStr = @"Preferred Location";
            titlePlaceholderStr = @"Specify Preferred Location";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"location_txtFld";
            
            break;
        }
        case ROW_TYPE_EMPLOYMENT_STATUS_DESIRED_JOB:{
            
            titleLableStr = @"Employment Status";
            titlePlaceholderStr = @"Specify Employment Status";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"emp_status_txtFld";

            
            
            break;
        }
        case ROW_TYPE_EMPLOYMENT_TYPE_DESIRED_JOB:{
            
            titleLableStr = @"Employment Type";
            titlePlaceholderStr = @"Specify Employment Type";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"emp_type_txtFld";

            
            
            break;
            
        }
            
    }

}
-(void)configureCellForEditIndustryInformationVCWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    switch (row) {
            
        case ROW_TYPE_INDUSTRY_TYPE:{
            
            titleLableStr = @"Industry Type";
            titlePlaceholderStr = @"Specify Industry Type";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag = ROW_TYPE_INDUSTRY_TYPE;
            self.txtTitle.accessibilityLabel = @"industry_txtFld";

            
            break;
        }
        case ROW_TYPE_OTHER_INDUSTRY:{
            titleLableStr = @"Other Industry" ;
            titlePlaceholderStr = @"Specify Other Industry";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = ROW_TYPE_OTHER_INDUSTRY;
            self.isEditable = YES;
            showAccessoryView = NO;
            [self setAccessibilityLabel:@"name_cell"];
            self.txtTitle.accessibilityLabel = @"other_industry_txtFld";

            
            break;
        }
        case ROW_TYPE_FUNC_DEPT:{
            
            titleLableStr = @"Function Area/Department";
            titlePlaceholderStr = @"Specify Function Area/Department";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"dept_txtFld";
            self.txtTitle.tag = ROW_TYPE_FUNC_DEPT;
            
            break;
            
        }
        case ROW_TYPE_OTHER_FUNC_DEPT:{
            titleLableStr = @"Other Function Area/Department" ;
            titlePlaceholderStr = @"Specify Other Function Area/Department";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = ROW_TYPE_OTHER_INDUSTRY;
            self.isEditable = YES;
            showAccessoryView = NO;
            self.txtTitle.accessibilityLabel = @"other_func_txtFld";
            self.txtTitle.tag = ROW_TYPE_OTHER_FUNC_DEPT;
            
            break;
        }
            
        case ROW_TYPE_WORK_LEVEL:{
            titleLableStr = @"Work Level";
            titlePlaceholderStr = @"Specify Work Level";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"work_level_txtFld";
            self.txtTitle.tag = ROW_TYPE_WORK_LEVEL;

            
            break;
        }
        case ROW_TYPE_AVAILIBILITY_JOIN:{
            
            titleLableStr = @"Availability to Join";
            titlePlaceholderStr = @"Specify Availability to Join";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.accessibilityLabel = @"availability_txtFld";
            self.txtTitle.tag = ROW_TYPE_AVAILIBILITY_JOIN;
            
            break;
        }
            
        default:
            break;
    }

}
-(void)configureCellForEditPersonalDetailWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    switch (row) {
        case DATE_OF_BIRTH:{
            
            titleLableStr = @"Date of Birth";
            titlePlaceholderStr = @"Select Date of Birth";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            [self setAccessibilityLabel:@"dob_cell"];
            self.txtTitle.accessibilityLabel = @"dob_txtFld";
            
            break;
        }
            
        case NATIONALITY:{
            titleLableStr = @"Nationality";
            titlePlaceholderStr = @"Select nationality";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            [self setAccessibilityLabel:@"nationality_cell"];
            self.txtTitle.accessibilityLabel = @"nationality_txtFld";
            
            break;
        }
            
        case RELIGION:{
            titleLableStr = @"Religion";
            titlePlaceholderStr = @"Select religion";
            titleStr = [data objectForKey:@"data"];;
            self.isEditable = NO;
            showAccessoryView = YES;
            [self setAccessibilityLabel:@"religion_cell"];
            self.txtTitle.accessibilityLabel = @"religion_txtFld";
            
            break;
        }
            
        case MARITAL_STATUS:{
            
            titleLableStr = @"Marital Status";
            titlePlaceholderStr = @"Select status";
            titleStr = [data objectForKey:@"data"];;
            self.isEditable = NO;
            showAccessoryView = YES;
            [self setAccessibilityLabel:@"maritalStatus_cell"];
            self.txtTitle.accessibilityLabel = @"maritalStatus_txtFld";

            
            
            break;
        }
        case DRIVING_LICENSE_LOCATION:{
            
            titleLableStr = @"Driving License received from";
            titlePlaceholderStr = @"Select location";
            titleStr = [data objectForKey:@"data"];;
            self.isEditable = NO;
            showAccessoryView = YES;
            [self setAccessibilityLabel:@"dlLocation_cell"];
            self.txtTitle.accessibilityLabel = @"dlLocation_txtFld";
            
            
            break;
        }
            
        case LANGUAGES:{
            titleLableStr = @"Languages Known (Upto 3 Languages)";
            titlePlaceholderStr = @"Select languages";
            
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            [self setAccessibilityLabel:@"language_cell"];
            self.txtTitle.accessibilityLabel = @"language_txtFld";

            
            break;
        }
        default:
            break;
    }

}
-(void)configureCellForResmanLastStepPersonalDetailWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    switch (row) {
        case K_ROW_TYPE_DOB:{
            
            titleLableStr = @"Date of Birth";
            titlePlaceholderStr = @"What is your Date of Birth";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag = K_ROW_TYPE_DOB;
            [UIAutomationHelper setAccessibiltyLabel:@"dob_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"dob_cell" forUIElement:self withAccessibilityEnabled:NO];

            break;
            
            
        }
        case K_ROW_TYPE_ALTERNATE_EMAIL:{
            
            titleLableStr = @"Alternate Email Id";
            titlePlaceholderStr = @"Your Alternate Email Address";
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = [NSNumber numberWithInt:80];
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = K_ROW_TYPE_ALTERNATE_EMAIL;

            self.txtTitle.keyboardType=UIKeyboardTypeEmailAddress;
           
            [UIAutomationHelper setAccessibiltyLabel:@"email_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"email_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            
            break;

        }
            
        case K_ROW_TYPE_RELIGION:{
            
            titleLableStr = @"Religion";
            titlePlaceholderStr = @"What is your Religion";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag = K_ROW_TYPE_RELIGION;

            [UIAutomationHelper setAccessibiltyLabel:@"religion_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"religion_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            
            break;

        }
            
        case K_ROW_TYPE_OTHER_RELIGION:{
            
            titleLableStr = @"Other Religion";
            titlePlaceholderStr = @"Specify Other Religion";
            self.txtTitle.tag = K_ROW_TYPE_OTHER_RELIGION;
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = [NSNumber numberWithInt:60];
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = K_ROW_TYPE_OTHER_RELIGION;

            self.txtTitle.keyboardType=UIKeyboardTypeEmailAddress;
            [UIAutomationHelper setAccessibiltyLabel:@"otherReligion_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"otherReligion_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            
            break;

            
        }
            
        case K_ROW_TYPE_MARITAL_STATUS:{
            
            titleLableStr = @"Marital Status";
            titlePlaceholderStr = @"What is your Marital Status";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag = K_ROW_TYPE_MARITAL_STATUS;

            [UIAutomationHelper setAccessibiltyLabel:@"maritalStatus_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"maritalStatus_cell" forUIElement:self withAccessibilityEnabled:NO];
  
            
            break;

        }
            
        case K_ROW_TYPE_LANGUAGES:{
            
            titleLableStr = @"Languages";
            titlePlaceholderStr = @"Choose upto 3 Languages you know";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            [self setAccessibilityLabel:@"language_cell"];
            self.txtTitle.accessibilityLabel = @"language_txtFld";
            self.txtTitle.tag = K_ROW_TYPE_LANGUAGES;

            [UIAutomationHelper setAccessibiltyLabel:@"language_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            [UIAutomationHelper setAccessibiltyLabel:@"language_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            
            
            break;

        }
        default:
            break;
    }

}
-(void)configureCellForResmanDLVisaWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    CellTypeDLVisaVC type = row;
    
    switch (type) {
        case CellTypeVisaStatus:{
            
            titleLableStr = @"Visa";
            titleStr = [data objectForKey:@"data"];
            titlePlaceholderStr = @"Visa Status of your current country";
            showAccessoryView = YES;
            self.isEditable = NO;
            self.txtTitle.tag = CellTypeVisaStatus;
            [UIAutomationHelper setAccessibiltyLabel:@"visaStatus_cell" forUIElement:self withAccessibilityEnabled:NO];
            [UIAutomationHelper setAccessibiltyLabel:@"visaStatus_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            
            break;
        }
            
        case  CellTypeVisaValidity:{
            titleLableStr = @"Visa Validity";
            titlePlaceholderStr = @"Visa valid till Date";
            titleStr = [data objectForKey:@"data"];
            self.txtTitle.tag = CellTypeVisaValidity;
            showAccessoryView = YES;
            self.isEditable = NO;
            [UIAutomationHelper setAccessibiltyLabel:@"visaValidTill_cell" forUIElement:self withAccessibilityEnabled:NO];
            [UIAutomationHelper setAccessibiltyLabel:@"visaValidTill_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            break;
        }
        case CellTypeDLIssued:{
            
            titleLableStr = @"Driving License issued by";
            titlePlaceholderStr = @"Driving License issued by";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag = CellTypeDLIssued;

            [UIAutomationHelper setAccessibiltyLabel:@"dlLocation_cell" forUIElement:self withAccessibilityEnabled:NO];
            [UIAutomationHelper setAccessibiltyLabel:@"dlLocation_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];

            
            
            
            break;
        }
        default:
            break;
    }
}
-(void)configureCellForResmanPersonalDetailWithData:(NSMutableDictionary*)data andIndex:(NSInteger)index
{
    NSInteger row = index;
    switch (row) {
        case K_ROW_TYPE_NAME:{
            
            titleLableStr = @"Full Name" ;
            titlePlaceholderStr = @"Your Full Name";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = YES;
            showAccessoryView = NO;
            self.txtTitle.returnKeyType = UIReturnKeyNext;
            self.txtTitle.tag = K_ROW_TYPE_NAME;
            self.txtTitle.textColor = [UIColor blackColor];
            keyTxtCharLimit = [NSNumber numberWithInt:50];

            [UIAutomationHelper setAccessibiltyLabel:@"name_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            
            [UIAutomationHelper setAccessibiltyLabel:@"name_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
            
        }
            
        case K_ROW_TYPE_NATIONALITY:{
            titleLableStr = @"Nationality";
            titlePlaceholderStr = @"What is Your Nationality";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            showAccessoryView = YES;
            self.txtTitle.tag = K_ROW_TYPE_NATIONALITY;

            self.txtTitle.textColor = [UIColor blackColor];
            self.txtTitle.accessibilityLabel = @"nationality_txtFld";
            
            
            [UIAutomationHelper setAccessibiltyLabel:@"nationality_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            
            [UIAutomationHelper setAccessibiltyLabel:@"nationality_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            break;
            
        }
            
        case K_ROW_TYPE_CITY:{
            
            titleLableStr = @"City";
            titlePlaceholderStr = @"City You are Living in";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = YES;
            showAccessoryView = NO;
            keyTxtCharLimit = [NSNumber numberWithInt:60];
            self.txtTitle.tag = K_ROW_TYPE_CITY;

            self.txtTitle.textColor = [UIColor blackColor];
            self.txtTitle.returnKeyType = UIReturnKeyDone;
            
            [UIAutomationHelper setAccessibiltyLabel:@"city_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            
            [UIAutomationHelper setAccessibiltyLabel:@"city_cell" forUIElement:self withAccessibilityEnabled:NO];

            
            
            break;
        }
            
        case K_ROW_TYPE_COUNTRY:{
            
            titleLableStr = @"Country";
            titlePlaceholderStr = @"Country You are Living in";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            self.txtTitle.tag = K_ROW_TYPE_COUNTRY;

            self.txtTitle.textColor = [UIColor blackColor];
            showAccessoryView = YES;
            
            [UIAutomationHelper setAccessibiltyLabel:@"country_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            
            [UIAutomationHelper setAccessibiltyLabel:@"country_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
        }
            
        case K_ROW_TYPE_ALERT_SETTINGS:{
            
            titleLableStr = @"Alert Settings";
            titlePlaceholderStr = @"Alert Settings";
            titleStr = [data objectForKey:@"data"];
            self.isEditable = NO;
            self.txtTitle.tag = K_ROW_TYPE_ALERT_SETTINGS;

            showAccessoryView = YES;
            
            [UIAutomationHelper setAccessibiltyLabel:@"alertSetting_txtFld" forUIElement:self.txtTitle withAccessibilityEnabled:YES];
            
            [UIAutomationHelper setAccessibiltyLabel:@"alert_cell" forUIElement:self withAccessibilityEnabled:NO];
            
            break;
        }
        default:
            break;
    }

}
- (void)configureEditProfileCell{
    _charLimitLabel.hidden = !showCharLimit;
    _lblPlaceHolder.text = titleLableStr;
    _txtTitle.placeholder = titlePlaceholderStr;
    if (!titleStr || [titleStr isEqual:[NSNull null]])
        titleStr = @"";
    _txtTitle.text = titleStr;
    
    if(!keyTxtCharLimit ||![keyTxtCharLimit isKindOfClass:[NSNull class]])
        iLimit =  keyTxtCharLimit.integerValue;
    
    if(isDeletable)
        deleteBtn.hidden = NO;
    else
        deleteBtn.hidden = YES;
    
    if (showAccessoryView) {
        _imgRightAccessory.hidden = NO;
    }else{
        _imgRightAccessory.hidden = YES;
        [_txtTitle setRightView:nil];
        [_txtTitle setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    if (_otherDataStr) {
        
        if (0>=[[ValidatorManager sharedInstance] validateValue:_otherDataStr withType:ValidationTypeString].count)
            [self showOtherTextField];
        else{
            [self hideOtherTextField];
        }
        
    }else{
        
        [self hideOtherTextField];
        
    }
    
    switch (_editModuleNumber) {
            
        case K_EDIT_BASIC_DETAIL_PAGE:{
            if (!_isEditable)
                _txtTitle.userInteractionEnabled = NO;
            else
                _txtTitle.userInteractionEnabled = YES;
            break;
        }
        case K_EDIT_CONTACT_DETAIL_PAGE:{
            
            [self customTextFieldDidBeginEditing:_txtTitle];
            [_txtTitle setKeyboardType:UIKeyboardTypeNumberPad];
            
            break;
        }
            
        case k_RESMAN_PAGE_EXP_BASIC_DETAIL:
            if (self.index == 5) {
                [self customTextFieldDidBeginEditing:_txtTitle];
                
            }
            break;
            
        case K_EDIT_RESUME_HEADLINE_DETAIL_PAGE:{
            
            _txtTitle.userInteractionEnabled = YES;
            break;
        }
            
        case k_RESMAN_PAGE_LOGIN_DETAIL:{
            
            if (IS_IPHONE5)
            {
            _txtTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:titlePlaceholderStr attributes: @{NSFontAttributeName: [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0]}];
            }
            
            _txtTitle.userInteractionEnabled = YES;
            CGFloat colorCode = 122.0f/255.0f;
            _lblOtherTitle.textColor = [UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f];
            break;
            
        }
        case K_EDIT_INDUSTRY_INFORMATION:{
            
            
            [_lblOtherTitle removeFromSuperview];
            if (!_isEditable)
                _txtTitle.userInteractionEnabled = NO;
            else
                _txtTitle.userInteractionEnabled = YES;
            break;
        }
            
            
        case K_EDIT_WORK_DETAILS:
            _txtTitle.userInteractionEnabled = NO;
            break;
            
        case K_RESMAN_PAGE_KEY_SKILLS:{
            
            _charLimitLabel.text = [NSString stringWithFormat:@"%ld Characters Left",(long)(iLimit-titleStr.length)];
            
            if (!_isEditable)
                _txtTitle.userInteractionEnabled = NO;
            else
                _txtTitle.userInteractionEnabled = YES;
            
        }
            
        default: {
            
            [_lblOtherTitle removeFromSuperview];
            if (!_isEditable)
                _txtTitle.userInteractionEnabled = NO;
            else
                _txtTitle.userInteractionEnabled = YES;
            
        }
            break;
    }
    
    _txtTitle.hidden = shouldHide;
    _lblPlaceHolder.hidden = shouldHide;
    
}
#pragma mark -
#pragma mark Button Actions
- (IBAction)onAccessoryClick:(id)sender{
}
- (IBAction)deleteIconTapped:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteTapped:)])
        [_delegate deleteTapped:_index];
}

#pragma mark -
#pragma mark UITextfield Delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    BOOL bToReturn = NO;
    
    if (_isEditable)
        bToReturn = YES;
    
    
    if([_delegate respondsToSelector:@selector(textFieldShouldStartEditing:)])
        return [_delegate textFieldShouldStartEditing:_index];
    
    return bToReturn;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([_delegate respondsToSelector:@selector(textFieldDidReturn:)]){
        [_delegate textFieldDidReturn:_index];
    }
    
    if ([_delegate respondsToSelector:@selector(textFieldDidReturn:forIndex:)]) {
        [_delegate textFieldDidReturn:textField forIndex:_index];
    }
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)callParentDelegateAndReturnTextFieldShouldReturnFlagForTextFieldString:(NSString*)paramString ReplacementString:(NSString*)paramReplacementString WithCharLimit:(NSInteger)paramCharLimit andIndexValue:(NSInteger)paramIndex{
    
    //for delete key press, allow editing in anyway
    if (nil == paramReplacementString || [@"" isEqualToString:paramReplacementString]) {
        return YES;
    }
    
    NSString *newTotalString = [paramString stringByAppendingString:paramReplacementString];
    if (paramCharLimit < newTotalString.length) {
        return NO;
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(textFieldValue: havingIndex:)])
            [self.delegate textFieldValue:newTotalString havingIndex:paramIndex];
        return YES;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    switch (_editModuleNumber) {
        case K_EDIT_BASIC_DETAIL_PAGE:{
            if (-1 == iLimit) {
                return YES;
            }else{
                NSString *newTotalString = [textField.text stringByAppendingString:string];
                if(newTotalString.length > iLimit)
                    return NO;
            }
        break;
        }
        case K_EDIT_WORK_EXPERIENCE:{
        
            if (textField.text.length >= iLimit && range.length == 0) {
                
                return NO;
            }
            
            break;
        }
            
        case K_EDIT_CONTACT_DETAIL_PAGE:{
            
            if (iLimit > 0 && textField.text.length >= iLimit){
                
                if (![string isEqualToString:@""])
                    return NO;
            }
            break;
        }
        
         
        case K_EDIT_UNREG_APPLY:
        {
            
            if (iLimit > 0 && textField.text.length >= iLimit){
                
                if (![string isEqualToString:@""])
                    return NO;
            }
            break;
        }
            
            //NOTE:If u required custom limit check then
            //break these cases into individual cases
        case k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL:
        case k_RESMAN_PAGE_EXP_BASIC_DETAIL:
        case k_RESMAN_PAGE_PREVIOUS_WORK_EXP:
        {
            if (iLimit > 0 && textField.text.length >= iLimit){
                
                if (![string isEqualToString:@""])
                    return NO;
            }
        }
            break;
            
        case K_RESMAN_PAGE_KEY_SKILLS:{
           
            NSInteger charactersLeft ;
         
            if (string.length + textField.text.length > iLimit) {
                
                return NO;
            }
            if (string.length== 0) {
                
                charactersLeft = iLimit-textField.text.length+1;
            }
            else{
                charactersLeft =  iLimit - textField.text.length-string.length;

            }
            if (charactersLeft <0) {
                charactersLeft = 0;
            }
    
            _charLimitLabel.text = [NSString stringWithFormat:@"%ld Characters Left", (long)charactersLeft];

            break;
        }
            
        case K_RESMAN_PAGE_PERSONAL_DETAILS:{
            
            if (iLimit > 0 && textField.text.length >= iLimit){
                
                if (![string isEqualToString:@""])
                    return NO;
            }
           
            break;
            
        }
        case k_RESMAN_PAGE_LOGIN_DETAIL:{
            
            
            if (iLimit > 0 && textField.text.length >= iLimit){
                
                if (![string isEqualToString:@""])
                    return NO;
            }
            else{
            
                if(textField.tag == ROW_TYPE_PASSWORD){
                NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                textField.text = updatedString;
                return NO; // imp to fix live bug (hide button overwrites last pasword text)
                }
            }
            break;
            
        }
            
            
        default:{
            
            if (iLimit > 0 && textField.text.length >= iLimit){
                
                if (![string isEqualToString:@""])
                    return NO;
            }
            
        }
            break;
    }
    
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(textFieldValue: havingIndex:)]){
            [self.delegate textFieldValue:textField.text havingIndex:_index];
        }else if ([_delegate respondsToSelector:@selector(textField:WithValue:havingIndex:)]){
            [self.delegate textField:textField WithValue:textField.text havingIndex:_index];
        }else{
        }
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidStartEditing:)]){
        [_delegate textFieldDidStartEditing:_index];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidStartEditing:havingIndex:)]){
        [_delegate textFieldDidStartEditing:textField havingIndex:_index];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
 
    if (!_charLimitLabel.hidden) {
      
        NSInteger charactersLeft = iLimit - textField.text.length;
        if (charactersLeft <0)
            charactersLeft = 0;
        _charLimitLabel.text = [NSString stringWithFormat:@"%ld Characters Left", (long)charactersLeft];

    }

    
        textField.text = [NSString stripWhiteSpaceFromBeginning:textField.text];
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldValue: havingIndex:)]){
        [self.delegate textFieldValue:textField.text havingIndex:_index];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing: havingIndex:)]){
        [_delegate textFieldDidEndEditing:textField.text havingIndex:_index];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing: WithValue:havingIndex:)]){
        [_delegate textFieldDidEndEditing:textField WithValue:textField.text havingIndex:_index];
    }
    
}
-(void)customTextFieldDidBeginEditing:(UITextField*)textField
{
    [textField setInputAccessoryView:[self customToolBarForKeyBoard:textField]];
}

-(UIToolbar*)customToolBarForKeyBoard:(UITextField*)textField
{
    selectedTF =textField;
    
    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolBar.frame = CGRectMake(0, 0, 320, 50);
    [toolBar setTintColor:UIColorFromRGB(0x403E3F)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [toolBar sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)];
    
    
    [doneButton setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:15],
                                         NSForegroundColorAttributeName: UIColorFromRGB(0X75cafb)
                                         } forState:UIControlStateNormal];
    NSArray *items  =   [[NSArray alloc] initWithObjects:doneButton,nil];
    
    [toolBar setItems:items];
    
    
    return toolBar;
}

-(void)dismissKeyboard:(id)sender
{
    [selectedTF resignFirstResponder];
}

-(void) setAccessibilityLabels{
    
    [UIAutomationHelper setAccessibiltyLabel:self.txtTitle.text forUIElement:self.txtTitle withAccessibilityEnabled:YES];
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"%ld_cell",(long)self.index] forUIElement:self withAccessibilityEnabled:NO];
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    _charLimitLabel.text = [NSString stringWithFormat:@"%d Characters Left",255];
    return YES;
}
@end
