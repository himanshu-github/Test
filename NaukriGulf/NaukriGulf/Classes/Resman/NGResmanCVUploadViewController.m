//
//  NGResmanCVUploadViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 2/4/15.
//  Copyright (c) 2015 Infoedge. All rights reserved.
//

#import "NGResmanCVUploadViewController.h"
#import "NGResmanCVHeadlineViewController.h"
#import "NGCVUploadDataCell.h"
#import "NGDocumentFetcher.h"

typedef NS_ENUM(NSUInteger, kResmanCVUploadCellRow){
    kResmanCVUploadCellRowHeading,
    kResmanCVUploadCellRowDropbox,
    kResmanCVUploadCellRowGoogleDrive,
    kResmanCVUploadCellRowiCloudDrive,
};


@interface NGResmanCVUploadViewController (){
    NGResmanDataModel *resmanModel;
    UILabel *lblBottomContent;
}

@end

@implementation NGResmanCVUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    resmanModel = [[DataManagerFactory getStaticContentManager]getResmanFields];
    //NOTE:This must be here becz we r using model view controller here
    //which triggers screen report again and again.
    if (resmanModel.isFresher) {
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_RESUME_UPLOAD_FRESHER];
    }
    else{
        [NGGoogleAnalytics sendScreenReport:K_GA_RESMAN_RESUME_UPLOAD_EXPERIENCED];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeUploadedWithNotification:) name:K_NOTIFICATION_RESUME_UPLOAD object:nil];
    

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNavigationBarWithTitleOnly:@"Upload Your CV"];
    [self addTableFooterView];
    [self addBottomView];
    
    [NGDecisionUtility checkNetworkStatus];

}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.editTableView setScrollEnabled:YES];
    
    [self setAutomationLabel];
}
-(void)setAutomationLabel{
    
    [UIAutomationHelper setAccessibiltyLabel:@"editCVUpload_table" forUIElement:self.editTableView withAccessibilityEnabled:NO];
    
    
}
-(void)addTableFooterView{
    if(self.editTableView.tableFooterView==nil)
    {
    [self setEditTableInReduceSizeWithSaveBtnHiddenBy:64];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    UIButton *uploadLaterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadLaterBtn.frame = CGRectMake(0, 1.0, SCREEN_WIDTH, 89);
    [uploadLaterBtn setTitle:@"I will Upload it Later" forState:UIControlStateNormal];
    [uploadLaterBtn setTitleColor:[UIColor colorWithRed:8.0/255 green:58.0/255 blue:116.0/255 alpha:1.0] forState:UIControlStateNormal];
    [uploadLaterBtn.titleLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:14.0]];
    [uploadLaterBtn setBackgroundImage:[self setBackgroundImageByColor:[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1.0] withFrame:uploadLaterBtn.frame cornerRadius:0] forState:UIControlStateHighlighted];
    [footerView addSubview:uploadLaterBtn];
    [uploadLaterBtn addTarget:self action:@selector(uploadCVLaterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.editTableView.tableFooterView = footerView;
    }
    
}
-(void)resumeUploadedWithNotification:(NSNotification*)paramNotification{
    if ([K_NOTIFICATION_RESUME_UPLOAD isEqualToString:paramNotification.name]) {
        
        NSString *selfClassName = NSStringFromClass([self class]);
        NSString *notificationForObject = [paramNotification.userInfo objectForKey:CV_UPLOAD_FOR_OBJECT_KEY];
        if ([selfClassName isEqualToString:notificationForObject]) {
            
            if (resmanModel.isFresher) {
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_RESUME_UPLOADED_FRESHER withEventLabel:K_GA_RESMAN_EVENT_RESUME_UPLOADED_FRESHER withEventValue:nil];
            }else{
                [NGGoogleAnalytics sendEventWithEventCategory:K_GA_RESMAN_CATEGORY withEventAction:K_GA_RESMAN_EVENT_RESUME_UPLOADED_EXPERIENCED withEventLabel:K_GA_RESMAN_EVENT_RESUME_UPLOADED_EXPERIENCED withEventValue:nil];
            }
            
            NGResmanCVHeadlineViewController *cvHeadlineVc = [[NGResmanCVHeadlineViewController alloc] init];

            [(IENavigationController*)self.navigationController pushActionViewController:cvHeadlineVc Animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))
        return 3;//no icloud support
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowIndex = indexPath.row;
    switch (rowIndex) {
        case kResmanCVUploadCellRowHeading:{

            {
                NGCustomValidationCell *cell = [self.editTableView dequeueReusableCellWithIdentifier:@"" ];
                if (cell == nil)
                {
                    cell = [[NGCustomValidationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    UILabel *lblSuccessMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
                    UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 50)];

                    lblSuccessMsg.textAlignment = NSTextAlignmentCenter;
                    txtLabel.textAlignment = NSTextAlignmentCenter;
                    
                    lblSuccessMsg.backgroundColor = UIColorFromRGB(0x37995a);
                    
                    [lblSuccessMsg setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:15.0]];
                    [txtLabel setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:13.0]];
                     
                    lblSuccessMsg.text = @"Your Profile is Successfully Registered";
                    txtLabel.text = @"Upload CV using following sevices";
                     
                     lblSuccessMsg.textColor = [UIColor whiteColor];
                    txtLabel.textColor = [UIColor darkGrayColor];
                     
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    [cell.contentView addSubview:lblSuccessMsg];
                    [cell.contentView addSubview:txtLabel];
                    return cell;
                    
                    
                }
                
                break;
            }
        }break;
          
        case kResmanCVUploadCellRowDropbox:{
            NGCVUploadDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cvUploadDataCell"];
            [cell configureCellWithWay:NGResmanCVUploadWayDropbox];
            [UIAutomationHelper setAccessibiltyLabel:@"CVUploadDataCell_dropbox" forUIElement:cell withAccessibilityEnabled:NO];
            return cell;
        }break;
            
        case kResmanCVUploadCellRowGoogleDrive:{
            NGCVUploadDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cvUploadDataCell"];
            [cell configureCellWithWay:NGResmanCVUploadWayGoogleDrive];
            [UIAutomationHelper setAccessibiltyLabel:@"CVUploadDataCell_google_drive" forUIElement:cell withAccessibilityEnabled:NO];
            return cell;
        }break;
          
        case kResmanCVUploadCellRowiCloudDrive:{
            NGCVUploadDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cvUploadDataCell"];
            [cell configureCellWithWay:NGResmanCVUploadWayiCloudDrive];
            [UIAutomationHelper setAccessibiltyLabel:@"CVUploadDataCell_iCloud_drive" forUIElement:cell withAccessibilityEnabled:NO];
            return cell;
        }break;
        
        default:
            break;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 90.0f;
    if (kResmanCVUploadCellRowHeading == indexPath.row) {
        rowHeight = 100.0;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger rowIndex = indexPath.row;
    if (kResmanCVUploadCellRowDropbox==rowIndex) {
        NGDocumentFetcher *docFetcher = [NGDocumentFetcher sharedInstance];
        docFetcher.commingFromVC = self;
        [docFetcher showDropBoxOption];
        
    }else if(kResmanCVUploadCellRowGoogleDrive==rowIndex){
        NGDocumentFetcher *docFetcher = [NGDocumentFetcher sharedInstance];
        docFetcher.commingFromVC = self;
        [docFetcher showGoogleDriveOption];

    }else if(kResmanCVUploadCellRowiCloudDrive ==rowIndex){
        NGDocumentFetcher *docFetcher = [NGDocumentFetcher sharedInstance];
        docFetcher.commingFromVC = self;
        [docFetcher showiCloudDriveOption];
        
    }
   
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)uploadCVLaterButtonPressed:(id)sender{
   
    [self showAnimator];
    
    if (self.isRequestInProcessing) {
        return;
    }
    
    self.isRequestInProcessing = YES;
    __weak NGResmanCVUploadViewController *weakSelf = self;
    NGWebDataManager *obj = [DataManagerFactory getWebDataManagerWithServiceType:SERVICE_TYPE_CV_REMIND_ME_LATER];
    [obj getDataWithParams:nil handler:^(NGAPIResponseModal *responseInfo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideAnimator];
        });
        
        if (responseInfo.isSuccess) {
            if (responseInfo.responseCode == K_RESPONSE_SUCESS_WITHOUT_BODY) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                NGResmanCVHeadlineViewController *cvHeadlineVc = [[NGResmanCVHeadlineViewController alloc] init];
                [(IENavigationController*)weakSelf.navigationController pushActionViewController:cvHeadlineVc Animated:YES];
                    
                });
                
            }
        }else{
            NSDictionary* responseDataDict = (NSDictionary*)responseInfo.parsedResponseData;
            NSInteger statusCode = 0;
            @try {
                NSDictionary *errorDetailObject = [responseDataDict objectForKey:KEY_ERROR];
                statusCode = [[errorDetailObject objectForKey:@"status"] integerValue];
            }
            @catch (NSException *exception) {
                
            }
            
            NSString *errorStringToShow = K_CONNECTION_ESTABLISH_EROR_MSG;
            if (statusCode == 401) {
                errorStringToShow = @"Invalid user details";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [NGMessgeDisplayHandler showErrorBannerFromTop:[UIApplication sharedApplication].keyWindow title:@"" subTitle:errorStringToShow animationTime:5 showAnimationDuration:0];
            });
        }
        [weakSelf setIsRequestInProcessing:NO];
    }];
}
-(void)saveButtonPressed {
    //dummy implementation
}
-(void)addBottomView{
    
    if (nil == lblBottomContent) {
        lblBottomContent = [[UILabel alloc] init];
        NSString *contentString = @"Supported file formats DOC, DOCX, PDF, RTF\r\nMaximum file size 500 KB";
        CGFloat colorCode = 122.0f/255.0f;
        [lblBottomContent setTextColor:[UIColor colorWithRed:colorCode green:colorCode blue:colorCode alpha:1.0f]];
        [lblBottomContent setFont:[UIFont fontWithName:FONT_STYLE_HELVITCA_NEUE_LIGHT size:12.0f]];
        [lblBottomContent setNumberOfLines:0];
        [lblBottomContent setLineBreakMode:NSLineBreakByWordWrapping];
        [lblBottomContent setBackgroundColor:[UIColor clearColor]];
        [lblBottomContent setTextAlignment:NSTextAlignmentCenter];
        [lblBottomContent setTranslatesAutoresizingMaskIntoConstraints:NO];
        [lblBottomContent setText:contentString];
        [self.view insertSubview:lblBottomContent aboveSubview:self.editTableView];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:lblBottomContent attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:lblBottomContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:SCREEN_WIDTH];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:lblBottomContent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.saveBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:lblBottomContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:70];
        
        [self.view addConstraint:leadingConstraint];
        [self.view addConstraint:widthConstraint];
        [self.view addConstraint:bottomConstraint];
        [self.view addConstraint:heightConstraint];
        
        [self.view layoutIfNeeded];
    }
}
-(UIImage *)setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect cornerRadius:(float)radius{
    
    UIView *tcv = [[UIView alloc] initWithFrame:rect];
    [tcv setBackgroundColor:backgroundColor];
    
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);;
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:radius] addClip];
    [image drawInRect:RECT];
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageNew;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_NOTIFICATION_RESUME_UPLOAD object:nil];
}
@end
