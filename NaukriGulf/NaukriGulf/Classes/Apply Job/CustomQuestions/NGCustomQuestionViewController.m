//
//  NGCustomQuestionViewController.m
//  NaukriGulf
//
//  Created by Arun Kumar on 07/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGCustomQuestionViewController.h"
#import "NGCQDescrptiveAnswerCell.h"

#define TOTAL_OPTIONS 4

@interface NGCustomQuestionViewController ()
{
    UITableViewCell* cqInfoCell;
    NGRowScrollHelper *scrollHelper;
    UIView *footerView;
    int tappedTag;
    
}


@end

@implementation NGCustomQuestionViewController



NSString * const qTypeArray[] = {
    @"MS",// multi select
    @"YN", // yes no
    @"MM",// multiple multiple
    @"TA" // text
};

-(qType) arrowTypeStringToEnum:(NSString*)strVal
{
    int retVal=0;
    for(int i=0; i < sizeof(qTypeArray)-1; i++)
    {
        if([(NSString*)qTypeArray[i] isEqual:strVal])
        {
            retVal = i;
            break;
        }
    }
    return (qType)retVal;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [AppTracer traceStartTime:TRACER_ID_CUSTOM_QUESTION];
    [super viewDidLoad];
    [self addNavigationBarWithCloseBtnWithTitle:@"Additional Information"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    scrollHelper = [[NGRowScrollHelper alloc] init];
    scrollHelper.tableViewToScroll = self.tableView;
    scrollHelper.tableViewFooter = self.tableView.tableFooterView;
    [UIAutomationHelper setAccessibiltyLabel:@"additionalInformation_table" forUIElement:self.tableView withAccessibilityEnabled:NO];
    
    self.isSwipePopGestureEnabled = YES;
    self.isSwipePopDuringTransition = NO;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.isSwipePopDuringTransition)
        return;
    
    [super viewWillAppear:animated];
    [scrollHelper listenToKeyboardEvent:YES];
    scrollHelper.headerHeight = 112;
    scrollHelper.rowHeight = 0;//normal row type, hence not required
    [self getCQDataArray];
    [NGDecisionUtility checkNetworkStatus];
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.isSwipePopDuringTransition)
        return;
    

    [NGHelper sharedInstance].appState = APP_STATE_CQ;
    [super viewDidAppear:animated];
    [AppTracer traceEndTime:TRACER_ID_CUSTOM_QUESTION];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [scrollHelper listenToKeyboardEvent:NO];
    [AppTracer clearLoadTime:TRACER_ID_CUSTOM_QUESTION];
    
}
-(void)getCQDataArray{
    
    
    for (int i=0; i<self.cqArray.count; i++)
    {
        
        NSDictionary *dict =   [self.cqArray objectAtIndex:i];
        [dict setValue:@"" forKey:@"AnsText"];
        
        NSArray *optionArr = [dict valueForKey:@"options"];
        
        for (int j=0; j<optionArr.count; j++) {
            
            NSDictionary *dict =   [optionArr objectAtIndex:j];

            [dict setValue:@"0" forKey:@"isSelected"];
            
            
        }
        
    }
    
}
#pragma mark -
#pragma mark TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.cqArray.count+1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==0)
    {
        NSString * CellIdentifier =@"CQ Section1";
        [self configureCQInfoCell:tableView andCellIdentifier:CellIdentifier];
        return cqInfoCell;
    }
    
    else
    {

        NSDictionary *dataDict = [self.cqArray objectAtIndex:indexPath.row-1];
        return [self configureCell:dataDict withIndexpath:indexPath];
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0){
        return 112;
    }
    
    else
    {
        NSString* prefix=[@"Question" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        return    [self getHeightForQuestion:[self arrowTypeStringToEnum:[[self.cqArray objectAtIndex:indexPath.row-1] valueForKey:@"type"]] forIndex:indexPath.row-1 withPrefix:prefix];
        
    }
}
#pragma mark- UITableview data feed methods

-(CGFloat)getHeightForQuestion:(qType)qType forIndex:(NSInteger)cellIndex_ withPrefix:(NSString*)qNo{
    
    
    switch (qType)
    {
        case 0:
        {
            
            CGFloat height = [UITableViewCell getCellHeight:[self configureSingleSelectionCell:[self.cqArray objectAtIndex:cellIndex_] andIndex:cellIndex_]];
            return height;
        }
            break;
        case 1:
        {
            CGFloat height = [UITableViewCell getCellHeight:[self configureSingleSelectionCell:[self.cqArray objectAtIndex:cellIndex_] andIndex:cellIndex_]];
            return height;
        }
            break;
        case 2:
        {
            
            CGFloat height = [UITableViewCell getCellHeight:[self configureMultipleSelectionCell:[self.cqArray objectAtIndex:cellIndex_] andIndex:cellIndex_]];
            return height;
            
        }
            break;
        case 3:
        {
            
            CGFloat height = [UITableViewCell getCellHeight:[self configureDescriptiveCell:[self.cqArray objectAtIndex:cellIndex_] andIndex:cellIndex_]];
            return height;
        }
            break;
        default:
            break;
    }
    
    
}

-(UITableViewCell*)configureCell:(NSDictionary*)dict withIndexpath:(NSIndexPath*)indexpath{
    
    UITableViewCell* cell;

   qType qType =  [self arrowTypeStringToEnum:[dict valueForKey:@"type"]];
    switch (qType)
    {
        case 0:
        {
            
            cell =  [self configureSingleSelectionCell:dict andIndex:indexpath.row];
            
        }
            break;
        case 1:
        {
            cell =  [self configureYesNoSelectionCell:dict andIndex:indexpath.row];

        }
            break;
        case 2:
        {
            cell =  [self configureMultipleSelectionCell:dict andIndex:indexpath.row];

        }
            break;
        case 3:
        {
            
            cell =  [self configureDescriptiveCell:dict andIndex:indexpath.row];

        }
            break;
        default:
            break;
    }
    
    return cell;

}
#pragma mark -
#pragma mark Configure Custom Cells

-(void)configureCQInfoCell:(UITableView*)tableView andCellIdentifier:(NSString*)CellIdentifier
{
    cqInfoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cqInfoCell == nil)
    {
        
        cqInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
    }
    cqInfoCell.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel *infoLbl = (UILabel*)[cqInfoCell.contentView viewWithTag:1001];
    [UIAutomationHelper setAccessibiltyLabel:@"cqInfoCell" forUIElement:cqInfoCell withAccessibilityEnabled:NO];
    [UIAutomationHelper setAccessibiltyLabel:@"info_header_lbl" value:@"Employer have requested additional information with your application for this job" forUIElement:infoLbl];
    
}

-(UITableViewCell*)configureSingleSelectionCell:(NSDictionary*)dict  andIndex:(NSInteger)row
{
    NSString *CellIdentifier =@"Single Selection";
    NGCQSingleSelectionAnswerCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[NGCQSingleSelectionAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                   reuseIdentifier:CellIdentifier];
    cell.delegateForAnsweredOption = self;
    
    [dict setCustomObject:[NSString stringWithFormat:@"%ld",(long)row] forKey:@"row_number"];
    [cell configureCQSingleSelectionAnswerCell:dict];
    
    return cell;
    
}
-(UITableViewCell*)configureYesNoSelectionCell:(NSDictionary*)dict andIndex:(NSInteger)row
{
    NSString *CellIdentifier =@"Single Selection";
    NGCQSingleSelectionAnswerCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[NGCQSingleSelectionAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:CellIdentifier];
        
    cell.delegateForAnsweredOption = self;
    
    [dict setCustomObject:[NSString stringWithFormat:@"%ld",(long)row] forKey:@"row_number"];
    [cell configureCQSingleSelectionAnswerCell:dict];
    
    return cell;
    
}
-(UITableViewCell*)configureMultipleSelectionCell:(NSDictionary*)dict andIndex:(NSInteger)row
{
    NSString *CellIdentifier =@"Multiple Selection";
    
    NGCQMultipleChoiceAnswerCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[NGCQMultipleChoiceAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:CellIdentifier];
    
    cell.delegateForAnsweredOptions = self;
    [dict setCustomObject:[NSString stringWithFormat:@"%ld",(long)row] forKey:@"row_number"];
    [cell configureCQMultipleChoiceAnswerCell:dict];

    return cell;
    
    
}
-(UITableViewCell*)configureDescriptiveCell:(NSDictionary*)dict andIndex:(NSInteger)row
{
    NSString *CellIdentifier =@"Descriptive";
    
    NGCQDescrptiveAnswerCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[NGCQDescrptiveAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [dict setCustomObject:[NSString stringWithFormat:@"%ld",(long)row] forKey:@"row_number"];
    [cell configureCQDescriptiveAnswerCell:dict];
    
    return cell;
    
}
#pragma mark- Check mark pressed delegates for single selection


-(void)checkMarkOptionPressed:(UIImageView*)imgV andCell:(NGCQSingleSelectionAnswerCell*)cell{

    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *cellDict = [self.cqArray fetchObjectAtIndex:indexpath.row-1];
    NSArray*  optionsArray=[cellDict valueForKey:@"options"];

    qType qType =  [self arrowTypeStringToEnum:[cellDict valueForKey:@"type"]];

    switch (qType)
    {
        case 0:
        {
            //single selection cell
            if(imgV == cell.option1Icon)
            {
            
                for (int i=0; i<optionsArray.count; i++) {
                    
                    if(i==0)
                    {
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
                        {
                            [optionDict setValue:@"0" forKey:@"isSelected"];
                            [cell.option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                            
                        }
                        else{
                            
                            [optionDict setValue:@"1" forKey:@"isSelected"];
                            [cell.option1Icon setImage:[UIImage imageNamed:@"checked"]];
                            
                        }

                        
                    }
                    else{
                            NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                            [optionDict setValue:@"0" forKey:@"isSelected"];

                    }
                    
                }
                
                [cell.option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option4Icon setImage:[UIImage imageNamed:@"unchecked-light"]];

            }
            else if (imgV == cell.option2Icon)
            {
                
                for (int i=0; i<optionsArray.count; i++) {
                    
                    if(i==1)
                    {
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
                        {
                            [optionDict setValue:@"0" forKey:@"isSelected"];
                            [cell.option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                            
                        }
                        else{
                            
                            [optionDict setValue:@"1" forKey:@"isSelected"];
                            [cell.option2Icon setImage:[UIImage imageNamed:@"checked"]];
                            
                        }
                        
                        
                    }
                    else{
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        [optionDict setValue:@"0" forKey:@"isSelected"];
                        
                    }
                    
                }
                
                [cell.option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option4Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            else if (imgV == cell.option3Icon)
            {
                
                for (int i=0; i<optionsArray.count; i++) {
                    
                    if(i==2)
                    {
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
                        {
                            [optionDict setValue:@"0" forKey:@"isSelected"];
                            [cell.option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                            
                        }
                        else{
                            
                            [optionDict setValue:@"1" forKey:@"isSelected"];
                            [cell.option3Icon setImage:[UIImage imageNamed:@"checked"]];
                            
                        }
                        
                        
                    }
                    else{
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        [optionDict setValue:@"0" forKey:@"isSelected"];
                        
                    }
                    
                }
                
                [cell.option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option4Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            else if (imgV == cell.option4Icon)
            {
                
                for (int i=0; i<optionsArray.count; i++) {
                    
                    if(i==3)
                    {
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
                        {
                            [optionDict setValue:@"0" forKey:@"isSelected"];
                            [cell.option4Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                            
                        }
                        else{
                            
                            [optionDict setValue:@"1" forKey:@"isSelected"];
                            [cell.option4Icon setImage:[UIImage imageNamed:@"checked"]];
                            
                        }
                        
                        
                    }
                    else{
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        [optionDict setValue:@"0" forKey:@"isSelected"];
                        
                    }
                    
                }
                
                [cell.option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            
        }
            break;
        case 1:
        {
            
            //yes no cell seletin
            if(imgV == cell.option1Icon)
            {
                
                for (int i=0; i<optionsArray.count; i++) {
                    
                    if(i==0)
                    {
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
                        {
                            [optionDict setValue:@"0" forKey:@"isSelected"];
                            [cell.option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                            
                        }
                        else{
                            
                            [optionDict setValue:@"1" forKey:@"isSelected"];
                            [cell.option1Icon setImage:[UIImage imageNamed:@"checked"]];
                            
                        }
                        
                        
                    }
                    else{
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        [optionDict setValue:@"0" forKey:@"isSelected"];
                        
                    }
                    
                }
                
                [cell.option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option4Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            else if (imgV == cell.option2Icon)
            {
                
                for (int i=0; i<optionsArray.count; i++) {
                    
                    if(i==1)
                    {
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
                        {
                            [optionDict setValue:@"0" forKey:@"isSelected"];
                            [cell.option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                            
                        }
                        else{
                            
                            [optionDict setValue:@"1" forKey:@"isSelected"];
                            [cell.option2Icon setImage:[UIImage imageNamed:@"checked"]];
                            
                        }
                        
                        
                    }
                    else{
                        NSDictionary *optionDict = [optionsArray objectAtIndex:i];
                        [optionDict setValue:@"0" forKey:@"isSelected"];
                        
                    }
                    
                }
                
                [cell.option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                [cell.option4Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            
        }
        
        
            break;
        default:
            break;
    }

}

#pragma mark- Check mark pressed delegates for multiple selection
-(void)multipleCheckMarkOptionPressed:(UIImageView *)imgV andCell:(NGCQMultipleChoiceAnswerCell *)cell{

    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *cellDict = [self.cqArray fetchObjectAtIndex:indexpath.row-1];
    NSArray*  optionsArray=[cellDict valueForKey:@"options"];

        //multiple seleton
    
        if(imgV == cell.option1Icon)
        {
            NSDictionary *optionDict = [optionsArray objectAtIndex:0];
            if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
            {
                [optionDict setValue:@"0" forKey:@"isSelected"];
                [cell.option1Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            else{
                
                [optionDict setValue:@"1" forKey:@"isSelected"];
                [cell.option1Icon setImage:[UIImage imageNamed:@"checked"]];
                
            }
            
        }
        else if (imgV == cell.option2Icon)
        {
            NSDictionary *optionDict = [optionsArray objectAtIndex:1];
            if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
            {
                [optionDict setValue:@"0" forKey:@"isSelected"];
                [cell.option2Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            else{
                
                [optionDict setValue:@"1" forKey:@"isSelected"];
                [cell.option2Icon setImage:[UIImage imageNamed:@"checked"]];
                
            }
            
            
        }
        else if (imgV == cell.option3Icon)
        {
            
            NSDictionary *optionDict = [optionsArray objectAtIndex:2];
            if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
            {
                [optionDict setValue:@"0" forKey:@"isSelected"];
                [cell.option3Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            else{
                
                [optionDict setValue:@"1" forKey:@"isSelected"];
                [cell.option3Icon setImage:[UIImage imageNamed:@"checked"]];
                
            }
            
            
        }
        else if (imgV == cell.option4Icon)
        {
            
            
            NSDictionary *optionDict = [optionsArray objectAtIndex:3];
            if([[optionDict objectForKey:@"isSelected"] integerValue] == 1)
            {
                [optionDict setValue:@"0" forKey:@"isSelected"];
                [cell.option4Icon setImage:[UIImage imageNamed:@"unchecked-light"]];
                
            }
            else{
                
                [optionDict setValue:@"1" forKey:@"isSelected"];
                [cell.option4Icon setImage:[UIImage imageNamed:@"checked"]];
                
            }
            
            
        }
 
}

#pragma mark- validation check
-(BOOL)isAllMandatoryQuestionHasAnswered{

    BOOL isAnswered = YES;
    
    for (int i=0; i<self.cqArray.count; i++) {
        
        NSDictionary *dataDict = [self.cqArray objectAtIndex:i];
        if([[dataDict objectForKey:@"manadatory"] integerValue]==1)
        {
            qType qType =  [self arrowTypeStringToEnum:[dataDict valueForKey:@"type"]];

            if(qType == 0)
            {
                //single selection
                NSArray *optionArr = [dataDict objectForKey:@"options"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected = %@",@"1"];
                NSArray *arr = [optionArr filteredArrayUsingPredicate:predicate];
                if(arr.count>0)
                    isAnswered = YES;
                else
                {
                    isAnswered = NO;
                    break;
                }

            }
            else if(qType == 1)
            {
                //yesno selction
                NSArray *optionArr = [dataDict objectForKey:@"options"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected = %@",@"1"];
                NSArray *arr = [optionArr filteredArrayUsingPredicate:predicate];
                if(arr.count>0)
                    isAnswered = YES;
                else
                {
                    isAnswered = NO;
                    break;
                }

            
            }
            else if(qType == 2)
            {
                //multiple selection
                NSArray *optionArr = [dataDict objectForKey:@"options"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected = %@",@"1"];
                NSArray *arr = [optionArr filteredArrayUsingPredicate:predicate];
                if(arr.count>0)
                    isAnswered = YES;
                else
                {
                    isAnswered = NO;
                    break;
                }


            }

            else if(qType == 3)
            {
                //descriptive
                if([[dataDict objectForKey:@"AnsText"] length]>0)
                    isAnswered = YES;
                else
                {
                    isAnswered = NO;
                    break;
                }

            }
        }
    }
    
    return isAnswered;
    
    
}
-(void)convertAnswersToTheRequiredFormat{

    NSMutableArray* finalArray=[[NSMutableArray alloc] init];
    for (int i=0; i<self.cqArray.count; i++) {
        
        NSDictionary *dataDict = [self.cqArray objectAtIndex:i];
        
            qType qType =  [self arrowTypeStringToEnum:[dataDict valueForKey:@"type"]];
            
            if(qType == 0)
            {
                //single selection
                NSArray *optionArr = [dataDict objectForKey:@"options"];
                
                for (int j=0; j<optionArr.count; j++) {
                    
                    NSMutableDictionary* value=[optionArr objectAtIndex:j];

                    if([[value objectForKey:@"isSelected"] integerValue]==1)
                    {
                        NSMutableDictionary* dictWithCustomQuestionsAns=[[NSMutableDictionary alloc] init];
                        [dictWithCustomQuestionsAns setValue:[value valueForKey:@"id"] forKey:@"AnsId"];
                        [dictWithCustomQuestionsAns setValue:[value valueForKey:@"qId"] forKey:@"QId"];
                        [finalArray addObject:dictWithCustomQuestionsAns];
                    }
                    
                }
                
                
            }
            else if(qType == 1)
            {
                //yesno selction
                NSArray *optionArr = [dataDict objectForKey:@"options"];
                
                for (int j=0; j<optionArr.count; j++) {
                    
                    NSMutableDictionary* value=[optionArr objectAtIndex:j];
                    
                    if([[value objectForKey:@"isSelected"] integerValue]==1)
                    {
                        NSMutableDictionary* dictWithCustomQuestionsAns=[[NSMutableDictionary alloc] init];
                        [dictWithCustomQuestionsAns setValue:[value valueForKey:@"id"] forKey:@"AnsId"];
                        [dictWithCustomQuestionsAns setValue:[value valueForKey:@"qId"] forKey:@"QId"];
                        [finalArray addObject:dictWithCustomQuestionsAns];
                    }
                    
                }
                
                
            }
            else if(qType == 2)
            {
                //multiple selection
                NSArray *optionArr = [dataDict objectForKey:@"options"];
                
                for (int j=0; j<optionArr.count; j++) {
                    
                    NSMutableDictionary* value=[optionArr objectAtIndex:j];
                    
                    if([[value objectForKey:@"isSelected"] integerValue]==1)
                    {
                        NSMutableDictionary* dictWithCustomQuestionsAns=[[NSMutableDictionary alloc] init];
                        [dictWithCustomQuestionsAns setValue:[value valueForKey:@"id"] forKey:@"AnsId"];
                        [dictWithCustomQuestionsAns setValue:[value valueForKey:@"qId"] forKey:@"QId"];
                        [finalArray addObject:dictWithCustomQuestionsAns];
                    }
                    
                }
            }
            
            else if(qType == 3)
            {
                //descriptive
                
                NSMutableDictionary* dictWithCustomQuestionsAns=[[NSMutableDictionary alloc] init];
                [dictWithCustomQuestionsAns setValue:[dataDict valueForKey:@"AnsText"] forKey:@"AnsId"];
                [dictWithCustomQuestionsAns setValue:[dataDict valueForKey:@"id"] forKey:@"QId"];
                [finalArray addObject:dictWithCustomQuestionsAns];
               
            }
        
    }
    self.cqArrayWithUnRegServiceFormat=[self convertCQDataForResponse:finalArray];
}


-(NSMutableArray*)convertCQDataForResponse:(NSMutableArray*)finalArray
{
    NSMutableArray* arrayFinal=[[NSMutableArray alloc]init];
    
    for (int i=0; i<finalArray.count; i++)
    {
        
        NSMutableDictionary* dict=[[NSMutableDictionary alloc] init];
        
        id multiplechoiceAns=[[finalArray fetchObjectAtIndex:i] valueForKey:@"AnsId"];
        
        //Converting MultipleChoice Answers into required format.
        if ([multiplechoiceAns isKindOfClass:[NSArray class]])
        {
            
            NSArray* multiplechoiceAnsArray=(NSArray*)multiplechoiceAns;
            NSMutableArray* multiplechoiceAns=[[NSMutableArray alloc] init];
            
            for (int i=0; i<multiplechoiceAnsArray.count; i++)
            {
                [multiplechoiceAns addObject:[[multiplechoiceAnsArray fetchObjectAtIndex:i] valueForKey:@"AnsId"]];
            }
            
            [dict setValue:multiplechoiceAns forKey:[NSString stringWithFormat:@"%@",[[finalArray fetchObjectAtIndex:i] valueForKey:@"QId"]]];
            
            
        }
        
        else
        {
            NSMutableArray* arrayForAnswers=[[NSMutableArray alloc] init];
            [arrayForAnswers addObject:[[finalArray fetchObjectAtIndex:i] valueForKey:@"AnsId"]];
            [dict setValue:arrayForAnswers forKey:[NSString stringWithFormat:@"%@",[[finalArray fetchObjectAtIndex:i] valueForKey:@"QId"]]];
            
        }
        [arrayFinal addObject:dict];
        
    }
    
    
    return arrayFinal;
}

#pragma mark -
#pragma mark EventListeners

- (IBAction)applyJobWithCQ:(id)sender
{
    [self.view endEditing:YES];

    if([self isAllMandatoryQuestionHasAnswered])
    {
        [self convertAnswersToTheRequiredFormat];
        
        NGJobsHandlerObject *obj =  [[NGJobsHandlerObject alloc]init];
        obj.openJDLocation =  self.openJDLocation;
        obj.isEmailRegistered = self.bIsRegistredEmailId;
        obj.Controller =  self;
        obj.jobObj =  self.jobObj;
        obj.applyState = self.applyHandlerState;
        obj.cqData = self.cqArrayWithUnRegServiceFormat;
        obj.unregApplyModal = [[DataManagerFactory getStaticContentManager]getApplyFields];
        
        [[NGCQHandler sharedManager]cqHandlerCallUpdateAppliedService:obj];
        
    }else{
        
        [NGUIUtility showAlertWithTitle:@"Incomplete Form!" withMessage:[NSArray arrayWithObjects:@"Please answer all the mandatory questions", nil]
                       withButtonsTitle:@"OK" withDelegate:nil];
        
    }

    
}
-(void)closeButtonClicked:(id)sender{
    
    for (NSInteger i = self.navigationController.viewControllers.count-1;i>=0;i--) {
       
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:i];
        if ([vc isKindOfClass:[NGJDParentViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }

}
-(void)closeTapped:(id)sender
{
    
    if (self.applyHandlerState==LoginApplyStateUnRegistered)
    {
        NGJobsHandlerObject *obj =  [[NGJobsHandlerObject alloc]init];
        obj.openJDLocation =  self.openJDLocation;
        obj.Controller =  self;
        obj.jobObj =  self.jobObj;
        obj.applyState = self.applyHandlerState;
        obj.cqData = self.cqArrayWithUnRegServiceFormat;
        obj.isCQCancelled = YES;
        [[NGCQHandler sharedManager]cqHandlerCallUpdateAppliedService:obj];
    }
    
    for (id vc in [NGAnimator sharedInstance].viewCntlrArr)
    {
        if ([vc isKindOfClass:[NGJDParentViewController class]])
        {
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"ApplyUnsuccessfullMsg"];
            
            [[NGAnimator sharedInstance]popToViewController:vc animated:YES];
            break;
        }
    }
    
}


#pragma mark -
#pragma mark TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return FALSE;
    }
    if(text.length == 0 && textView.text.length == 0)
    {
        
        [self.view endEditing:YES];
    }
    
    if (textView.text.length >= 280 && range.length == 0)
        return FALSE;
    
    
    return TRUE;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint textVOrigin = [textView convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:textVOrigin];
    NSUInteger rowItem = indexpath.row;
    scrollHelper.rowType = NGScrollRowTypeNormalReloadInset;
    if (rowItem <= self.cqArray.count) {
        scrollHelper.indexPathOfScrollingRow = [NSIndexPath indexPathForItem:rowItem inSection:0];
    }else{
        scrollHelper.indexPathOfScrollingRow = nil;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
        CGPoint textVOrigin = [textView convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:textVOrigin];
        NSDictionary *datadict = [self.cqArray fetchObjectAtIndex:indexpath.row-1];
        if(textView.text!=nil)
        [datadict setValue:textView.text forKey:@"AnsText"];
    
}
#pragma mark -
#pragma mark Hadling Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
