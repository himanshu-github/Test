//
//  NGEditResuableTableViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditResuableTableViewController.h"

@interface NGEditResuableTableViewController ()

@end

@implementation NGEditResuableTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tblEditMNJ.dataSource = self.delegate;
    self.tblEditMNJ.delegate = self.delegate;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NGDecisionUtility checkNetworkStatus];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 The @p alreadyRegisteredPressed: is explicitly implemented for NGResmanLoginViewController.
 @note This method is called when user taps on the @p self.saveBtn and also the @p next button in @p SaveButtonCell.
 */
- (IBAction)saveButton:(id)sender
{
    if([self.delegate respondsToSelector:@selector(alreadyRegisteredPressed:)]){
        
        [self.delegate alreadyRegisteredPressed: sender];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(saveButtonPressed)]){
            
            [self.delegate saveButtonPressed];
        }
    }
}

-(void) makeTableFullScreen {
    
    self.saveHeight.constant = 0;
    self.saveBtn.clipsToBounds = YES;
}

-(void) makeTableShortInHeight : (NSInteger) height{
    
    self.tableSaveRelativeConstraint.constant -= -height;
}
-(void) reduceTableSizeWithSaveBtnHiddenBy:(NSInteger) height{
    
    self.saveHeight.constant = 0;
    self.saveBtn.clipsToBounds = YES;
    self.tableSaveRelativeConstraint.constant -= -height;

}

@end
