//
//  RateController.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 06/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponsiveLabel.h"
#import "PrefixHeader.pch"
@interface RateController : UIViewController<UITextViewDelegate,getPostData,UIAlertViewDelegate,gettingFeed,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    UIView *containerView;
    HPGrowingTextView *m_message_txtView;
}
@property(strong,nonatomic)NSArray *m_responseData;
@property (strong, nonatomic) IBOutlet UIImageView *m_profilePic;
@property (strong, nonatomic) IBOutlet UILabel *m_headinglabel;
@property (strong, nonatomic) IBOutlet UILabel *m_headingQuery;
@property (strong, nonatomic) IBOutlet UIImageView *m_image1;
//@property (strong, nonatomic) IBOutlet UILabel *m_img_first_Title;
@property (strong, nonatomic) IBOutlet UIImageView *m_image2;
@property (strong, nonatomic) IBOutlet UILabel *m_voteCount;
@property (strong, nonatomic) IBOutlet UILabel *m_votingQuery;
//@property (strong, nonatomic) IBOutlet UILabel *m_hashTag;
//@property (strong, nonatomic) IBOutlet UILabel *m_img_two_Title;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (strong, nonatomic) IBOutlet UIView *m_topView;
@property (strong, nonatomic) IBOutlet ResponsiveLabel *m_hashTag;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *m_visualEffect_one;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *m_visualEffect_two;
@property (strong, nonatomic) IBOutlet UIButton *m_firstImage_checkBox;
@property (strong, nonatomic) IBOutlet UIButton *m_secondImage_checkBox;
@property (strong, nonatomic) IBOutlet UIButton *m_voting;
@property (strong, nonatomic) IBOutlet UIButton *m_chat;
@property (strong, nonatomic) IBOutlet UIButton *m_sharing;
@property(strong,nonatomic)NSString *getQuestion_Id;
@property(strong,nonatomic)NSString *getQuestionType;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *m_toplayout;
@property (strong, nonatomic) IBOutlet UILabel *m_timeLabel;
@property (strong, nonatomic) IBOutlet UIView *m_view_one;
@property (strong, nonatomic) IBOutlet UIView *m_view_sec;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *m_top_hashTag;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *m_top_query_constraint;
@property (strong, nonatomic) IBOutlet UITableView *m_commentfeed;
@property (strong, nonatomic) IBOutlet UIView *m_subView;
@property(strong,nonatomic)NSMutableArray *m_commentdata;




@end
