//
//  PostaQuestionView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
@interface PostaQuestionView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,UIWebViewDelegate,gettingFeed>
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollview;
@property (strong, nonatomic) IBOutlet UIImageView *img_source1;
@property (strong, nonatomic) IBOutlet UIImageView *img_source2;
@property (strong, nonatomic) IBOutlet UITextView *txtView;
@property (strong, nonatomic) IBOutlet UITextView *m_textview_hashTag;
@property (strong, nonatomic) IBOutlet UILabel *lblOptionA;
@property (strong, nonatomic) IBOutlet UILabel *lblOptionB;
@property (strong, nonatomic) IBOutlet UITextView *m_txtView;
@property (strong, nonatomic) IBOutlet UITextView *m_secondtextView;
@property (strong, nonatomic) IBOutlet UICollectionView *m_collectionBackgroundData;
@property (strong, nonatomic) IBOutlet UICollectionView *m_collectionSecondbgData;
@property (strong, nonatomic) IBOutlet UICollectionView *m_textCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *m_collectionSecondtextfontcolor;
@property (strong, nonatomic) IBOutlet UILabel *m_lblbgtheme;
@property (strong, nonatomic) IBOutlet UILabel *m_secondlblbgtheme;
@property (strong, nonatomic) IBOutlet UILabel *m_lblfontcolor;
@property (strong, nonatomic) IBOutlet UILabel *m_secondlblfontcolor;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *m_txtView_toplayout;
@property (strong, nonatomic) IBOutlet UIView *m_sharingView;
@property (strong, nonatomic) IBOutlet UIButton *m_first_cross;
@property (strong, nonatomic) IBOutlet UIButton *m_sec_cross;
//MARK: variable taken Only for showing suggestion for username 
@property (strong, nonatomic) IBOutlet UITableView *m_suggest_user_tblView;
@property(strong,nonatomic)NSMutableArray*m_username;

@end
