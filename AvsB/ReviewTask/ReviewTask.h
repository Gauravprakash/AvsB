//
//  ReviewTask.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "ResponsiveLabel.h"
@interface ReviewTask : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,QuestionuploadingWithImage,QuestionuploadingWithText>
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (strong, nonatomic) IBOutlet UILabel *m_title_query;
@property (strong, nonatomic) IBOutlet UIImageView *m_image_firstPost;
@property (strong, nonatomic) IBOutlet UIImageView *m_image_secondPost;
@property (strong, nonatomic) IBOutlet UIImageView *m_roundprofilePic;
@property (nonatomic,nonnull) UIImage*m_str_firstImage;
@property (nonatomic,nonnull) UIImage *m_str_secondImage;
@property(nonatomic,nonnull)NSString *m_str_title_query;
@property(nonatomic,nonnull)NSString*m_str_title_hashTag;
@property(nonatomic,nonnull)NSString *m_str_timeValue;
@property (strong, nonatomic) IBOutlet UILabel *m_timeValue;
@property (strong, nonatomic) IBOutlet UILabel *m_titleName;
@property (strong, nonatomic) IBOutlet ResponsiveLabel *m_hashTagLabel;
@property (strong, nonatomic) IBOutlet UIButton *m_submitButton;
@property(strong,nonatomic)NSString*m_firstLabel;
@property(strong,nonatomic)NSString*m_secondLabel;
@property(strong,nonatomic)NSDictionary *receivedDict;
@property (strong, nonatomic) IBOutlet UILabel *m_titleQuery;
@property (strong, nonatomic) IBOutlet UIImageView *m_vs;
@property (strong, nonatomic) IBOutlet UIView *m_navigationMenu;
@property (strong, nonatomic) IBOutlet UIView *m_firstView;
@property (strong, nonatomic) IBOutlet UIView *m_secondView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *m_friends_Toplayout;
@property (strong, nonatomic) IBOutlet UILabel *m_firstviewlbl;
@property (strong, nonatomic) IBOutlet UILabel *m_secondviewlbl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *m_hashTag_constraint;
@property (strong, nonatomic) IBOutlet UILabel *m_viewlbl;
@property(strong,nonatomic)NSString *hashTagContent;




@end
