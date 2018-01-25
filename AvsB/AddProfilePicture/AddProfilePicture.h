//
//  AddProfilePicture.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
@interface AddProfilePicture : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,Webservices,uploadingpicture,gettingFeed>
@property (strong, nonatomic) IBOutlet UIImageView *m_profileImage;
@property (strong, nonatomic) IBOutlet UIButton *m_skip;
@property (strong, nonatomic) IBOutlet UIButton *add_photo;
@property (strong, nonatomic) IBOutlet UILabel *m_photo_description;
@property (strong, nonatomic) IBOutlet UILabel *m_addpicture;
@end
