//
//  NGSearchJobsViewController.h
//  NaukriGulf
//
//  Created by Iphone Developer on 28/05/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutocompletionTableView.h"
#import "NGRecentSearchReponseModal.h"
#import "NGSearchJobParametersTupple.h"
#import "NGValueSelectionViewController.h"
#import "NGSearchSobExperianceTupple.h"
#import "NGRecentSearchTupple.h"

@interface NGSearchJobsViewController : NGBaseViewController<ValueSelectorDelegate,NGSearchJobParameterDelegate,
ExperinceTupleDelegate,SaveSearchDelegate >

@property(nonatomic,readwrite) int classType;

//This variable explains the screen name which called the create Alert form
@property(nonatomic,readwrite) NSString *comingVia;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTableTopConstraint;
/**
 *  Denotes the existing search parameters.
 */
@property (strong, nonatomic) NSMutableDictionary *inputParams;

@end
