//
//  SearchUsersProfile.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 11/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//
#define ROW_HEIGHT 60.0
#import "SearchUsersProfile.h"
@interface SearchUsersProfile (){
    WebServices *webData;
    AppDelegate*appDelegate;
    NSString *isPrivate;
    NSString *profile_URL;
    NSArray *m_dataitems;
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *profileIndicatorView;
    FollowersProfileCell *shell;
    SearchViewCell*cell;
    NSInteger totalPages, totalFollowersPage, totalFollowingPage;
    int pageNo,followersNo, followingNo;
    NSString *remainTime,*img1_url, *img2_url;
    NSString *first_txt_color;
    UIColor *first_txtColor;
    NSString*sec_txt_color;
    UIColor *sec_txtColor;
    NSString *first_view_color;
    UIColor *first_viewColor;
    NSString *sec_view_color;
    UIColor *sec_viewColor;
    BOOL pageIncrement,isFollowersIncrement,RefreshAllPost,RefreshAllFollowers,RefreshAllFollowing,isFollowingIncrement;
    NSMutableDictionary *m_dict;
    UILabel *k_label;
    NSString *follow_handle;
}
@end
@implementation SearchUsersProfile

#pragma mark: ViewController life Cycle Methods

-(void)viewDidLoad{
    [super viewDidLoad];
    m_dataitems=[[NSArray alloc]init];
    m_InstanceMethods =[CommonMethods sharedInstance];
    webData =[[WebServices alloc]init];
    webData.gettingFeeddelegate=self;
    webData.getLikedelegate = self;
    appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    CGRect frame =[[UIScreen mainScreen]bounds];
    k_label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, 200.0f, 21.0f)] ;
    k_label.center =self.view.center;
    UIFont * customFont = [UIFont fontWithName:@"ProximaNova-SemiBold" size:10];
    k_label.font = customFont;
    k_label.adjustsFontSizeToFitWidth = YES;
    k_label.adjustsLetterSpacingToFitWidth = YES;
    k_label.minimumScaleFactor = 10.0f/12.0f;
    k_label.clipsToBounds = YES;
    k_label.backgroundColor = [UIColor clearColor];
    k_label.textColor = [UIColor blackColor];
    k_label.textAlignment =NSTextAlignmentCenter;
    k_label.numberOfLines = 0;
    [self.view addSubview:k_label];
    self.totalFollowers=[[NSMutableArray alloc]init];
    self.totalFollowing =[[NSMutableArray alloc]init];
    self.totalPosting = [[NSMutableArray alloc]init];
    pageNo =1;
    followersNo = 1;
    followingNo =1;
    follow_handle = @"";
    isFollowingIncrement =NO;
    isFollowersIncrement=NO;
    [self registercollectionView];
    [self registerTableView];
    m_dict =[[NSMutableDictionary alloc]init];
     profileIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     [profileIndicatorView setHidesWhenStopped:YES];
    [self hittingWebServicestogetProfile];
    [self performSelector:@selector(sendhttpdatatobackendtogetpostListing) withObject:nil afterDelay:0.01];
    [self.m_lockView setHidden:YES];
    [self.m_collectionView setHidden:YES];
    [self.m_tableView setHidden:YES];
    [profileIndicatorView setHidden:NO];
    [profileIndicatorView startAnimating];
    [profileIndicatorView setCenter:self.view.center];
    [self.view addSubview:profileIndicatorView];
    [self.m_Posts setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_followers setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_following setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[self.m_followers titleLabel] setNumberOfLines:0];
    [[self.m_followers titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [self.m_followers.titleLabel setTextAlignment:UITextAlignmentCenter];
    [[self.m_Posts titleLabel] setNumberOfLines:0];
    [[self.m_Posts titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [self.m_Posts.titleLabel setTextAlignment:UITextAlignmentCenter];
    [[self.m_following titleLabel] setNumberOfLines:0];
    [[self.m_following titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [self.m_following.titleLabel setTextAlignment:UITextAlignmentCenter];

    }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [profileIndicatorView setHidden:YES];
    [profileIndicatorView removeFromSuperview];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

# pragma mark : Add custom Methods
-(void)setUpViews{
if([self.buttonTitle isEqualToString:@"1"]){
[self.m_followbutton  setTitle:[NSString stringWithFormat:@"Following"] forState:UIControlStateNormal];
[self.m_followbutton setBackgroundColor:[UIColor whiteColor]];
[self.m_followbutton setTitleColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0] forState:UIControlStateNormal];
}
else{
[self.m_followbutton  setTitle:[NSString stringWithFormat:@"Follow"] forState:UIControlStateNormal];
[self.m_followbutton setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0]];
[self.m_followbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
[self.m_followbutton.layer setBorderWidth:1.0f];
[self.m_followbutton.layer setBorderColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0].CGColor];
[m_InstanceMethods addCornerRadiusToButton:self.m_followbutton];
[m_InstanceMethods addCornerRadiusToButton:self.m_detailButton];
[CommonMethods setImageCorner:self.m_roundProfilePic];
}

// detail button Action
- (IBAction)m_detailButton:(id)sender {
    [self showActionSheet];
}

// Action sheet
-(void)showActionSheet{
  NSString *other1 = @"Report";
    NSString *other2 = @"Copy profile URL";
    NSString *other3 = @"Send Message";
    NSString *cancelTitle = @"Cancel"; //cancel button
    NSString *destructiveButton = @"Block"; //destructivebutton
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveButton
                                  otherButtonTitles:other1, other2, other3, nil];
    [self changeTextColorForUIActionSheet:actionSheet];
    [actionSheet setTag:2];
                [actionSheet showInView:self.view];
}

- (void) changeTextColorForUIActionSheet:(UIActionSheet*)actionSheet {
    UIColor *tintColor = [UIColor greenColor];
    NSArray *actionSheetButtons = actionSheet.subviews;
    for (int i = 0; [actionSheetButtons count] > i; i++) {
        UIView *view = (UIView*)[actionSheetButtons objectAtIndex:i];
        if([view isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton*)view;
            [btn setTitleColor:tintColor forState:UIControlStateNormal];
            
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Copy profile URL"]){
        NSLog(@"profile URL is copied");
    }
    else if ([buttonTitle isEqualToString:@"Send Message"]){
         [self sendTextMessage];
    }
    else if ([buttonTitle isEqualToString:@"Report"]){
               NSLog(@"Reported profile successfully");
    }
}


//MARK: send text Message
-(void)sendTextMessage{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]){
        controller.body = @"Hello  this is testing";
        controller.recipients = [NSArray arrayWithObjects:@"7026144009", nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

// UIMessage delegate Method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
        {
            kAlertView(@"Error", @"Message sending failed");
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark : tableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([follow_handle isEqualToString:@"1"]||[follow_handle isEqualToString:@"2"]){
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([follow_handle isEqualToString:@"1"]){
        if(self.totalFollowers.count>0){
            return self.totalFollowers.count;
        }
    }
    else if([follow_handle isEqualToString:@"2"] ){
         if (self.totalFollowing.count>0){
            return  self.totalFollowing.count;
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
    shell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorColor=[UIColor clearColor];
    UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, shell.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    shell.m_buttonFolllow.tag=indexPath.row;
    [shell.contentView addSubview:separatorView];
      [CommonMethods setImageCorner: shell.m_imageFollowers];
       [shell.m_buttonFolllow.layer setBorderColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0].CGColor];
    if([follow_handle isEqualToString:@"1"]){
        profile_URL =[[self.totalFollowers valueForKey:@"picture"]objectAtIndex:indexPath.row];
        if([[[self.totalFollowers objectAtIndex:indexPath.row]valueForKey:@"my_follow_stauts"]isEqualToString:@"3"]){
            [shell.m_buttonFolllow setHidden:YES];
        }
        else{
            [shell.m_buttonFolllow setHidden: NO];
        }
        if ([[[self.totalFollowers objectAtIndex:indexPath.row]valueForKey:@"my_follow_stauts"]isEqualToString:@"1"]) {
            [shell.m_buttonFolllow setTitle:@"Following" forState:UIControlStateNormal];
            [shell.m_buttonFolllow setBackgroundColor:[UIColor whiteColor]];
            [shell.m_buttonFolllow setTitleColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else{
            [shell.m_buttonFolllow setTitle:@"Follow" forState:UIControlStateNormal];
            [shell.m_buttonFolllow setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0]];
            [shell.m_buttonFolllow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
           [shell.m_buttonFolllow addTarget:self action:@selector(GetFollowersScreen:) forControlEvents: UIControlEventTouchUpInside];
           [shell.m_profileName setText:[NSString stringWithFormat:@"%@",[[self.totalFollowers objectAtIndex:indexPath.row]valueForKey:@"name"]]];
            shell.m_profileName.textColor =[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0];
    }
    else if([follow_handle isEqualToString:@"2"]){
        [shell.m_buttonFolllow setHidden:YES];
        [shell.m_buttonFolllow setTitle:@"Following" forState:UIControlStateNormal];
        profile_URL =[[self.totalFollowing valueForKey:@"picture"]objectAtIndex:indexPath.row];
        shell.m_profileName.text =[NSString stringWithFormat:@"%@",[[self.totalFollowing objectAtIndex:indexPath.row]valueForKey:@"name"]];
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
    [shell.m_buttonFolllow.layer setCornerRadius: 5.0f];
    [shell.m_buttonFolllow.layer setBorderWidth: 1.0f];
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    return shell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      NSString *userId =@"";
    if([follow_handle isEqualToString:@"1"]){
    userId = [[self.totalFollowers valueForKey:@"user_id"]objectAtIndex:indexPath.row];
    }
    else if ([follow_handle isEqualToString:@"2"]){
    userId = [[self.totalFollowing valueForKey:@"user_id"]objectAtIndex:indexPath.row];
    }
    NSString*myId = [appDelegate.signup_resultant valueForKey:@"id"];
    if([userId isEqualToString:myId]){
        UserProfile *user =INSTANTIATE(USER_PROFILE_SCREEN);
        user.navigationMenu=@"show";
       [self.navigationController pushViewController:user animated:YES];
     }
    else{
    SearchUsersProfile* myVC = [sb instantiateViewControllerWithIdentifier:@"SearchUsersProfile"];
    if([follow_handle isEqualToString:@"1"]){
     myVC.self.profile_id= [[self.totalFollowers valueForKey:@"user_id"]objectAtIndex:indexPath.row];
    if([[[self.totalFollowers objectAtIndex:indexPath.row]valueForKey:@"my_follow_stauts"]isEqualToString:@"1"]){
    myVC.buttonTitle = @"Following";
    }
    else{
    myVC.buttonTitle = @"Follow";
    }
    }
    else if ([follow_handle isEqualToString:@"2"]){
    myVC.self.profile_id = [[self.totalFollowing valueForKey:@"user_id"]objectAtIndex:indexPath.row];
    myVC.buttonTitle = @"Following";
    }
    [self.navigationController pushViewController:myVC animated:YES];
    }
}

// MARK: follow button Action

-(void)GetFollowersScreen:(UIButton *)sender{
    NSString *user_id =[[self.totalFollowers valueForKey:@"user_id"]objectAtIndex:sender.tag];
      [m_dict removeAllObjects];
     [m_dict setValue:user_id forKey:@"followingid"];
    NSString*myfollow_status =@"";
    NSString*following_URL=[NSString stringWithFormat:@"%@/%@",getfollowUnfollow_URL,user_id];
        if([sender.titleLabel.text isEqualToString:@"Follow"]){
             [sender setTitle:@"Following" forState:UIControlStateNormal];
              [sender setBackgroundColor:[UIColor whiteColor]];
              [sender setTitleColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                 myfollow_status = @"1";
        }
        else if ([sender.titleLabel.text isEqualToString:@"Following"]){
            [sender setTitle:@"Follow" forState:UIControlStateNormal];
            [sender setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            myfollow_status = @"0";
        }
        [webData webserviceshitLikeorUnlike:following_URL parameters:m_dict withheaderSection:appDelegate.array_rawData];
    }

#pragma mark : Collection view Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.totalPosting.count==0){
        return  0;
    }
    else{
        return self.totalPosting.count;
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
    cell.backgroundColor =[UIColor clearColor];
    cell.layer.borderColor =[UIColor colorWithRed:52/255.0 green:105/255.0 blue:218/255.0 alpha:1.0].CGColor;
if([[[self.totalPosting valueForKey:@"isivoted"]objectAtIndex:indexPath.row]isEqualToString:@"0"]){
        [cell.m_first_view_lbl setHidden:YES];
        [cell.m_sec_view_lbl setHidden:YES];
    }
    else{
        [cell.m_first_view_lbl setHidden:NO];
        [cell.m_sec_view_lbl setHidden:NO];
        if([[[self.totalPosting valueForKey:@"votepercentage_a"]objectAtIndex:indexPath.row]isEqualToString:@"0%"]&&[[[self.totalPosting valueForKey:@"votepercentage_b"]objectAtIndex:indexPath.row]isEqualToString:@"0%"]){
            [cell.m_first_view_lbl setHidden:YES];
            [cell.m_sec_view_lbl setHidden:YES];
        }
        else{
            [cell.m_first_view_lbl setHidden:NO];
            [cell.m_sec_view_lbl setHidden:NO];
            [cell.m_first_view_lbl setTitle:[NSString stringWithFormat:@" %@",[[self.totalPosting valueForKey:@"votepercentage_a"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            [cell.m_sec_view_lbl setTitle:[NSString stringWithFormat:@" %@",[[self.totalPosting valueForKey:@"votepercentage_b"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            
        }
    }
    NSInteger timeLeft =[[[self.totalPosting valueForKey:@"remainedtime"]objectAtIndex:indexPath.row]intValue];
    if(timeLeft==0){
        [cell.m_timelabel  setHidden:YES];
         remainTime = @"TimeOut";
    }
    else{
        [cell.m_timelabel setHidden:YES];
         remainTime = @"";
        [cell.m_timelabel setText:[NSString stringWithFormat:@"%@",[m_InstanceMethods timeLeftString:timeLeft]]];
    }
    
    NSDate * dateTimeStamping =[NSDate dateWithTimeIntervalSince1970:[[[self.totalPosting valueForKey:@"posted_on"]objectAtIndex:indexPath.row]doubleValue]];
        NSString *postedDate = [NSString stringWithFormat:@"%@ ago",[m_InstanceMethods timeLeftSinceDate:dateTimeStamping]];
    cell.m_profileDate.text =[NSString stringWithFormat:@"%@",postedDate];
    cell.m_first_txtlbl.numberOfLines =2;
    cell.m_sec_txtlbl.numberOfLines =2;
    if([[[self.totalPosting objectAtIndex:indexPath.row]valueForKey:@"question_type"]isEqualToString:@"1"]){
        img1_url =[[self.totalPosting valueForKey:@"option_a"]objectAtIndex:indexPath.row];
        img2_url = [[self.totalPosting valueForKey:@"option_b"]objectAtIndex:indexPath.row];
        [cell.m_first_txtlbl setTextColor:[UIColor whiteColor]];
         [cell.m_sec_txtlbl setTextColor:[UIColor whiteColor]];
       [cell.m_first_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.totalPosting valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]]];
      [cell.m_sec_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.totalPosting valueForKey:@"overtext_b"]objectAtIndex:indexPath.row]]];
        [cell.m_first_view setHidden:YES];
        [cell.m_second_veiw setHidden:YES];
        [cell.m_searchCell_img1 setHidden:NO];
        [cell.m_searchCell_img2 setHidden:NO];
      [cell.m_searchCell_img1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:img1_url]] placeholderImage:[UIImage imageNamed:@"placeholder_A"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            cell.m_searchCell_img1.image =image;
            cell.m_searchCell_img1.contentMode = UIViewContentModeScaleAspectFill;
            cell.m_searchCell_img1.clipsToBounds = YES;
        } failure:nil];
        [cell.m_searchCell_img2 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:img2_url]] placeholderImage:[UIImage imageNamed:@"placeholder_B"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            cell.m_searchCell_img2.image =image;
            cell.m_searchCell_img2.contentMode = UIViewContentModeScaleAspectFill;
            cell.m_searchCell_img2.clipsToBounds = YES;
        } failure:nil];
        
    }
    else{
        [cell.m_first_view setHidden:NO];
        [cell.m_second_veiw setHidden:NO];
        [cell.m_searchCell_img1 setHidden:YES];
        [cell.m_searchCell_img2 setHidden:YES];
        [cell.contentView bringSubviewToFront:cell.m_profileDate];
        [cell.contentView bringSubviewToFront: cell.m_first_view_lbl];
        [cell.contentView bringSubviewToFront: cell.m_sec_view_lbl];
        [cell.m_first_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.totalPosting objectAtIndex:indexPath.row]valueForKey:@"option_a"]]];
        [cell.m_sec_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.totalPosting objectAtIndex:indexPath.row]valueForKey:@"option_b"]]];
        first_txt_color = [NSString stringWithFormat:@"%@",[[self.totalPosting valueForKey:@"textcolor_a"]objectAtIndex:indexPath.row]];
        first_txtColor = [m_InstanceMethods getUIColorObjectFromHexString:first_txt_color alpha:0.9];
        cell.m_first_txtlbl.textColor = first_txtColor;
        
        sec_txt_color = [NSString stringWithFormat:@"%@",[[self.totalPosting valueForKey:@"textcolor_b"]objectAtIndex:indexPath.row]];
        sec_txtColor = [m_InstanceMethods getUIColorObjectFromHexString:first_txt_color alpha:0.9];
        cell.m_sec_txtlbl.textColor = sec_txtColor;
        first_view_color = [NSString stringWithFormat:@"%@",[[self.totalPosting valueForKey:@"background_a"]objectAtIndex:indexPath.row]];
        first_viewColor=[m_InstanceMethods getUIColorObjectFromHexString:first_view_color alpha:0.9];
        cell.m_first_view.backgroundColor = first_viewColor;
        sec_view_color = [NSString stringWithFormat:@"%@",[[self.totalPosting valueForKey:@"background_b"]objectAtIndex:indexPath.row]];
        sec_viewColor=[m_InstanceMethods getUIColorObjectFromHexString:sec_view_color alpha:0.9];
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
    NSString*questionid_detail =[[self.totalPosting valueForKey:@"question_id"]objectAtIndex:indexPath.row];
    DetailPost *rate = INSTANTIATE(DETAIL_POST_VIEW)
    rate.getQuestionId = questionid_detail;
    [self.navigationController pushViewController:rate animated:YES];
}

#pragma mark: hitting webservices
-(void)hittingWebServicestogetProfile{
    NSString *url = [NSString stringWithFormat:@""];
        url =[NSString stringWithFormat:@"%@/%@",userprofile_URL,self.profile_id];
      [webData gettingFeedResult:url parameters:appDelegate.array_rawData];
}

// handle delegate response
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSString *resultStatus = [responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"profile"]){
        if([resultStatus intValue]==200){
            if([responseData count]>0){
            m_dataitems = responseData;
             profile_URL =[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"picture"]];
                if(profile_URL!=nil){
                    [self.m_profileImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:profile_URL]]
                                               placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                            self.m_profileImage.image = image;
                                                           
                                                        } failure:nil];
                }
                dispatch_queue_t backgroundQueue = dispatch_queue_create("com.gettingresults", 0);
                  dispatch_async(backgroundQueue, ^{
                self.buttonTitle =[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"my_follow_stauts"]];
                    NSString *followers =[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"totalfollowers"]];
                    NSString *following =[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"totalfollowing"]];
                    NSString *posts =[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"totalposts"]];
                NSString * attr_PostsString = [NSString stringWithFormat:@"%@\nPOSTS",posts];
                NSString * attr_followersString =[NSString stringWithFormat:@"%@\nFOLLOWERS",followers];
                NSString * attr_followingString =[NSString stringWithFormat:@"%@\nFOLLOWING",following];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setUpViews];
                        [self.m_Posts setTitle:attr_PostsString forState:UIControlStateNormal];
                        [self.m_followers setTitle:attr_followersString forState:UIControlStateNormal];
                        [self.m_following setTitle:attr_followingString forState:UIControlStateNormal];
                        self.m_headername.text = [NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"name"]];
                        self.m_profilename.text =[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"name"]];
                        if([[[m_dataitems valueForKey:@"data"]valueForKey:@"is_private"]isEqualToString:@"1"]){
                            self.m_lockView.hidden = YES;
                        }
                        else{
                            self.m_lockView.hidden = YES;
                        }
                    });    
                });
                
            }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                kAlertView(@"", @"No data found");
            });
        }
        }
        
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [CommonMethods alertView:self  title:@"" message:[responseData objectForKey:@"message"]];
        });
    }
    }
    else if ([methodName isEqualToString:@"get_users_allquestion"]){
        if([resultStatus intValue]==200){
             if ([[responseData valueForKey:@"data"] count]>0) {
                [self.m_collectionView setHidden:NO];
                if([[responseData valueForKey:@"next"]isEqualToString:@""]||[[responseData valueForKey:@"next"]isEqualToString:@""]){
                    pageIncrement = NO;
                }else{
                    pageIncrement = YES;
                }
                totalPages  =  [[responseData objectForKey:@"totalpage"] integerValue];
                NSLog(@"%d",totalPages);
                NSArray *array_data = [responseData objectForKey:@"data"];
                for(int i= 0; i<array_data.count;i++){
                    if(![self.totalPosting containsObject:[array_data objectAtIndex:i]]){
                        [self.totalPosting addObject:[array_data objectAtIndex:i]];
                    }
                }
                   dispatch_async(dispatch_get_main_queue(),^{
                    NSString * attr_PostString = [NSString stringWithFormat:@"%@\nPOSTS",[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"totalposts"]]];
                    [self.m_Posts setTitle:attr_PostString forState:UIControlStateNormal];
                    [self.m_collectionView reloadData];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_Posts setTitle:[NSString stringWithFormat:@"0\nPOSTS"] forState:UIControlStateNormal];
                 if([follow_handle isEqualToString:@""]){
                    [k_label setHidden:NO];
                    k_label.text=@"No Posting..";
                 }
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                kAlertView(@"", @"Error in connection");
            });
        }
    }
    else if ([methodName isEqualToString:@"get_users_followers"]){
        if([resultStatus intValue]==200){
             if ([[responseData  valueForKey:@"data"]count]>0) {
                [self.m_tableView setHidden:NO];
                totalFollowersPage  =  [[responseData objectForKey:@"totalpage"] integerValue];
                NSLog(@"%d",totalFollowersPage);
                if([[responseData valueForKey:@"next"]isEqualToString:@""]||[[responseData valueForKey:@"next"]isEqualToString:@""]){
                    isFollowersIncrement = NO;
                }else{
                    isFollowersIncrement = YES;
                }
                NSArray *array_data = [responseData objectForKey:@"data"];
                [self.totalFollowers removeAllObjects];
                for(int i= 0; i<array_data.count;i++){
                [self.totalFollowers addObject:[array_data objectAtIndex:i]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.totalFollowers.count>0){
                        NSString * attr_followerString =[NSString stringWithFormat:@"%@\nFOLLOWERS",[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"totalfollowers"]]];
                      [self.m_followers setTitle:attr_followerString forState:UIControlStateNormal];
                    }else{
                        [self.m_followers setTitle:[NSString stringWithFormat:@"%0\nFOLLOWERS"] forState:UIControlStateNormal];
                    }
                    [self.m_tableView reloadData];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                 [self.m_followers setTitle:[NSString stringWithFormat:@"0\nFOLLOWERS"] forState:UIControlStateNormal];
                    if([follow_handle isEqualToString:@"1"]){
                    k_label.text=@"You have no followers..";
                    [k_label setHidden:NO];
                    [self.m_tableView setHidden:YES];
                    }
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                kAlertView(@"", @"Error in connection");
            });
        }
    }
    else if ([methodName isEqualToString:@"get_users_following"]){
        if([resultStatus intValue]==200){
             if ([[responseData  valueForKey:@"data"]count]>0){
                [self.m_tableView setHidden:NO];
                totalFollowingPage  =  [[responseData objectForKey:@"totalpage"] integerValue];
                NSLog(@"%d",totalFollowingPage);
                if([[responseData valueForKey:@"next"]isEqualToString:@""]||[[responseData valueForKey:@"next"]isEqualToString:@""]){
                    isFollowingIncrement = NO;
                }else{
                    isFollowingIncrement = YES;
                }
                NSArray *array_data = [responseData objectForKey:@"data"];
                [self.totalFollowing removeAllObjects];
                for(int i= 0; i<array_data.count;i++){
                        [self.totalFollowing addObject:[array_data objectAtIndex:i]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.totalFollowing.count>0){
                    NSString * attr_followingString =[NSString stringWithFormat:@"%@\nFOLLOWING",[NSString stringWithFormat:@"%@",[[m_dataitems valueForKey:@"data"]valueForKey:@"totalfollowing"]]];
                        [self.m_following setTitle:attr_followingString forState:UIControlStateNormal];
                    }else{
                     [self.m_following setTitle:[NSString stringWithFormat:@"%0\nFOLLOWING"] forState:UIControlStateNormal];
                    }
                    [self.m_tableView reloadData];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_following setTitle:[NSString stringWithFormat:@"%lu\nFOLLOWING",[self.totalFollowing count]] forState:UIControlStateNormal];
                   if([follow_handle isEqualToString:@"2"]){
                    k_label.text=@"You are not following anyone..";
                    k_label.hidden = NO;
                    [self.m_tableView setHidden:YES];
                    }
                });
            }
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                kAlertView(@"", @"Error in connection");
            });
        }
    }
else{
        NSLog(@"Method name is not matching..");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [profileIndicatorView stopAnimating];
        [profileIndicatorView setHidden:YES];
        [profileIndicatorView removeFromSuperview];
    });
}

//MARK : button Actions
// Post button Action
- (IBAction)m_totalPosts:(id)sender {
  follow_handle = @"";
    [self.totalPosting removeAllObjects];
    pageNo =1;
    [k_label setHidden:YES];
    self.m_tableView.hidden =YES;
    self.m_collectionView.hidden = NO;
    [self.m_Posts setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_followers setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_following setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self sendhttpdatatobackendtogetpostListing];
}

//followers button Action
- (IBAction)m_totalfollowers:(id)sender {
  follow_handle = @"1";
  [k_label setHidden:YES];
    followersNo =1;
    [self.totalFollowers removeAllObjects];
    [self.m_followers setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_Posts setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_following setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.m_tableView.hidden =YES;
    profileIndicatorView.hidden =NO;
    [profileIndicatorView startAnimating];
    profileIndicatorView.center =self.m_tableView.center;
    [self.view addSubview:profileIndicatorView];
    self.m_collectionView.hidden =YES;
    [self sendhttpdatatobackendtogetfollowersList];
}

//following button Action
- (IBAction)m_totalFollowing:(id)sender {
 follow_handle = @"2";
[k_label setHidden:YES];
followingNo = 1;
[self.totalFollowing removeAllObjects];
[self.m_following setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
[self.m_followers setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
[self.m_Posts setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
self.m_tableView.hidden =YES;
profileIndicatorView.hidden =NO;
[profileIndicatorView startAnimating];
profileIndicatorView.center =self.m_tableView.center;
[self.view addSubview:profileIndicatorView];
self.m_collectionView.hidden =YES;
[self sendhttpdatatobackendtogetfollowingList];
}

//back button Action
- (IBAction)back_button:(id)sender {
 [self.navigationController popViewControllerAnimated:YES];
[profileIndicatorView setHidden:YES];
}

//MARK: Custom Methods
-(void)registercollectionView{
    UINib *nib_file=[UINib nibWithNibName:@"SearchViewCell" bundle:nil];
    [self.m_collectionView registerNib:nib_file forCellWithReuseIdentifier:@"reusingData"];
    self.m_collectionView.dataSource=self;
    self.m_collectionView.delegate=self;
}

//Registering Tableview
-(void)registerTableView{
    UINib*nib=[UINib nibWithNibName:@"FollowersProfileCell" bundle:nil];
    [self.m_tableView registerNib:nib forCellReuseIdentifier:@"followersData"];
    self.m_tableView.dataSource = self;
    self.m_tableView.delegate = self;
}

#pragma mark :Data Communication services

-(void)sendhttpdatatobackendtogetpostListing{
    NSString *post_URL = [NSString stringWithFormat:@"%@/%@/%d",getAllQuestionsList_URL,self.profile_id,pageNo];
    [webData gettingFeedResult:post_URL parameters:appDelegate.array_rawData];
}
-(void)sendhttpdatatobackendtogetfollowersList{
    NSString*followers_URL = [NSString stringWithFormat:@"%@/%@/%d",getAllFollowersList_URL,self.profile_id,followersNo];
     [webData gettingFeedResult:followers_URL parameters:appDelegate.array_rawData];
}
-(void)sendhttpdatatobackendtogetfollowingList{
    NSString*following_URL =[NSString stringWithFormat:@"%@/%@/%d",getAllFollowingList_URL,self.profile_id,followingNo];
    [webData gettingFeedResult:following_URL parameters:appDelegate.array_rawData];
}

// handling delegate of Post method
-(void)getLikeResult:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*statusCode =[responseDictionary valueForKey:@"status"];
    NSString *methodName =[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"follow_unfollow_people"]){
        if([statusCode intValue]==200){
            NSLog(@"Successfully liked");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingFollowersList" object:nil];
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"ProfileUpdated" object:nil];
                     });
                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [self hittingWebServicestogetProfile];
                   [self sendhttpdatatobackendtogetfollowersList];
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
- (IBAction)m_follow_button:(UIButton*)sender{
    NSString*follow_URL=[NSString stringWithFormat:@"%@/%@",getfollowUnfollow_URL,self.profile_id];
    [m_dict removeAllObjects];
    [m_dict setValue:self.profile_id forKey:@"followingid"];
    if([sender.titleLabel.text isEqualToString:@"Follow"]){
    [sender setTitle:@"Following" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setTitleColor:[UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0] forState:UIControlStateNormal];
   }
    else{
        [sender setTitle:@"Follow" forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:112.0/255.0 blue:225.0/255.0 alpha:1.0]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    k_label.hidden = YES;
    follow_handle = @"1";
    [self.m_collectionView setHidden:YES];
    [self.m_followers setTitleColor:[UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_Posts setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.m_following setTitleColor:[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:172.0/255.0 alpha:1.0] forState:UIControlStateNormal];
   [webData webserviceshitLikeorUnlike:follow_URL parameters:m_dict withheaderSection:appDelegate.array_rawData];
}

// hitting webservices to thebackend to get details

#pragma mark- Scrollview Delegates ..............................................
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height);
  if (endScrolling > (float)scrollView.contentSize.height || endScrolling == (float)scrollView.contentSize.height){
        if([follow_handle isEqualToString:@"1"]){
             if (followersNo<totalFollowersPage &&isFollowersIncrement== YES){
                        followersNo++;
                [self performSelector:@selector(sendhttpdatatobackendtogetfollowingList) withObject:nil afterDelay:0.01];
               isFollowersIncrement=NO;
            }
        }
        else if ([follow_handle isEqualToString:@"2"]){
             if (followingNo<totalFollowingPage &&isFollowingIncrement== YES){
                        followingNo++;
                [self performSelector:@selector(sendhttpdatatobackendtogetfollowersList) withObject:nil afterDelay:0.01];
                isFollowingIncrement=NO;
            }
        }
        else{
        if (pageNo<totalPages&&pageIncrement== YES){
                    pageNo++;
            [self performSelector:@selector(sendhttpdatatobackendtogetpostListing) withObject:nil afterDelay:0.01];
            pageIncrement=NO;
        }
        }
    }
}

// touches began Method
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
