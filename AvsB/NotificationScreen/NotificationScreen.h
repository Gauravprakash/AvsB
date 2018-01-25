//
//  NotificationScreen.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"


@interface NotificationScreen : UIViewController<UITableViewDataSource,UITableViewDelegate,gettingFeed>
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UITableView *m_tableview2;
@property(strong,nonatomic)NSMutableArray *m_array_followersNotification;
@property(strong,nonatomic)NSMutableArray *m_array_votingNotification;



@end
