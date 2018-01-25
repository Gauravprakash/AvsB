//
//  HomeCell.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponsiveLabel.h"
@interface HomeCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>{
    CommonMethods *m_instanceMethod;
    int secondsLeft;
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UIVisualEffectView *first_visualView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *second_visualView;
@property (strong, nonatomic) IBOutlet UIButton *m_firstchk_box;
@property (strong, nonatomic) IBOutlet UIButton *m_secchk_box;
@property (strong, nonatomic) NSMutableArray *expandedCells;
@property (strong, nonatomic) IBOutlet UIImageView *round_profilePic;
@property (strong, nonatomic) IBOutlet UILabel *m_headerTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_query;
@property (strong, nonatomic) IBOutlet UIImageView *m_pic1;
@property (strong, nonatomic) IBOutlet UIImageView *m_pic2;
@property (strong, nonatomic) IBOutlet UILabel *m_pic1_title;
@property (strong, nonatomic) IBOutlet UILabel *m_pic2_title;
@property (strong, nonatomic) IBOutlet UIButton *m_buttonvoting;
@property (strong, nonatomic) IBOutlet UIButton *m_buttonComment;
@property (strong, nonatomic) IBOutlet UIButton *m_buttonShare;
@property (strong, nonatomic) IBOutlet UILabel *m_countVote;
@property (strong, nonatomic) IBOutlet UILabel *m_static_query;
//@property (strong, nonatomic) IBOutlet UILabel *m_hashTag;
@property (strong, nonatomic) IBOutlet UIButton *btn_commentSections;
@property (strong, nonatomic) IBOutlet UILabel *m_timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *m_hoursLabel;
@property (strong, nonatomic) IBOutlet UIButton *m_precentageA;
@property (strong, nonatomic) IBOutlet UIButton *m_percentageB;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *m_queryConstraint;
@property (strong, nonatomic) IBOutlet UIView *m_view1;
@property (strong, nonatomic) IBOutlet UIView *m_view2;
@property (strong, nonatomic) IBOutlet UIImageView *m_trophy_one;
@property (strong, nonatomic) IBOutlet UIImageView *m_trophy_two;
@property (strong, nonatomic) IBOutlet ResponsiveLabel *m_hashTag;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *m_hashTagConstraint;
@property(strong,nonatomic)NSTimer *timer;
@property(nonatomic,assign) NSInteger remainingTime;
-(void)calculateRemainingTime;
@end
