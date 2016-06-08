//
//  JDTableRowController.m
//  NaukriGulf
//
//  Created by Arun on 1/17/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "JDTableRowController.h"
#import "WatchConstants.h"

@interface JDTableRowController(){
}

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblDesignation;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblCmpany;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblExp;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblLocation;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblJobDescription;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblEmployerDetails;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblGender;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblNationality;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblEducation;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblOtherDetails;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpApply;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnApply;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imgSpinner;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblVacancy;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblSalary;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblPostedDate;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblIndustryType;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblFunctionalAra;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblKeywords;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnAlreadyApplied;



@end

@implementation JDTableRowController

-(IBAction)applyClickedAtIndex:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(applyClicked)])
        [_delegate applyClicked];

}

-(void)configureJDRow:(NSDictionary*)dict{
    
    [_imgSpinner setHidden:YES];
    [_lblDesignation setText:dict[@"designation"]];
    [_lblCmpany setText:dict[@"company"]];
    [_lblExp setText:dict[@"experience"]];
    [_lblLocation setText:dict[@"location"]];
    [_lblJobDescription setText:dict[@"job_description"]];
    
    [_lblGender setText:dict[@"gender"]];
    if([dict[@"gender"] isKindOfClass:[NSNull class]] || !dict[@"gender"] || ([dict[@"gender"] length]==0)){
        _lblGender.text = @"Not Mentioned";
    }
    if ([dict[@"gender"] isEqualToString:@"Any"]) {
        _lblGender.text = @"Any Gender";
    }
   
    
    [_lblEducation setText:dict[@"education"]];
    if([dict[@"education"] isKindOfClass:[NSNull class]] || !dict[@"education"] || ([dict[@"education"] length]==0)){
        _lblEducation.text = @"Not Mentioned";
    }
    
    NSString* empDetails = dict[@"employer_details"];
    if (!empDetails.length)
        empDetails = K_NOT_MENTIONED_WATCH;
    [_lblEmployerDetails setText:empDetails];
    
    NSString* otherDetails = dict[@"dc_profile"];
    if (!otherDetails.length)
        otherDetails = K_NOT_MENTIONED_WATCH;
    [_lblOtherDetails setText:otherDetails];
    
    
    NSString* nationality = dict[@"nationality"];
    if (!nationality.length)
        nationality = K_NOT_MENTIONED_WATCH;
    [_lblNationality setText:nationality];

    
    
    NSInteger  status = [dict[@"is_applied"] integerValue];
    [_grpApply setHidden:status];
    [_btnAlreadyApplied setHidden:!status];
    
    
    
    _lblVacancy.text = dict[@"vacancy"];
    _lblPostedDate.text = [NSString stringWithFormat:@"Posted on %@",dict[@"postedOn"]];
    
    if (![dict[@"salary"] isEqualToString:K_NOT_MENTIONED_WATCH])
    {
        _lblSalary.text = [NSString stringWithFormat:@"%@ per month",dict[@"salary"]];
    }
    else
        _lblSalary.text = dict[@"salary"];
    
    if (![dict[@"isCtcHidden"] isEqualToString:@"false"]) {
        _lblSalary.text = K_NOT_MENTIONED_WATCH;
    }
 
    _lblIndustryType.text = dict[@"industryType"];
    if([dict[@"industryType"] isKindOfClass:[NSNull class]] || !dict[@"industryType"] || ([dict[@"industryType"] length]==0)){
        _lblIndustryType.text = @"Not Mentioned";
    }
    
    _lblFunctionalAra.text = dict[@"functionalArea"];
    if([dict[@"functionalArea"] isKindOfClass:[NSNull class]] || !dict[@"functionalArea"] || ([dict[@"functionalArea"] length]==0)){
        _lblFunctionalAra.text = @"Not Mentioned";
    }
    
    _lblKeywords.text = dict[@"keywords"];
    if([dict[@"keywords"] isKindOfClass:[NSNull class]] || !dict[@"keywords"] || ([dict[@"keywords"] length]==0)){
        _lblKeywords.text = @"Not Mentioned";
    }

}

-(void)configureTableForApplying{
    [_imgSpinner setHidden:NO];
    [_btnApply setHidden:YES];
    [_imgSpinner setImageNamed:@"spinner"];
    [_imgSpinner startAnimatingWithImagesInRange:NSMakeRange(1, 42)
                                    duration:1.0
                                 repeatCount:0];
}
-(void)configureTableForApply{
    
    [_imgSpinner setHidden:YES];
    [_grpApply setHidden:NO];
    [_btnApply setHidden:NO];
    [_btnAlreadyApplied setHidden:YES];

    
}
-(void)configureTableForApplied{
    [_grpApply setHidden:YES];
    [_btnAlreadyApplied setHidden:NO];
}
@end
