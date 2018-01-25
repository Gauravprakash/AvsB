//
//  UniqueUserView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "UniqueUserView.h"

@interface UniqueUserView (){
    CommonMethods *m_InstanceMethods;
    AppDelegate *appDelegate;
    NSString *deviceType;
    NSString *deviceToken;
    WebServices *webClass;
    NSArray *raw_Data;
    NSString *url_type;
    NSString*signUpType;
    NSMutableDictionary *username_suggst;
    NSArray *response_arrayData;
    SuggestionCell *cell;
}
@end

@implementation UniqueUserView

#pragma mark : View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    m_InstanceMethods =[CommonMethods sharedInstance];
    appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    deviceType =@"1";
    deviceToken =@"1234df5d5fd4fd5fd54f5d";
    self.m_unique_username.delegate=self;
    webClass =[[WebServices alloc]init];
    webClass.usernamedelegate=self;
    webClass.usernamesuggestdelegate =self;
    raw_Data =[[NSArray alloc]init];
    signUpType = appDelegate.signup_Type;
    username_suggst=[[NSMutableDictionary alloc]init];
    response_arrayData=[[NSArray alloc]init];
    [self registerCustomCell];
    self.m_unique_username.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
    [CommonMethods addBackgroundColorToTextField:self.m_unique_username];
    [CommonMethods addBorderLineToTextField:self.m_unique_username];
    [CommonMethods addPaddingView:self.m_unique_username];
    [m_InstanceMethods addCornerRadiusToButton:self.m_buttonNext];
    [self.view bringSubviewToFront:self.button_mark];
    [self.button_mark setImage:[UIImage imageNamed:@"white_tick"] forState:UIControlStateNormal];
    self.m_suggest_tblview.hidden =YES;
    [self.m_unique_username setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    url_type = userNameAvailable_URL;
}

-(void)viewWillLayoutSubviews{
//    [self.view addSubview:self.m_bottomView];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
//Next button Action
- (IBAction)nxt_Button:(id)sender {
    [self checkStatus];
    [self.view endEditing:YES];
}
-(void)checkStatus{
    if(self.m_unique_username.text.isEmpty){
        kAlertView(@"Please Note!", @"Please enter a unique userrname to sign up successfully.");
    }
    else{
        [appDelegate.userData setObject:self.m_dummy_username forKey:@"name"];
        [appDelegate.userData setObject:self.m_dummy_password forKey:@"password"];
        [appDelegate.userData setObject:self.m_dummy_email forKey:@"email"];
        [appDelegate.userData setObject:self.m_unique_username.text forKey:@"username"];
        [appDelegate.userData setObject:signUpType forKey:@"signup_type"];
        [appDelegate.userData setObject:deviceType forKey:@"device_type"];
        [appDelegate.userData setObject:deviceToken forKey:@"device_token"];
        [self hitDataAtBackend];
  }
}
- (IBAction)m_loginbutton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark : Textfield delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.m_unique_username becomeFirstResponder];
    [self performSelectorOnMainThread:@selector(getListingOfUsername) withObject:nil waitUntilDone:YES];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.m_unique_username resignFirstResponder];
    self.m_suggest_tblview.hidden=YES;
   [self.button_mark setImage:[UIImage imageNamed:@"green_tick"] forState:UIControlStateNormal];
   return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.m_suggest_tblview.hidden=YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength==0){
    [self.button_mark setImage:[UIImage imageNamed:@"white_tick"] forState:UIControlStateNormal];
    }
    else{
     [self.button_mark setImage:[UIImage imageNamed:@"green_tick"] forState:UIControlStateNormal];
    }
    return newLength <= 25;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark : webservices using
-(void)hitDataAtBackend{
    NSString *dummy_txt =self.m_unique_username.text;
    raw_Data =[NSArray arrayWithObjects:AUTHKEY,dummy_txt,nil];
    [webClass webserviceuserName:url_type parameters:raw_Data];
}

-(void)getListingOfUsername{
    NSString *username = self.m_dummy_username;
    [username_suggst setObject:username forKey:@"name"];
    [webClass suggestUsername:username_suggst withheaderPath:AUTHKEY passingThroughUrl:usernameSuggestion_URL];
}


//MARK: webservice getting result
-(void)userNamePick:(NSDictionary *)responseData error:(NSError *)error{
    [SVProgressHUD dismiss];
    NSLog(@"Response data = %@",responseData);
    NSString *status =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"username_available"]){
        if ([status intValue]==200) {
            [self.button_mark setImage:[UIImage imageNamed:@"green_tick"] forState:UIControlStateNormal];
            FindFacebookFriends *fb_friend=INSTANTIATE(@"FindFacebookFriends");
            [self.navigationController pushViewController:fb_friend animated:YES];
        }
        else{
            kAlertView(@"Errror!", error.localizedDescription);
        }
    }
    else{
        kAlertView(@"Errror!", @"This username already taken");
          [self.button_mark setImage:[UIImage imageNamed:@"white_tick"] forState:UIControlStateNormal];
}
}
-(void)gettingUserName:(NSDictionary*)responseData error:(NSError*)error{
    NSLog(@"Response data = %@",responseData);
    NSString *status =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"username_suggestion"]){
          if ([status intValue]==200){
              response_arrayData = [responseData valueForKey:@"data"];
              if([response_arrayData  count]>0){
                  self.m_suggest_tblview.hidden = NO;
              dispatch_async(dispatch_get_main_queue(), ^{
                  self.m_suggest_tblview.reloadData;
              });
              }
              else{
                  NSLog(@"No Data found");
              }
          }
          else{
              kAlertView(@"Errror!", error.localizedDescription);
          }
    }
    else{
         kAlertView(@"Errror!", error.localizedDescription);
    }
}

#pragma mark : TableView Datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return response_arrayData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"cellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[SuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.m_suggestName.text =[NSString stringWithFormat:@"%@",[[response_arrayData valueForKey:@"name"]objectAtIndex:indexPath.row]];
    tableView.separatorColor=[UIColor clearColor];
    UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    return cell;
}

#pragma mark: Tableview delegate method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     self.m_unique_username.text = [[response_arrayData valueForKey:@"name"]objectAtIndex:indexPath.row];
}

// Registering custom cell
-(void)registerCustomCell{
    UINib *nib_file =[UINib nibWithNibName:@"SuggestionCell" bundle:nil];
    [self.m_suggest_tblview registerNib:nib_file forCellReuseIdentifier:@"cellIdentifier"];
    self.m_suggest_tblview.dataSource=self;
    self.m_suggest_tblview.delegate=self;
    self.m_suggest_tblview.showsHorizontalScrollIndicator=NO;
    self.m_suggest_tblview.showsVerticalScrollIndicator=YES;
    self.m_suggest_tblview.allowsSelection=YES;
}




#pragma mark :Memory usage Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
