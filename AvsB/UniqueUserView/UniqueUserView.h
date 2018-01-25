//
//  UniqueUserView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
@interface UniqueUserView : UIViewController<UITextFieldDelegate,Randomusername,UITableViewDataSource,UITableViewDelegate,usernameSuggestion,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *m_bottomView;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (strong, nonatomic) IBOutlet UITextField *m_unique_username;
@property (strong, nonatomic) IBOutlet UIButton *m_buttonNext;
@property (strong, nonatomic) IBOutlet UIButton *button_mark;
@property(strong,nonatomic)NSString*m_dummy_email;
@property(strong,nonatomic)NSString*m_dummy_contact;
@property(strong,nonatomic)NSString*m_dummy_username;
@property(strong,nonatomic)NSString*m_dummy_password;
@property (strong, nonatomic) IBOutlet UITableView *m_suggest_tblview;


@end
