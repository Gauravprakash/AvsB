//
//  PhoneVerificationView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "PhoneVerificationView.h"

@interface PhoneVerificationView (){
    CommonMethods *m_InstanceMethods;
}

@end

@implementation PhoneVerificationView

- (void)viewDidLoad {
    [super viewDidLoad];
    m_InstanceMethods=[CommonMethods sharedInstance];
    self.m_txt_phone_fill.delegate=self;
    [self setUpViews];
    for(UIView*button in self.view.subviews){
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
    }
    [self.m_txt_phone_fill setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
   }
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(void)viewWillLayoutSubviews{
//    [self.view addSubview:self.m_bottomView];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)btn_Next:(id)sender {
    [self phoneVerification];
    [self.view endEditing:YES];
}

-(void)phoneVerification{
    if(self.m_txt_phone_fill.text.isEmpty){
        kAlertView(@"Please Note!", @"This field is mandatory");
    }
    else if(![m_InstanceMethods validatePhoneNumberWithString:self.m_txt_phone_fill.text]){
        kAlertView(@"Alert", @"Please enter a valid phone number");
      }
    else{
        EmailLoginView *emailView=INSTANTIATE(@"EmailLoginView");
        emailView.phone_details=self.m_txt_phone_fill.text;
        [self.navigationController pushViewController:emailView animated:YES];
    }
}
- (IBAction)m_login:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

//customMethod
-(void)setUpViews{
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
    self.lbl_background.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    self.view_background.layer.borderWidth=1.5f;
    self.view_background.layer.borderColor=[UIColor colorWithRed:217/255.0 green:221/255.0 blue:225/255.0 alpha:1.0].CGColor;
    self.view_background.layer.cornerRadius=5.0f;
    self.view_background.clipsToBounds=YES;
    [CommonMethods addBackgroundColorToTextField:self.m_txt_phone_fill];
    [CommonMethods addPaddingView: self.m_txt_phone_fill];
    [m_InstanceMethods addCornerRadiusToButton:self.m_buttonNext];
    self.view_background.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
}

#pragma mark : Textfield delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
   [self.m_txt_phone_fill becomeFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.m_txt_phone_fill.placeholder = @"Phone number";
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.m_txt_phone_fill resignFirstResponder];
}

#  pragma Mark : Memory usage Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
