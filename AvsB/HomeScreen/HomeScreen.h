//
//  HomeScreen.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "ResponsiveLabel.h"
@interface HomeScreen : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,gettingFeed,UITabBarControllerDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableArray *expandedCells;
@property (nonatomic, retain) UIImageView *m_pic_one;
@property (nonatomic, retain) UIImageView *m_pic_second;
@property(strong,nonatomic)UIView*m_firstView;
@property(strong,nonatomic)UIView *m_secondView;
@property(strong,nonatomic)UILabel*m_firstTypelbl;
@property(strong,nonatomic)UILabel*m_secondTypelbl;
@property(strong,nonatomic)UIImage *first_img_type;
@property(strong,nonatomic)UIImage *sec_img_type;
@property(strong,nonatomic)NSMutableArray *m_dict_array;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalItems;
@property (assign) NSTimer *countdownTimer;
@property (retain, nonatomic) UILabel *updatingLabel;
@property (strong, nonatomic) IBOutlet UITableView *m_tblView;
@property(strong,nonatomic)NSString*searchHashTagging;

@end
