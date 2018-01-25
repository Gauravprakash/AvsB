//
//  SearchUsersProfile.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 11/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import <MessageUI/MessageUI.h>

@interface SearchUsersProfile : UIViewController<UIActionSheetDelegate,gettingFeed,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,hitLikeOrUnLike,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate>{
    CommonMethods *m_InstanceMethods;
}
@property (strong, nonatomic) IBOutlet UIImageView *m_roundProfilePic;
@property (strong, nonatomic) IBOutlet UIButton *m_followbutton;
@property (strong, nonatomic) IBOutlet UIButton *m_detailButton;
@property(strong,nonatomic)NSString *profile_id;
@property (strong, nonatomic) IBOutlet UIButton *m_Posts;
@property (strong, nonatomic) IBOutlet UIButton *m_followers;
@property (strong, nonatomic) IBOutlet UIButton *m_following;
@property(assign,nonatomic)NSString *buttonTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_headername;
@property (strong, nonatomic) IBOutlet UILabel *m_profilename;
@property (strong, nonatomic) IBOutlet UIImageView *m_profileImage;
@property (strong, nonatomic) IBOutlet UILabel *m_profileInfo;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *m_collectionView;
@property (strong, nonatomic) IBOutlet UIView *m_lockView;
@property(strong,nonatomic)NSMutableArray *totalFollowers;
@property(strong,nonatomic)NSMutableArray *totalFollowing;
@property(strong,nonatomic)NSMutableArray *totalPosting;
@property(strong,nonatomic) NSString *tableSelected;
@property(strong,nonatomic)  NSString *user_profile_id;
@property (strong, nonatomic) IBOutlet UIView *m_postView;
@property (strong, nonatomic) IBOutlet UIView *m_followersView;
@property (strong, nonatomic) IBOutlet UIView *m_followingView;




@end
