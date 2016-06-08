//
//  NGEditIndustryInformationViewController.h
//  NaukriGulf
//
//  Created by Shikha Sharma on 10/7/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//
#import "NGValueSelectionViewController.h"


enum {
    
    ROW_TYPE_INDUSTRY_TYPE = 0,
    ROW_TYPE_OTHER_INDUSTRY ,
    ROW_TYPE_FUNC_DEPT,
    ROW_TYPE_OTHER_FUNC_DEPT,
    ROW_TYPE_WORK_LEVEL,
    ROW_TYPE_AVAILIBILITY_JOIN

};


@protocol EditIndustryInfoDelegate <NSObject>
/**
 *   a delegate method initailzed when the request from the server is successful
 *
 *  @param successFlag IF YES, the details are added successfully
 */
-(void)editedIndustryInfoWithSuccess:(BOOL)successFlag;
/**
 *   a delegate method used  to notify about cacellation
 */


@end

@interface NGEditIndustryInformationViewController : NGEditBaseViewController<ValueSelectorDelegate,UITextFieldDelegate>

@property (weak, nonatomic) id<EditIndustryInfoDelegate> editDelegate;

/**
 *  a JSONModel class for parsing and creating custom getter & setter.
 */
@property (strong, nonatomic) NGMNJProfileModalClass *modalClassObj;

-(void)updateDataWithParams:(NGMNJProfileModalClass *)obj;

@end
