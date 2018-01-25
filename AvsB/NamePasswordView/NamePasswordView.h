//
//  NamePasswordView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@interface NamePasswordView : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *m_bottomView;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (strong, nonatomic) IBOutlet UITextField *m_fullName_view;
@property (strong, nonatomic) IBOutlet UITextField *m_password_view;
@property (strong, nonatomic) IBOutlet UIButton *m_nextButton;
@property(strong,nonatomic)NSString *m_emailData;
@property(strong,nonatomic)NSString*m_phoneData;



@end
