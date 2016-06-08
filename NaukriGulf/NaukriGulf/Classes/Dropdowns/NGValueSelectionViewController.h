//
//  NGValueSelectionViewController.h
//  Naukri
//
//  Created by Arun Kumar on 17/01/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGSearchBar.h"
@protocol ValueSelectorDelegate <NSObject>

@optional

-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag;
-(void)didSelectValues:(NSDictionary *)responseParams success:(BOOL)successFlag withSelectedIndexes:(NSArray *)seletedIndexArray;


@end

@interface NGValueSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, NGSearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *resetView;
@property (weak, nonatomic) IBOutlet UILabel *valueTypeLbl;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIView *doneView;

@property (strong, nonatomic) NSMutableDictionary *requestParams;
@property (strong, nonatomic) NSMutableArray* arrPreSelectedIds;

@property (assign) int noOfSections;
@property (nonatomic,strong) NSMutableArray* selectedIds;

@property (nonatomic, weak) id<ValueSelectorDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property(nonatomic, strong) DDBase* objDDBase;
@property(nonatomic,assign) int dropdownType;
@property(nonatomic,strong) NGSearchBar* searchBar;
@property(nonatomic) BOOL showSearchBar;


- (IBAction)doneTapped:(id)sender;
- (IBAction)resetTapped:(id)sender;
- (void)displayDropdownData;
@end