//
//  EmailLoginView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "EmailLoginView.h"

@interface EmailLoginView (){
    CommonMethods *m_InstanceMethods;
}
@end
@implementation EmailLoginView
-(void)viewDidLoad {
    [super viewDidLoad];
    m_InstanceMethods =[CommonMethods sharedInstance];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.m_txt_email setDelegate:self];
    [self.m_txt_email setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
    [self.view bringSubviewToFront:self.m_bottomView];
    [self setUpViews];
    NSLog(@"phone number: %@",self.phone_details);

}
- (void)scrollTap:(UIGestureRecognizer*)gestureRecognizer {
    [self.view endEditing:YES];
}
-(void)viewWillLayoutSubviews{
//    [self.view addSubview:self.m_bottomView];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)btn_Next:(id)sender {
    if(self.m_txt_email.text.isEmpty){
        kAlertView(@"Please Note!", @"Email field is Mandatory.");
    }
    else if (!self.m_txt_email.text.isValidEmail){
        kAlertView(@"Please Note!", @"Please enter a valid mail");
}
    else{
        NamePasswordView *name_pass_view= INSTANTIATE(@"NamePasswordView");
        name_pass_view.m_emailData = self.m_txt_email.text;
        name_pass_view.m_phoneData = self.phone_details;
        [self.navigationController pushViewController:name_pass_view animated:YES];
    }
    [self.view endEditing:YES];
    }
- (IBAction)m_loginView:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)setUpViews{
    [CommonMethods addBackgroundColorToTextField:self.m_txt_email];
    [CommonMethods addBorderLineToTextField:self.m_txt_email];
    [m_InstanceMethods addCornerRadiusToButton:self.m_buttonNext];
    [CommonMethods addPaddingView:self.m_txt_email];
}

#pragma mark : Textfield delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
       [self.m_txt_email becomeFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.self.m_txt_email.placeholder = @"EmailID";
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.m_txt_email resignFirstResponder];
}



#pragma mark : Memory usage warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
