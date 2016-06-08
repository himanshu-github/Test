//
//  NGSocialLoginManager.m
//  NaukriGulf
//
//  Created by Himanshu on 3/15/16.
//  Copyright © 2016 Infoedge. All rights reserved.
//

#import "NGSocialLoginManager.h"
#import "NGFacebookLoginParser.h"
#import "NGGoogleLoginParser.h"

#define profilePicWidth 280
#define profilePicHeight 280

@interface NGSocialLoginManager ()<GIDSignInUIDelegate,GIDSignInDelegate>

@end
@implementation NGSocialLoginManager
{
    FBSDKLoginManager *fbLoginManager;
    NSDictionary *requestFBFields;
}

@synthesize grantedFBPermissions = _grantedFBPermissions;

@synthesize declinedFBPermissions = _declinedFBPermissions;

static NGSocialLoginManager *singleton;

/**
 *  A Shared Instance Singleton class of NGSocialLoginManager
 *
 *  @return sharedInstance created once only
 */

+(NGSocialLoginManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleton==nil) {
            singleton = [[NGSocialLoginManager alloc]init];
            
        }
    });
    return singleton;
}

-(id)init{
    if (self=[super init]) {
        fbLoginManager = [[FBSDKLoginManager alloc] init];
        _grantedFBPermissions = [[NSSet alloc] init];
        _declinedFBPermissions = [[NSSet alloc] init];
        requestFBFields = nil;
    }
    
    return self;
}



#pragma mark- Google Plus Login
-(void) gPlusButtonPressed
{
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    [signIn setClientID:GOOGLE_DRIVE_CLIENT_ID];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = @[@"https://www.googleapis.com/auth/plus.login",@"https://www.googleapis.com/auth/userinfo.email",@"https://www.googleapis.com/auth/userinfo.profile"];
    [signIn signIn];
    
}
#pragma mark- Google plus Sign in Delegates

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
    if(error){
        NSLog(@" Error ocucured : %@",[error localizedDescription]);
        if([self.delegate respondsToSelector:@selector(errorInGplusLogin)])
        {
            [self.delegate errorInGplusLogin];
        }
    }
    
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [(UIViewController*)self.delegate presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [(UIViewController*)self.delegate dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    NSURLSessionConfiguration *confi = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:confi delegate:nil delegateQueue:nil];
    NSString *requestString =[NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/me?access_token=\%@",signIn.currentUser.authentication.accessToken];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
          NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          if (error || [jsonObject objectForKey:@"error"]){
//              NSLog(@" Error ocucured : %@",[error localizedDescription]);
              if([self.delegate respondsToSelector:@selector(errorInGplusLogin)]){
                  [self.delegate errorInGplusLogin];
              }
          }
          else{
               NGResmanDataModel *parsedResmanModel = [NGGoogleLoginParser parseTheGoogleData:jsonObject inResmanModel:_resmanModel];
              if([self.delegate respondsToSelector:@selector(getResmanModelWithGPlusLogin:)]){
                  [self.delegate getResmanModelWithGPlusLogin:parsedResmanModel];
              }
                  
          }
         }];
    [dataTask resume];
    
}
- (void)logoutFromGooglePlus
{
    [[GIDSignIn sharedInstance] signOut];
}

#pragma mark- Facebook Login

- (void)setGrantedFBPermissions: (NSSet *)grantedFBPermissions
{
    _grantedFBPermissions = grantedFBPermissions;
    [self setRequestedFBFieldsWithGrantedPermissions:_grantedFBPermissions];
}

- (void)setRequestedFBFieldsWithGrantedPermissions: (NSSet*)grantedFBPermissions
{
    NSString *value = [self mapPermissionsToFBGraphAPIFields:grantedFBPermissions];
    requestFBFields = @{@"fields": value};
}


-(void) facebookButtonPressed
{
    NSArray* permisstionsArray = @[@"public_profile", @"email", @"user_birthday", @"user_location", @"user_education_history", @"user_work_history"];
    __block NGResmanDataModel *resModel = self.resmanModel;
    [self facebookLogInWithReadPermissions:permisstionsArray handler:^()
     {
         [self getFacebookUserDataWithHandler:^(NSDictionary *result)
         {
             NGResmanDataModel *parsedResmanModel = [NGFacebookLoginParser parseTheFacebookData:result inResmanModel:resModel];
             if([self.delegate respondsToSelector:@selector(getResmanModelWithFacebookLogin:)])
             {
                 [self.delegate getResmanModelWithFacebookLogin:parsedResmanModel];
             }
         } withError:^(NSError *error) {
             //NSLog(@"%@", error);
             if([self.delegate respondsToSelector:@selector(errorInFacebookLogin)])
             {
                 [self.delegate errorInFacebookLogin];
             }
         }];
     } withError:^(NSError *error) {
         //NSLog(@"%@", error);
         if([self.delegate respondsToSelector:@selector(errorInFacebookLogin)])
         {
             [self.delegate errorInFacebookLogin];
         }
     } andCancel:^{
         //NSLog(@"User cancelled FB Login");
         if([self.delegate respondsToSelector:@selector(errorInFacebookLogin)])
         {
             [self.delegate errorInFacebookLogin];
         }
     }];
    
}

- (void)facebookLogInWithReadPermissions:(NSArray *)permissions handler: (void (^)())successBlock withError:(void (^)(NSError* error))errorBlock andCancel: (void (^)())cancelBlock
{
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    if(![FBSDKAccessToken currentAccessToken])
    {
        if(!profile)
        {
            [self setLoginBehavior:fbLoginManager];
            [fbLoginManager logInWithReadPermissions: permissions
                                fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
             {
                 if (error) {
                     errorBlock(error);
                 } else if (result.isCancelled) {
                     cancelBlock();
                 } else {
                     self.grantedFBPermissions = result.grantedPermissions;
                     self.declinedFBPermissions = result.declinedPermissions;
                     successBlock();
                 }
             }];
            
        }
    }
    else
    {
        
        
    }
    
}

- (void)getFacebookUserDataWithHandler: (void (^)(NSDictionary* result))successBlock withError:(void (^)(NSError* error))errorBlock
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:requestFBFields HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error != nil)
        {
            errorBlock(error);
        }
        else
        {
            successBlock(result);
        }
    }];
}

- (void)setLoginBehavior:(FBSDKLoginManager*) manager
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        manager.loginBehavior = FBSDKLoginBehaviorNative;
    }
    else
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
            manager.loginBehavior = FBSDKLoginBehaviorNative;
        } else {
            manager.loginBehavior = FBSDKLoginBehaviorWeb;
        }
    }
}

- (NSString*)mapPermissionsToFBGraphAPIFields: (NSSet*) permissions
{
    NSString *fieldValue = @"id, ";
    
    for (id permissionString in permissions)
    {
        if ([permissionString isEqual:@"public_profile"])
        {
            fieldValue = [fieldValue stringByAppendingString:@"name, name_format, gender, "];
        }
        if ([permissionString isEqual:@"email"])
        {
            fieldValue = [fieldValue stringByAppendingString:@"email, "];
        }
        if ([permissionString isEqual:@"user_birthday"])
        {
            fieldValue = [fieldValue stringByAppendingString:@"birthday, "];
        }
        if ([permissionString isEqual:@"user_location"])
        {
            fieldValue = [fieldValue stringByAppendingString:@"location, "];
        }
        if ([permissionString isEqual:@"user_education_history"])
        {
            fieldValue = [fieldValue stringByAppendingString:@"education, "];
        }
        if ([permissionString isEqual:@"user_work_history"])
        {
            fieldValue = [fieldValue stringByAppendingString:@"work, "];
        }
    }
    
    if ([fieldValue length] > 0) {
        fieldValue = [fieldValue substringToIndex:[fieldValue length] - 2];
    }
    
    return fieldValue;
}

- (void)logoutFromFacebook
{
    [fbLoginManager logOut];
}

@end
