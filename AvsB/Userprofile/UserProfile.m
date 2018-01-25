//
//  UserProfile.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#define ROW_HEIGHT 60.0
#import "UserProfile.h"
@interface UserProfile (){
    AppDelegate*app;
    SearchViewCell*cell;
    FollowersProfileCell *shell;
    CommonMethods *m_instanceMethods;
    NSString*m_userID;
    NSString*m_tokenKey;
    WebServices *webData;
    NSString *m_user_email;
    NSString*m_signup_type;
    NSString *isPrivateKey;
    UIRefreshControl *refreshControl;
    int pageNo,followersPageNo, followingPageNo;
    UIActivityIndicatorView *profileIndicatorView;
    NSString *first_view_color, *sec_view_color, *remainingTime,*first_txt_color,*sec_txt_color,*img1_URL,*img2_URL,*profile_URL,*postedDate;
    UIColor *first_viewColor, *sec_viewColor,*first_txtColor,*sec_txtColor;
    NSMutableDictionary *m_data;
    BOOL isFollowersTapped, isFollowingTapped,pageIncrement,followersPageIncrement,followingPageIncrement,RefreshAllPost,RefreshAllFollowers,RefreshAllFollowing;
    UIActivityIndicatorView *spinner;
    UILabel *m_label;
    NSMutableAttributedString*attr_followersString, *attr_PostsString , *attr_followingString;
    NSString*followers_handle , *notification_handling;
}
@end
@implementation UserProfile

# pragma mark: ViewController Life Cycle Methods

-(void)viewDidLoad {
    [super viewDidLoad];
    webData=[[WebServices alloc]init];
    webData.gettingFeeddelegate = self;
    webData.getLikedelegate = self;
    pageIncrement = NO;
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self registerNib];
    [self registertableViewNib];
    pageNo = 1;
    [self.m_CollectionView setHidden:YES];
    [self.followers_table setHidden:YES];
    CGRect frame =[[UIScreen mainScreen]bounds];
    m_label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, self.view.frame.size.width, 21.0f)] ;
    m_label.center =self.view.center;
    UIFont * customFont = [UIFont fontWithName:@"ProximaNova-SemiBold" size:10];
    m_label.font = customFont;
    m_label.adjustsFontSizeToFitWidth = YES;
    m_label.adjustsLetterSpacingToFitWidth = YES;
    m_label.minimumScaleFactor = 10.0f/12.0f;
    m_label.clipsToBounds = YES;
    m_label.backgroundColor = [UIColor clearColor];
    m_label.textColor = [UIColor blackColor];
    m_label.textAlignment =NSTextAlignmentCenter;
    m_label.numberOfLines = 0;
    [self.view addSubview:m_label];
    followersPageNo = 1;
    followingPageNo =1;
    m_data =[[NSMutableDictionary alloc]init];
    m_instanceMethods=[CommonMethods sharedInstance];
     webData.gettingFeeddelegate =self;
    self.totalfollowersList =[[NSMutableArray alloc]init];
    self.totalfollowingList =[[NSMutableArray alloc]init];
    self.totalPostingList = [[NSMutableArray alloc]init];
    self.m_user_dataItems = [[NSDictionary alloc]init];
    self.m_user_dataItems = [[NSUserDefaults standardUserDefaults]objectForKey:@"signupdata"];
    profileIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [profileIndicatorView setHidesWhenStopped:YES];
    RefreshAllFollowers =NO;
    RefreshAllPost = NO;
    RefreshAllFollowing = NO;
//    refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.tintColor = [UIColor grayColor];
//    [refreshControl addTarget:self action:@selector(refreshAllPostingList) forControlEvents:UIControlEventValueChanged];
  followers_handle = @"";
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [self performSelector:@selector(sendhttpdatatobackendtogetpostListing) withObject:nil afterDelay:0.00];
    CGFloat x = (self.m_CollectionView.frame.size.width- profileIndicatorView.frame.size.width)/2;
    CGFloat y = (self.m_CollectionView.frame.size.height-profileIndicatorView.frame.size.height)/2;
    profileIndicatorView.frame = CGRectMake(x, y,profileIndicatorView.frame.size.width, profileIndicatorView.frame.size.height);
    [self setusersProfile];
    [profileIndicatorView setHidden:NO];
    [profileIndicatorView startAnimating];
    [profileIndicatorView setCenter:self.view.center];
    [self.view addSubview:profileIndicatorView];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gettingPostNotification:) name:@"updatingPostingList" object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gettingPostNotification:) name:@"updatingFollowersList" object:nil];
dispatch_async(dispatch_get_main_queue(), ^{
         [self setUpViews];
    });
    if([self.navigationMenu isEqualToString:@"show"]){
        self.m_backButton.hidden = NO;
    }else{
        self.m_backButton.hidden = YES;
    }
    self.m_CollectionView.backgroundColor = [UIColor clearColor];
    [m_label setHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     self.m_profilename.text =[NSString stringWithFormat:@"%@",app.user_name];
    self.m_profile_info.text =[NSString stringWithFormat:@"%@", app.user_info];
    self.m_image_profile.image =app.img_profile;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [profileIndicatorView setHidden:YES];
    [profileIndicatorView removeFromSuperview];
    RefreshAllFollowers =NO;
    RefreshAllPost = NO;
    RefreshAllFollowing = NO;
    notification_handling = @"";
}
-(void)gettingPostNotification:(NSNotification*)notification{
if([notification.name isEqualToString:@"updatingPostingList"]){
     notification_handling = @"post";
    [self sendhttpdatatobackendtogetpostListing];
}
else if ([notification.name isEqualToString:@"updatingFollowersList"]){
    notification_handling = @"followers";
[self sendhttpdatatobackendtogetfollowersList];
}
}
- (IBAction)m_back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark : Collection view Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.totalPostingList.count==0){
        return  0;
    }
    else{
    return self.totalPostingList.count;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"reusingData";
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.borderWidth = 3.0f;
    cell.m_searchCell_img1.layer.borderWidth=0.5f;
    cell.m_searchCell_img2.layer.borderWidth=0.5f;
    cell.m_first_view.layer.borderWidth=0.5f;
    cell.m_second_veiw.layer.borderWidth=0.5f;
    cell.m_searchCell_img1.layer.borderColor = [UIColor colorWithRed:52/255.0 green:105/255.0 blue:218/255.0 alpha:1.0].CGColor;
    cell.m_searchCell_img2.layer.borderColor =[UIColor colorWithRed:52/255.0 green:105/255.0 blue:218/255.0 alpha:1.0].CGColor;
    cell.m_first_view.layer.borderColor=[UIColor colorWithRed:54/255.0 green:129/255.0 blue:220/255.0 alpha:1.0].CGColor;
    cell.m_second_veiw.layer.borderColor =[UIColor colorWithRed:54/255.0 green:129/255.0 blue:220/255.0 alpha:1.0].CGColor;
    cell.layer.borderColor =[UIColor colorWithRed:52/255.0 green:105/255.0 blue:218/255.0 alpha:1.0].CGColor;
    cell.backgroundColor =[UIColor clearColor];
    if([[[self.totalPostingList valueForKey:@"votepercentage_a"]objectAtIndex:indexPath.row]isEqualToString:@"0%"]){
        [cell.m_first_view_lbl setHidden:YES];
        [cell.m_sec_view_lbl setHidden:YES];
    }
    else{
    [cell.m_first_view_lbl setHidden: NO];
    [cell.m_sec_view_lbl setHidden: NO];
    [cell.m_first_view_lbl setTitle:[NSString stringWithFormat:@"%@",[[self.totalPostingList valueForKey:@"votepercentage_a"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [cell.m_sec_view_lbl setTitle:[NSString stringWithFormat:@"%@",[[self.totalPostingList valueForKey:@"votepercentage_b"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    }
    NSInteger timeLeft =[[[self.totalPostingList valueForKey:@"remainedtime"]objectAtIndex:indexPath.row]intValue];
    if(timeLeft==0){
        [cell.m_timelabel  setHidden:YES];
         remainingTime = @"TimeOut";
    }
    else{
        [cell.m_timelabel  setHidden:YES];
         remainingTime = @"";
        [cell.m_timelabel setText:[NSString stringWithFormat:@"%@",[m_instanceMethods timeLeftString:timeLeft]]];
}
NSDate * dateTimeStamping =[NSDate dateWithTimeIntervalSince1970:[[[self.totalPostingList valueForKey:@"posted_on"]objectAtIndex:indexPath.row]doubleValue]];
    postedDate = [NSString stringWithFormat:@"%@ ago",[m_instanceMethods timeLeftSinceDate:dateTimeStamping]];
    cell.m_profileDate.text =[NSString stringWithFormat:@"%@",postedDate];
    cell.m_first_txtlbl.numberOfLines =2;
    cell.m_sec_txtlbl.numberOfLines=2;
if([[[self.totalPostingList objectAtIndex:indexPath.row]valueForKey:@"question_type"]isEqualToString:@"1"]){
    img1_URL =[[self.totalPostingList valueForKey:@"option_a"]objectAtIndex:indexPath.row];
    img2_URL= [[self.totalPostingList valueForKey:@"option_b"]objectAtIndex:indexPath.row];
     [cell.m_first_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.totalPostingList valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]]];
     [cell.m_sec_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.totalPostingList valueForKey:@"overtext_b"]objectAtIndex:indexPath.row]]];
        [cell.m_first_txtlbl setTextColor:[UIColor whiteColor]];
        [cell.m_sec_txtlbl setTextColor:[UIColor whiteColor]];
        [cell.m_first_view setHidden:YES];
        [cell.m_second_veiw setHidden:YES];
        [cell.m_searchCell_img1 setHidden:NO];
        [cell.m_searchCell_img2 setHidden:NO];
        [cell.m_searchCell_img1 bringSubviewToFront:cell.m_first_view_lbl];
        [cell.m_searchCell_img2 bringSubviewToFront:cell.m_sec_view_lbl];
        [cell.m_searchCell_img1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:img1_URL]] placeholderImage:[UIImage imageNamed:@"placeholder_A"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            cell.m_searchCell_img1.image =image;
            cell.m_searchCell_img1.contentMode = UIViewContentModeScaleAspectFill;
            cell.m_searchCell_img1.clipsToBounds = YES;
        } failure:nil];
    [cell.m_searchCell_img2 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:img2_URL]] placeholderImage:[UIImage imageNamed:@"placeholder_B"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            cell.m_searchCell_img2.image =image;
            cell.m_searchCell_img2.contentMode = UIViewContentModeScaleAspectFill;
            cell.m_searchCell_img2.clipsToBounds = YES;
        } failure:nil];
}
    else{
        [cell.contentView bringSubviewToFront: cell.m_first_view_lbl];
        [cell.contentView bringSubviewToFront: cell.m_sec_view_lbl];
        [cell.contentView bringSubviewToFront:cell.m_profileDate];
        [cell.m_first_view setHidden:NO];
        [cell.m_second_veiw setHidden:NO];
        [cell.m_searchCell_img1 setHidden:YES];
        [cell.m_searchCell_img2 setHidden:YES];
        [cell.m_first_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.totalPostingList objectAtIndex:indexPath.row]valueForKey:@"option_a"]]];
        [cell.m_sec_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.totalPostingList objectAtIndex:indexPath.row]valueForKey:@"option_b"]]];
     first_txt_color = [NSString stringWithFormat:@"%@",[[self.totalPostingList valueForKey:@"textcolor_a"]objectAtIndex:indexPath.row]];
        first_txtColor = [m_instanceMethods getUIColorObjectFromHexString:first_txt_color alpha:0.9];
        cell.m_first_txtlbl.textColor = first_txtColor;
        sec_txt_color = [NSString stringWithFormat:@"%@",[[self.totalPostingList valueForKey:@"textcolor_b"]objectAtIndex:indexPath.row]];
        sec_txtColor = [m_instanceMethods getUIColorObjectFromHexString:first_txt_color alpha:0.9];
        cell.m_sec_txtlbl.textColor = sec_txtColor;
        first_view_color = [NSString stringWithFormat:@"%@",[[self.totalPostingList valueForKey:@"background_a"]objectAtIndex:indexPath.row]];
        first_viewColor=[m_instanceMethods getUIColorObjectFromHexString:first_view_color alpha:0.9];
        cell.m_first_view.backgroundColor = first_viewColor;
        sec_view_color = [NSString stringWithFormat:@"%@",[[self.totalPostingList valueForKey:@"background_b"]objectAtIndex:indexPath.row]];
        sec_viewColor=[m_instanceMethods getUIColorObjectFromHexString:sec_view_color alpha:0.9];
        cell.m_second_veiw.backgroundColor = sec_viewColor;
     }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.01f;
    float cellHeight =0.0f;
    if(screenRect.size.width ==320.0f){
        cellHeight = 80.0f;
    }
    else{
       cellHeight = 102.0f;
    }
    CGSize size = CGSizeMake(cellWidth, cellHeight);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.5f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.5f;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString*questionid_detail =[[self.totalPostingList valueForKey:@"question_id"]objectAtIndex:indexPath.row];
    DetailPost *rate = INSTANTIATE(DETAIL_POST_VIEW);
    rate.getQuestionId = questionid_detail;
    [self.navigationController pushViewController:rate animated:YES];
}

#pragma mark : tableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([followers_handle isEqualToString:@"1"]||[followers_handle isEqualToString:@"2"]){
    return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([followers_handle isEqualToString:@"1"] ){
        if(self.totalfollowersList.count>0){
        return self.totalfollowersList.count;
    }
    }
else if([followers_handle isEqualToString:@"2"] ){
 if (self.totalfollowingList.count>0){
    return  self.totalfollowingList.count;
    }
}
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"followersData";
    shell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!shell){
    shell = [[FollowersProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [shell.m_imageFollowers addSubview:profileIndicatorView];
    shell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorColor=[UIColor clearColor];
    UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, shell.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    shell.m_buttonFolllow.tag=indexPath.row;
    [shell.contentView addSubview:separatorView];
    [CommonMethods setImageCorner: shell.m_imageFollowers];
   [shell.m_buttonFolllow.layer setBorderColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0].CGColor];
   if([followers_handle isEqualToString:@"1"]){
        [shell.m_buttonFolllow setHidden: NO];
    profile_URL =[[self.totalfollowersList valueForKey:@"picture"]objectAtIndex:indexPath.row];
       if ([[[self.totalfollowersList objectAtIndex:indexPath.row]valueForKey:@"my_follow_stauts"]isEqualToString:@"1"]) {
           [shell.m_buttonFolllow setTitle:@"Following" forState:UIControlStateNormal];
           [shell.m_buttonFolllow setBackgroundColor:[UIColor whiteColor]];
           [shell.m_buttonFolllow setTitleColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0] forState:UIControlStateNormal];
       }
       else{
           [shell.m_buttonFolllow setTitle:@"Follow" forState:UIControlStateNormal];
           [shell.m_buttonFolllow setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0]];
           [shell.m_buttonFolllow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       }
     [shell.m_buttonFolllow addTarget:self action:@selector(NavigateToFollowersScreen:) forControlEvents:    UIControlEventTouchUpInside];
     [shell.m_profileName setText:[NSString stringWithFormat:@"%@",[[self.totalfollowersList objectAtIndex:indexPath.row]valueForKey:@"name"]]];
    shell.m_profileName.textColor =[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0];
   }
    else if([followers_handle isEqualToString:@"2"]){
             [shell.m_buttonFolllow setHidden:YES];
   profile_URL =[[self.totalfollowingList valueForKey:@"picture"]objectAtIndex:indexPath.row];
    shell.m_profileName.text =[NSString stringWithFormat:@"%@",[[self.totalfollowingList objectAtIndex:indexPath.row]valueForKey:@"name"]];
    shell.m_profileName.textColor =[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0];
}
if(profile_URL!=nil){
    [shell.m_imageFollowers setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:profile_URL]]
                       placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    shell.m_imageFollowers.image = image;
                                     } failure:nil];
}
    [shell.m_buttonFolllow setTag:indexPath.row];
    [shell.m_buttonFolllow.layer setCornerRadius:5.0f];
    [shell.m_buttonFolllow.layer setBorderWidth:1.0f];
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    return shell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
dispatch_async(dispatch_get_main_queue(),^{
    NSString *followers_id = @"";
     SearchUsersProfile *search= INSTANTIATE(SEARCH_USERS_PROFILE);
    if([followers_handle isEqualToString:@"1"]){
    followers_id =[[self.totalfollowersList valueForKey:@"user_id"]objectAtIndex:indexPath.row];
}
  else if ([followers_handle isEqualToString:@"2"]){
   followers_id =[[self.totalfollowingList valueForKey:@"user_id"]objectAtIndex:indexPath.row];
 }
NSLog(@"followers_id: %@",followers_id);
 search.profile_id = followers_id;
[self.navigationController pushViewController:search animated:YES];
});
}

// follow button Action
-(void)NavigateToFollowersScreen:(UIButton *)sender{
NSString *user_id =[[self.totalfollowersList valueForKey:@"user_id"]objectAtIndex:sender.tag];
     [m_data setValue:user_id forKey:@"followingid"];
    NSString*follow_URL=[NSString stringWithFormat:@"%@/%@",getfollowUnfollow_URL,user_id];
            if([sender.titleLabel.text isEqualToString:@"Follow"]){
             [sender setTitle:@"Following" forState:UIControlStateNormal];
              [sender setBackgroundColor:[UIColor whiteColor]];
              [sender setTitleColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            else if ([sender.titleLabel.text isEqualToString:@"Following"]){
                [sender setTitle:@"Follow" forState:UIControlStateNormal];
                [sender setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0]];
                [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        [webData webserviceshitLikeorUnlike:follow_URL parameters:m_data withheaderSection:app.array_rawData];
   }

#pragma mark : Storyboard segue methods

- (IBAction)settingProfile:(id)sender {
  SettingsView*settings= INSTANTIATE(SETTING_VIEW_SCREEN);
  [self.navigationController pushViewController:settings animated:YES];
}
//MARK: Button Action 
- (IBAction)m_posts:(id)sender {
     pageNo = 1;
    [self.followers_table setHidden:YES];
    [self.m_CollectionView setHidden:YES];
    [self.totalPostingList removeAllObjects];
    m_label.hidden =YES;
    followers_handle = @"";
    [profileIndicatorView setHidden:NO];
    [profileIndicatorView startAnimating];
    profileIndicatorView.center =self.followers_table.center;
    [self.view addSubview:profileIndicatorView];
    [self.m_posts setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_followers setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_following setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self sendhttpdatatobackendtogetpostListing];
}
- (IBAction)m_buttonFollowers:(id)sender {
    [m_label setHidden:YES];
    followers_handle = @"1" ;
    [self.m_CollectionView setHidden:YES];
    [self.followers_table setHidden:YES];
    followersPageNo = 1;
    [self.totalfollowersList removeAllObjects];
    [self.m_followers setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_posts setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_following setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [profileIndicatorView setHidden:NO];
    [profileIndicatorView startAnimating];
    profileIndicatorView.center =self.followers_table.center;
    [self.view addSubview:profileIndicatorView];
    [self sendhttpdatatobackendtogetfollowersList];
    }

- (IBAction)m_following:(id)sender {
    [m_label setHidden:YES];
     followers_handle = @"2";
    followingPageNo = 1;
    [self.followers_table setHidden:YES];
    [self.m_CollectionView setHidden:YES];
    [self.totalfollowingList removeAllObjects];
    [self.m_following setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_followers setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_posts setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [profileIndicatorView setHidden:NO];
    [profileIndicatorView startAnimating];
    profileIndicatorView.center =self.followers_table.center;
    [self.view addSubview:profileIndicatorView];
    [self sendhttpdatatobackendtogetfollowingList];
}
//MARK: Custom Methods
-(void)registerNib{
    UINib *nib_file=[UINib nibWithNibName:@"SearchViewCell" bundle:nil];
    [self.m_CollectionView registerNib:nib_file forCellWithReuseIdentifier:@"reusingData"];
    self.m_CollectionView.dataSource=self;
    self.m_CollectionView.delegate=self;
}
-(void)setUpViews{
    cell.m_first_view.hidden = YES;
    cell.m_second_veiw.hidden = YES; 
    self.m_editProfile.layer.borderWidth=1.0f;
    self.m_editProfile.layer.borderColor =[UIColor colorWithRed:206.0/255.0 green:212.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
    self.m_editProfile.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    NSString *attr_PostsString = [NSString stringWithFormat:@"%@\nPOSTS",app.totalPosts];
    [self.m_posts setTitle:attr_PostsString forState:UIControlStateNormal];
    [self.m_posts setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    NSString *attr_followersString =[NSString stringWithFormat:@"%@\nFOLLOWERS",app.totalFollowers];
    [self.m_followers setTitle:attr_followersString forState:UIControlStateNormal];
    [self.m_followers setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    NSString *attr_followingString =[NSString stringWithFormat:@"%@\nFOLLOWING",app.totalFollowing];
    [self.m_following setTitle:attr_followingString forState:UIControlStateNormal];
   [self.m_following setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[self.m_followers titleLabel] setNumberOfLines:0];
    [[self.m_followers titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [self.m_followers.titleLabel setTextAlignment:UITextAlignmentCenter];
    [[self.m_posts titleLabel] setNumberOfLines:0];
    [[self.m_posts titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [self.m_posts.titleLabel setTextAlignment:UITextAlignmentCenter];
    [[self.m_following titleLabel] setNumberOfLines:0];
    [[self.m_following titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [self.m_following.titleLabel setTextAlignment:UITextAlignmentCenter];
    [CommonMethods setImageCorner:self.m_image_profile];
    [m_instanceMethods addCornerRadiusToButton:self.m_editProfile];
}

-(void)setusersProfile{
    if([app.userprofile_data count]>0){
 NSString *url_image =[[app.userprofile_data objectForKey:@"data"]valueForKey:@"picture"];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url_image]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                app.img_profile = [UIImage imageWithData:data];
                if (app.img_profile) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       self.m_image_profile.image = app.img_profile;
                });
                }
            }
        }];
        [task resume];
     }
}

// Registering followers cell
- (void)registertableViewNib{
    UINib*nib=[UINib nibWithNibName:@"FollowersProfileCell" bundle:nil];
    [self.followers_table registerNib:nib forCellReuseIdentifier:@"followersData"];
    self.followers_table.dataSource=self;
    self.followers_table.delegate=self;
}

#pragma mark: Data communication Method

-(void)sendhttpdatatobackendtogetpostListing{
    m_userID =[self.m_user_dataItems valueForKey:@"id"];
    NSString *post_URL =[NSString stringWithFormat:@"%@/%@/%d",getAllQuestionsList_URL,m_userID,pageNo];
    [webData gettingFeedResult:post_URL parameters:app.array_rawData];
}
-(void)sendhttpdatatobackendtogetfollowersList{
     m_tokenKey =[self.m_user_dataItems valueForKey:@"token"];
     m_userID =[self.m_user_dataItems valueForKey:@"id"];
    NSString*followers_URL =[NSString stringWithFormat:@"%@/%@/%d",getAllFollowersList_URL,m_userID,followersPageNo];
    [webData gettingFeedResult:followers_URL parameters:app.array_rawData];
}
-(void)sendhttpdatatobackendtogetfollowingList{
    m_tokenKey =[self.m_user_dataItems valueForKey:@"token"];
    m_userID =[self.m_user_dataItems valueForKey:@"id"];
    NSString *following_URL = [NSString stringWithFormat:@"%@/%@/%d",getAllFollowingList_URL,m_userID,followingPageNo];
    [webData gettingFeedResult:following_URL parameters:app.array_rawData];
}

#pragma mark: handling delegate of response

-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSString*statusCode =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"get_users_allquestion"]){
        if([statusCode intValue]==200){
            NSArray *data = [responseData valueForKey:@"data"];
             if (data.count>0) {
                if([[responseData valueForKey:@"next"]isEqualToString:@"0"]||[[responseData valueForKey:@"next"]isEqualToString:@""]){
                    pageIncrement = NO;
                }else{
                    pageIncrement = YES;
                }
                self.totalPages  =  [[responseData objectForKey:@"totalpage"] integerValue];
                NSLog(@"%d",self.totalPages);
                NSArray *array_data = [responseData objectForKey:@"data"];
                if(RefreshAllPost ==YES){
                 [self.totalPostingList removeAllObjects];
                for(int i= 0; i<array_data.count;i++){
                [self.totalPostingList addObject:[array_data objectAtIndex:i]];
                }
                }
            else{
                for(int i =0;i<[array_data count];i++){
                    if(![self.totalPostingList containsObject:[array_data objectAtIndex:i]]){
                          [self.totalPostingList addObject:[array_data objectAtIndex:i]];
                    }
                }
                }
               dispatch_async(dispatch_get_main_queue(),^{
                [self.m_CollectionView setHidden:NO];
                [self.m_CollectionView reloadData];
            });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                NSString *  attr_PostString = [NSString stringWithFormat:@"%@\nPOSTS",app.totalPosts];
                [self.m_posts setTitle:attr_PostString forState:UIControlStateNormal];
                if([followers_handle isEqualToString:@""]){
                   [m_label  setHidden:NO];
                   m_label.text=[NSString stringWithFormat:@"No Posting.."];
                  [self.m_CollectionView setHidden:YES];
                }
            });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 kAlertView(@"", @"Error in connection");
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.followers_table setHidden:YES];
         });
        if([notification_handling isEqualToString:@"post"]){
            NSString *  attr_PostString = [NSString stringWithFormat:@"%lu\nPOSTS",self.totalPostingList.count];
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.m_posts setTitle:attr_PostString forState:UIControlStateNormal];
            });
        }
    }
    else if ([methodName isEqualToString:@"get_users_followers"]){
        if([statusCode intValue]==200){
            NSArray*data = [responseData valueForKey:@"data"];
             if (data.count>0) {
                if([[responseData valueForKey:@"next"]isEqualToString:@""]||[[responseData valueForKey:@"next"]isEqualToString:@"0"]){
                     followersPageIncrement= NO;
                }else{
                    followersPageIncrement = YES;
                }
               self.totalFollowersPages =  [[responseData objectForKey:@"totalpage"] integerValue];
                [self.followers_table setHidden:NO];
                NSArray *array_data = [responseData objectForKey:@"data"];
                if (RefreshAllFollowers==YES){
                [self.totalfollowersList removeAllObjects];
                for(int i= 0; i<array_data.count;i++){
                [self.totalfollowersList addObject:[array_data objectAtIndex:i]];
                }
                }
                else{
                [self.totalfollowersList removeAllObjects];
                for(int i= 0; i<array_data.count;i++){
               [self.totalfollowersList addObject:[array_data objectAtIndex:i]];
                }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.followers_table setHidden:NO];
                    [self.followers_table reloadData];
              });
            }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
             [self.m_followers setTitle:[NSString stringWithFormat:@"0\nFOLLOWERS"] forState:UIControlStateNormal];
                if ([followers_handle isEqualToString:@"1"]) {
                    m_label.text =[NSString stringWithFormat:@"You have no followers to show.."];
                    [m_label  setHidden:NO];
                    [self.followers_table setHidden:YES];
                }
        });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                kAlertView(@"", @"Error in connection");
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.m_CollectionView setHidden:YES];
        });
       
        if([notification_handling isEqualToString:@"followers"]){
            if(self.totalfollowersList.count>0){
                NSString *attr_followerString =[NSString stringWithFormat:@"%lu\nFOLLOWERS",self.totalfollowersList.count];
                [self.m_followers setTitle:attr_followerString forState:UIControlStateNormal];
            }else{
                [self.m_followers setTitle:[NSString stringWithFormat:@"%0\nFOLLOWERS"] forState:UIControlStateNormal];
            }
            [self sendhttpdatatobackendtogetfollowingList];
        }
    }
 else if ([methodName isEqualToString:@"get_users_following"]){
        if([statusCode intValue]==200){
              NSArray*data = [responseData valueForKey:@"data"];
             if (data.count>0){
                if([[responseData valueForKey:@"next"]isEqualToString:@"0"]||[[responseData valueForKey:@"next"]isEqualToString:@""]){
                     followingPageIncrement= NO;
                   }
                 else{
                    followingPageIncrement = YES;
                     }
                self.totalFollowingPages =  [[responseData objectForKey:@"totalpage"] integerValue];
                  [self.followers_table setHidden:NO];
                NSArray *array_data = [responseData objectForKey:@"data"];
                if (RefreshAllFollowing==YES){
                    [self.totalfollowingList removeAllObjects];
                    for(int i= 0; i<array_data.count;i++){
                    [self.totalfollowingList addObject:[array_data objectAtIndex:i]];
                    }
                }
                else{
                     [self.totalfollowingList removeAllObjects];
                      for(int i= 0; i<array_data.count;i++){
                    [self.totalfollowingList addObject:[array_data objectAtIndex:i]];
                    }
                }
               dispatch_async(dispatch_get_main_queue(), ^{
                if(self.totalfollowingList.count>0){
                    [self.followers_table reloadData];
                    [self.followers_table setHidden:NO];
                    NSString *attr_followingsString =[NSString stringWithFormat:@"%lu\nFOLLOWING",self.totalfollowingList.count];
                   [self.m_following setTitle:attr_followingsString forState:UIControlStateNormal];
                }else{
                [self.m_following setTitle:[NSString stringWithFormat:@"0\nFOLLOWING"] forState:UIControlStateNormal];
                }
            });
            }
    else{
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.m_following setTitle:[NSString stringWithFormat:@"0\nFOLLOWING"] forState:UIControlStateNormal];
        if([followers_handle isEqualToString:@"2"]){
        m_label.hidden =NO;
        m_label.text =[NSString stringWithFormat:@"You are not following anyone."];
        [self.followers_table setHidden:YES];
        }
     });
    }
        }
else{
            dispatch_async(dispatch_get_main_queue(), ^{
                kAlertView(@"", @"Error in connection");
            });
}
     dispatch_async(dispatch_get_main_queue(), ^{
         [self.m_CollectionView setHidden:YES];
     });
 }
    dispatch_async(dispatch_get_main_queue(), ^{
        [profileIndicatorView stopAnimating];
        [profileIndicatorView setHidesWhenStopped:YES];
        [profileIndicatorView removeFromSuperview];
    });
}

//handling delegate of Post method
-(void)getLikeResult:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*statusCode =[responseDictionary valueForKey:@"status"];
    NSString *methodName =[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"follow_unfollow_people"]){
        if([statusCode intValue]==200){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"ProfileUpdated" object:nil];
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingFollowersList" object:nil];
            });
        } else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [CommonMethods alertView:self title:@"Error!" message:error.localizedDescription];
            });
        }
    }
    else{
        NSLog(@"Method name not matching..");
    }
}

#pragma mark - Scrollview Delegates ..............................................

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height);
     if (endScrolling > (float)scrollView.contentSize.height || endScrolling == (float)scrollView.contentSize.height){
        if([followers_handle isEqualToString:@"1"]){
        if (followersPageNo<self.totalFollowersPages  && followersPageIncrement== YES){
            followersPageNo++;
            [self performSelector:@selector(sendhttpdatatobackendtogetfollowersList) withObject:nil afterDelay:0.5];
                    followersPageIncrement=NO;
                    RefreshAllFollowers = NO;
                }
            }
            else if ([followers_handle isEqualToString:@"2"]){
                if (followingPageNo<self.totalFollowingPages  && followingPageIncrement== YES){
                        followingPageNo++;
                    [self performSelector:@selector(sendhttpdatatobackendtogetfollowingList) withObject:nil afterDelay:0.5];
                    followingPageIncrement=NO;
                    RefreshAllFollowing =NO;
                }
            }
        else{
            if (pageNo<self.totalPages&&pageIncrement== YES){
             pageNo++;
            [self performSelector:@selector(sendhttpdatatobackendtogetpostListing) withObject:nil afterDelay:0.5];
            pageIncrement=NO;
            RefreshAllPost = NO;
        }
        }
     }
    
}

// MARK: Edit Profile Action
- (IBAction)editProfileAction:(id)sender {
    EditProfile*edit=INSTANTIATE(EDIT_PROFILE_SCREEN);
    edit.m_image = app.img_profile;
    edit.m_userinfo=self.m_profile_info.text;
    [self.navigationController pushViewController:edit animated:YES];
}

//MARK : Refresh All data htorugh Refresh controller
-(void)refreshAllPostingList{
    self.followers_table.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
    [refreshControl endRefreshing];
    if([followers_handle isEqualToString:@"1"]){
        followersPageNo =1;
     RefreshAllFollowers=YES;
    [self performSelector:@selector(sendhttpdatatobackendtogetfollowersList) withObject:nil afterDelay:0.01];
    }
    else if([followers_handle isEqualToString:@"2"]){
        followingPageNo =1;
    RefreshAllFollowing=YES;
    [self performSelector:@selector(sendhttpdatatobackendtogetfollowingList) withObject:nil afterDelay:0.01];
    }
    else{
    pageNo =1;
    RefreshAllPost =YES;
   [self performSelector:@selector(sendhttpdatatobackendtogetpostListing) withObject:nil afterDelay:0.01];
    }
}




#pragma mark: Memory usage warning
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
