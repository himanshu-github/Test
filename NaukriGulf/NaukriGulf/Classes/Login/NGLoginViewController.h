//
//  NGLoginViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 02/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//
/**
 *  LOGINVIEWTYPE enums are used for dsiplaying views. It consist of two view type LOGINVIEWTYPE_REGISTER_VIEW,LOGINVIEWTYPE_APPLY_VIEW
 */

typedef enum LOGINVIEWTYPE {
    
    LOGINVIEWTYPE_REGISTER_VIEW,
    LOGINVIEWTYPE_APPLY_VIEW
    
}LOGINVIEWTYPE;

@class NGJobDetails;
@class NGTextField;
/**
 *  This Class allows the user to login. User can login from two ways either by applying from Register view or from Apply view
 */


@interface NGLoginViewController : NGBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) LoginApplyHandlerState applyHandlerState;

/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */
@property (strong, nonatomic) NGJobDetails *jobObj;

/**
 *  Specifies location(page/form) from where job descrption page is opened,
 this is being used in MIS.
 */
@property (nonatomic) int openJDLocation;

@property (strong,nonatomic) NSString *titleForLoginView;

@property (weak,nonatomic) IBOutlet UITableView *tblLoginForm;

@property (nonatomic) BOOL showAlreadyRegisteredError;

-(void)showViewWithType:(LOGINVIEWTYPE)viewType;
@end
