//
//  SignUpView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 05/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "SignUpView.h"

@interface SignUpView (){
    Facebookdelegates *fb_delegate;
    AppDelegate*appDelegate;
    NSString *fb_id;
    NSString *deviceToken;
    NSString*deviceType;
    NSString*username;
    NSString *picture;
    NSString *signup_type;
    WebServices *webData;
    NSString *headerPath ;
    NSOperationQueue *mainQueue;
    NSString *signup_userID;
    NSString *signup_token_key;
}
@end
@implementation SignUpView

# pragma mark: view LifeCycle Methods
- (void)viewDidLoad{
    [super viewDidLoad];
    fb_delegate=[[Facebookdelegates alloc]init];
    fb_delegate.delegate=self;
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.dataDict=[[NSMutableDictionary alloc]init];
    mainQueue = [[NSOperationQueue alloc]init];
    webData =[[WebServices alloc]init];
    webData.CommonSourcedelegate=self;
    headerPath = AUTHKEY;
    self.raw_signUpData=[[NSMutableArray alloc]init];
}
- (void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:YES];
        self.navigationController.navigationBarHidden=YES;
        self.navigationItem.hidesBackButton=YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

//MARK: Signup button Actions
- (IBAction)signUp_Facebook:(id)sender {
     appDelegate.signup_Type=@"1";
     [fb_delegate FaceboookLogin:self];
}
- (IBAction)signUp_Phone:(id)sender {
    appDelegate.signup_Type=@"2";
    PhoneVerificationView *ph_verify=INSTANTIATE( PHONE_VERIFICATION_SCREEN);
    [self.navigationController pushViewController:ph_verify animated:YES];
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
        [self.dataDict setObject: username forKey:@"name"];
        [self.dataDict setObject:fb_id forKey:@"facebookid"];
        [self.dataDict setObject:deviceToken forKey:@"device_token"];
        [self.dataDict setObject:deviceType forKey:@"device_type"];
        [self.dataDict setObject:signup_type forKey:@"signup_type"];
        [self.dataDict setObject:picture forKey:@"picture"];
        [self sendDetailsToBackend:self.dataDict];
    }
}
-(void)errorResult:(NSError *)error{
    NSLog(@"Error result shown : %@",error.localizedDescription);
}

//Custom Method
-(void)sendDetailsToBackend:(NSDictionary*)dictionaryItems{
    NSLog(@"Dictionary items are : %@",dictionaryItems);
    NSString *stringUrl = Signup_URL;
    [webData sendhttpDataToBackend:dictionaryItems withHeader:headerPath passingthroughURL:stringUrl];
}

//Common class delegate methods
-(void)getResults:(NSDictionary*)dataDict{
         [SVProgressHUD dismiss];
        NSString *resultStatus = [dataDict valueForKey:@"status"];
        if([resultStatus intValue]==200){
        if(![[NSUserDefaults standardUserDefaults]valueForKey:@"signupdata"]){
               [CommonMethods saveUserValue:dataDict forKey:@"signupdata"];   // for new user when tap on sign up facebook button
            signup_userID = [NSString stringWithFormat: @"%@",[dataDict valueForKey:@"id"]];
            signup_token_key =[NSString stringWithFormat: @"%@",[dataDict valueForKey:@"token"]];
             self.raw_signUpData=[NSMutableArray arrayWithObjects:signup_userID,signup_token_key,AUTHKEY, nil];
            if(appDelegate.array_rawData == nil){
                appDelegate.array_rawData =  self.raw_signUpData;
            }
            NSString *user_profile_url= [NSString stringWithFormat:@"%@/%@",userprofile_URL,signup_userID];
            dispatch_async(dispatch_get_main_queue(), ^{
                [webData gettingFeedResult:user_profile_url parameters:self.raw_signUpData];
            });
       }
        else{
            if(appDelegate.array_rawData!=nil){  // already user login using facebook only
                [appDelegate.array_rawData removeAllObjects];
                signup_userID =  [NSString stringWithFormat: @"%@",[dataDict valueForKey:@"id"]];
                signup_token_key =[dataDict valueForKey:@"token"];
                self.raw_signUpData =[NSMutableArray arrayWithObjects:signup_userID,signup_token_key,AUTHKEY, nil];
                appDelegate.array_rawData = self.raw_signUpData;
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
 
// getting feed result
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSLog(@"Response data = %@",responseData);
    NSString *resultStatus = [responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"profile"]){
        if([resultStatus intValue]==200){
        appDelegate.userprofile_data = responseData;
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

-(void)errorMethod:(NSError *) error{
    NSLog(@"Oops Error Shown: %@",error.localizedDescription);
}

//sign in button Action
- (IBAction)sign_in:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];}

# pragma mark : Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

@end
