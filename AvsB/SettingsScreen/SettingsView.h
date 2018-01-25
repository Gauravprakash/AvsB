//
//  SettingsView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfile.h"
#import "PrefixHeader.pch"
@interface SettingsView : UIViewController< Logoutservice,turnedNotificationOn>
@property (strong, nonatomic) IBOutlet UIButton *m_logOut;
@property (strong, nonatomic) IBOutlet UIButton *m_privacyPolicy;
@property (strong, nonatomic) IBOutlet UIButton *m_reportProblem;
@property (strong, nonatomic) IBOutlet UIButton *m_helpcenter;
@property (strong, nonatomic) IBOutlet UIView *m_Notification;
@property (strong, nonatomic) IBOutlet UIButton *m_changePassword;
@property (strong, nonatomic) IBOutlet UIButton *m_editProfile;
@property (strong, nonatomic) IBOutlet UISwitch *m_switch;

@end
