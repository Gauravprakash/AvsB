//
//  HomeCell.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "HomeCell.h"
@implementation HomeCell
@synthesize expandedCells;

- (void)awakeFromNib{
    appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
}


-(void)calculateRemainingTime{
    int hours, minutes, seconds,secondsLeft;
     secondsLeft = self.remainingTime;
//    NSLog(@"%d",secondsLeft);
       hours = secondsLeft/3600;
        minutes = (secondsLeft % 3600)/60;
        seconds = (secondsLeft % 3600)% 60;
        self.m_timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
     self.remainingTime--;
    if (seconds==0){
        self.m_timeLabel.hidden = YES;
        [ self.timer invalidate];
        self.timer = nil;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
