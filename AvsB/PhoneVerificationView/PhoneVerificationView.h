//
//  PhoneVerificationView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@interface PhoneVerificationView : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *m_bottomView;
@property (strong, nonatomic) IBOutlet UIView *m_middleView;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_phone_fill;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_background;
@property (strong, nonatomic) IBOutlet UIView *view_background;
@property (strong, nonatomic) IBOutlet UIButton *m_buttonNext;

@end
