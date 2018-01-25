//
//  DetailPost.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 21/09/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "ResponsiveLabel.h"
#import "CommentCell.h"

@interface DetailPost : UIViewController<gettingFeed,getPostData,hitLikeOrUnLike,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
     UIView *containerView;
    HPGrowingTextView *m_message_txtView;
}
@property (strong, nonatomic) IBOutlet UIView *m_navigationView;
@property(strong,nonatomic)NSString*getQuestionId;
@property (strong, nonatomic) IBOutlet UITableView *m_tblView;
@property(strong,nonatomic)NSMutableArray *m_commentsfeed;
@property(strong,nonatomic)NSArray *m_response_data;


@end
