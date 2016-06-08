//
//  NGLayeredValueSelectionViewController.h
//  Naukri
//
//  Created by Arun Kumar on 8/27/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGSearchBar.h"

@class NGValueSelectionResponseModal;

@protocol NGValueSelectionRequestModal<NSObject>
@end

@protocol LayeredValueSelectionDelegate <NSObject>

-(void)layerValueSelected:(NGValueSelectionResponseModal*)selectedModal;

@end



@interface NGLayeredValueSelectionViewController : NGBaseViewController<UISearchBarDelegate, UISearchDisplayDelegate, NGSearchBarDelegate>

@property(nonatomic, strong) NSMutableArray *displayData;
@property(nonatomic, strong) NSString *selectedId;

@property(nonatomic, strong) IBOutlet UIButton* btnBottom;
@property(nonatomic, strong) NGValueSelectionResponseModal* valueSelectionResponseModal;
@property(nonatomic) NSInteger iLayerProgressStatus;
@property(nonatomic,readwrite) NSInteger dropdownType; //drop down types integer
@property(nonatomic,strong) NSMutableArray* arrTitles;
@property(nonatomic,strong) NGSearchBar* searchBar;
@property(nonatomic) BOOL showSearchBar;

@property(nonatomic, assign) id<LayeredValueSelectionDelegate>delegateOfLayerViewController;
@end
