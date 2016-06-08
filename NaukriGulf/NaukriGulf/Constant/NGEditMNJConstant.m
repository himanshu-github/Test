//
//  NGEditMNJConstant.m
//  Naukri
//
//  Created by Arun Kumar on 3/18/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGEditMNJConstant.h"

#pragma mark - Basic Details

//resman constants
NSString * const K_RESMAN_EXPPROFESSIONALDETAIL_PLACEHOLDER_FA = @"Select Function/Department";
NSString * const K_RESMAN_EXPPROFESSIONALDETAIL_PLACEHOLDER_INDUSTRY = @"Industry your Company belongs to";
NSString * const K_RESMAN_EXPBASICDETAIL_PLACEHOLDER_EXP = @"Your Total Experience";
NSString * const K_RESMAN_EXPBASICDETAIL_PLACEHOLDER_DESIGNATION = @"Your Current Designation";
NSString * const K_RESMAN_EXPBASICDETAIL_PLACEHOLDER_COMPANY = @"Your Current Employer";
NSString * const K_RESMAN_EXPBASICDETAIL_PLACEHOLDER_CURRENTSALARY = @"Your Monthly Salary";

NSString * const K_RESMAN_PREVIOUS_WORKEXP_PLACEHOLDER_DESIGNATION = @"What was Your Designation?";
NSString * const K_RESMAN_PREVIOUS_WORKEXP_PLACEHOLDER_PREV_COMPANY = @"Name of Previous Employer";

NSString * const K_RESMAN_EDUCATION_PLACEHOLDER_UG_COURSE = @"Select Basic Course";
NSString * const K_RESMAN_EDUCATION_PLACEHOLDER_UG_SPECIALIZATION = @"Select Basic Specialization";
NSString * const K_RESMAN_EDUCATION_PLACEHOLDER_PG_COURSE = @"Select Post Graduate Course";
NSString * const K_RESMAN_EDUCATION_PLACEHOLDER_PG_SPECIALIZATION = @"Select Post Graduate Specialization";
NSString * const K_RESMAN_EDUCATION_PLACEHOLDER_PPG_COURSE = @"Select Doctorate Course";
NSString * const K_RESMAN_EDUCATION_PLACEHOLDER_PPG_SPECIALIZATION = @"Select Doctorate Specialization";
NSString * const K_RESMAN_EDUCATION_PLACEHOLDER_HIGHEST_EDUCATION = @"What is your Highest Education";


//place holders
NSString * const K_BASIC_DETAIL_PLACEHOLDER_NAME = @"Enter Name";
NSString * const K_BASIC_DETAIL_PLACEHOLDER_DESIGNATION = @"Enter Current Designation";
NSString * const K_BASIC_DETAIL_PLACEHOLDER_LOCATION = @"Select Current Location";
NSString * const K_BASIC_DETAIL_PLACEHOLDER_OTHER_LOCATION = @"Enter Current City";
NSString * const K_BASIC_DETAIL_PLACEHOLDER_SALARY = @"Select Monthly Salary";
NSString * const K_BASIC_DETAIL_PLACEHOLDER_CURRENCY_TYPE = @"Select Currency";
NSString * const K_BASIC_DETAIL_PLACEHOLDER_EXPERIENCE = @"Select your experience";
NSString * const K_BASIC_DETAIL_PLACEHOLDER_VISA_VALID_DATE = @"Select Visa Valid date";
NSString * const K_BASIC_DETAIL_PLACEHOLDER_VISA_STATUS = @"Select Visa Status";

// resume headline
NSInteger const K_RESUME_HEADLINE_NO_OF_SECTIONS = 1;
NSInteger const K_RESUME_HEADLINE_NO_OF_ROWS = 1;
NSInteger const K_RESUME_HEADLINE_ROW_HEIGHT = 135;
NSInteger const K_RESUME_HEADLINE_LIMIT = 80;
NSString * const K_EDIT_RESUME_HEADLINE_STATIC_LABEL = @"CV headline is one line statement that describes your professional career. It is the first thing an employer reads about you. e.g. enter 'B.Tech, Mechanical engineering with 4 years experience in Oil & Gas.";

//edit work experience
NSString* const WORK_EXP_TITLE = @"Work Experience";
NSString* const CURRENT_COMPANY_YES = @"yes";
NSString* const EDIT_EXP_FIRST_SEGMENT_VALUE = @"Yes";
NSString* const EDIT_EXP_SECOND_SEGMENT_VALUE = @"No";
NSString* const NOT_MENTIONED = @"Not Mentioned";
NSString* const MONTH_YEAR = @"Month, Year ";
NSInteger const K_JOB_DESCRIPTION_LIMIT = 4000;
NSString* const CURRENT_COMPANY_VALUE = @"Present";
NSString* const CURRENT_COMPANY_NO = @"no";

//profile Summary
NSInteger const K_PROFILE_SUMMARY_NO_OF_SECTIONS = 1;
NSInteger const K_PROFILE_SUMMARY_NO_OF_ROWS = 1;
//NSInteger const K_PROFILE_SUMMARY_ROW_HEIGHT = 120;
NSInteger const K_PROFILE_SUMMARY_ROW_HEIGHT = 270;
NSInteger const K_PROFILE_SUMMARY_LIMIT = 1000;
NSString * const K_EDIT_PROFILE_SUMMARY_STATIC_LABEL = @"Your profile summary should mention the highlights of your career and education, what are your professional interest and what kind of a career you are looking for";

//contact details
NSInteger const K_CONTACT_DEATILS_NO_OF_SECTIONS = 1;
NSInteger const K_CONTACT_DEATILS_NO_OF_ROWS = 3;
NSInteger const K_CONTACT_DEATILS_ROW_HEIGHT = 75;
NSInteger const K_MOBILE_NUMBER_CHARCTER_LIMIT = 15;
NSInteger const K_RESIDENCE_PHONE_COUNTRY_CODE = 100;
NSInteger const K_RESIDENCE_PHONE_AREA_CODE = 101;
NSInteger const K_RESIDENCE_PHONE_NUMBER = 102;
NSString* const K_MOBILE_NUMBER_PREFIX_7 = @"7";
NSString* const K_MOBILE_NUMBER_PREFIX_8 = @"8";
NSString* const K_MOBILE_NUMBER_PREFIX_9 = @"9";
NSString * const K_EDIT_CONTACT_DETAIL_STATIC_LABEL = @"Change in EMail ID will change your username \n   New EMail ID will become your username";

//unreg apply 
NSInteger const K_CHARCTER_LIMIT_NAME = 35;
NSInteger const K_CHARCTER_LIMIT_EMAIL = 40;
NSInteger const K_CHARCTER_LIMIT_LOCATION = 255;
NSInteger const K_CHARCTER_LIMIT_ORGANISATION = 512;
NSInteger const K_CHARCTER_LIMIT_DESIGNATION = 512;
NSInteger const K_CHARCTER_LIMIT_KEY_SKILLS = 250;

//affirmative info
NSInteger const K_AFFIRMATIVE_INFO_NO_OF_SECTIONS = 1;
NSInteger const K_AFFIRMATIVE_INFO_NO_OF_ROWS = 3;
NSInteger const K_AFFIRMATIVE_INFO_ROW_HEIGHT = 85;
NSInteger const K_AFFIRMATIVE_INFO_LIMIT = 250;

//ITSkill view info
NSInteger const K_ITSKILL_VIEW_NO_OF_SECTIONS = 1;
NSInteger const K_ITSKILL_VIEW_NO_OF_ROWS = 5;
NSInteger const K_ITSKILL_VIEW_INFO_ROW_HEIGHT = 75;


NSString * const K_KEY_EDIT_PLACEHOLDER = @"edit_bd_placeholder";
NSString * const K_KEY_EDIT_PLACEHOLDER2 = @"edit_bd_placeholder2";
NSString * const K_KEY_HIDDEN_PLACEHOLDER =@"hidden";

NSString * const K_KEY_EDIT_TITLE = @"edit_bd_title";


NSString * const K_KEY_EDIT_COUNTRY_CODE = @"edit_country_code";
NSString * const K_KEY_EDIT_AREA_CODE = @"edit_area_code";
NSString * const K_KEY_EDIT_PHONE_NUMBER = @"edit_phone_number";


//segment button
NSInteger const K_SEGMENT_BUTTON_ORIGIN_X = 10;
NSInteger const K_SEGMENT_BUTTON_ORIGIN_Y = 38;
NSInteger const K_SEGMENT_BUTTON_HEIGHT = 40;
NSInteger const K_SEGMENT_TOTAL_VIEW_WIDTH = 300;


NSString * const K_EMPLOYMENT_DESC_MESSAGE= @"Writing here...";
