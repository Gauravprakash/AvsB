//
//  CommentSection.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 19/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "HPGrowingTextView.h"
#import "NSMutableAttributedString+FormatLabel.h"
@interface CommentSection : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,gettingFeed,getPostData,hitLikeOrUnLike,gettingreplyfeedResult,UIAlertViewDelegate,UIScrollViewDelegate,HPGrowingTextViewDelegate>{
    UIView *containerView;
    HPGrowingTextView *m_message_txtView;
}
@property (strong, nonatomic) IBOutlet UITableView *m_Comment_tableView;
@property (strong, nonatomic) IBOutlet UIView *m_Comment_sectionView;
//@property (strong, nonatomic) IBOutlet UITextView *m_message_txtView;
@property(strong,nonatomic)NSString*kQuestionId;
@property(strong,nonatomic)NSString *kCommentsId;
@property(strong,nonatomic)NSMutableArray*m_commentsFeed;
@property(strong,nonatomic)NSMutableArray*m_repliesFeed;
@property(strong,nonatomic)NSMutableDictionary *m_commentsData;
@property(strong,nonatomic)NSMutableDictionary *m_repliesData;
@property(strong,nonatomic)NSMutableDictionary *m_hitLikeData;
@property (assign) NSInteger expandedSectionHeaderNumber;
@property (assign) UITableViewHeaderFooterView *expandedSectionHeader;
@property(strong,nonatomic)NSMutableArray *expandedSections;


@end
