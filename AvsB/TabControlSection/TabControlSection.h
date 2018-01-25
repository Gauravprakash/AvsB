//
//  TabControlSection.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TabControlSection : UITabBarController<UITabBarControllerDelegate,UITabBarDelegate>
@property (strong, nonatomic) IBOutlet UITabBar *m_tabBar;

@end
