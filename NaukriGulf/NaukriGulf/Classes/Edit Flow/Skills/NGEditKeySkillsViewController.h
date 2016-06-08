//
//  NGEditKeySkillsViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

/**
 *   delegate of NGEditKeySkillsViewController must adopt the EditKeySkillsDelegate and informs about the actions performed during editing
 */
@protocol EditKeySkillsDelegate <NSObject>
/**
 *   a delegate method initailzed when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */

-(void)editedKeySkillsWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */

@end

/**
 *  This Controller is used for displaying Key Skills
 *  Conforms the UITextFieldDelegate, UITableViewDataSource, EditKeySkillModalViewDelegate,UITableViewDelegate,EditKeySkillsCellDelegate .
 */

@interface NGEditKeySkillsViewController : NGEditBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) id<EditKeySkillsDelegate> editDelegate;
/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj;

@end
