//
//  NGEnum.h
//  NaukriGulf
//
//  Created by Ayush Goel on 26/06/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//


enum {
    RowType_Skills = 0,
    RowType_Location,
    RowType_Location_Other,
    RowType_Experience,
    RowType_SearchJobs,
};


typedef enum
{
    loginForm=0,
    forgotPwd,
    contactUs,
    aboutUs
    
}FormType;

typedef enum
{
    inputFieldTypeMail=0,
    inputFieldTypePwd,
    inputFieldTypeMobileNum,
    inputFieldTypeName,
    inputFieldTypeFeedback
}InputFieldType;

//edits

//Edit Profile States
enum{
    K_EDIT_BASIC_DETAIL_PAGE = 1,
    K_EDIT_CONTACT_DETAIL_PAGE,
    K_EDIT_EDUCATION_DETAIL_PAGE,
    K_EDIT_LANGUAGE_DETAIL_PAGE,
    K_EDIT_PERSONAL_DETAILS,
    K_EDIT_RESUME_HEADLINE_DETAIL_PAGE,
    K_EDIT_PROFILE_SUMMARY_DETAIL_PAGE,
    K_EDIT_CERTIFICATION_PAGE,
    K_EDIT_WORK_EXPERIENCE,
    K_EDIT_WORK_DETAILS,
    K_EDIT_AFFIRMATIVE_ACTION_DETAIL_PAGE,
    K_EDIT_PROJECT,
    K_EDIT_UNREG_APPLY,
    K_EDIT_INDUSTRY_INFORMATION,
    K_EDIT_DESIRED_JOB,
    K_EDIT_UNREG_APPLY_FRESHERS,
    k_RESMAN_PAGE_LOGIN_DETAIL,//page 1
    k_RESMAN_PAGE_FRESHER_EXP,//page 2
    k_RESMAN_PAGE_EXP_BASIC_DETAIL,//page 3
    k_RESMAN_PAGE_EXP_PROFESSIONAL_DETAIL,//page4
    K_RESMAN_PAGE_PERSONAL_DETAILS,
    K_RESMAN_PAGE_KEY_SKILLS,
    k_RESMAN_PAGE_PREVIOUS_WORK_EXP,
    k_RESMAN_PAGE_EDUCATION,
    k_RESMAN_JOB_PREFERENCES_VC,
    k_RESMAN_LAST_STEP_PERSONAL_DETAILS,
    k_RESMAN_DLVISA_VC,

};

enum AppBlockerFlag {
    
    K_NA = 0,
    K_BLOCKER,
    K_NON_BLOCKING_MSG,
    K_FORCE_UPGRADE,
    K_BLOCK_NOTIFICATIONS
};

enum{
    
    K_NAUKRI_PROFILE = 0,
    K_NAUKRI_HOME_HAMBURGER_ID = 1,
    K_SEARCH_JOBS_HAMBURGER_ID = 2,
    K_WHO_VIEWED_MY_CV_HAMBURGER_ID = 3,
    K_SHORTLISTED_JOBS_HAMBURGER_ID = 4,
    K_RECOMMENDED_JOBS_HAMBURGER_ID = 5,
    K_APPLY_HISTORY_HAMBURGER_ID = 6,
    K_CAREER_CAFE_HAMBURGER_ID = 7,
    K_WHATS_NEW_HAMBURGER_ID = 8,
    K_LOGOUT_HAMBURGER_ID = 9,
    K_FEEDBACK_HAMBURGER_ID = 10,
    K_LOGIN_HAMBURGER_ID = 11,
    K_REGISTER_HAMBURGER_ID = 12
};

//Local notifications

enum{
    
    K_RECOMMENDED_JOBS_LOCAL_NOTIFICATION = 0,
    K_RESMAN_LOCAL_NOTIFICATION = 1,
    K_MNJ_PAGE_LOCAL_NOTIFICATION = 2,
    K_EDIT_CV_PAGE_LOCAL_NOTIFICATION = 3,
    K_PROFILE_PAGE_LOCAL_NOTIFICATION = 4,
    K_LOGIN_PAGE_LOCAL_NOTIFICATION = 5,
    K_LOCAL_NOTIFICATION_BIRTHDAY = 6

};

//new enums
typedef NS_ENUM(NSInteger, kResmanProfileOrSearchRowType){
    
    kResmanProfileOrSearchRowTypeLetsStart = 0,
    kResmanProfileOrSearchRowTypeProfileOption,
    kResmanProfileOrSearchRowTypeSearchOption
};

typedef NS_ENUM(NSUInteger,NGFileUploadType){
    NGFileUploadTypeResume = 1,
    NGFileUploadTypePhoto
};

typedef enum {
    LoginApplyStateRegisterd = 0,
    LoginApplyStateUnRegistered = 1,
} LoginApplyHandlerState;

//Job create or Search Jobs
enum {
    K_CLASS_SEARCH_JOBS = 0,
    K_CLASS_CREATE_JOB_ALERT,
    K_CLASS_MODIFY_SEARCH,
};

typedef NS_ENUM(NSInteger, IENavigationActionType){
    IENavigationActionTypeNone = 0,
    IENavigationActionTypePush,
    IENavigationActionTypePop,
    IENavigationActionTypePopTo
};

typedef NS_ENUM(NSInteger, ValidationTypeEnum){
    VALIDATION_TYPE_EMPTY = 1,
    VALIDATION_TYPE_VALIDEMAIL,
    VALIDATION_TYPE_NUMERIC,
    VALIDATION_TYPE_SPECIALCHAR_OR_NUMERIC
};

typedef NS_ENUM(NSInteger, UserProfile){
    NONE_SECTION = INT_MIN,
    BASIC_DETAILS = 0,
    CONTACT_DETAILS=1,
    CV_HEADLINE = 2,
    KEY_SKILLS = 3,
    INDUSTRY_INFO = 4,
    WORK_EXPERIENCE = 5,
    EDUCATION = 6,
    PERSONAL_DETAILS = 7,
    DESIRED_JOB = 8,
    PROJECTS = 9,
    IT_SKILLS = 10,
    CV = 11,
};

typedef NS_ENUM(NSInteger, DropDownConstants){
    DDC_COUNTRY = 0,
    DDC_CITY = 1,
    DDC_UGCOURSE = 2,
    DDC_UGSPEC = 3,
    DDC_PGCOURSE = 4,
    DDC_PGSPEC = 5,
    DDC_PPGCOURSE = 6,
    DDC_PPGSPEC = 7,
    DDC_EXP_MONTH = 8,
    DDC_WORK_LEVEL = 9,
    DDC_SALARY_LACS = 10,
    DDC_INDUSTRY_TYPE = 11,
    DDC_JOBTYPE = 12,
    DDC_PREFRENCE_LOCATION = 13,
    DDC_EMPLOYMENT_STATUS = 14,
    DDC_FAREA = 15,
    DDC_CURRENCY = 16,
    DDC_WORK_STATUS = 17,
    DDC_NATIONALITY = 18,
    DDC_NOTICE_PERIOD = 19,
    DDC_RELIGION = 20,
    DDC_MARITAL_STATUS = 21,
    DDC_EXP_YEARS = 22,
    DDC_LANGUAGE = 23,
    DDC_HIGHEST_EDUCTAION = 24,
    DDC_ALERT = 25,
    DDC_GENDER = 26,
    DDC_SALARY_RANGE = 27,
    DDC_LOCATION = 28,
    DD_EDIT_EXPERIENCE =104,
    DD_EDIT_COUNTRY_CITY = 105,
    DDC_DESIGNATION = 29,
    DDC_FAMAPPED = 30,
    DDC_COMPANY = 31,
    DDC_IAMAPPED = 32,
};


typedef NS_ENUM(NSInteger, NGApplicationState){
    APP_STATE_HOME = 1,
    APP_STATE_JOB_SEARCH = 2,
    APP_STATE_SRP = 3,
    APP_STATE_SHORTLISTED_JOB = 4,
    APP_STATE_JD = 5,
    APP_STATE_MNJ=  6,
    APP_STATE_PROFILE = 7,
    APP_STATE_EDIT_FLOW = 8,
    APP_STATE_MNJ_ANALYTICS = 9,
    APP_STATE_PROFILE_VIEWER = 10,
    APP_STATE_APPLIED_JOBS  = 11,
    APP_STATE_RECOMMENDED_JOBS = 12,
    APP_STATE_FEEDBACK  = 13,
    APP_STATE_LOGIN = 14,
    APP_STATE_UNREG_APPLY  = 15,
    APP_STATE_MODIFY_SSA = 16,
    APP_STATE_CQ = 17,
    APP_STATE_APPLY_CONFIRMATION  =18,
    K_APP_STATE_FORCE_UPGRADE = 19,
    APP_STATE_RESMAN_FLOW = 20,
    APP_STATE_VIEW_MORE_JOB = 21,


};

typedef enum {
    VCLogStatusNone,
    VCLogStatusStart,
    VCLogStatusEnd,
    VCLogStatusKill
}VCLogStatus;

NS_ENUM(NSUInteger, NGTimeUnit){
    NGTimeUnitMinute,
    NGTimeUnitHour,
    NGTimeUnitDay
};

typedef enum{
    UnRegApplyContactCellTextTagCountryCode,
    UnRegApplyContactCellTextTagMobileNumber
}UnRegApplyContactCellTextTag;


typedef enum{
    V_SPOTLIGHT_SRP,
    V_SPOTLIGHT_RECOMMENDED_JOBS,
    V_SPOTLIGHT_APPLIED_JOBS,
    V_SPOTLIGHT_SHORTLISTED_JOBS,
    V_SPOTLIGHT_CV_VIEW,
    V_SPOTLIGHT_REGISTRATION,
    V_SPOTLIGHT_SEARCH,
    V_SPOTLIGHT_JOB_DESCRIPTION,
    V_SPOTLIGHT_HOME,
    V_SPOTLIGHT_MNJ,
    V_SPOTLIGHT_SHORTLISTED_JOBS_AT_JOB_ANALYTICS,
    V_SPOTLIGHT_PROFILE
   
}SPOTLIGHT_PAGES;

typedef enum{
    JD_FROM_SRP_PAGE = 1,
    JD_FROM_RECOMMENDED_JOBS_PAGE = 2,
    JD_FROM_SAVED_OR_SHORTLISTED_JOBS_PAGE = 3,
    JD_FROM_VIEWMORE_OR_JD_SIM_JOB = 4,
    JD_FROM_ACP_SIM_JOB_PAGE = 5
    
}JD_OPEN_PAGES;
