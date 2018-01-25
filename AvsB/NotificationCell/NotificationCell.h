//
//  NotificationCell.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 13/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *m_round_profile_pic;
@property (strong, nonatomic) IBOutlet UILabel *m_title_label;
@property (strong, nonatomic) IBOutlet UILabel *m_title_query;
@property (strong, nonatomic) IBOutlet UIImageView *m_first_image;
@property (strong, nonatomic) IBOutlet UIImageView *m_second_image;
@property (strong, nonatomic) IBOutlet UILabel *m_time_table;
@property (strong, nonatomic) IBOutlet UIImageView *m_transparency_check1;
@property (strong, nonatomic) IBOutlet UIImageView *m_transparency_check2;
@property (strong, nonatomic) IBOutlet UILabel *m_queryType;
@property (strong, nonatomic) IBOutlet UIView *m_firstView;
@property (strong, nonatomic) IBOutlet UIView *m_secondView;
@property (strong, nonatomic) IBOutlet UILabel *m_first_pic_lbl;
@property (strong, nonatomic) IBOutlet UILabel *m_sec_pic_lbl;

@end
