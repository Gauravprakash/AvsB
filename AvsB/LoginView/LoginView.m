//
//  LoginView.m
//  AvsB
//

//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//
#define MAXLENGTH 6
#import "LoginView.h"
#define kUsernameField 1
#define kPasswordField 2

@interface LoginView ()<FacebookDelegate>{
    UIButton *m_signUp;
    Facebookdelegates* fb_delegate;
    AppDelegate *appDelegate;
    SVProgressHUD*progressHUD;
    NSOperationQueue *mainQueue;
    CGFloat viewHeight;
    CGFloat view_firstLine_Width;
    CommonMethods *m_InstanceMethods;
    CGFloat view_secondLine_Width;
    WebServices *webData;
    NSString *m_username;
    NSString *m_password;
    NSMutableDictionary *dataDict;
    NSString *headerPath ;
    NSString *fb_id;
    NSString *picture;
    NSString *deviceToken;
    NSString*deviceType;
    NSString*username;
    NSString *signup_type;
    NSString* token_key;
    NSString* userID;
}
@end

@implementation LoginView

#pragma mark : ViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    fb_delegate=[[Facebookdelegates alloc]init];
    fb_delegate.delegate=self;
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    mainQueue = [[NSOperationQueue alloc]init];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    m_InstanceMethods=[CommonMethods sharedInstance];
    webData=[[WebServices alloc]init];
    webData.CommonSourcedelegate=self;
    webData.gettingFeeddelegate =self;
    self.m_dataDict=[[NSMutableDictionary alloc]init];
    self.fb_data=[[NSMutableDictionary alloc]init];
    dataDict=[[NSMutableDictionary alloc]init];
    headerPath =AUTHKEY;
    self.m_password.delegate = self;
    self.m_user_name.delegate= self;
    self.raw_arrayData=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressBar:)  name:@"removebar" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [SVProgressHUD dismiss];
    self.navigationController.navigationBarHidden=YES;
    [self setUpViews];
    deviceToken =@"21dfdfdfdfdfdfdfdfdf";
    deviceType=@"1";
    [self.m_user_name setTag:kUsernameField];
    [self.m_password setTag: kPasswordField];
    [self.m_user_name setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
    [self.m_password setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.m_scrollView.bounces = NO;
    self.m_scrollView.scrollEnabled = NO;
    viewHeight= self.m_View_ImageType.frame.size.height;
    view_firstLine_Width=self.m_view_firstSidebar.frame.size.width;
    view_secondLine_Width=self.m_view_secondSidebar.frame.size.width;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGRect frame =[[UIScreen mainScreen]bounds];
    self.m_scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}
//-(void)scrollTap:(UIGestureRecognizer*)gestureRecognizer {
//    [self.view endEditing:YES];
//}

// sign up button
- (IBAction)m_signUp:(id)sender {
    SignUpView *signup=INSTANTIATE(SIGN_UP_SCREEN);
    [self.navigationController pushViewController:signup animated:YES];
}

// facebook button
- (IBAction)fb_login_action:(id)sender {
    appDelegate.signup_Type=@"1";
    [fb_delegate FaceboookLogin:self];
}
//forgot password button
- (IBAction)m_forgotPassword:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgotPasswordView *forgot_pass= [storyboard instantiateViewControllerWithIdentifier:FORGOT_PASSWORD_SCREEN];
    [self.navigationController pushViewController:forgot_pass animated:YES];
}
// login button
- (IBAction)m_loginAction:(id)sender{
    [self statusCheck];
}


// Private Methods
-(void)statusCheck{
    if(self.m_user_name.text.isEmpty&&self.m_password.text.isEmpty){
        kAlertView(@"Please Note!", @"All fields are mandatory");
    }
    else if (self.m_user_name.text.isEmpty){
        kAlertView(@"Please Note!", @"Email field should not be left blank");
    }
    else if (self.m_password.text.isEmpty){
        kAlertView(@"Please Note!", @"Password field should not be left blank");
    }
    else if (!self.m_user_name.text.isValidEmail){
        kAlertView(@"Please Note!", @"You must required to enter a valid email");
    }
    else if (self.m_password.text.length<MAXLENGTH){
        kAlertView(@"Please Note!", @"Password must be atleast of 6 characters");
    }
    else{
        m_username = self.m_user_name.text;
        m_password = self.m_password.text;
        [dataDict setObject:m_username forKey:@"username"];
        [dataDict setObject:m_password forKey:@"password"];
        [dataDict setObject:deviceToken forKey:@"device_token"];
        [dataDict setObject:deviceType forKey:@"device_type"];
        [self sendDatatoBackend:dataDict];
    }
}

-(void)setUpViews{
    [CommonMethods addBackgroundColorToTextField:self.m_password];
    [CommonMethods addBackgroundColorToTextField:self.m_user_name];
    [CommonMethods addPaddingView:self.m_password];
    [CommonMethods addPaddingView:self.m_user_name];
    [CommonMethods addBorderLineToTextField:self.m_user_name];
    [CommonMethods addBorderLineToTextField:self.m_password];
    [m_InstanceMethods addCornerRadiusToButton:self.m_loginButton];
    self.m_signUp.titleLabel.numberOfLines = 1;
    self.m_signUp.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.m_signUp.titleLabel.lineBreakMode = NSLineBreakByClipping;
    self.m_loginButton.titleLabel.numberOfLines =1;
    self.m_loginButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    self.m_loginButton.titleLabel.lineBreakMode =NSLineBreakByClipping;
    self.m_btn_fb.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 25.0f, 0.0f, 0.0f);
    self.m_loginView.backgroundColor =[UIColor clearColor];
    [self.m_btn_fb setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}

//**** MARK: Send data to server

-(void)sendDatatoBackend:(NSDictionary*)m_dataDict{
    NSLog(@"Dictionary items are:%@",m_dataDict);
    NSString*loginUrl = Login_URL;
    if([m_dataDict count] > 0){
    [webData sendhttpDataToBackend:m_dataDict withHeader:headerPath passingthroughURL:loginUrl];
    }
    else{
        kAlertView(@"ERROR!", @"You're not register with us, please register first to continue login.");
    }
}

-(void)getResults:(NSDictionary*)dataDict{
    NSString *methodName =[dataDict valueForKey:@"method"];
    if([methodName isEqualToString:@"login"]){
    dispatch_async(dispatch_get_main_queue(), ^{
    [SVProgressHUD dismiss];
    });
    NSString *resultStatus = [dataDict valueForKey:@"status"];
    if([resultStatus intValue]==200){
         // manual login
        [CommonMethods saveUserValue:dataDict forKey:@"signupdata"];
            [appDelegate.array_rawData removeAllObjects];
            userID =  [NSString stringWithFormat: @"%@",[dataDict valueForKey:@"id"]];
            token_key =[dataDict valueForKey:@"token"];
            self.raw_arrayData=[NSMutableArray arrayWithObjects:userID,token_key,AUTHKEY, nil];
            appDelegate.array_rawData = self.raw_arrayData;
            NSString *user_profile_url= [NSString stringWithFormat:@"%@/%@",userprofile_URL,userID];
        [webData gettingFeedResult:user_profile_url parameters:self.raw_arrayData];
    }
    else{
        [CommonMethods alertView:self  title:@"" message:[dataDict objectForKey:@"message"]];
    }
    }
    else if ([methodName isEqualToString:@"signup"]){
        dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
        });
                NSString *resultStatus = [dataDict valueForKey:@"status"];
                if([resultStatus intValue]==200){
                if(![[NSUserDefaults standardUserDefaults]valueForKey:@"signupdata"]){
                [CommonMethods saveUserValue:dataDict forKey:@"signupdata"]; // for new user when tap on login facebook button
                   userID = [NSString stringWithFormat: @"%@",[dataDict valueForKey:@"id"]];
                    token_key =[dataDict valueForKey:@"token"];
                    self.raw_arrayData=[NSMutableArray arrayWithObjects:userID,token_key,AUTHKEY, nil];
                    if([appDelegate.array_rawData count]==0){
                    [appDelegate.array_rawData removeAllObjects];
                    appDelegate.array_rawData = self.raw_arrayData;
                    }
                    NSString *user_profile_url= [NSString stringWithFormat:@"%@/%@",userprofile_URL,userID];
                    [webData gettingFeedResult:user_profile_url parameters:self.raw_arrayData];
                }
                else{
                    if([appDelegate.array_rawData count]>0)
                    {  // already user login using facebook only
                        [appDelegate.array_rawData removeAllObjects];
                        userID =  [NSString stringWithFormat: @"%@",[dataDict valueForKey:@"id"]];
                        token_key =[dataDict valueForKey:@"token"];
                        self.raw_arrayData=[NSMutableArray arrayWithObjects:userID,token_key,AUTHKEY, nil];
                        appDelegate.array_rawData = self.raw_arrayData;
                      }
                      [mainQueue addOperationWithBlock:^{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                       TabControlSection *Tab= INSTANTIATE(TAB_CONTROL_SECTION);
                       [self.navigationController pushViewController:Tab animated:YES];
                    }];
                }];
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(),^{
                [CommonMethods alertView:self  title:@"" message:[dataDict objectForKey:@"message"]];
                });
            }
    }
    else{
        NSLog(@"No Results found");
    }}

-(void)errorMethod:(NSError *) error{
    NSLog(@"Oops Error Shown: %@",error.localizedDescription);
}

-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSLog(@"Response data = %@",responseData);
    NSString *resultStatus = [responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"profile"]){
        if([resultStatus intValue]==200){
            if([appDelegate.userprofile_data count]==0||[appDelegate.userprofile_data count]!=0){
                appDelegate.userprofile_data =nil;
                appDelegate.userprofile_data = responseData;
                appDelegate.totalPosts=[[responseData valueForKey:@"data"]valueForKey:@"totalposts"];
                appDelegate.totalFollowers=[[responseData valueForKey:@"data"]valueForKey:@"totalfollowers"];
                appDelegate.totalFollowing=[[responseData valueForKey:@"data"]valueForKey:@"totalfollowing"];
                appDelegate.user_name = [responseData valueForKey:@"name"];
                appDelegate.user_info = [[responseData valueForKey:@"data"]valueForKey:@"aboutme"];
                appDelegate.user_name =[[responseData valueForKey:@"data"]valueForKey:@"name"];
                appDelegate.user_phone =[[responseData valueForKey:@"data"]valueForKey:@"phone"];
                appDelegate.nick_name =[[responseData valueForKey:@"data"]valueForKey:@"username"];
                appDelegate.user_email= [[responseData valueForKey:@"data"]valueForKey:@"email"];
               appDelegate.user_gender = [[responseData valueForKey:@"data"]valueForKey:@"gender"];
              appDelegate.user_website = [[responseData valueForKey:@"data"]valueForKey:@"website"];
            }
            [mainQueue addOperationWithBlock:^{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    TabControlSection *Tab= INSTANTIATE(TAB_CONTROL_SECTION);
                         [self.navigationController pushViewController:Tab animated:YES];
                }];
            }];
        }
        else{
            //          [CommonMethods alertView:self  title:@"" message:[responseData objectForKey:@"message"]];
        }
    }
}

# pragma mark : facebook delegate results
-(void)getFacebookResult:(NSDictionary *)dict{
  NSLog(@"Facebook data: %@",dict);
    if(dict!=nil){
        username= [dict valueForKey:@"name"];
        fb_id=[dict valueForKey:@"id"];
        picture =[[[dict valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"];
        deviceToken =@"21dfdfdfdfdfdfdfdfdf";
        deviceType=@"1";
        signup_type = appDelegate.signup_Type;
        [self.fb_data setObject: username forKey:@"name"];
        [self.fb_data setObject:fb_id forKey:@"facebookid"];
        [self.fb_data setObject:deviceToken forKey:@"device_token"];
        [self.fb_data  setObject:deviceType forKey:@"device_type"];
        [self.fb_data setObject:signup_type forKey:@"signup_type"];
        [self.fb_data setObject:picture forKey:@"picture"];
        NSString *stringUrl = Signup_URL;
        [webData sendhttpDataToBackend:self.fb_data withHeader:headerPath passingthroughURL:stringUrl];
    }
}
//error
-(void)errorResult:(NSError *)error{
    NSLog(@"Error result shown : %@",error.localizedDescription);
}

// Notification Method
-(void)removeProgressBar:(NSNotification*)notification{
    [SVProgressHUD dismiss];
}

#pragma mark : Textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case kUsernameField:
            [self.m_user_name becomeFirstResponder];
            break;
            
        case kPasswordField:
            [self.m_password becomeFirstResponder];
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
if(textField.tag==kUsernameField){
    [self.m_password becomeFirstResponder];
}
else if(textField.tag==kPasswordField){
    [textField resignFirstResponder];
}
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    switch (textField.tag) {
        case kUsernameField:
           self.m_user_name.placeholder =@"EmailID";
            break;
            
        case kPasswordField:
           self.m_password.placeholder =@"Password";
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }

    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case kUsernameField:
            [self.m_password becomeFirstResponder];
            break;
            
        case kPasswordField:
            [self.m_password resignFirstResponder];
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }

}


# pragma mark : Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
