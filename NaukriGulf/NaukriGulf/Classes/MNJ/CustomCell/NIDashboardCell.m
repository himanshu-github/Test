//
//  NIDashboardCell.m
//  Naukri
//
//  Created by Swati Kaushik on 15/04/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NIDashboardCell.h"


#define kFirstViewTag  1899
@interface NIDashboardCell()
{
    NSTimer* timer;
    float originX;
    int tileIndex;
}
@end
@implementation NIDashboardCell

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

-(void)handlePan:(UIPanGestureRecognizer*)gesture{
    CGPoint translatedPoint = [gesture translationInView:gesture.view];
    if(gesture.state == UIGestureRecognizerStateEnded){
        NSInteger expandIndex = 0;
        BOOL doNothing = NO;
        if(translatedPoint.y < 0)
        {
            if(_isExpanded)
            {
                switch (titleLbl.tag) {
                    case CellTypeRecommendedJobs:
                        expandIndex = CellTypeSavedJobs;
                        break;
                    case CellTypeSavedJobs:
                        expandIndex =  CellTypeAppliedJobs;
                        break;
                    case CellTypeAppliedJobs:
                        expandIndex = CellTypePV;
                        break;
                    default:
                        doNothing = YES;
                        break;
                }
                
                
            }
            else
            {
                expandIndex = titleLbl.tag;
            }
            
        }
        else
        {
            if(_isExpanded)
            {
                switch (titleLbl.tag) {
                    case CellTypeRecommendedJobs:
                        doNothing = YES;
                        break;
                    case CellTypeSavedJobs:
                        expandIndex = CellTypeRecommendedJobs;
                        break;
                        
                        
                    case CellTypeAppliedJobs:
                        expandIndex = CellTypeSavedJobs;
                        break;
                        
                    case CellTypePV:
                        expandIndex = CellTypeAppliedJobs;
                        break;
                    default:
                        doNothing = YES;
                        
                        break;
                }
                
            }
            else
            {
                if(titleLbl.tag == CellTypePV)
                    doNothing = YES;
                else
                    expandIndex = titleLbl.tag;
                
            }
            
            
            
        }
        if(!doNothing)
            [_delegate changeCellState:expandIndex isExpanded:YES];
        
        
    }
}

-(void)awakeFromNib{
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]init];
    panGesture.delegate = self;
    [panGesture addTarget:self action:@selector(handlePan:)];
    panGesture.cancelsTouchesInView = YES;
    [self.contentView addGestureRecognizer:panGesture];
}
-(void)configureCellWithType:(CellType)cellType{
    
    titleLbl.tag = cellType;
    counterLbl.text = [NSString stringWithFormat:@"%ld",(long)_displayCount];
   
    NSString *facetMessageForCell = @"new";
    
    switch (cellType) {
        case CellTypeRecommendedJobs:
            
            self.contentView.backgroundColor =  kDashboardBlueColor;
            titleLbl.text  = @"Recommended Jobs";
            tilesImageView.image = [UIImage imageNamed:@"jobscroll"];
            if(_displayCount > 0){
                
                facetMessageForCell = self.tileCount>1?@"new jobs":@"new job";
                
            }else{
                
                facetMessageForCell = nil;
            }
            break;
        case CellTypeSavedJobs:
            self.contentView.backgroundColor =  kDashboardAquaColor;
            titleLbl.text  = @"Shortlisted Jobs";
            self.tileCount = 0;
        
            break;
        case CellTypeAppliedJobs:
            self.contentView.backgroundColor =  kDashboardAquaGreenColor;
            titleLbl.text  = @"Applied Jobs";
            self.tileCount = 0;
            
            break;
        case CellTypePV:
            self.contentView.backgroundColor =  kDashboardGreenColor;
            titleLbl.text  = @"Profile Views";
            tilesImageView.image = [UIImage imageNamed:@"viewscroll"];
            if(_displayCount > 0) {
            
                facetMessageForCell = self.tileCount>1?@"new views":@"new view";
            }else{
                
                facetMessageForCell = nil;
            }
            break;
        default:
            break;
    }
    if(self.tileCount > 0) {
    
        tilesCountLbl.text = [NSString stringWithFormat:@"%ld %@",(long)self.tileCount,facetMessageForCell];

        tilesImageView.hidden = !_isExpanded;
    
        tilesCountLbl.hidden = !_isExpanded;
    }else{
        
        tilesImageView.hidden = TRUE;
        tilesCountLbl.hidden= TRUE;
        
    }
    
    [UIAutomationHelper setAccessibiltyLabel:@"totalCount_lbl" value:counterLbl.text forUIElement:counterLbl];
    
    [UIAutomationHelper setAccessibiltyLabel:@"newCount_lbl" value:tilesCountLbl.text forUIElement:tilesCountLbl];

}

@end
