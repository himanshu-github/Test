//
//  DDBaseIndepenndent.m
//  NaukriGulf
//
//  Created by Ayush Goel on 08/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "DDBase.h"
#import "DDHighestEducation.h"
#import "DDReligion.h"
#import "DDSalaryRange.h"
#import "DDLocation.h"
#import "DDGender.h"
#import "DDAlert.h"
#import "DDLanguage.h"
#import "DDExpYear.h"
#import "DDMaritalStatus.h"
#import "DDNoticePeriod.h"
#import "DDNationality.h"
#import "DDWorkStatus.h"
#import "DDCurrency.h"
#import "DDCurrency.h"
#import "DDEmploymentStatus.h"
#import "DDPrefLocation.h"
#import "DDCountry.h"
#import "DDPPGCourse.h"
#import "DDPGCourse.h"
#import "DDUGCourse.h"
#import "DDCity.h"
#import "DDUGSpec.h"
#import "DDPGSpec.h"
#import "DDPPGSpec.h"
#import "DDExpMonth.h"
#import "DDWorkLevel.h"
#import "DDSalaryLacs.h"
#import "DDIndustryType.h"
#import "DDJobType.h"
#import "DDFArea.h"


#import "Designation.h"
#import "FAMapped.h"

#import "CompanyName.h"
#import "IndustryAreaMapped.h"

#import "DropDown.h"


@implementation DDBase

@dynamic valueName;
@dynamic valueID;
@dynamic selectionLimit;
@dynamic headerName;
@dynamic sortedID;
@dynamic descriptionText;

#pragma mark Object Creation

+(NSManagedObject *)objectWithDict:(NSDictionary*)dict andContext:(NSManagedObjectContext *)context
{
    if(dict == nil || dict.count ==0)
        return nil;
    
    static int iSortedId = 0;
    NSManagedObject *obj = [NSEntityDescription
                            insertNewObjectForEntityForName:NSStringFromClass([self class])
                            inManagedObjectContext:context];
    [obj setValue:@"" forKey:@"descriptionText"];
    [obj setValue:[NSNumber numberWithInt:iSortedId] forKey:@"sortedID"];
    [obj setValue: [dict objectForKey:@"label"] forKey:@"valueName"];
    [obj setValue: [NSNumber numberWithInt:[[dict objectForKey:@"value"] intValue]]  forKey:@"valueID"];
    
    if ([self class] == [DDNoticePeriod class])
        [obj setValue:[dict objectForKey:@"value"]  forKey:@"serverID"];
    
    if ([self class] == [DDNoticePeriod class])
        [obj setValue:[dict objectForKey:@"value"]  forKey:@"serverID"];
    else if (([self class] == [DDExpYear class]) &&
             ([[dict objectForKey:@"label"] isEqualToString:@"30+"]))
        [obj setValue: [NSNumber numberWithInt:31] forKey:@"valueID"];
    else if([self class] == [DDAlert class])
        [obj setValue:[dict objectForKey:@"valueLabel"]  forKey:@"valueLabel"];


    [DDBase setMyValues:obj];
    iSortedId++;
    return obj;
}



+(void) setMyValues:(NSManagedObject *)objManaged
{
    DDBase* obj = (DDBase*)objManaged;
    obj.selectionLimit = [NSNumber numberWithInt:1];

     if([obj isKindOfClass: [DDCountry class]])
        obj.headerName = @"Country";
    
    else if([obj isKindOfClass: [DDCity class]])
        obj.headerName = @"City";
    
    else if([obj isKindOfClass: [DDUGCourse class]] ||
            [obj isKindOfClass: [DDPGCourse class]] ||
            [obj isKindOfClass: [DDPPGCourse class]])
        obj.headerName = @"Course";
    
    else if([obj isKindOfClass: [DDUGSpec class]] ||
            [obj isKindOfClass: [DDPGSpec class]] ||
            [obj isKindOfClass: [DDPPGSpec class]])
        obj.headerName = @"Specialization";
    
    else if([obj isKindOfClass: [DDLocation class]]){
        obj.headerName = @"Location";
        NSArray* arr = [NGDatabaseHelper getAllClassData:[DDLocation class]];
        obj.selectionLimit = [NSNumber numberWithInteger:arr.count];
    }
    else if([obj isKindOfClass: [DDWorkStatus class]])
        obj.headerName = @"Visa Status";
    
    else if([obj isKindOfClass: [DDExpYear class]])
        obj.headerName = @"Years";
    
    
    else if([obj isKindOfClass: [DDExpMonth class]])
        obj.headerName = @"Months";
    
    else if([obj isKindOfClass: [DDSalaryRange class]])
        obj.headerName = @"Current Salary";
    
    
    else if([obj isKindOfClass: [DDNationality class]])
        obj.headerName = @"Nationality";
    
    else if([obj isKindOfClass: [DDReligion class]])
        obj.headerName = @"Religion";
    
    else if([obj isKindOfClass: [DDMaritalStatus class]])
        obj.headerName = @"Marital Status";
    
    else if([obj isKindOfClass: [DDLanguage class]]){
        obj.headerName = @"Langauges Known";
        obj.selectionLimit = [NSNumber numberWithInt:3];
    }
    
    else if([obj isKindOfClass: [DDIndustryType class]])
        obj.headerName = @"Industry Type";
    
    else if([obj isKindOfClass: [DDFArea class]])
        obj.headerName = @"Functional Area";
    
    else if([obj isKindOfClass: [DDWorkLevel class]])
        obj.headerName = @"Work Level";
    
    else if([obj isKindOfClass: [DDNoticePeriod class]])
        obj.headerName = @"Availability to Join";
    
    else if([obj isKindOfClass: [DDHighestEducation class]])
        obj.headerName = @"Highest Education";
    
    else if([obj isKindOfClass: [DDPrefLocation class]]){
        obj.headerName = @"Preferred Location";
        obj.selectionLimit = [NSNumber numberWithInt:3];
    }
    else if([obj isKindOfClass: [DDEmploymentStatus class]])
        obj.headerName = @"Employment Status";
    
    else if([obj isKindOfClass: [DDJobType class]])
        obj.headerName = @"Employment Preference";
    
    else if([obj isKindOfClass: [DDCurrency class]])
        obj.headerName = @"Currency";
    
    else  if([obj isKindOfClass: [DDAlert class]]){
        obj.headerName = @"Alerts Settings";
        NSArray* arr = [NGDatabaseHelper getAllClassData:[DDAlert class]];
        obj.selectionLimit = [NSNumber numberWithInteger:arr.count];
    }
}

-(NSString *) selectedValueID:(int) ddType
{
    switch (ddType)
    {
        case DDC_NOTICE_PERIOD:
        {
            
            return [self valueForKey:@"serverID"];
  
        }
        break;
        case DDC_ALERT:
            return [self valueForKey:@"valueLabel"];
            break;
               default:
            break;
    }
   
    return ((NSNumber*)[self valueForKey:@"valueID"]).stringValue;
}


#pragma mark Update/Create Data
+(void)updateDataFromTextFile
{
    
}
+(void)updateDataFromTextFile:(int) ddType andContext:(NSManagedObjectContext *)context;
{
    NSArray *arr = [NGStaticContentManager getNewDropDownData:ddType];
    switch (ddType)
    {
        case DDC_RELIGION:
        case DDC_LANGUAGE:
        case DDC_HIGHEST_EDUCTAION:
        case DDC_SALARY_RANGE:
        case DDC_EXP_MONTH:
        case DDC_WORK_LEVEL:
        case DDC_SALARY_LACS:
        case DDC_INDUSTRY_TYPE:
        case DDC_JOBTYPE:
        case DDC_PREFRENCE_LOCATION:
        case DDC_EMPLOYMENT_STATUS:
        case DDC_FAREA:
        case DDC_CURRENCY:
        case DDC_WORK_STATUS:
        case DDC_NATIONALITY:
        case DDC_NOTICE_PERIOD:
        case DDC_MARITAL_STATUS:
        case DDC_EXP_YEARS:
        {
            for(NSDictionary *dict in arr)
            {
                [[self class] objectWithDict:dict andContext:context];
            }
            
        }
            break;
       case DDC_GENDER:
        case DDC_ALERT:
        {
            int count =0;
            for(NSDictionary *tempDict in arr)
            {
                NSMutableDictionary *dict =[NSMutableDictionary new];
                [dict setObject:[tempDict objectForKey:@"label"] forKey:@"label"];
                [dict setObject:[NSString stringWithFormat:@"%d",count] forKey:@"value"];
                [dict setObject:[tempDict objectForKey:@"value"] forKey:@"valueLabel"];
                [[self class]  objectWithDict:dict andContext:context];
                count ++;
            }
            break;
        }
        case DDC_LOCATION:
        {
            int count = 0;
            for(NSString *name in arr)
            {
                NSMutableDictionary *dict =[NSMutableDictionary new];
                [dict setObject:name forKey:@"label"];
                [dict setObject:[NSString stringWithFormat:@"%d",count] forKey:@"value"];
                [[self class] objectWithDict:dict andContext:context];
                count ++;
            }
             break;
        }
        default:
            break;
    }
}

#pragma mark  Fetch Server DropDown

+(void)fetchDataFromServer:(NSDictionary *) modifiedDict
{
    
    /*
    __block int serviceCount = 0;
    if(modifiedDict.count!=0)
    {
        NSArray *keys = [modifiedDict allKeys];
             for(NSString *lKey in keys)
             {
                 DropDown *dropdownObj = [DropDown dropDownObjectonServiceName:lKey];
                 if(dropdownObj)
                 {
                     BOOL updateNeeded = [ DDBase updateNeeded:dropdownObj inAllValues:modifiedDict];
                     if(updateNeeded)
                     {
                         NSMutableDictionary *params = [NSMutableDictionary dictionary];
                         [params setValue:dropdownObj.serviceName forKey:@"dropdownType"];
                         NGWebDataManager *wobj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
                         [wobj getDataWithParams:params handler:^(NGAPIResponseModal *responseData)
                          {
                              if(responseData.isSuccess)
                              {
                                  if(![dropdownObj.dependentClassName isEqualToString:@""])
                                  {
                                      DropDown *childObj = [DropDown dropDownObjectonClassName:dropdownObj.dependentClassName];
                                      NSMutableDictionary *lparams = [NSMutableDictionary dictionary];
                                      [lparams setValue:childObj.serviceName forKey:@"dropdownType"];
                                      NGWebDataManager *wobj1 = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_DROPDOWN];
                                      [wobj1 getDataWithParams:lparams handler:^(NGAPIResponseModal *lresponseData)
                                       {
                                           if(lresponseData.isSuccess)
                                           {
                                               [dropdownObj saveServerData:responseData.parsedResponseData time:[modifiedDict valueForKey:dropdownObj.serviceName]];
                                               [childObj saveServerData:lresponseData.parsedResponseData time:[modifiedDict valueForKey:childObj.serviceName]];
                                               serviceCount ++;
                                               [DDBase checkServiceRequestCompleted:serviceCount totalServices:(int)modifiedDict.count];
                                           }
                                           else
                                           {
                                               // Child Service Failure
                                               serviceCount ++;
                                               [DDBase checkServiceRequestCompleted:serviceCount totalServices:(int)modifiedDict.count];
                                           }
                                       }];
                                  }
                                  else
                                  {
                                      [dropdownObj saveServerData:responseData.parsedResponseData time:[modifiedDict valueForKey:dropdownObj.serviceName]];
                                      serviceCount ++;
                                      [DDBase checkServiceRequestCompleted:serviceCount totalServices:(int)modifiedDict.count];
                                  }
                              }
                              else
                              {
                                  // Service Failure
                                  serviceCount ++;
                                  [DDBase checkServiceRequestCompleted:serviceCount totalServices:(int)modifiedDict.count];
                              }
                          }];
                     }
                     else
                     {
                         // Update  not Needed
                         serviceCount ++;
                         [DDBase checkServiceRequestCompleted:serviceCount totalServices:(int)modifiedDict.count];
                     }
                 }
                 else
                 {
                     // Object not Found
                     serviceCount ++;
                     [DDBase checkServiceRequestCompleted:serviceCount totalServices:(int)modifiedDict.count];
                 }
             }
    }
     */
}

+(void) checkServiceRequestCompleted:(int) serviceCount totalServices:(int) totalServiceCount
{
    if(serviceCount==totalServiceCount)
    {
        [NGDropDownModel saveDataContext];
        [DropDown updateDropDownData];
    }
}

+(void) insertSeverIndependentData:(NSArray *)responseArray forClass:(Class )className andContext:(NSManagedObjectContext *)context
{
    for(NSDictionary *temp in responseArray )
    {
        [className objectWithDict:temp andContext:context];
    }
}

+(void) insertChildData:(NSArray *)childArray forChild:(Class )childClass andParent:(Class )parentClass andContext:(NSManagedObjectContext *)context
{
    for(NSDictionary *temp in childArray )
    {
        NSManagedObject *childObj= [childClass objectWithDict:temp andContext:context];
        if([parentClass isSubclassOfClass:[DDCountry class]])
        {
            NSArray *parentArray=[DDCountry parentObjectWithID:[temp objectForKey:@"parentid"] andContext:context];
            for(DDCountry *obj in parentArray)
            {
                DDCity *cityObj = (DDCity *)childObj;
                if(obj!=nil && cityObj!=nil)
                    [obj addCitiesObject:cityObj];
            }
        }
        else if([parentClass isSubclassOfClass:[DDUGCourse class]])
        {
            NSArray *parentArray=[DDUGCourse parentObjectWithID:[temp objectForKey:@"parentid"] andContext:context];
            for(DDUGCourse *obj in parentArray)
            {
                DDUGSpec *specObj = (DDUGSpec *)childObj;
                if(obj!=nil && specObj!=nil)
                    [obj addSpecsObject:specObj];
            }
        }
        else if([parentClass isSubclassOfClass:[DDPGCourse class]])
        {
            NSArray *parentArray=[DDPGCourse parentObjectWithID:[temp objectForKey:@"parentid"] andContext:context];
            for(DDPGCourse *obj in parentArray)
            {
                DDPGSpec *specObj = (DDPGSpec *)childObj;
                if(obj!=nil && specObj!=nil)
                    [obj addSpecsObject:specObj];
            }
        }
        else if([parentClass isSubclassOfClass:[DDPPGCourse class]])
        {
            
            NSArray *parentArray=[DDPPGCourse parentObjectWithID:[temp objectForKey:@"parentid"] andContext:context];
            for(DDPPGCourse *obj in parentArray)
            {
                DDPPGSpec *specObj = (DDPPGSpec *)childObj;
                if(obj!=nil && specObj!=nil)
                    [obj addSpecsObject:specObj];
            }
        }
    }
 
}


+(BOOL) updateNeeded:(DropDown *)obj inAllValues: (NSDictionary*)dict
{
    NSArray *keys = [NSMutableArray arrayWithArray:[dict allKeys]];
    NSDate *ldate = [NGDateManager UTCDateFromString: [dict objectForKey:obj.serviceName] WithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    if(ldate == nil||[ldate compare:obj.lastUpdated]==NSOrderedSame)
        return NO;
    if([keys containsObject:obj.parentName]&&![obj.parentName isEqualToString:@""])
    {
        DropDown *parentObj = [DropDown dropDownObjectonServiceName:obj.parentName];
        if(parentObj == nil)
            return YES;
        NSDate *ldate = [NGDateManager UTCDateFromString: [dict objectForKey:parentObj.serviceName] WithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        if(ldate == nil||[ldate compare:parentObj.lastUpdated]==NSOrderedSame)
            return YES;
        else
            return  NO;
    }
    else
        return YES;
}


#pragma mark Utility Method

+ (NSArray *) parentObjectWithID:(NSNumber *)valueID andContext:(NSManagedObjectContext *)temporaryContext;
{
        NSArray *allObjects =[NSArray array];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:temporaryContext];
        if(entity!=nil)
        {
            NSPredicate* myPredicate = [NSPredicate predicateWithFormat:@"valueID == %d",valueID.intValue];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:myPredicate];
            NSError *error;
            allObjects =  [temporaryContext executeFetchRequest:fetchRequest error:&error];
        }
       return allObjects;
}
+(NSMutableDictionary*)updateUNRegModel:(NSMutableDictionary *)dict havingType:(int)ddType
{
    NSString* myId = [dict objectForKey:KEY_ID] ;
    DDBase* objBase = [[NGDatabaseHelper searchForType:KEY_ID havingValue:myId
                                             andDDType:ddType] firstObject];
    [dict setCustomObject:objBase.valueName forKey:KEY_VALUE];
    return dict;
}

+(NSMutableDictionary*)updateUNRegModel:(NSMutableDictionary *)dict havingType:(int)ddType inArray:(NSArray *)parentArray
{
    NSString* myId = [dict objectForKey:KEY_ID] ;

    DDBase* objBase = [[NGDatabaseHelper searchForType:KEY_ID havingValue:myId inArray:parentArray andDDType:ddType] firstObject ];
    [dict setCustomObject:objBase.valueName forKey:KEY_VALUE];
    return dict;
}

+ (NSArray *)getValuesForSelectedIds:(NSArray *)selectedArr inContents:(NSArray *)dataArr
{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<dataArr.count; i++) {
        
        DDBase* obj = [dataArr fetchObjectAtIndex:i];
        
        NSString* _id = @"";
        if ([obj isKindOfClass:[DDNoticePeriod class]]) {
            DDNoticePeriod * obj1= (DDNoticePeriod *)obj;
            _id = obj1.serverID;
        }else if ([obj isKindOfClass:[DDAlert class]]){
            DDAlert* obj2 = (DDAlert*)obj;
            _id = obj2.valueLabel;
        }else
            _id = obj.valueID.stringValue;
        
        if ([selectedArr containsObject:_id] && ![arr containsObject:obj.valueName])
            [arr addObject:obj.valueName];
        
    }
    
    return arr;
}

+ (Class) classForDDType:(int)ddType{
    
    Class myclass;
    
    switch (ddType) {
        case DDC_COUNTRY:
        {
            myclass = [DDCountry class];
            break;
        }
        case DDC_CITY:
        {
            myclass = [DDCity class];
            break;
        }
            
        case DDC_UGCOURSE:{
            
            myclass = [DDUGCourse class];
            break;
        }
        case DDC_UGSPEC:{
            
            myclass = [DDUGSpec class];
            break;
        }
            
        case DDC_PGCOURSE:{
            
            myclass = [DDPGCourse class];
            break;
        }
        case DDC_PGSPEC:{
            
            myclass = [DDPGSpec class];
            break;
        }
            
        case DDC_PPGCOURSE:{
            
            myclass = [DDPPGCourse class];
            break;
        }
            
        case DDC_PPGSPEC:{
            myclass = [DDPPGSpec class];
            break;
        }
            
        case DDC_EXP_MONTH:{
            myclass = [DDExpMonth class];
            break;
        }
            
        case DDC_WORK_LEVEL:{
            
            myclass = [DDWorkLevel class];
            break;
        }
            
        case DDC_SALARY_LACS:{
            
            myclass = [DDSalaryLacs class];
            
            break;
        }
            
        case DDC_INDUSTRY_TYPE:{
            myclass = [DDIndustryType class];
            
            break;
        }
            
        case DDC_JOBTYPE:{
            myclass = [DDJobType class];
            
            break;
        }
            
        case DDC_PREFRENCE_LOCATION:{
            
            myclass = [DDPrefLocation class];
            
            break;
        }
            
        case DDC_EMPLOYMENT_STATUS:{
            myclass = [DDEmploymentStatus class];
            
            break;
        }
            
        case DDC_FAREA:{
            myclass = [DDFArea class];
            
            break;
        }
            
        case DDC_CURRENCY:{
            
            myclass = [DDCurrency class];
            
            break;
        }
            
        case DDC_WORK_STATUS:{
            
            myclass = [DDWorkStatus class];
            
            break;
        }
            
        case DDC_NATIONALITY:{
            myclass = [DDNationality class];
            
            break;
        }
            
        case DDC_NOTICE_PERIOD:{
            myclass = [DDNoticePeriod class];
            
            break;
        }
            
        case DDC_RELIGION:{
            myclass = [DDReligion class];
            
            break;
        }
            
        case DDC_MARITAL_STATUS:{
            myclass = [DDMaritalStatus class];
            
            break;
        }
            
        case DDC_EXP_YEARS:{
            myclass = [DDExpYear class];
            
            break;
        }
            
        case DDC_LANGUAGE:{
            myclass = [DDLanguage class];
            
            break;
        }
            
        case DDC_HIGHEST_EDUCTAION:{
            myclass = [DDHighestEducation class];
            
            break;
        }
            
        case DDC_ALERT:{
            myclass = [DDAlert class];
            
            break;
        }
        case DDC_GENDER:
            myclass = [DDGender class];
            
            break;
            
        case DDC_SALARY_RANGE:
            myclass = [DDSalaryRange class];
            
            break;
            
            
        case DDC_LOCATION:
            myclass = [DDLocation class];
            
            break;
            
        case DDC_DESIGNATION:
            myclass = [Designation class];
            
            break;
        case DDC_COMPANY:
            myclass = [CompanyName class];
            
            break;
            
            
        default:
            myclass = nil;
            break;
    }
    
    return  myclass;
    
}

@end
