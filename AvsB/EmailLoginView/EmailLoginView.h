//
//  EmailLoginView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
@interface EmailLoginView : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *m_bottomView;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_email;
@property (strong, nonatomic) IBOutlet UIButton *m_buttonNext;
@property(strong,nonatomic)NSString *phone_details;

@end
