//
//  SettingsView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#define pURL @"https://www.google.co.in"
#import "SettingsView.h"

@interface SettingsView (){
    NSArray *headerfile;
    NSDictionary*m_dictionary;
    WebServices *webData;
    AppDelegate *appDelegate;
    NSString *userId;
    NSString *deviceToken;
}
@end
@implementation SettingsView

#pragma mark : view Controller life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    m_dictionary=[[NSDictionary alloc]init];
    headerfile=[[NSArray alloc]init];
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    webData=[[WebServices alloc]init];
    webData.logoutdelegate=self;
    webData.TurnedNotificationOffdelegate = self;
    m_dictionary=[[NSUserDefaults standardUserDefaults]objectForKey:@"signupdata"];
    if([m_dictionary count]>0){
        userId=[NSString stringWithFormat:@"%@",[m_dictionary valueForKey:@"id"]];
        deviceToken =[m_dictionary valueForKey:@"token"];
        headerfile=[NSArray arrayWithObjects:deviceToken,userId,AUTHKEY, nil];
    }
    else{
        NSLog(@"we are not able to fetch the values");
    }
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
  }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}
- (IBAction)setting_back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: button Action
- (IBAction)m_targetAllButton:(UIButton*)sender{
    if(sender.tag==801){
        EditProfile *edit = INSTANTIATE(EDIT_PROFILE_SCREEN);
        [self.navigationController pushViewController:edit animated:YES];
    }
    else if (sender.tag==802){
        ChangePassword *change = INSTANTIATE(CHANGE_PASSWORD_VIEW);
        [self.navigationController pushViewController:change animated:YES];
    }
 else if (sender.tag==803){
     if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]]){
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL]];
             exit(0);
         });
     }

 }
 else if (sender.tag==804){
     if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]]){
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL]];
             exit(0);
         });
     }
}
 else if (sender.tag==805){
     if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL]]){
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL]];
             exit(0);
         });
     }
 }
 else if (sender.tag==806){
     NSString *url = logOutURL;
     [webData webServicelogOut:url parameters:headerfile];
 }

}
- (IBAction)m_switchAction:(id)sender {
    if([sender isOn]){
        NSLog(@"Switched on ");
    }else{
          NSLog(@"Switched off ");
    }
    [webData webServiceTurnedNotificationOnOff:notificationSetting_URL parameters:appDelegate.array_rawData];
}


//Logout delegate methods

-(void)logOut:(NSDictionary *)responseData error:(NSError *)error{
    NSLog(@"Response data = %@",responseData);
    NSString *status =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"logout"]){
        if ([status intValue]==200) {
            [appDelegate.array_rawData removeAllObjects];
            appDelegate.userprofile_data = nil ;
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"signupdata"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self goToLogin];
            appDelegate.user_name =nil;
            appDelegate.user_phone =nil;
            appDelegate.nick_name =nil;
            appDelegate.user_email= nil;
            appDelegate.user_gender =nil;
            appDelegate.user_website =nil;
            appDelegate.totalPosts = nil;
            appDelegate.totalFollowers =nil;
            appDelegate.totalFollowing =nil;
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center removeObserver:appDelegate name:@"ProfileUpdated" object:nil];
}
        else{
            NSLog(@"Error description : %@",error.localizedDescription);
        }
    }
}
-(void)getNotificationResult:(NSDictionary*)responseData error:(NSError *)error{
    NSLog(@"Response data = %@",responseData);
    NSString *status =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
if ([methodName isEqualToString:@"change_notification_setting"]){
           if ([status intValue]==200){
               NSString *notification =[responseData valueForKey:@"notification"];
               if([notification intValue]==0){
                   dispatch_async(dispatch_get_main_queue(), ^{
                       kAlertView(@"", @"Notfiication turned off successfully");
                   });
               }
               else{
                   dispatch_async(dispatch_get_main_queue(), ^{
                       kAlertView(@"", @"Notfiication turned on successfully");
                   });
             }
    }
               else{
                     NSLog(@"Error!");
                }
    }
           else{
               NSLog(@"Method name not matching");
           }
}

//MARK: go to Login Screen
-(void)goToLogin{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginView*login =[storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    appDelegate.navigationController =[[UINavigationController alloc]initWithRootViewController:login];
    appDelegate.window.rootViewController = appDelegate.navigationController;
}
#pragma mark : Memory usage Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
