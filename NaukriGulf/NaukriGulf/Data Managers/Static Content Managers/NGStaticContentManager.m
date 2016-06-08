//
//  NGStaticContentManager.m
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGStaticContentManager.h"
#import "NGProfileDataFetcher.h"
#import "NGJDdataFetcher.h"
#import "NGJobDataFetcher.h"
#import "NGFileDataFetcher.h"
#import "NGStaticContentParser.h"
#import "NGUnregApplyFieldsDataFetcher.h"
#import "NGResmanDataFetcher.h"
#import "Designation.h"
#import "CompanyName.h"

@implementation NGStaticContentManager



#pragma mark Suggested Strings
+(NSArray *)getNewDropDownData:(int) ddType{
    
    NGFileDataFetcher *fileDataFetcher = [[NGFileDataFetcher alloc] init];
    NSString * data = [fileDataFetcher getDataFromFile:[NGConfigUtility  getAppDropDownFileName:ddType ] ];
    NGStaticContentParser *scpObj = [[NGStaticContentParser alloc]init];
    NSArray *ddArr;
    NSDictionary *ddDict = [scpObj parseTextResponseData:[NSDictionary dictionaryWithObjectsAndKeys:data,KEY_DD_DATA,[NSNumber numberWithInteger:ddType],KEY_DD_TYPE, nil]];
    if (ddDict) {
        ddArr = [ddDict objectForKey:KEY_DD_DATA];
    }
    return ddArr;
    
    
}

-(NSArray*) getSuggestedKeySkillsWithFrequency:(NSString*) key {
   
    NGFileDataFetcher *fdfObj = [[NGFileDataFetcher alloc]init];
    NSMutableArray *skillArray = [[NSMutableArray alloc] init];
    NSString *str = [fdfObj getDataFromFile:key];
    NSMutableArray *newSkill = [[NSMutableArray alloc] init];
    for (NSString *string in [str componentsSeparatedByString:@",\n"]){
        
        NSDictionary *dict =  [string JSONValue];
        
        if (dict) {
            [newSkill addObject:dict];
        }
        
        
    }
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"Frequency" ascending:true];
    
    newSkill= (NSMutableArray*)[newSkill sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    for (NSInteger i = newSkill.count-1; i>=0; i--) {
        
        NSDictionary *dict =   [newSkill objectAtIndex:i];
        [dict objectForKey:@"skill"];
        [skillArray addObject:[dict objectForKey:@"skill"]];
    }
    
    return (NSArray*)(skillArray);
}
-(NSArray*) getSuggestedCompanyWithFrequency:(NSString*)key {
    
    NGFileDataFetcher *fdfObj = [[NGFileDataFetcher alloc]init];
    NSMutableArray *companyArray = [[NSMutableArray alloc] init];
    NSString *str = [fdfObj getDataFromFile:key];
    NSMutableArray *newCompany = [[NSMutableArray alloc] init];
    for (NSString *string in [str componentsSeparatedByString:@",\n"]){
        
        NSDictionary *dict =  [string JSONValue];
        
        if (dict) {
            [newCompany addObject:dict];
        }
        
        
    }
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"Frequency" ascending:true];
    
    newCompany= (NSMutableArray*)[newCompany sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    for (NSInteger i = newCompany.count-1; i>=0; i--) {
        
        NSDictionary *dict = [newCompany objectAtIndex:i];
        [dict objectForKey:@"company"];
        [companyArray addObject:[dict objectForKey:@"company"]];
    }
    
    return (NSArray*)(companyArray);
}

-(NSArray*) getSuggestedDesignationWithFrequency:(NSString*)key {

    NGFileDataFetcher *fdfObj = [[NGFileDataFetcher alloc]init];
    NSMutableArray *companyArray = [[NSMutableArray alloc] init];
    NSString *str = [fdfObj getDataFromFile:key];
    NSMutableArray *newCompany = [[NSMutableArray alloc] init];
    for (NSString *string in [str componentsSeparatedByString:@",\n"]){
        
        NSDictionary *dict =  [string JSONValue];
        
        if (dict) {
            [newCompany addObject:dict];
        }
        
        
    }
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"Frequency" ascending:true];
    
    newCompany= (NSMutableArray*)[newCompany sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    for (NSInteger i = newCompany.count-1; i>=0; i--) {
        
        NSDictionary *dict = [newCompany objectAtIndex:i];
        [dict objectForKey:@"designation"];
        [companyArray addObject:[dict objectForKey:@"designation"]];
    }
    
    return (NSArray*)(companyArray);
}

-(NSArray *)getSuggestedStringsFromKey:(NSString*)key
{
    NGFileDataFetcher *fdfObj = [[NGFileDataFetcher alloc]init];
    NSString *str = [fdfObj getDataFromFile:key];
    NSArray *wordsArr = [str componentsSeparatedByString:@";"];
    
    return wordsArr;
}
#pragma mark JobRedirection needed
-(BOOL) isRedirectionJobToWebView: (NSString *) jobID{
    
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    return [dataFetcher isRedirectionJob:jobID];
}
#pragma mark Shortlisted/Saved Jobs

-(BOOL) isShortlistedJob: (NSString *) jobID{
    
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    return [dataFetcher isShortlistedJob:jobID];
}

-(void) shorlistedJobTuple: (NGJobDetails *) obj forStoring: (BOOL)flag{
    
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    [dataFetcher saveJobTuple:[NSArray arrayWithObjects:obj, nil] ofType:JOB_TYPE_SHORTLISTED forStoring:flag];
}

-(void)markJobAsAlreadyApplied:(NSString*)jobID
{
    
    NGJDdataFetcher *dataFetcher = [[NGJDdataFetcher alloc] init];
    [dataFetcher markJobAsAlreadyApplied:jobID];
}

-(NSInteger)isJobApplied:(NSString*)jobID{
    
    NGJDdataFetcher *dataFetcher = [[NGJDdataFetcher alloc] init];
    return [dataFetcher isJobApplied:jobID];
}

- (NSArray *) getAllSavedJobs{
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    
    return [dataFetcher getAllJobsOfType:JOB_TYPE_SHORTLISTED];
    
}

#pragma mark Recommended Jobs

-(void)saveRecommendedJobs:(NSArray *)jobs{
    
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    
    [dataFetcher saveJobTuple:jobs ofType:JOB_TYPE_RECOMMENDED forStoring:TRUE];
    
}

- (NSArray *)getAllRecommendedJobs{
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    
    return [dataFetcher getAllJobsOfType:JOB_TYPE_RECOMMENDED];
    
}

-(void)deleteAllRecommendedJobs{
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    
    [dataFetcher deleteAllJobsWithJobType:JOB_TYPE_RECOMMENDED];
}

-(void)deleteRecommendedJobs:(NSArray *)jobs{
    
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    
    [dataFetcher saveJobTuple:jobs ofType:JOB_TYPE_RECOMMENDED forStoring:FALSE];
    
}

#pragma mark Applied jobs

-(void)saveAppliedJobs:(NSArray *)jobs{
    
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    
    [dataFetcher saveJobTuple:jobs ofType:JOB_TYPE_APPLIED forStoring:TRUE];
    
}

- (NSArray *) getAllAppliedJobs{
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    
    return [dataFetcher getAllJobsOfType:JOB_TYPE_APPLIED];
    
}

-(void)deleteAllAppliedJobs{
    NGJobDataFetcher *dataFetcher = [[NGJobDataFetcher alloc] init];
    
    [dataFetcher deleteAllJobsWithJobType:JOB_TYPE_APPLIED];
}

#pragma mark ProfileViewers

-(void)saveProfileViews:(NSArray *)profileViews{
    
    NGProfileDataFetcher *dataFetcher = [[NGProfileDataFetcher alloc] init];
    
    [dataFetcher saveProfileViewTuple:profileViews];
    
}

- (NSArray *) getAllProfileViews
{
    NGProfileDataFetcher *dataFetcher = [[NGProfileDataFetcher alloc] init];
    return [dataFetcher getAllProfileViews];
}

-(void)deleteAllProfileViews
{
    NGProfileDataFetcher *dataFetcher = [[NGProfileDataFetcher alloc] init];
    
    [dataFetcher deleteAllProfileViews];
}

#pragma mark JD for swipe/transition

-(void) storeViewedJobToLocal : (NGJDJobDetails *)obj
{
    NGJDdataFetcher *dataFetcher = [[NGJDdataFetcher alloc] init];
    [dataFetcher storeViewedJobToLocal:obj];
}

-(void)deleteAllJD
{
    NGJDdataFetcher *dataFetcher = [[NGJDdataFetcher alloc] init];
    [dataFetcher deleteAllJD];
}
#pragma mark MNJ User Profile

//// MNJ User Profile

-(void)saveMNJUserProfile:(NGMNJProfileModalClass *)modelObj{
    NGProfileDataFetcher *dataFetcher = [[NGProfileDataFetcher alloc] init];
    [dataFetcher saveMNJUserProfile:modelObj];
}

-(NGMNJProfileModalClass *)getMNJUserProfile{
    NGProfileDataFetcher *dataFetcher = [[NGProfileDataFetcher alloc] init];
    NGMNJProfileModalClass *objModel = [dataFetcher getMNJUserProfile];
    return objModel;
}

-(void)deleteMNJUserProfile{
    NGProfileDataFetcher *dataFetcher = [[NGProfileDataFetcher alloc] init];
    [dataFetcher deleteMNJUserProfile];
}

-(void)saveException:(NSException*)exception withTopControllerName:(NSString*)controller{
    NGLocalDataFetcher* datafetcher = [[NGLocalDataFetcher alloc]init];
    [datafetcher saveException:exception withTopController:controller];
}

-(void)saveErrorForServer:(NGServerErrorDataModel*)errorModal{
    
    NGLocalDataFetcher* datafetcher = [[NGLocalDataFetcher alloc]init];
    [datafetcher saveErrorForServer:errorModal];
}

-(NSArray*)fetchSavedExceptions{
    NGLocalDataFetcher* datafetcher = [[NGLocalDataFetcher alloc]init];
    return [datafetcher fetchSavedExceptions:nil];
}

-(NSArray*)fetchSavedErrorsForServer{
    
    NGLocalDataFetcher* datafetcher = [[NGLocalDataFetcher alloc]init];
    return [datafetcher fetchSavedErrorsforServer:nil];
}

- (void)deleteExceptions{
    
    NGLocalDataFetcher* datafetcher = [[NGLocalDataFetcher alloc]init];
    [datafetcher deleteExceptions];
}


#pragma mark - Apply Fields


-(void)saveApplyFields:(NGApplyFieldsModel*)modalFieldObj{
    
    NGUnregApplyFieldsDataFetcher* dataFetcher = [[NGUnregApplyFieldsDataFetcher alloc] init];
    [dataFetcher saveApplyFields:modalFieldObj];
}

-(NGApplyFieldsModel*) getApplyFields{
    
    NGUnregApplyFieldsDataFetcher *dataFetcher = [[NGUnregApplyFieldsDataFetcher alloc] init];
    return [dataFetcher getApplyFields];
}


#pragma mark - Resman Fields

-(void)saveResmanFields:(NGResmanDataModel*)modalFieldObj{
    
    NGResmanDataFetcher* dataFetcher = [[NGResmanDataFetcher alloc] init];
    [dataFetcher saveResmanFields:modalFieldObj];
}

-(NGResmanDataModel*) getResmanFields{
    
    NGResmanDataFetcher *dataFetcher = [[NGResmanDataFetcher alloc] init];
    return [dataFetcher getResmanFields];
}



@end
