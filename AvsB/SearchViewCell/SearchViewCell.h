//
//  SearchViewCell.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 05/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewCell : UICollectionViewCell{
    AppDelegate*app;
}
@property (strong, nonatomic) IBOutlet UIImageView *m_searchCell_img1;
@property (strong, nonatomic) IBOutlet UIImageView *m_searchCell_img2;
@property (strong, nonatomic) IBOutlet UILabel *m_profileDate;
@property (strong, nonatomic) IBOutlet UILabel *m_timelabel;
@property (strong, nonatomic) IBOutlet UIView *m_first_view;
@property (strong, nonatomic) IBOutlet UIView *m_second_veiw;
@property (strong, nonatomic) IBOutlet UIButton *m_first_view_lbl;
@property (strong, nonatomic) IBOutlet UIButton *m_sec_view_lbl;
@property (strong, nonatomic) IBOutlet UILabel *m_first_txtlbl;
@property (strong, nonatomic) IBOutlet UILabel *m_sec_txtlbl;
@end
