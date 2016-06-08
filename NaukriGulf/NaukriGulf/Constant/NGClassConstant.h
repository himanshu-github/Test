// Base Classes
#import "NGBaseViewController.h"
#import "NGAppDelegate.h"
#import "NGAppManager.h"
#import "NGEditBaseViewController.h"
#import "DataManagerFactory.h"

//Constants
#import "Constant.h"
#import "NGEnum.h"
#import  "Macro.h"
#import "NGEditMNJConstant.h"
#import "StringConstants.h"
#import "NumberConstants.h"
#import "ServiceConstant.h"
#import "FontConstant.h"
#import "GoogleAnalyticsConstant.h"
#import "ColorConstant.h"
#import "ErrorMessagesConstant.h"
#import "PushNotificationConstant.h"

//Handlers
#import "NGAppStateHandler.h"
#import "NGApplyJobHandler.h"
#import "NGExceptionHandler.h"
#import "NGMessgeDisplayHandler.h"
#import "NGNotificationWebHandler.h"

//Category
#import "NSMutableArray+DuplicacyRemover.h"
#import "UILabel+DynamicHeight.h"
#import "NSMutableDictionary+SetObject.h"
#import "UILabel+DefaultValue.h"
#import "NSArray+FetchObject.h"
#import "NSString+Extra.h"
#import "NSArray+Extra.h"
#import "UITableViewCell+Extra.h"
#import "UIImage+Extra.h"
#import "NSDictionary+SetObject.h"

// Others
#import "NGSpotlightSearchHelper.h"
#import "NGErrorViewController.h"
#import "NGLocalNotificationHelper.h"
#import "NGWebViewController.h"
#import "NGDateManager.h"
#import "NGLoginHelper.h"
#import "NGDeepLinkingHelper.h"
#import "NGLoginViewController.h"
#import "NGJDParentViewController.h"
#import "NGJobDetails.h"
#import "NGViewBuilder.h"
#import "NGConfigUtility.h"
#import "NGUIUtility.h"
#import "NGDecisionUtility.h"
#import "NGDirectoryUtility.h"
#import "NGHelper.h"
#import "NGSavedData.h"
#import "NGGoogleAnalytics.h"
#import "NGLoader.h"
#import "NGCoreDataHelper.h"
#import "UIAutomationHelper.h"
#import "NGCustomValidationCell.h"
#import "ValidatorManager.h"
#import "NGView.h"
#import "NGResmanNotificationHelper.h"
#import "NGFileDataFetcher.h"
#import "DDBase.h"
#import "NGAnimator.h"
#import "NGDatabaseHelper.h"
#import "NGLoginHelperTest.h"

//Tests
#import "NGSearchJobHelperTest.h"
#import "BannerManager.h"

//TracerConstant
#import "TracerVCConstant.h"
// Added Static
#import "NGStaticDDHelper.h"
#import "NGDynamicCoreDataHelper.h"
#import "NGStaticDDCoreDataLayer.h"

//ERROR MODELS
#import "NGServerErrorDataModel.h"

