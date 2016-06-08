//
//  NGJobDetails.h
//  NaukriGulf
//
//  Created by Arun Kumar on 04/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGJDJobDetails.h"
#import "JSONModel.h"

@protocol NGJobDetails

@end

/**
 *  The class behaves as a model class for Job Tuple.
 */
@interface NGJobDetails : JSONModel <NSCoding>

@property (nonatomic,strong)NSString *appliedDate;
@property (nonatomic,strong)NSString *designation;
@property (nonatomic,strong)NSString *jobDescription;
@property (nonatomic,strong)NSString *cmpnyName;
@property (nonatomic,strong)NSString *location;
@property (nonatomic,strong)NSString *jobID;
@property (nonatomic,strong)NSString *jdURL;
@property (nonatomic,strong)NSString *latestPostDate;
@property (nonatomic,strong)NSString *minExp;
@property (nonatomic,strong)NSString *maxExp;
@property (nonatomic,strong)NSString *keywords;
@property (nonatomic)NSInteger vacancy;
@property (nonatomic,strong)NSString *cmpnyID;
@property (nonatomic)BOOL isAlreadyRead;
@property (nonatomic)BOOL isAlreadyShortlisted;
@property (nonatomic)BOOL isTopEmployer;
@property (nonatomic)BOOL isTopEmployerLite;
@property (nonatomic)BOOL isFeaturedEmployer;
@property (nonatomic)BOOL isWebJob;
@property (nonatomic)BOOL isQuickWebJob;
@property (nonatomic)BOOL isAlreadyApplied;
@property (nonatomic)BOOL isPremiumJob;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) NSString *TELogoURL;


@property (nonatomic, strong)NSString *isPremiumJobStr;
@property (nonatomic, strong)NSString *isFeaturedEmployerStr;
@property (nonatomic, strong)NSString *isWebJobStr;
@property (nonatomic, strong)NSString *isQuickWebJobStr;
@property (nonatomic, strong)NSString *isAlreadyAppliedStr;
@property (nonatomic, strong)NSString *isTopEmployerStr;
@property (nonatomic, strong)NSString *isTopEmployerLiteStr;


//Var to know where it was initiated, so that
//we can take required actions on JD, By Default = NO
@property (nonatomic, readwrite) BOOL isInitiatedFromDeeplinking;
//@property (nonatomic, readwrite) BOOL isInitiatedFromSpotlight;

@property (nonatomic)CGFloat cellHeight;

-(NSString *)getLogoUrl;
-(id)initWithJDJobDetailObject:(NGJDJobDetails*)paramJDJobDetails;
-(id)fillRequiredFieldsFromJDJobDetailObject:(NGJDJobDetails*)paramJDJobDetails;
//Properties for MIS data storing and taking values
//while many other screens[ex:login] comes in between apply tap and
//actual apply api hit
@property (nonatomic, strong)NSString *xzMIS;
@end

/**
 *  The class behaves as a model class for Jobs API. The model object gets create while parsing the Jobs API response.
 */
@interface NGJobDetailModel: JSONModel

@property (nonatomic,strong) NSMutableArray<NGJobDetails> *jobList;
@property (nonatomic) NSInteger totoalJobsCount;
@property (nonatomic) NSInteger totoalVacancyCount;
@property (nonatomic,strong) NSMutableDictionary *clusters;
@property (nonatomic,strong) NSString *xzMIS;
@property (nonatomic,strong) NSString *srchID_MIS;

@end
