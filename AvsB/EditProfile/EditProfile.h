//
//  EditProfile.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
@interface EditProfile : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,profileUpdated,ProfilepictureUpdated,UITextFieldDelegate >
@property (strong, nonatomic) IBOutlet UIScrollView *m_ScrollView;
@property (strong, nonatomic) IBOutlet UIButton *btn_updateProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *m_profile_image;
@property(strong,nonatomic)UIImage *m_image;
@property (strong, nonatomic)NSString *m_userinfo;
- (IBAction)m_updateYourProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_profile_image;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_username;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_nickName;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_website;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_info;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_email;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_phone;
@property (strong, nonatomic) IBOutlet UITextField *m_txt_gender;
@end
