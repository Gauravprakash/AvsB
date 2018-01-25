//
//  ForgotPasswordView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
@interface ForgotPasswordView : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *m_txt_email_field;
@property (strong, nonatomic) IBOutlet UIButton *m_sendPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@end
