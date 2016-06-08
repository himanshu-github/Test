//
//  NGJobTupleCustomCell.m
//  NaukriGulf
//
//  Created by Arun Kumar on 16/10/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGJobTupleCustomCell.h"

#import "AsyncImageView.h"

#define SHORTLISTED 11
#define UNSHORTLISTED 10

@interface NGJobTupleCustomCell ()
{
    NSInteger cellIndex; //will hold value for row at tableview
    
}
@property (weak, nonatomic) IBOutlet AsyncImageView *logoImg;
@property (weak, nonatomic) IBOutlet NGLabel *locationLbl;
@property (weak, nonatomic) IBOutlet NGLabel *designationLbl;

@property (weak, nonatomic) IBOutlet NGLabel *cmpnyNameLbl;
@property (weak, nonatomic) IBOutlet NGLabel *expLbl;
@property (weak, nonatomic) IBOutlet NGLabel *vacancyLbl;
@property (weak, nonatomic) IBOutlet NGImageView *jobTypeImg;
@property (weak, nonatomic) IBOutlet NGImageView *vacancyImg;
@property (weak, nonatomic) IBOutlet NGImageView *locationImg;
@property (weak, nonatomic) IBOutlet NGImageView *expImg;
@property (weak,nonatomic) IBOutlet UIImageView *isAppliedForJob;


@end
@implementation NGJobTupleCustomCell

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
    _shortListBtn.selected = NO;
    _shortListBtn.highlighted = NO;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    _shortListBtn.highlighted = NO;
}

-(void)displayData:(NGJobDetails *)jobObj atIndex:(NSInteger)index{
    self.contentView.backgroundColor = [UIColor whiteColor];
    cellIndex = index;
    
    _jobObj = jobObj;
    _jobIndex = index;
    
    
    if (_jobObj.isAlreadyRead) {
        _designationLbl.font = [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:17.0f];
    }else{
        _designationLbl.font = [UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_REGULAR size:17.0f];
    }
    
    _designationLbl.textColor = UIColorFromRGB(0x003f7d);
    _designationLbl.text = jobObj.designation;
    _cmpnyNameLbl.text   =  jobObj.cmpnyName;
    
    
    if ([jobObj.minExp isEqualToString:@""])
        jobObj.minExp = @"0";
    
    if ([jobObj.minExp isEqualToString:jobObj.maxExp]) {
        _expLbl.text                =   [NSString stringWithFormat:@"%@ Years",jobObj.maxExp];
    }else{
        _expLbl.text                =   [NSString stringWithFormat:@"%@ - %@ Years",jobObj.minExp,jobObj.maxExp];
    }
    
    NSString *positionStr = jobObj.vacancy>1?@"Vacancies":@"Vacancy";
    _vacancyLbl.text                = [NSString stringWithFormat:@"%ld %@",(long)jobObj.vacancy,positionStr];
    
    
    _locationLbl.text = [NSString stringWithFormat:@"%@",jobObj.location];

    if (_jobObj.appliedDate.length>0)
    {
        _appliedDate.text=[NSString stringWithFormat:@"%@",_jobObj.appliedDate];
        _appliedDate.hidden = NO;
    }else{
        _appliedDate.hidden = YES;
        [_appliedDate setHidden:YES];
    }
    
    [self updateShortlistState];
    
    [_shortListBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    _shortListBtn.hidden = NO;
    if (_jobObj.isAlreadyApplied)
    {
        [_isAppliedForJob setHidden:NO];
        _shortListBtn.hidden = YES;
        
    }else{
        [_shortListBtn setHidden:NO];
        [_isAppliedForJob setHidden:YES];
    }
    
    
    NSString *url = [jobObj getLogoUrl];
    
    if (url && url.length  > 0) {
        NSURL* imgUrl = [NSURL URLWithString:url];
        _logoImg.showActivityIndicator = NO;
        [_logoImg setImageURL:imgUrl];
    }
    
    _jobTypeImg.image = [UIImage imageNamed:@"PremiumJob"];
    
    _jobTypeImg.hidden = YES;
    _logoImg.hidden = YES;
    
    if (jobObj.isTopEmployerLite && jobObj.isPremiumJob) {
        _jobTypeImg.hidden = NO;
        _logoImg.hidden = NO;
    }else if (jobObj.isTopEmployerLite && !jobObj.isPremiumJob) {
        _logoImg.hidden = NO;
    }else if (!jobObj.isTopEmployerLite && jobObj.isPremiumJob) {
        _jobTypeImg.hidden = NO;
    }
    
    if (jobObj.isTopEmployer) {
        _jobTypeImg.hidden = NO;
        _logoImg.hidden = NO;
    }
    
    [_locationLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-(320-167)];
    [_appliedDate setPreferredMaxLayoutWidth:SCREEN_WIDTH-(320-105)];
    [_expLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-(320-190)];
    [_cmpnyNameLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-(320-190)];
    [_designationLbl setPreferredMaxLayoutWidth:SCREEN_WIDTH-(320-202)];



    [self setAutomationLabelsAtIndex:index];
}
-(void)setAutomationLabelsAtIndex:(NSInteger)paramIndex{
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"Location_lbl_%ld",(long)paramIndex] value:_locationLbl.text forUIElement:_locationLbl];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"designation_lbl_%ld",(long)paramIndex] value:_designationLbl.text forUIElement:_designationLbl];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"appliedDate_lbl_%ld",(long)paramIndex] value:_appliedDate.text forUIElement:_appliedDate];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"compnyName_lbl_%ld",(long)paramIndex] value:_cmpnyNameLbl.text forUIElement:_cmpnyNameLbl];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"exp_lbl_%ld",(long)paramIndex] value:_expLbl.text forUIElement:_expLbl];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"alreadyApplied_img_%ld",(long)paramIndex] value:[NSString stringWithFormat:@"%d",!_isAppliedForJob.isHidden] forUIElement:_isAppliedForJob];
    
    NSString *saveJobBtnStatus = [NSString stringWithFormat:@"%d",_shortListBtn.tag == SHORTLISTED];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"SaveJob_btn_%ld",(long)paramIndex] value:saveJobBtnStatus forUIElement:_shortListBtn];

    [self setAccessibilityLabel:[NSString stringWithFormat:@"JobCell_%ld",(long)paramIndex]];
}
/**
 *  updates the shorlisted flag on the JobTouple.
 */

-(void)updateShortlistState{
    if ([[DataManagerFactory getStaticContentManager] isShortlistedJob:_jobObj.jobID ]) {
        _shortListBtn.tag = SHORTLISTED;
        [_shortListBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else{
        [_shortListBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        _shortListBtn.tag = UNSHORTLISTED;
    }
}

- (IBAction)shortListTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag==UNSHORTLISTED) {
        
        [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_SHORT_LISTED_JOB withEventLabel:K_GA_EVENT_SHORT_LISTED_JOB withEventValue:nil];
        btn.tag = SHORTLISTED;
        [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        
        [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:_jobObj forStoring:YES];
        _jobObj.isAlreadyShortlisted = YES;
        
        
        if([_delegate respondsToSelector:@selector(jobTupleCell:shortListTappedWithFlag:)])
        {
            [_delegate jobTupleCell:self shortListTappedWithFlag:YES];
        }
        
        
    }
    else{
        btn.tag = UNSHORTLISTED;
        [btn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        
        [[DataManagerFactory getStaticContentManager] shorlistedJobTuple:_jobObj forStoring:NO];
        _jobObj.isAlreadyShortlisted = NO;
        
        if([_delegate respondsToSelector:@selector(jobTupleCell:shortListTappedWithFlag:)])
        {
            [_delegate jobTupleCell:self shortListTappedWithFlag:NO];
        }
        
    }
    
    NSString *saveJobBtnStatus = [NSString stringWithFormat:@"%d",_shortListBtn.tag == SHORTLISTED];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"SaveJob_btn_%ld",(long)cellIndex] value:saveJobBtnStatus forUIElement:_shortListBtn];
}

@end
