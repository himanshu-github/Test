//
//  JDInterfaceController.m
//  NaukriGulf
//
//  Created by Arun on 1/14/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "JDInterfaceController.h"
#import "JDTableRowController.h"
#import "WatchConstants.h"
#import "WatchHelper.h"


@interface JDInterfaceController()<JDTableRowControllerDelegate,WCSessionDelegate>{
    
    NSMutableDictionary* dictData;
    NSString* jobId;
    BOOL isWebJob;
    BOOL isRedirectionJob;
    BOOL isRecoPage;
    NSInteger jobApplied;
    NSInteger indexClicked;


}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tblJD;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpSpinner;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grpErrorOccured;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblStatus;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imgSpinner;

@end


@implementation JDInterfaceController

- (void)awakeWithContext:(id)context {
   
    [super awakeWithContext:context];
    [self setTitle:@"Job Details"];

    indexClicked = [context[KEY_INDEX] integerValue] ;
    
    if (context[KEY_DELEGATE])
        _delegate = context[KEY_DELEGATE];

     NSDictionary* dataDict = context[@"data"];
     jobId = dataDict[@"JobId"];

    [_tblJD setHidden:YES];
    [_grpErrorOccured setHidden:YES];
    [self showSpinner];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.reachable) {
            
    [[WCSession defaultSession] sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"jd",@"name",
                                             jobId,@"jobId",
                                             nil]
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                   
                                   if ([replyMessage[@"response"] isKindOfClass:[NSString class]])
                                       
                                       [self showStatus:K_NO_INTERENT];
                                   
                                   else if ([replyMessage[@"response"] isKindOfClass:[NSDictionary class]]) {

                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       dictData = [NSMutableDictionary dictionaryWithDictionary:replyMessage[@"response"]];
                                       [dictData setObject:context[@"is_applied"] forKey:@"is_applied"];
                                       [self loadTable];
                                   });
                               }
                               }
                               errorHandler:^(NSError * _Nonnull error) {
                                   
                                   [self showStatus:K_SOME_ERROR_OCCURED];

                               }];
        }
    }
    
    NSInteger webJob = [[dataDict[@"IsWebJob"] lowercaseString] isEqualToString:@"true"]?1:0;
    NSInteger redirectionJob = [dataDict[@"isRedirectionJob"] intValue]?1:0;

    if ([context[@"reco_page"] boolValue])
        isRecoPage = YES;
    if (webJob)
        isWebJob = YES;
    if (redirectionJob)
        isRedirectionJob = YES;
    
    [WatchHelper sendScreenReportOnGA:GA_WATCH_JD_SCREEN];
}

-(void)showSpinner{
    
    [_grpSpinner setHidden:NO];
    [_imgSpinner setHidden:NO];
    [_imgSpinner setImageNamed:@"spinner"];
    [_imgSpinner startAnimatingWithImagesInRange:NSMakeRange(1, 42)
                                            duration:1.0
                                         repeatCount:0];
}
-(void)showStatus:(NSString*)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_tblJD setHidden:YES];
        [_grpSpinner setHidden:YES];
        [_grpErrorOccured setHidden:NO];
        [_lblStatus setText:message];
        
    });
}


- (void)willActivate {
    
    [super willActivate];
}



-(void)loadTable{
    
    [_tblJD setNumberOfRows:1 withRowType:@"JDTableRowController"];
    JDTableRowController * row = [_tblJD rowControllerAtIndex:0];
    row.delegate = self;
    [row configureJDRow:dictData];
    
    
    [_grpSpinner setHidden:YES];
    [_tblJD setHidden:NO];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)applyClicked{
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        if (session.reachable) {
            [session sendMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"check_eligibility",@"name", nil]
                                       replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
       if([[replyMessage objectForKey:@"internet"] boolValue]){
           if([[replyMessage objectForKey:@"isLoggedIn"] boolValue]){
               __block JDTableRowController* row = [_tblJD rowControllerAtIndex:0];
           
       if (isWebJob || isRedirectionJob){
           
           if (isRecoPage){
               
               [self saveJob];
               [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                   K_ERROR_WEB_APPLIED_RECO,KEY_MESSAGE,
                                   self,KEY_DELEGATE,
                                   nil]];
           }
           else
               [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                   K_ERROR_WEB_APPLIED_SAVED,KEY_MESSAGE,
                                   self,KEY_DELEGATE,
                                   nil]];
       }
       else{
//#warning testing
//           return;
           
       [row configureTableForApplying];
       NSMutableDictionary* dictDataForPhone = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"api_apply",@"name",
                                        jobId,@"job_id",
                                                nil];
       
       [session sendMessage:dictDataForPhone
              replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage){
                  
        NSString* status = replyMessage[@"apply_status"];
        dispatch_async(dispatch_get_main_queue(), ^{
                      
          if (isRecoPage) {
              
              if ([status isEqualToString:@"cq"]){
                  
                  [self saveJob];
                  [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                      K_ERROR_CQ_APPLIED_RECO,KEY_MESSAGE,
                                      self,KEY_DELEGATE,
                                      nil]];
                  [row configureTableForApply];
                  
              }
              
              else if ([status isEqualToString:@"sucess"]){
                  
                  
                  [self jobAppliedFromReco];
                  [self showResponse: [NSDictionary dictionaryWithObjectsAndKeys:
                                       K_SUCCESSFULLY_APPLIED,KEY_MESSAGE,
                                       self,KEY_DELEGATE,
                                       nil]];
                  [row configureTableForApplied];
   
              }
              else{
                  [self showResponse: [NSDictionary dictionaryWithObjectsAndKeys:
                                       K_SOME_ERROR_OCCURED,KEY_MESSAGE,
                                       self,KEY_DELEGATE,
                                       nil]];
                  [row configureTableForApply];
              }
              
      }else{

          if ([status isEqualToString:@"cq"]){
              
              [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                  K_ERROR_CQ_APPLIED_SAVED,KEY_MESSAGE,
                                  self,KEY_DELEGATE,
                                  nil]];
              [row configureTableForApply];
          }
          
          else if ([status isEqualToString:@"sucess"]){
              [self jobAppliedFromSaved];
              [self showResponse:[NSDictionary dictionaryWithObjectsAndKeys:
                                  K_SUCCESSFULLY_APPLIED,KEY_MESSAGE,
                                  self,KEY_DELEGATE,
                                  nil]];
              [row configureTableForApplied];
          }
          else{
              [self showResponse: [NSDictionary dictionaryWithObjectsAndKeys:
                                   K_SOME_ERROR_OCCURED,KEY_MESSAGE,
                                   self,KEY_DELEGATE,
                                   nil]];
              [row configureTableForApply];
          }
          
      }
                      
            
        });
                  
             
    }
    errorHandler:^(NSError * _Nonnull error) {
               //[self showStatus:K_SOME_ERROR_OCCURED];
    }];
          
       }

        }
        else
        [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
                [NSDictionary dictionaryWithObjectsAndKeys:K_LOGIN_FROM_IPHONE,KEY_MESSAGE, nil]];
           
       }
       else
           [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:[NSDictionary dictionaryWithObjectsAndKeys:K_NO_INTERENT,KEY_MESSAGE,                                                                                                             nil]];
                                           
    }
       errorHandler:^(NSError * _Nonnull error) {
           [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
            [NSDictionary dictionaryWithObjectsAndKeys:K_SOME_ERROR_OCCURED,KEY_MESSAGE, nil]];
           
       }];
            
    }
        else{
            [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:
             [NSDictionary dictionaryWithObjectsAndKeys:K_ERROR_REACHABLE,KEY_MESSAGE, nil]];
        }
        
    }

   
}
-(void)showResponse:(id)response{
    
    [self presentControllerWithName:CONTROLLER_RESPONSE_SCREEN context:response];
}

-(void)popToSource{
    
    
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:0.5];
}

-(void)delayPop{
    
    [self popController];

}


#pragma mark RecoIntefaceControllerDelegates

-(void)saveJob{
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateValuesForSave:)])
        [_delegate updateValuesForSave:
         [NSDictionary dictionaryWithObjectsAndKeys:jobId,@"job_id", [NSNumber numberWithInteger:indexClicked],KEY_INDEX, nil]];
}

-(void)jobAppliedFromReco{
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateApplyValueFromReco:)])
        [_delegate updateApplyValueFromReco:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:indexClicked],KEY_INDEX, nil]];
    
}
-(void)jobAppliedFromSaved{
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateApplyValueFromSaved:)])
        [_delegate updateApplyValueFromSaved:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:indexClicked],KEY_INDEX, nil]];

}

@end

/*{
 "Job": {
 "JobId": "081115000111",
 "IndustryType": "IT - Software Services",
 "FunctionalArea": "IT Software",
 "Location": "Al Ahmadi - Kuwait , Al Farawaniyah - Kuwait , Al Jahra - Kuwait",
 "Description": "Ready to make $60,000 USD while working for a fortune 500 company from the comfort of your home? Eager to join a network of the most talented remote workers in the world? If so, this role is for you. Work for Crossover, and you’ll earn the most competitive wages on the market, collaborate with the most skilled teams in your field, and work for the most elite companies in the world. Sound too good to be true? Take a closer look...\r\n\r\n\r\nWhat to Expect as a Java Software Architect at Crossover\r\n\r\nChoose Crossover and you’ll be given responsibility for the whole process of a key technology platform. You will facilitate the platform as it supplies source, build, and test services. We expect for you to utilize your extensive experience to continually improve and redefine software development. You will consistently ensure quality and productivity by implementing automation wherever possible.\r\n\r\n\r\nQualifications for this Opportunity\r\n\r\nIf you want to work with the best, you have to be the best. A successful Java Software Architect at Crossover will demonstrate the following qualifications:\r\n\r\n-6+ years of experience as both a hands-on architect and a software engineer\r\n-Bachelor’s Degree in Computer Science, Electrical Engineering, or Computer Engineering (further education is a plus)\r\n-Leadership experience in creating, deploying, and iterating excellent software\r\n-Proficiency in the following skills and technologies is mandatory:\r\n-Java EE including (Web Services, REST, JPA).\r\n-Database (SQL server/Oracle/MySQL)\r\n-Spring, Hibernate\r\n-SOA, EDA, and Design patterns.\r\n-Cloud computing architecting\r\n-noSQL (MongoDB and/or cassandra)\r\n-Linux\r\n-DevOps\r\n-Proficiency in the Hadoop, MVVC, and knowledge of another programming language (C#, Ruby, PHP) is desired but not mandatory.\r\n\r\n\r\nCompensation\r\n\r\nAt Crossover, you’ll earn extremely competitive wages while enjoying the flexibility of working from virtually anywhere on the face of the earth:\r\n\r\nSalary: 30 USD/hr\r\nPosition type: Full time (40 hours per week)\r\nLocation: Global\r\n\r\n\r\nThe Type of Java Software Architects We’re Looking For\r\n\r\nCrossover values a culture of excellence. We need software architects who are not only technically proficient, but also demonstrate the following qualities:\r\n\r\n-A willingness to embrace the concept of iterative development as the means for building excellent products\r\nReadiness to give all the effort necessary to do an excellent job - even if it means putting in extra time to research the problem you’re facing\r\n-Perfectionism: knowing how it should be done and not stop until it’s done right\r\n-Excellent communication skills (in English)\r\n\r\n\r\nNext Steps\r\n\r\nReady to join? Start the process now by applying through our application link: \r\n\r\nhttps://www.crossover.com/x/?&utm_source=NaukriGulf&utm_medium=JB&utm_campaign=Isa#/redirect/job/10\r\n\r\nIf you meet the qualifications, we will proceed with a series of tests and interviews. Crossover is eager to see what you have to offer our cutting edge global workforce.",
 "Designation": "Java Software Architect - $30/hr (Work from Home)",
 "LogoUrl": "",
 "TELogoUrl": "",
 "Company": {
 "Name": "Crossover Markets, LLC",
 "Profile": "Crossover is redefining the way people work. Brick and mortar offices are history. The future of our global workforce will be built from teams collaborating from every corner of the world. We have embarked on an expedition to find and engage with that talent. Crossover has developed a unique method of finding, curating, and managing remote contractors. Our platform connects customers to the worlds best talent for both technical and non-technical employment. But we don't just find the best, we also provide the tools, training, and relationship building support to ensure success for long term growth."
 },
 "Compensation": {
 "MinCtc": "$4001",
 "MaxCtc": "$5000",
 "IsCtcHidden": "true",
 "Vacancies": "5",
 "CurrentCountry": "",
 "Country": "Kuwait",
 "LatestPostedDate": 1448629138
 },
 "JdURL": "http://www.naukrigulf.com/job-listings-----to--years--",
 "Other": {
 "Tag": "",
 "ResponseType": "",
 "IsConsultantJob": "false",
 "Type": "normal",
 "Keywords": "Java EE including, Web Services, REST, JPA, Database, SQL server, MySQL, Spring, Hibernate, SOA, EDA, Cloud computing, noSQL, Linux, DevOps",
 "ReferenceNumber": "",
 "Homepage": "",
 "Template": "crossover|XXXXXX|crossover",
 "Microsite": "",
 "IsWebJob": "false",
 "IsQuickWebJob": "false",
 "IsArchived": "false",
 "IsPremium": "false",
 "ShowLogo": "false",
 "ShowTemplate": "false",
 "PostedDate": 1446958800,
 "IsApplied": "true",
 "IsFeaturedEmployer": "false",
 "IsTopEmployer": "",
 "IsTopEmployerLite": ""
 },
 "DesiredCandidate": {
 "Profile": "",
 "Experience": {
 "MinExperience": "6",
 "MaxExperience": "12"
 },
 "Education": "Basic - Diploma",
 "Nationality": "Any Nationality",
 "Gender": "Any",
 "Category": "rm"
 },
 "Contact": {
 "Name": "Recruiter",
 "Designation": "",
 "Country": "",
 "City": "",
 "StreetAddress": "",
 "Pincode": "",
 "Landline": "",
 "Fax": "",
 "Mobile": "",
 "Email": "",
 "IsEmailHidden": "true",
 "Website": "http://www.crossover.com"
 }
 }
 }*/

