//
//  FindFacebookFriends.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "FindFacebookFriends.h"

@interface FindFacebookFriends ()<FacebookDelegate>{
     Facebookdelegates* fb_delegate;
}
@end
@implementation FindFacebookFriends
- (void)viewDidLoad {
    [super viewDidLoad];
    fb_delegate=[[Facebookdelegates alloc]init];
    fb_delegate.delegate=self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (IBAction)find_myFriends:(id)sender {
    [fb_delegate FaceboookLogin:self];
}

# pragma mark : facebook delegate results

-(void)getFacebookResult:(NSDictionary *)dict{
    NSLog(@"Facebook data: %@",dict);
    if(dict!=nil){
        TabControlSection *Tab=INSTANTIATE(TAB_CONTROL_SECTION);
        [self.navigationController pushViewController:Tab animated:YES];
    }
}
-(void)errorResult:(NSError *)error{
    NSLog(@"Error result shown : %@",error.localizedDescription);
}
- (IBAction)m_Skip:(id)sender {
    AddProfilePicture *add_profile =INSTANTIATE(ADD_PROFILE_PICTURE);
    [self.navigationController pushViewController:add_profile animated:YES];
}

# pragma mark : Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
