//
//  BlockedCell.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 19/09/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *m_blockList;
@property (strong, nonatomic) IBOutlet UIImageView *m_blockImage;
@property (strong, nonatomic) IBOutlet UIButton *m_unblock;

@end
