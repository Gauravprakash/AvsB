//
//  CommentCell.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 10/10/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *m_roundImage;
@property (strong, nonatomic) IBOutlet UILabel *m_comment_lbl;
@property (strong, nonatomic) IBOutlet UILabel *m_time_lbl;
@property (strong, nonatomic) IBOutlet UIButton *m_replybutton;
@property (strong, nonatomic) IBOutlet UIButton *m_likebutton;
@property (strong, nonatomic) IBOutlet UILabel *m_lblCount;

@end
