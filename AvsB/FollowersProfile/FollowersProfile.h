//
//  FollowersProfile.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 04/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@interface FollowersProfile : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property(strong,nonatomic)NSArray*m_followersList ;
@property(strong,nonatomic)NSArray*m_followersImage;
@property (strong, nonatomic) IBOutlet UIButton *m_followButton;
@property (strong, nonatomic) IBOutlet UILabel *m_profile_name;
@property (strong, nonatomic) IBOutlet UIImageView *m_profile_image;
@property (strong, nonatomic) IBOutlet UILabel *m_lbl_follwers;
@property (strong, nonatomic) IBOutlet UILabel *m_lbl_post;

@property (strong, nonatomic) IBOutlet UILabel *m_lbl_following;
@end
