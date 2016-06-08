//
//  NGCriticalSectionHelper.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 8/21/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGCriticalSectionHelper.h"
#import "NGProfileSectionModalClass.h"
@interface NGCriticalSectionHelper(){
    
    NSMutableArray *profileSectionsArr;
}

@end
@implementation NGCriticalSectionHelper

+(NGCriticalSectionHelper *)sharedInstance{
    
    static NGCriticalSectionHelper *sharedInstance =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  =  [[NGCriticalSectionHelper alloc]init];
    });
    return sharedInstance;
}

-(NSMutableArray*)configureSectionsArr
{
    profileSectionsArr = [[NSMutableArray alloc] init];
    [profileSectionsArr removeAllObjects];
    
    for (int i = CSTypeProfilePhoto; i <= CSTypeResume; i++) {
        
        NGProfileSectionModalClass* profSect = [[NGProfileSectionModalClass alloc]init];
        profSect.profileSectionType = i;
        profSect.isComplete = TRUE;
        [profileSectionsArr addObject:[self setProfileSectionData:profSect]];
    }
    
    return profileSectionsArr;
}


-(NGProfileSectionModalClass*) setProfileSectionData:(NGProfileSectionModalClass*)
profSectionObject{
    
    NGMNJProfileModalClass *objModel = [[DataManagerFactory getStaticContentManager] getMNJUserProfile];
    
    switch (profSectionObject.profileSectionType) {
            
        case CSTypeProfilePhoto:
            profSectionObject.title = @"Profile Photo" ;
            profSectionObject.apiName = @"Photo";
            profSectionObject.tapIndex = BASIC_DETAILS;
            profSectionObject.icon = profSectionObject.isComplete?@"photo":@"photo_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?@"Update profile photo" :@"Get extra visibility with employers";
            
            break;
        
        case CSTypeBasicDetails:
            profSectionObject.title = @"Basic Details" ;
            profSectionObject.apiName = @"Basic" ;
            profSectionObject.tapIndex = BASIC_DETAILS;
            profSectionObject.icon = profSectionObject.isComplete?@"basic_details":@"basic_details_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?objModel.city?[NSString stringWithFormat:@"%@",[objModel.city objectForKey:@"value"]]:@"Not Mentioned" :@" Essential information missing";
            
            
            break;
        case CSTypeContactDetails:
            profSectionObject.title = @"Contact Details" ;
            profSectionObject.apiName = @"Contact" ;
            profSectionObject.tapIndex = CONTACT_DETAILS;
            profSectionObject.icon = profSectionObject.isComplete?@"contact_det":@"contact_det_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?(objModel.username?[NSString stringWithFormat:@"%@",objModel.username]:@"Not Mentioned") :@"Update contact details";
            
            break;
            
        case CSTypeCVHeadline:
            profSectionObject.title = @"CV Headline" ;
            profSectionObject.apiName = @"Headline" ;
            profSectionObject.tapIndex = CV_HEADLINE;
            profSectionObject.icon = profSectionObject.isComplete?@"cvheadline":@"cvheadline_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?@"Update CV headline" :@"Add a CV Headline";
            
            break;
            
        case CSTypeKeySkills:
            profSectionObject.title = @"Key Skills" ;
            profSectionObject.apiName = @"KeySkills" ;
            profSectionObject.tapIndex = KEY_SKILLS;
            profSectionObject.icon = profSectionObject.isComplete?@"keyskill":@"keyskill_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?@"Add more for appearing in employer searches" :@"Add at least 5 Key Skills";
            
            break;
            
        case CSTypeIndustryInformation:
            profSectionObject.title = @"Industry Information" ;
            profSectionObject.apiName = @"Industry" ;
            profSectionObject.tapIndex = INDUSTRY_INFO;
            profSectionObject.icon = profSectionObject.isComplete?@"industry":@"industry_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?(objModel.industryType?[NSString stringWithFormat:@"%@",[objModel.industryType objectForKey:@"value"]]:@"Not Mentioned") :@"Add Notice Period information";
            
            
            break;
            
        case CSTypeWorkExperience:
            profSectionObject.title = @"Work Experience" ;
            profSectionObject.apiName = @"WorkExperience" ;
            profSectionObject.tapIndex = WORK_EXPERIENCE;
            profSectionObject.icon = profSectionObject.isComplete?@"workexdet":@"workexdet_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?(objModel.currentDesignation?[NSString stringWithFormat:@"%@",objModel.currentDesignation]:@"Not Mentioned") :@"Showcase professional acheivements";
            
            
            break;
        case CSTypeEducation:{
            
            NSString *highestEdu;
            profSectionObject.title = @"Education" ;
            profSectionObject.apiName = @"Education" ;
            profSectionObject.tapIndex = EDUCATION;
            profSectionObject.icon = profSectionObject.isComplete?@"edudet":@"edudet_red";
         
            [objModel createEducationList];
            
            NGEducationDetailModel *eduModel;
            if(objModel.educationList.count > 0){
            eduModel = [objModel.educationList fetchObjectAtIndex:0];
            }
            
            if(eduModel) {
            
                if([eduModel.course objectForKey:@"value"]){
                
                highestEdu =[[eduModel.course objectForKey:@"value"] length]> 0?[eduModel.course objectForKey:@"value"]:@"Not Mentioned";
                
            }else if([eduModel.course objectForKey:@"subValue"]){
                
                highestEdu = [[eduModel.course objectForKey:@"subValue"] length]> 0?[eduModel.course objectForKey:@"subValue"]:@"Not Mentioned";
            
            }else{
                
                highestEdu = @"Not Mentioned";
            }
               
                
        }
            profSectionObject.descriptionStr =  profSectionObject.isComplete?highestEdu :@"Education details are missing";
            
        }
            break;
            
        case CSTypePersonalDetails:
            profSectionObject.title = @"Personal Details" ;
            profSectionObject.apiName = @"Personal" ;
            profSectionObject.tapIndex = PERSONAL_DETAILS;
            profSectionObject.icon = profSectionObject.isComplete?@"personaldetail":@"personaldetail_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?@"Update personal details" :@"Let employers know more about you";
            
            
            break;
        case CSTypeDesiredJob:
            profSectionObject.title = @"Desired Job" ;
            profSectionObject.apiName = @"DesiredJob" ;
            profSectionObject.tapIndex = DESIRED_JOB;
            profSectionObject.icon = profSectionObject.isComplete?@"MNJ_desiredjob_icon":@"desiredjobsred";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?@" Update your Job preferences" :@"Update for getting better Job recommendations";
            
            break;
            
        case CSTypeResume:
            profSectionObject.title = @"Resume" ;
            profSectionObject.apiName = @"AttachedCV";
            profSectionObject.tapIndex = CV;
            profSectionObject.icon = profSectionObject.isComplete?@"cv":@"cv_red";
            profSectionObject.descriptionStr =  profSectionObject.isComplete?@"Update Your Resume" :@"Attach Your Resume";
            
            break;
        default:
            break;
    }
    
    
    return profSectionObject;
}

-(NSMutableArray*) orderProfileSectionArray : (NSArray*) arr {
    
        profileSectionsArr = [[NGCriticalSectionHelper sharedInstance] configureSectionsArr];
        
        NSMutableArray *completeSecArr = [NSMutableArray array];
        NSMutableArray *incompleteSecArr = [NSMutableArray array];
        
        for (NGProfileSectionModalClass* sectionObj in profileSectionsArr) {
            
            if([arr containsObject:sectionObj.apiName]){
                sectionObj.isComplete = FALSE;
                [incompleteSecArr addObject:sectionObj];
            }
            else
                [completeSecArr addObject:sectionObj];
            
            [self setProfileSectionData:sectionObj];
        }
        
        if(incompleteSecArr.count)
        {
            [profileSectionsArr removeAllObjects];
            [profileSectionsArr addObjectsFromArray:incompleteSecArr];
            [profileSectionsArr addObjectsFromArray:completeSecArr];
            
        }
 
    return profileSectionsArr;
}

@end
