//
//  NGCVViewRowController.m
//  NaukriGulf
//
//  Created by Himanshu on 2/7/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGCVViewRowController.h"
#import <WatchKit/WatchKit.h>

@interface NGCVViewRowController(){

}
@property (unsafe_unretained, nonatomic)  IBOutlet WKInterfaceLabel *compNameLbl;
@property (unsafe_unretained, nonatomic)  IBOutlet WKInterfaceLabel *indLbl;
@property (unsafe_unretained, nonatomic)  IBOutlet WKInterfaceLabel *countryLbl;
@property (unsafe_unretained, nonatomic)  IBOutlet WKInterfaceLabel *dateLbl;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup  *grpLoadMore;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *loadMoreBtn;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage  *spinnerLoadMore;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *locationImg;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *spacingLbl1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *spacingLbl2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *spacingLbl3;



@end

@implementation NGCVViewRowController


- (IBAction)loadMoreAction {
    
    if (_delegate && [_delegate respondsToSelector:@selector(loadMoreTapped:)])
        [_delegate loadMoreTapped:self.iTag];
    
}
-(void)configureCVViewCell:(NSDictionary*)dictJob forIndex:(NSInteger)index{
    
    [_compNameLbl setHidden:NO];
    [_indLbl setHidden:NO];
    [_countryLbl setHidden:NO];
    [_dateLbl setHidden:NO];
    [_locationImg setHidden:NO];
    [_spacingLbl1 setHidden:NO];
    [_spacingLbl2 setHidden:NO];
    [_spacingLbl3 setHidden:NO];

    
    [_grpLoadMore setHidden:YES];
    [_loadMoreBtn setHidden:YES];
    [_spinnerLoadMore setHidden:YES];

   
    [_compNameLbl setText:dictJob[@"compName"]];
    [_indLbl setText:dictJob[@"indLabel"]];
    if(dictJob[@"countryLabel"])
    {
        if([dictJob[@"countryLabel"] length]>0)
        [_countryLbl setText:dictJob[@"countryLabel"]];
        else
        [_countryLbl setText:@"Not Mentioned"];

    }
    else
    [_countryLbl setText:@"Not Mentioned"];
    [_dateLbl setText:dictJob[@"viewedDate"]];

}

-(void)configureCVViewCellForLoadMore{
    [_compNameLbl setHidden:YES];
    [_indLbl setHidden:YES];
    [_countryLbl setHidden:YES];
    [_dateLbl setHidden:YES];
    [_locationImg setHidden:YES];

    [_spacingLbl1 setHidden:YES];
    [_spacingLbl2 setHidden:YES];
    [_spacingLbl3 setHidden:YES];

    
    [_grpLoadMore setHidden:NO];
    [_loadMoreBtn setHidden:NO];
    [_spinnerLoadMore setHidden:YES];
     [_loadMoreBtn setTitle:@"Load More"];
    
}
-(void)configureCVForShowingLoadMore{
    
    [_compNameLbl setHidden:YES];
    [_indLbl setHidden:YES];
    [_countryLbl setHidden:YES];
    [_dateLbl setHidden:YES];
    [_locationImg setHidden:YES];

    [_spacingLbl1 setHidden:YES];
    [_spacingLbl2 setHidden:YES];
    [_spacingLbl3 setHidden:YES];

    
    [_grpLoadMore setHidden:NO];
    [_loadMoreBtn setHidden:YES];
    [_spinnerLoadMore setHidden:NO];
    [_loadMoreBtn setTitle:@"Load More"];
    [self showSpinner:_spinnerLoadMore];
    
}

-(void)showSpinner:(WKInterfaceImage*)spinner{
    
    [spinner setHidden:NO];
    [spinner setImageNamed:@"spinner"];
    [spinner startAnimatingWithImagesInRange:NSMakeRange(1, 42)
                                    duration:1.0
                                 repeatCount:0];
}

@end
