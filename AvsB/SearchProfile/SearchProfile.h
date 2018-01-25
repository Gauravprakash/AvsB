//
//  SearchProfile.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SearchProfile : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,gettingFeed,UITextFieldDelegate,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *m_txtField;
@property (strong, nonatomic) IBOutlet UIButton *m_txtButton;
@property (strong, nonatomic) IBOutlet UIButton *m_cancelbtn;
@property (strong, nonatomic) IBOutlet UICollectionView *m_collectionView;
@property(strong,nonatomic)NSMutableArray *dataitems;
@property (nonatomic, assign) NSInteger totalPages, searchingtotalPage;
@property(strong,nonatomic)NSMutableArray *m_usersSearchdata;
@property(strong,nonatomic)NSArray*m_userFeeddata;
@property(strong,nonatomic)NSArray *m_feedsSearchdata;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property(strong,nonatomic)NSString*searchHashTagging;

@end
