//
//  getReplyOnComment.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 25/08/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getReplyOnComment : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *m_comment;
@property (strong, nonatomic) IBOutlet UIImageView *m_profilepic;
@property (strong, nonatomic) IBOutlet UIButton *m_replybtn;
@property (strong, nonatomic) IBOutlet UITextView *m_reply_txtview;

@end
