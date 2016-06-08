//
//  NGJDJobDetails.h
//  NaukriGulf
//
//  Created by Arun Kumar on 06/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
/**
 *  The class behaves as a model class for JD API. The model object gets create while parsing the JD API response.
 */
@interface NGJDJobDetails : JSONModel

@property(nonatomic,strong) NSString *industryType;
@property(nonatomic,strong) NSString *functionalArea;
@property(nonatomic,strong) NSString *location;
@property(nonatomic,strong) NSString *jobDescription;
@property(nonatomic,strong) NSString *jobId;
@property(nonatomic,strong) NSString *designation;
@property(nonatomic,strong) NSString *companyId;
@property(nonatomic,strong) NSString *companyName;
@property(nonatomic,strong) NSString *companyProfile;
@property(nonatomic,strong) NSString *minCtc;
@property(nonatomic,strong) NSString *maxCtc;
@property(nonatomic,strong) NSString *isCtcHidden;
@property(nonatomic,strong) NSString *otherBenefits;
@property (nonatomic) NSInteger vacancies;
@property(nonatomic,strong) NSString *latestPostedDate;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *isWebjob;
@property(nonatomic,strong) NSString *isQuickWebjob;
@property(nonatomic,strong) NSString *isPremium;
@property(nonatomic,strong) NSString *dcProfile;
@property (nonatomic,strong)NSString *minExp;
@property (nonatomic,strong)NSString *maxExp;
@property(nonatomic,strong) NSString *education;
@property(nonatomic,strong) NSString *nationality;
@property(nonatomic,strong) NSString *gender;
@property(nonatomic,strong) NSString *category;
@property(nonatomic,strong) NSString *contactName;
@property(nonatomic,strong) NSString *contactDesignation;
@property(nonatomic,strong) NSString *contactWebsite;
@property(nonatomic,strong) NSString *contactEmail;
@property(nonatomic,strong) NSString *isEmailHiddden;
@property(nonatomic,strong) NSString *landline;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *isAlreadyApplied;
@property(nonatomic,strong) NSString *isArchivedjob;
@property(nonatomic,strong) NSString* keywords;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) NSString *showLogo;

//added new properties, which were missing here
//and present in NGJobDetails,so when JD open directly(through deeplinking)
//we have all info
@property (nonatomic,strong)NSString *jdURL;
@property (nonatomic, strong) NSString *TELogoURL;
@property (nonatomic,readwrite)BOOL isTopEmployer;
@property (nonatomic,readwrite)BOOL isTopEmployerLite;
@property (nonatomic,readwrite)BOOL isFeaturedEmployer;
@property (nonatomic,readwrite)BOOL isPremiumJob;

//Shortened Texts
@property(nonatomic, strong) NSString *shortCompanyProfile;
@property(nonatomic, strong) NSString *shortJobDescription;
@property(nonatomic, strong) NSString *shortDcProfile;
@property(nonatomic,readwrite) BOOL isAlreadyAppliedAsBool;
@property(nonatomic,readwrite) BOOL isWebjobAsBool;
@property(nonatomic,readwrite) BOOL isQuickWebjobAsBool;

//Formatted Strings
@property(nonatomic,strong) NSString *formattedExperience;
@property(nonatomic,strong) NSString *formattedSalary;
@property(nonatomic,strong) NSString *formattedVacancies;
@property(nonatomic,strong) NSString *formattedContactNameDes;
@property(nonatomic,strong) NSString *formattedLatestPostedDate;

//new added
@property (nonatomic, strong) NSString *isTopEmployerStr;
@property (nonatomic, strong) NSString *isTopEmployerLiteStr;
@property (nonatomic, strong) NSString *isFeaturedEmployerStr;
@property (nonatomic, strong) NSString *isPremiumJobStr;
@property (nonatomic, strong) NSString *isQuickWebjobStr;


//Job Redirection key
@property (nonatomic, strong) NSString *isJobRedirection;
@property (nonatomic, strong) NSString *jobRedirectionUrl;


-(NSString *)getLogoUrl;
@end
