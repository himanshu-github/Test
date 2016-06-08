//
//  JDTableRowController.m
//  NaukriGulf
//
//  Created by Arun on 9/28/15.
//  Copyright © 2015 Infoedge. All rights reserved.
//

#import "RecoTableRowController.h"


@interface RecoTableRowController(){}


@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblDesignation;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblCompany;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblExp;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblLocation;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnApply;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpAlreadyApplied;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpSaveUnsave;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnSave;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUnsave;


@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpJDDesc;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpLoadMore;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpApply;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lbl1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lbl2;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *loadMoreBtn;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *spinnerForLoadMore;



@end

@implementation RecoTableRowController

- (IBAction)loadMoreAction {
    
    if (_delegate && [_delegate respondsToSelector:@selector(loadMoreTapped:)])
        [_delegate loadMoreTapped:_iTag];

}

- (IBAction)onSaveClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(saveClicked:)])
        [_delegate saveClicked:_iTag];
}
- (IBAction)onUnsave {
    
    if (_delegate && [_delegate respondsToSelector:@selector(unSaveClicked:)])
        [_delegate unSaveClicked:_iTag];

}

-(IBAction)onApplyClicked:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(applyClickedAtIndex:)])
        [_delegate applyClickedAtIndex:_iTag];

}

-(void)configureRecoCell:(NSDictionary*)dictJob forIndex:(NSInteger)index{
    
    
    [_grpJDDesc setHidden:NO];
    [_grpLoadMore setHidden:YES];
    [_grpApply setHidden:NO];
    [_lbl1 setHidden:NO];
    [_lbl2 setHidden:NO];
    

    
    [_lblDesignation setText: dictJob[@"Designation"]];
    [_loadMoreBtn setTitle:@"Load More"];

    
    
    
    [_lblCompany setText:[NSString stringWithFormat:@"%@", dictJob[@"Company"][@"Name"]]];
    [_lblExp setText:[NSString stringWithFormat:@"%@ - %@ Years",
                      dictJob[@"Experience"][@"Min"], dictJob[@"Experience"][@"Max"]]];
    [_lblLocation setText:[NSString stringWithFormat:@"%@", dictJob[@"Location"]]];
    [_imgSpinner setHidden:YES];
    
    BOOL isAlreadyApplied = [dictJob[@"IsApplied"] integerValue]? YES:NO;
    
    if (isAlreadyApplied){
        [self configureRecoForAlreadyApplied];
        return;
    }
    else{
        [_imgSpinner setHidden:YES];
        [_grpAlreadyApplied setHidden:!isAlreadyApplied];
        [_lbl2 setHidden:isAlreadyApplied];
        [_lbl1 setHidden:isAlreadyApplied];
        [_btnApply setHidden:isAlreadyApplied];
        
    }
    
    BOOL isAlreadySaved = [dictJob[@"IsSaved"] integerValue]? YES:NO;
    [_btnUnsave setHidden:!isAlreadySaved];
    [_btnSave setHidden:isAlreadySaved];
}
-(void)hideLoader:(NSDictionary*)dictJob forIndex:(NSInteger)index{
    [_btnApply setHidden:NO];
    [_imgSpinner setHidden:YES];
}
-(void)configureRecoCellForLoadMore{
    
    [_grpJDDesc setHidden:YES];
    [_grpApply setHidden:YES];
    [_lbl1 setHidden:YES];
    [_lbl2 setHidden:YES];
    [_grpAlreadyApplied setHidden:YES];
    
    [_grpLoadMore setHidden:NO];

    [_loadMoreBtn setTitle:@"Load More"];
    [_loadMoreBtn setHidden:NO];
    [_spinnerForLoadMore setHidden:YES];
    
}
-(void)configureRecoCellForShowingLoadMore{

    [_grpJDDesc setHidden:YES];
    [_grpApply setHidden:YES];
    [_lbl1 setHidden:YES];
    [_lbl2 setHidden:YES];
    [_grpAlreadyApplied setHidden:YES];
    
    [_grpLoadMore setHidden:NO];
    
    [_loadMoreBtn setTitle:@"Load More"];
    [_loadMoreBtn setHidden:YES];
    [_spinnerForLoadMore setHidden:NO];
    [self showSpinner:_spinnerForLoadMore];

}

-(void)configureRecoCellForApply{
    
    [_btnApply setHidden:YES];
    [self showSpinner:_imgSpinner];
}

-(void)configureRecoForAlreadyApplied{
    
    [_grpApply setHidden:YES];
    [_grpAlreadyApplied setHidden:NO];
    [_lbl2 setHidden:YES];
    [_lbl1 setHidden:YES];

}

-(void)configureRecoForSaving{
    
    [_btnSave setHidden:YES];
    [_btnUnsave setHidden:NO];
    
}

-(void)configureRecoForAlreadySaved{
    
    [_btnSave setHidden:YES];
    [_btnUnsave setHidden:NO];
    
}

-(void)configureRecoForUnsaving{
    
    [_btnUnsave setHidden:YES];
    [_btnSave setHidden:NO];
    
}

-(void)configureRecoForSave{
    
    [_btnSave setHidden:NO];
    [_btnUnsave setHidden:YES];
}

-(void)showSpinner:(WKInterfaceImage*)spinner{
    
    [spinner setHidden:NO];
    [spinner setImageNamed:@"spinner"];
    [spinner startAnimatingWithImagesInRange:NSMakeRange(1, 42)
                                            duration:1.0
                                         repeatCount:0];
}
@end
