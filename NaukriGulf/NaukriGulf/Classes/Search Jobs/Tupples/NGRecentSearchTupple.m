//
//  NGRecentSearcheTupple.m
//  NGSearchPage
//
//  Created by Arun Kumar on 1/14/14.
//  Copyright (c) 2014 naukri. All rights reserved.
//

#import "NGRecentSearchTupple.h"


NSInteger const K_RECENT_SERACH_KEYWORD_LENGTH = 25;

@interface NGRecentSearchTupple (){
    __weak IBOutlet NSLayoutConstraint *lblJobCountWidthContraint;
}

@property(weak,nonatomic) IBOutlet UIImageView* imgLocation; //location
@property(weak,nonatomic) IBOutlet UIImageView* imgExperience; //briefcase or wallet
@property(weak,nonatomic) IBOutlet UIImageView* imgSalary; //briefcase or wallet

@end
@implementation NGRecentSearchTupple{
    BOOL islblJobCountWidthContraintUpdated;
    
}

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
}


- (void)configureCellWithData:(NGRescentSearchTuple*)paramData AndIndex:(NSInteger)paramIndex{
    //reset all constraints
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NGRescentSearchTuple *data = (NGRescentSearchTuple*)paramData;
    
    //if skill or keywords not present
    if ([data.keyword isEqualToString:@""] || data.keyword == nil){
        
        _lblKeyword.text = K_NOT_MENTIONED;
    }else {
        
        NSString* keywords;
        if ([data.keyword length] >K_RECENT_SERACH_KEYWORD_LENGTH) {
            
            keywords = [data.keyword substringToIndex:K_RECENT_SERACH_KEYWORD_LENGTH];
            keywords = [keywords stringByAppendingString:@"..."];
            
        }else{
            keywords = [NGDecisionUtility isValidString:data.keyword]?data.keyword:K_NOT_MENTIONED;
        }
        
        _lblKeyword.text = keywords;
    }
    
    BOOL isOtherOnly = [[data.location lowercaseString] isEqualToString:@"other"];
    
    if ([data.location isEqualToString:@""] || data.location == nil){
        
        _lblLocation.text = @"Any Location";
        
    }else if(isOtherOnly){
        
        _lblLocation.text = @"Other";
    }else {
        _lblLocation.text = [self formattedLocationStringFromString:data.location];
    }
    
    NSInteger tmpExp = [data.experience integerValue];
    NSString *expYears = [NSString stringWithFormat:@"%ld %@",(long)tmpExp,tmpExp>=2?@"Years":@"Year"];
    _lblExperience.text = tmpExp<0||tmpExp==Const_Any_Exp_Tag?@"Any Experience":expYears;
    
    
    //job search count
    if (99 < [[data searchJobCount] integerValue]&&!islblJobCountWidthContraintUpdated) {
        islblJobCountWidthContraintUpdated = YES;
        NSInteger widthIncrementForJobCount = ([NSString stringWithFormat:@"%ld",(long)([[data searchJobCount] integerValue])].length-2) * 8;
        [lblJobCountWidthContraint setConstant:lblJobCountWidthContraint.constant+widthIncrementForJobCount];
    }
    [[_lblJobCount layer] setBorderWidth:1.0f];
    [[_lblJobCount layer] setCornerRadius:12.0f];
    float colorCode = 102.0f/255.0f;
    [[_lblJobCount layer] setBorderColor:[UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f].CGColor];
    [_lblJobCount setText:[NSString stringWithFormat:@"%ld",(long)[[data searchJobCount] integerValue]]];
    
    [self setAutomationLabelsAtIndex:paramIndex];
    
}
-(void)setAutomationLabelsAtIndex:(NSInteger)paramIndex{
    
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"lblKeyword_%ld",(long)paramIndex] value:_lblKeyword.text forUIElement:_lblKeyword];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"lblLocation_%ld",(long)paramIndex] value:_lblLocation.text forUIElement:_lblLocation];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"lblExperience_%ld",(long)paramIndex] value:_lblExperience.text forUIElement:_lblExperience];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"lblSalary_%ld",(long)paramIndex] value:_lblSalary.text forUIElement:_lblSalary];
    [UIAutomationHelper setAccessibiltyLabel:[NSString stringWithFormat:@"lblJobCount_%ld",(long)paramIndex] value:_lblJobCount.text forUIElement:_lblJobCount];
    
    [self setAccessibilityLabel:[NSString stringWithFormat:@"RecentSearchCell_%ld",(long)paramIndex]];
    
}
- (NSString*)formattedLocationStringFromString:(NSString*)paramLocationData{
    
    NSArray *locArr = [paramLocationData componentsSeparatedByString:@", "];
    
    NSString *formattedLocation = @"";
    NSInteger iTmp = 0;
    NSMutableArray *locationsToShow = [NSMutableArray new];
    
    NSInteger locArrCount = [locArr count];
    for (NSInteger i=iTmp; i<locArrCount; i++) {
        
        NSString *tmpStringLoc = [locArr fetchObjectAtIndex:i];
        BOOL isOtherWordOnly = [tmpStringLoc.lowercaseString isEqualToString:@"other"];
        
        if (!isOtherWordOnly) {
            [locationsToShow addObject:tmpStringLoc];
        }
        tmpStringLoc = nil;
    }
    
    formattedLocation = [locationsToShow componentsJoinedByString:@", "];
    locationsToShow  = nil;
    
    return formattedLocation;
}
@end
