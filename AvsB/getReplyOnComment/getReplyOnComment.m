//
//  getReplyOnComment.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 25/08/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "getReplyOnComment.h"

@implementation getReplyOnComment
@synthesize m_reply_txtview;
@synthesize m_replybtn;
- (void)awakeFromNib {
    if ([self.contentView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.contentView.preservesSuperviewLayoutMargins = NO;
}
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
