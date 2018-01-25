//
//  FollowingCell.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 17/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *m_img_profile;
@property (strong, nonatomic) IBOutlet UILabel *m_label_profile;
@property (strong, nonatomic) IBOutlet UIImageView *m_img_one;
@property (strong, nonatomic) IBOutlet UIImageView *m_img_two;
@property (strong, nonatomic) IBOutlet UILabel *m_postedhours;
@property (strong, nonatomic) IBOutlet UIView *m_firstView;
@property (strong, nonatomic) IBOutlet UIView *m_secondView;
@property (strong, nonatomic) IBOutlet UILabel *m_first_pic_label;
@property (strong, nonatomic) IBOutlet UILabel *m_second_pic_label;

@end
