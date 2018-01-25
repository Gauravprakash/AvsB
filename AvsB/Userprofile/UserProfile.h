//
//  UserProfile.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "WebServices.h"

@interface UserProfile : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,gettingFeed,UITableViewDataSource,UITableViewDelegate,hitLikeOrUnLike,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *m_editProfile;
@property (strong, nonatomic) IBOutlet UIImageView *m_image_profile;
@property (strong, nonatomic) IBOutlet UICollectionView *m_CollectionView;
@property(strong,nonatomic)NSDictionary *m_user_dataItems;
@property(strong,nonatomic)NSArray *m_array_elements;
@property(strong,nonatomic)NSArray *data_Images;
@property(strong,nonatomic)NSArray *data_SecondImages;
@property(strong,nonatomic)NSArray *user_name;
@property(strong,nonatomic)NSArray *postedDate;
@property(strong,nonatomic)NSArray *user_img;
@property (strong, nonatomic) IBOutlet UILabel *m_profilename;
@property (strong, nonatomic) IBOutlet UILabel *m_profile_info;
@property (strong, nonatomic) IBOutlet UITableView *followers_table;
@property (strong, nonatomic) IBOutlet UIButton *m_following;
@property (strong, nonatomic) IBOutlet UIButton *m_followers;
@property (strong, nonatomic) IBOutlet UIButton *m_posts;
@property(strong,nonatomic)NSMutableArray *totalfollowersList;
@property(strong,nonatomic)NSMutableArray *totalfollowingList;
@property(strong,nonatomic)NSMutableArray *totalPostingList;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalFollowersPages;
@property (strong, nonatomic) IBOutlet UIButton *m_backButton;
@property (nonatomic, assign) NSInteger totalFollowingPages;
@property(nonatomic,strong)NSString *navigationMenu;
@property (strong, nonatomic) IBOutlet UIView *m_followingView;

@end
