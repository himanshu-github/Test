//
//  Constant.h
//  NaukriGulf
//
//  Created by Arun Kumar on 03/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define OPEN_WITH_DOCUMENT_TYPE_HANDLER @"openWithDocumentTypeHandler"
#define APP_SHARE_URL @"http://itunes.apple.com/app/naukrigulfjobsindubaiuaegulf/id724241430?mt=8"
#define CAREER_CARE_URL @"http://www.naukrigulf.com/careercafe?src=app"
#define TOC_URL @"http://www.naukrigulf.com/ni/nilinks/nkr_links.php?open=restnc&flag=mnj&source="
#define MAT_ADVERTISER_ID @"13122"
#define MAT_CONVERSION_KEY  @"88850a8d82a397de6de7b3b8a6d56a1b"
#define DROPBOX_APP_KEY @"7r8cf9hco8nid6h"
#define DROPBOX_APP_SECRET_KEY @"v2hyqtd1xo34awb"
#define FB_APP_ID @"361272044007341"
#define GOOGLE_DRIVE_CLIENT_ID @"946992003672-helss6vbjvpupvsv18smuj4a7q72lvb6.apps.googleusercontent.com"
#define GOOGLE_DRIVE_CLIENT_SECRET_KEY @""
#define TECH_SUPPORT_MAIL_ID @"techsupport@naukrigulf.com"

