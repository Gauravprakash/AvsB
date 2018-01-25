//
//  TabControlSection.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "TabControlSection.h"

@interface TabControlSection (){
    UIImageView *imageView;
    double screenHeight;
}
@end

@implementation TabControlSection

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setShadowImage: nil];
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.m_tabBar.backgroundColor=[UIColor whiteColor];
    self.m_tabBar.barTintColor=[UIColor clearColor];
    self.m_tabBar.barStyle=UITabBarItemPositioningAutomatic;
    self.m_tabBar.layer.borderUIColor=[UIColor clearColor];
    self.m_tabBar.backgroundImage = [UIImage imageNamed:@"shape"];
    self.tabBarController.tabBar.autoresizesSubviews=NO;
    self.tabBarController.tabBar.clipsToBounds=YES;
    
    // to hide status shadow
   [self.tabBarController.navigationController.navigationBar setShadowImage:[UIImage new]];
   [self.m_tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
