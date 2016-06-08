//
//  NGForceUpgradeViewController.m
//  NaukriGulf
//
//  Created by Shikha Sharma on 9/24/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NGForceUpgradeViewController.h"

@interface NGForceUpgradeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;

@end

@implementation NGForceUpgradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (IS_IPHONE5)
    {
        UIImage *image = [UIImage imageNamed:@"LaunchImage-700-568h"];
        self.imgBG.image = image;
    }
    else{
        UIImage *image = [UIImage imageNamed:@"LaunchImage-700"];
        self.imgBG.image = image;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)upgradeAppTapped:(id)sender {
    
    [NGGoogleAnalytics sendEventWithEventCategory:K_GA_EVENT_CATEGORY withEventAction:K_GA_EVENT_FORCE_UPGRADE_CLICK withEventLabel:K_GA_EVENT_FORCE_UPGRADE_CLICK withEventValue:nil];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:APP_SHARE_URL]];
}
@end
