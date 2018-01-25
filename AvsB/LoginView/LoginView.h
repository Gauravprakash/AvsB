//
//  LoginView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "WebServices.h"
#import "Facebookdelegates.h"
@interface LoginView : UIViewController<UITextFieldDelegate,Webservices,gettingFeed,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *m_btn_fb;
@property (strong, nonatomic) IBOutlet UIView *m_bottom_view;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (strong, nonatomic) IBOutlet UITextField *m_user_name;
@property (strong, nonatomic) IBOutlet UITextField *m_password;
@property (strong, nonatomic) IBOutlet UIButton *m_loginButton;
@property (strong, nonatomic) IBOutlet UIButton *m_signUp;
@property (strong, nonatomic) IBOutlet UIView *m_View_ImageType;
@property (strong, nonatomic) IBOutlet UIView *m_view_firstSidebar;
@property (strong, nonatomic) IBOutlet UIView *m_view_secondSidebar;
@property(strong,nonatomic)NSMutableDictionary *m_dataDict;
@property(strong,nonatomic)NSMutableDictionary *fb_data;
@property(strong,nonatomic)NSMutableArray *raw_arrayData;
@property (strong, nonatomic) IBOutlet UIView *m_loginView;


@end
