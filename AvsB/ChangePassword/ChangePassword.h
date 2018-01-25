//
//  ChangePassword.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 19/09/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "ViewController.h"

@interface ChangePassword : ViewController<UITextFieldDelegate,profileUpdated>
@property (strong, nonatomic) IBOutlet UITextField *m_oldpass;
@property (strong, nonatomic) IBOutlet UITextField *m_newPass;
@property (strong, nonatomic) IBOutlet UITextField *m_retypePass;
@property (strong, nonatomic) IBOutlet UIButton *m_submitButton;
@property (strong, nonatomic) IBOutlet UIButton *m_backbutton;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollview;
@property(strong,nonatomic)NSMutableDictionary *m_dict;

@end
