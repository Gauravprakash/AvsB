//
//  BlockedusersListing.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 19/09/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "ViewController.h"
#import "PrefixHeader.pch"
@interface BlockedusersListing : ViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *m_blockTable;
@property (strong, nonatomic) IBOutlet UIButton *m_backbutton;
@property(strong,nonatomic)NSArray *m_blockListingArray;
@end
