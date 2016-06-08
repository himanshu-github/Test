//
//  NGUnRegApplyViewController.h
//  NaukriGulf
//
//  Created by Sandeep.Negi on 28/10/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
typedef enum{
    
    ROW_TYPE_NAME,
    ROW_TYPE_EMAIL,
    ROW_TYPE_MOBILE_NO,
    ROW_TYPE_GENDER,
    ROW_TYPE_WORK_EXP
    
}UnRegApplyRowType;

@interface NGUnRegApplyViewController : NGEditBaseViewController
@property (strong,nonatomic) NGJobDetails *jobObj;
@property (nonatomic) int openJDLocation;
/**
 *  Array that contains items in dropdown(s) like-years, months.
 */
@property(nonatomic,strong) NSMutableArray* dropdownItems;
@property (nonatomic,strong) NGApplyFieldsModel* applyModelObj;
@end
