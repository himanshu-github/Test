//
//  ViewController.h
//  Ios8Test
//


#import <UIKit/UIKit.h>


@protocol iCloudDelegate;

@interface iCloudViewController : NGBaseViewController  <UIDocumentPickerDelegate, UIDocumentMenuDelegate>
@property (nonatomic, weak) id <iCloudDelegate> rootViewDelegate;

@end

@protocol iCloudDelegate <NSObject>

@optional
- (void)iCloudBrowser:(iCloudViewController *)browser didDownloadFile:(NSString *)fileName;
- (void)iCloudBrowser:(iCloudViewController *)browser didFailToDownloadFile:(NSString *)fileName;
@end


