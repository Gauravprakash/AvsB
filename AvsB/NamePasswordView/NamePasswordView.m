//
//  NamePasswordView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//
#define MAXLENGTH 6
#import "NamePasswordView.h"
#define kFullname 1
#define kPassword 2

@interface NamePasswordView (){
    CommonMethods *m_instanceMethods;
}
@end
@implementation NamePasswordView

#pragma mark : App Life Cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    m_instanceMethods =[CommonMethods sharedInstance];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
//    [self.view bringSubviewToFront:self.m_bottomView];
    [CommonMethods addBackgroundColorToTextField:self.m_password_view];
    [CommonMethods addBackgroundColorToTextField:self.m_fullName_view];
    [CommonMethods addPaddingView:self.m_password_view];
    [CommonMethods addPaddingView:self.m_fullName_view];
    [m_instanceMethods addCornerRadiusToButton:self.m_nextButton];
    [CommonMethods addBorderLineToTextField:self.m_password_view];
    [CommonMethods addBorderLineToTextField:self.m_fullName_view];
    [self.m_fullName_view setTag:kFullname];
    [self.m_password_view setTag:kPassword];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.m_fullName_view setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
    [self.m_password_view setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
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
- (IBAction)btn_Next:(id)sender {
    [self checkStatus];
    [self.view endEditing:YES];
}
-(void)checkStatus{
    if(self.m_fullName_view.text.isEmpty && self.m_password_view.text.isEmpty){
        kAlertView(@"Please Note!", @"All fields are mandatory");
    }
   else if(self.m_fullName_view.text.isEmpty) {
        kAlertView(@"Please Note!", @"Please enter your full name");
    }
  else if(self.m_password_view.text.isEmpty){
          kAlertView(@"Please Note!", @"Please enter your password");
   }
   else if(self.m_password_view.text.length<MAXLENGTH){
      kAlertView(@"Please Note!", @"Password must be atleast more than 6 characters");
   }
   else{
       UniqueUserView *unique=INSTANTIATE(@"UniqueUserView");
       unique.m_dummy_contact =self.m_phoneData;
       unique.m_dummy_email = self.m_emailData;
       unique.m_dummy_username=self.m_fullName_view.text;
       unique.m_dummy_password =self.m_password_view.text;
       [self.navigationController pushViewController:unique animated:YES];
   }
}
#pragma mark : Textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case kFullname:
            [self.m_fullName_view becomeFirstResponder];
            break;
            
        case kPassword:
            [self.m_password_view becomeFirstResponder];
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag==kFullname){
        [self.m_password_view becomeFirstResponder];
    }
    else if(textField.tag==kPassword){
        [textField resignFirstResponder];
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    switch (textField.tag) {
        case kFullname:
            self.m_fullName_view.placeholder =@"Fullname";
            break;
            
        case kPassword:
            self.m_password_view.placeholder =@"Password";
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case kFullname:
            [self.m_password_view becomeFirstResponder];
            break;
            
        case kPassword:
            [self.m_password_view resignFirstResponder];
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }
    
}


- (IBAction)m_loginView:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
