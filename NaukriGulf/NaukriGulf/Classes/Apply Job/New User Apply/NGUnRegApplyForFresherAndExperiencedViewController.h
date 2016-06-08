//
//  NGUnRegApplyForFresherAndExperiencedViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/21/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
enum{
    
    ROW_TYPE_BASIC_EDUCATION_UNREG,
    ROW_TYPE_MASTER_EDUCATION_UNREG,
    ROW_TYPE_DOCTORATE_EDUCATION_UNREG,
    ROW_TYPE_CURRENT_LOCATION_UNREG,
    ROW_TYPE_NATIONALITY_UNREG,
    ROW_TYPE_DESIGNATION_UNREG
    
};




@interface NGUnRegApplyForFresherAndExperiencedViewController : NGEditBaseViewController

@property (nonatomic, strong) NGJobsHandlerObject *jobHandler;
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@end
