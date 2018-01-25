//  ForgotPasswordView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//


#import "ForgotPasswordView.h"
@interface ForgotPasswordView(){
    CommonMethods *m_instanceMethods;
}
@end

@implementation ForgotPasswordView

-(void)viewDidLoad{
    [super viewDidLoad];
    m_instanceMethods=[CommonMethods sharedInstance];
    self.m_txt_email_field.delegate =self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [CommonMethods addPaddingView:self.m_txt_email_field];
    [CommonMethods addBorderLineToTextField:self.m_txt_email_field];
    [m_instanceMethods addCornerRadiusToButton:self.m_sendPassword];
    [CommonMethods addBackgroundColorToTextField:self.m_txt_email_field];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.m_scrollView.bounces = NO;
    self.m_scrollView.scrollEnabled = NO;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)m_sendPassword:(id)sender {
    [self checkStatus];
    [self.view endEditing:YES];
}

-(void)checkStatus{
    if(self.m_txt_email_field.text.isEmpty){
        kAlertView(@"Please Note!", @"This field is Mandatory");
    }
    else if(!self.m_txt_email_field.text.isValidEmail){
          kAlertView(@"Please Note!", @"please enter only valid email ID");
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (IBAction)back_button:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
        [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma Mark: TextField Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField{
       [self.m_txt_email_field becomeFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.m_txt_email_field.placeholder = @"EmailId";
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.m_txt_email_field resignFirstResponder];
}


@end
