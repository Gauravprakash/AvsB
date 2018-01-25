//
//  ChangePassword.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 19/09/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#define kOldPass 1
#define kNewPass 2
#define kRetypePass 3

#import "ChangePassword.h"
@interface ChangePassword (){
CommonMethods *m_commonMethods;
WebServices *webData;
AppDelegate *appDelegate;
}
@end
@implementation ChangePassword

#pragma mark : view Controller life Cycle

-(void)viewDidLoad {
    [super viewDidLoad];
    m_commonMethods = [CommonMethods sharedInstance];
    self.m_oldpass.delegate =self;
    self.m_newPass.delegate =self;
    self.m_retypePass.delegate =self;
    self.m_dict =[[NSMutableDictionary alloc]init];
    webData =[[WebServices alloc]init];
    webData.profileUpdatedelegate=self;
    appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpViews];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.m_oldpass setTag:kOldPass];
    [self.m_newPass setTag:kNewPass];
    [self.m_retypePass setTag:kRetypePass];
    [self.m_oldpass setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
    [self.m_newPass setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
    [self.m_retypePass setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)setUpViews{
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
    [CommonMethods addBackgroundColorToTextField:self.m_oldpass];
    [CommonMethods addBackgroundColorToTextField:self.m_newPass];
    [CommonMethods addBackgroundColorToTextField:self.m_retypePass];
    [CommonMethods addBorderLineToTextField:self.m_oldpass];
    [CommonMethods addBorderLineToTextField:self.m_newPass];
    [CommonMethods addBorderLineToTextField:self.m_retypePass];
    [CommonMethods addPaddingView: self.m_oldpass];
    [CommonMethods addPaddingView: self.m_newPass];
    [CommonMethods addPaddingView: self.m_retypePass];
    [m_commonMethods addCornerRadiusToButton:self.m_submitButton];
}


#pragma mark : Textfield delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
       switch (textField.tag) {
        case kOldPass:
            [self.m_oldpass becomeFirstResponder];
            break;
            
        case kNewPass:
            [self.m_newPass becomeFirstResponder];
            break;
            
        case kRetypePass:
            [self.m_retypePass becomeFirstResponder];
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }

}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    switch (textField.tag) {
        case kOldPass:
            self.m_oldpass.placeholder =@"Old Password";
            break;
            
        case kNewPass:
            self.m_newPass.placeholder =@"New Password";
            break;
            
        case kRetypePass:
            self.m_retypePass.placeholder =@"Retype Password";
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
        case kOldPass:
            [self.m_newPass becomeFirstResponder];
            break;
            
        case kNewPass:
            [self.m_retypePass becomeFirstResponder];
            break;
            
        case kRetypePass:
            [self.m_retypePass resignFirstResponder];
            break;
            
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }
    return YES; 
}
// submit button Action
- (IBAction)m_submit:(id)sender {
    [self checkStatus];
    [self.view endEditing:YES];
}

// status check before submitting
-(void)checkStatus{
    if(self.m_oldpass.text.isEmpty&&self.m_newPass.text.isEmpty&&self.m_retypePass.text.isEmpty){
        kAlertView(@"Please Note!", @"All fields are mandatory");
    }
    else if (self.m_oldpass.text.isEmpty){
         kAlertView(@"Error!", @"please enter your old password");
    }
    else if (self.m_newPass.text.isEmpty){
        kAlertView(@"Error!", @"please enter your new password");
    }
    else if(![self.m_newPass.text isEqualToString:self.m_retypePass.text]){
        kAlertView(@"Error!", @"Pleae confirm your password, it's not matching");
    }
    else{
        [self.m_dict setValue:self.m_oldpass.text forKey:@"oldpassword"];
        [self.m_dict setValue:self.m_newPass.text forKey:@"newpassword"];
        [webData webServiceUpdateProfile:changePassword_URL  parameters:self.m_dict withheaderSection:appDelegate.array_rawData];
    }
}
// h+andling delegate
-(void)profileUpdated:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*status =[responseDictionary valueForKey:@"status"];
     NSString *methodName = [responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"change_password"]){
        if([status intValue]==200){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
              dispatch_async(dispatch_get_main_queue(), ^{
             [CommonMethods alertView:self title:@"" message:[responseDictionary valueForKey:@"message"]];
              });
        }
    }
    else{
    NSLog(@"Method Name not matching");
    }
}


// back button Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

    



@end
