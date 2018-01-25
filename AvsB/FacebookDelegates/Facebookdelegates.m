//
//  Facebookdelegates.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 21/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "Facebookdelegates.h"
@implementation Facebookdelegates
-(void)FaceboookLogin:(UIViewController*)viewController{
    FBSDKLoginManager *login_Manager=[[FBSDKLoginManager alloc]init];
    [login_Manager logOut];
    [login_Manager logInWithReadPermissions:@[@"public_profile",@"email"]fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
        if (!error){
            [self fetchInfoFromFacebookResult];
        }else{
            NSLog(@"error %@",error);
        }
    }];
}
-(void)fetchInfoFromFacebookResult{
    if ([FBSDKAccessToken currentAccessToken]){
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, email, picture.type(large), gender "}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){
             if (!error){
                 NSLog(@"%@",result);
                  [[self delegate]getFacebookResult:result];
//                 [[NSUserDefaults standardUserDefaults]setObject:result forKey:@"facebookresult"];
//                 [[NSUserDefaults standardUserDefaults]synchronize];
             }
         }];
    }

}

@end
