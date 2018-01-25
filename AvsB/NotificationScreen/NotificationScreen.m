//
//  NotificationScreen.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "NotificationScreen.h"

@interface NotificationScreen (){
    UIButton *btn_following;
    UIButton *btn_votes;
    UILabel *m_label_following;
    UILabel *m_label_votes;
    UILabel *m_Question_type;
    NotificationCell *cell;
    WebServices *webData;
    FollowingCell *shell;
    AppDelegate *appDelegate;
    CGRect frame;
    CommonMethods *method_Instance;
    NSString *segmentSection, *next;
    NSString *post_URL;
    int pageNo, totalPages;
    UIActivityIndicatorView *firstActivityIndicator;
    UIActivityIndicatorView *secondActivityIndicator;
    UILabel *label;
    UILabel *demolbl;
}
@end
@implementation NotificationScreen

#pragma mark: View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self RegisterNib];
    pageNo =1;
    CGRect frame =[[UIScreen mainScreen]bounds];
    label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width, 21.0f)] ;
    [label setFont:[UIFont fontWithName:@"ProximaNova-SemiBold" size:10]];
    label.center = self.view.center;
    label.adjustsFontSizeToFitWidth = YES;
    label.adjustsLetterSpacingToFitWidth = YES;
    label.minimumScaleFactor = 10.0f/12.0f;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    label.textAlignment =NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    firstActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    secondActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self registerSubviews];
    webData = [[WebServices alloc]init];
    webData.gettingFeeddelegate=self;
    appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.m_array_followersNotification=[[NSMutableArray alloc]init];
    self.m_array_votingNotification = [[NSMutableArray alloc]init];
    frame =[[UIScreen mainScreen]bounds];
    method_Instance = [CommonMethods sharedInstance];
    demolbl =[self.view viewWithTag:191];
    segmentSection =@"2";
    post_URL =[NSString stringWithFormat:@"%@/%@/%d",getNotification_URL,segmentSection,pageNo];
    m_label_following.backgroundColor=[UIColor whiteColor];
    m_label_votes.backgroundColor= [UIColor clearColor];
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
           [webData gettingFeedResult:post_URL parameters:appDelegate.array_rawData];
    }];
    [self.m_tableView setHidden:YES];
    [self.m_tableview2 setHidden:YES];
     [firstActivityIndicator setHidden:NO];
    [firstActivityIndicator startAnimating];
    [firstActivityIndicator setCenter:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2)];
    [self.view addSubview:firstActivityIndicator];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
  }
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.m_tableView setBackgroundColor:[UIColor clearColor]];
    [self.m_tableview2 setBackgroundColor:[UIColor clearColor]];
}

-(BOOL)prefersStatusBarHidden{
    return  NO;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

#pragma mark => Tableview Data Soure methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger countSection;
    if(tableView==self.m_tableView){
        countSection=1;
    }
    else if (tableView==self.m_tableview2){
        countSection =1;
    }
    return countSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount;
    if(tableView==self.m_tableView){
        rowCount = self.m_array_followersNotification.count;
    }
    else if(tableView==self.m_tableview2){
        rowCount = self.m_array_votingNotification.count;
    }
    
    return rowCount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowHeight;
    if(tableView==self.m_tableView){
        rowHeight =80.0f ;
   }
    else if (tableView==self.m_tableview2){
        rowHeight = 90.0f;
    }
    return rowHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    tableView.separatorColor=[UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
   if(tableView==self.m_tableView){
    NSString *username = @"";
    static NSString *identifier =@"reuseIdentifier";
      shell= [tableView dequeueReusableCellWithIdentifier:identifier];
      shell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(!shell){
            shell=[[FollowingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
        separator.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
        [shell.contentView addSubview:separator];
       NSDate *dateTimeStamping=[NSDate dateWithTimeIntervalSince1970:[[[self.m_array_followersNotification valueForKey:@"updated_at"]objectAtIndex:indexPath.row] doubleValue]];
       NSString*timeline=[NSString stringWithFormat:@"%@ ago",[method_Instance timeLeftSinceDate:dateTimeStamping]];
       shell.m_postedhours.text = [NSString stringWithFormat:@"%@",timeline];
       
       NSString*m_profileImage =[[self.m_array_followersNotification valueForKey:@"picture"]objectAtIndex:indexPath.row];
       [shell.m_img_profile setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_profileImage]]
                                  placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               shell.m_img_profile.image = image;
                                           } failure:nil];
       [CommonMethods setImageCorner:shell.m_img_profile];
       
       [method_Instance setLabelAsPerScreenSize:shell.m_label_profile];
       shell.m_first_pic_label.numberOfLines =2;
       shell.m_second_pic_label.numberOfLines =2;
    if([[[self.m_array_followersNotification valueForKey:@"section"]objectAtIndex:indexPath.row]isEqualToString:@"4"]){
             shell.m_img_one.hidden=YES;
             shell.m_img_two.hidden=YES;
             shell.m_firstView.hidden = YES;
             shell.m_secondView.hidden=YES;
           username =[[self.m_array_followersNotification valueForKey:@"name"]objectAtIndex:indexPath.row];
            NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ started following you",username]];
               [attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0]}range:(NSRange){0,username.length}];
             shell.m_label_profile.attributedText = attrString;
       }
       else if([[[self.m_array_followersNotification valueForKey:@"section"]objectAtIndex:indexPath.row]isEqualToString:@"5"]){
             if([[[self.m_array_followersNotification valueForKey:@"question_type"]objectAtIndex:indexPath.row]isEqualToString:@"1"]){
                     shell.m_img_one.hidden= NO;
                     shell.m_img_two.hidden= NO;
                     shell.m_firstView.hidden = YES;
                     shell.m_secondView.hidden=YES;
                     shell.m_first_pic_label.text =[NSString stringWithFormat:@"%@",[[self.m_array_followersNotification valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]];
                    shell.m_second_pic_label.text =[NSString stringWithFormat:@"%@",[[self.m_array_followersNotification valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]];
               NSString *m_firstImage =[[self.m_array_followersNotification valueForKey:@"option_a"]objectAtIndex:indexPath.row];
               NSString *m_secondImage  =[[self.m_array_followersNotification valueForKey:@"option_b"]objectAtIndex:indexPath.row];
               [shell.m_img_one setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_firstImage]]
                                      placeholderImage:[UIImage imageNamed:@"placeholder_A"]
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   shell.m_img_one.image = image;
                                               } failure:nil];
               [shell.m_img_two setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_secondImage]]
                                      placeholderImage:[UIImage imageNamed:@"placeholder_B"]
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   shell.m_img_two.image = image;
                                               } failure:nil];
           }
           else{
                shell.m_img_one.hidden= YES;
                shell.m_img_two.hidden= YES;
                shell.m_firstView.hidden = NO;
                shell.m_secondView.hidden = NO;
               shell.m_first_pic_label.text =[NSString stringWithFormat:@"%@",[[self.m_array_followersNotification valueForKey:@"option_a"]objectAtIndex:indexPath.row]];
               shell.m_second_pic_label.text =[NSString stringWithFormat:@"%@",[[self.m_array_followersNotification valueForKey:@"option_b"]objectAtIndex:indexPath.row]];
               NSString *background_firstColor =[[self.m_array_followersNotification valueForKey:@"background_a"]objectAtIndex:indexPath.row];
                     NSString *background_secondColor =[[self.m_array_followersNotification valueForKey:@"background_b"]objectAtIndex:indexPath.row];
               UIColor* first_backgroundColor = [method_Instance getUIColorObjectFromHexString:background_firstColor alpha:0.9];
                 UIColor* second_backgroundColor  = [method_Instance getUIColorObjectFromHexString:background_secondColor alpha:0.9];
               shell.m_firstView.backgroundColor = first_backgroundColor;
               shell.m_secondView.backgroundColor = second_backgroundColor;
           }
             username =[[self.m_array_followersNotification valueForKey:@"name"]objectAtIndex:indexPath.row];
            NSMutableAttributedString * attrString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ commented on your question",username]];
             [attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0]}range:(NSRange){0,username.length}];
             shell.m_label_profile.attributedText = attrString;
        }
       else{
          if([[[self.m_array_followersNotification valueForKey:@"question_type"]objectAtIndex:indexPath.row]isEqualToString:@"1"]){
              shell.m_img_one.hidden= NO;
              shell.m_img_two.hidden= NO;
              shell.m_firstView.hidden = YES;
              shell.m_secondView.hidden=YES;
        shell.m_first_pic_label.text =[NSString stringWithFormat:@"%@",[[self.m_array_followersNotification valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]];
        shell.m_second_pic_label.text =[NSString stringWithFormat:@"%@",[[self.m_array_followersNotification valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]];
           NSString *m_firstImage =[[self.m_array_followersNotification valueForKey:@"option_a"]objectAtIndex:indexPath.row];
           NSString *m_secondImage  =[[self.m_array_followersNotification valueForKey:@"option_b"]objectAtIndex:indexPath.row];
           [shell.m_img_one setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_firstImage]]
                                      placeholderImage:[UIImage imageNamed:@"placeholder_A"]
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   shell.m_img_one.image = image;
                                               } failure:nil];
           [shell.m_img_two setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_secondImage]]
                                  placeholderImage:[UIImage imageNamed:@"placeholder_B"]
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               shell.m_img_two.image = image;
                                           } failure:nil];

    }else{
                shell.m_img_one.hidden= YES;
                shell.m_img_two.hidden= YES;
                shell.m_firstView.hidden = NO;
                shell.m_secondView.hidden = NO;
        shell.m_first_pic_label.text =[NSString stringWithFormat:@"%@",[[self.m_array_followersNotification valueForKey:@"option_a"]objectAtIndex:indexPath.row]];
        shell.m_second_pic_label.text =[NSString stringWithFormat:@"%@",[[self.m_array_followersNotification valueForKey:@"option_b"]objectAtIndex:indexPath.row]];
        NSString *background_firstColor =[[self.m_array_followersNotification valueForKey:@"background_a"]objectAtIndex:indexPath.row];
      NSString *background_secondColor =[[self.m_array_followersNotification valueForKey:@"background_b"]objectAtIndex:indexPath.row];
         UIColor* first_backgroundColor = [method_Instance getUIColorObjectFromHexString:background_firstColor alpha:0.9];
          UIColor* second_backgroundColor  = [method_Instance getUIColorObjectFromHexString:background_secondColor alpha:0.9];
               shell.m_firstView.backgroundColor = first_backgroundColor;
               shell.m_secondView.backgroundColor = second_backgroundColor;
}
        username =[[self.m_array_followersNotification valueForKey:@"name"]objectAtIndex:indexPath.row];
        NSMutableAttributedString * attrString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ posted a question",username]];
         [attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0]}range:(NSRange){0,username.length}];
         shell.m_label_profile.attributedText = attrString;
         
 }
    [shell.m_label_profile setTag:indexPath.row];
    [self createUserButtonwithString:username andLabel:shell.m_label_profile];
    return shell;
}
    else{
        static NSString *identifier =@"reuseIdentifier2";
        cell= [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(!cell){
            cell=[[NotificationCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [method_Instance adjustlabelheight:cell.m_title_query];
        [method_Instance adjustlabelheight:cell.m_title_label];
        UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
        separator.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
        [cell.contentView addSubview:separator];
        NSString*m_profileImage =[[self.m_array_votingNotification valueForKey:@"picture"]objectAtIndex:indexPath.row];
        [cell.m_round_profile_pic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_profileImage]]
                                   placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                cell.m_round_profile_pic.image = image;
                                            } failure:nil];
        [CommonMethods setImageCorner:cell.m_round_profile_pic];
    NSString *m_username = [[self.m_array_votingNotification valueForKey:@"name"]objectAtIndex:indexPath.row];
    [method_Instance setLabelAsPerScreenSize:cell.m_title_label];
if([[[self.m_array_votingNotification objectAtIndex:indexPath.row]valueForKey:@"action"]isEqualToString:@"1"]){
            cell.m_transparency_check1.hidden =NO;
            cell.m_transparency_check2.hidden =YES;
    [cell.contentView bringSubviewToFront:cell.m_transparency_check1];
     NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ voted in look-1",m_username]];
    UIFont *font = [UIFont fontWithName:@"Arial" size:14.0];
     [attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0],NSFontAttributeName : font}
                         range:(NSRange){0, m_username.length}];
    cell.m_title_label.attributedText = attrString;
        }
    else{
        cell.m_transparency_check1.hidden = YES;
         cell.m_transparency_check2.hidden = NO;
         [cell.contentView bringSubviewToFront:cell.m_transparency_check2];
         NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ voted in look-2",m_username]];
        UIFont *font = [UIFont fontWithName:@"Arial" size:14.0];
         [attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0],NSFontAttributeName : font}
                             range:(NSRange){0, m_username.length}];
        cell.m_title_label.attributedText = attrString;
      }
        [cell.m_title_label setTag:indexPath.row];
    [self createUserButtonwithString:m_username andLabel:cell.m_title_label];
        cell.m_first_pic_lbl.numberOfLines =2;
        cell.m_sec_pic_lbl.numberOfLines =2;
if([[[self.m_array_votingNotification objectAtIndex:indexPath.row]valueForKey:@"question_type"] isEqualToString:@"2"]){
            cell.m_firstView.hidden=NO;
            cell.m_secondView.hidden=NO;
            cell.m_first_image.hidden=YES;
            cell.m_second_image.hidden=YES;
            cell.m_first_pic_lbl.text =[NSString stringWithFormat:@"%@",[[self.m_array_votingNotification  valueForKey:@"option_a"]objectAtIndex:indexPath.row]];
              cell.m_sec_pic_lbl.text =[NSString stringWithFormat:@"%@",[[self.m_array_votingNotification  valueForKey:@"option_b"]objectAtIndex:indexPath.row]];
            NSString *first_view_color =[NSString stringWithFormat:@"%@",[[self.m_array_votingNotification valueForKey:@"background_a"]objectAtIndex:indexPath.row]];
            UIColor *first_viewColor = [method_Instance getUIColorObjectFromHexString:first_view_color alpha:0.9];
            cell.m_firstView.backgroundColor = first_viewColor;
            NSString *second_view_color =[NSString stringWithFormat:@"%@",[[self.m_array_votingNotification valueForKey:@"background_b"]objectAtIndex:indexPath.row]];
            UIColor *second_viewColor = [method_Instance getUIColorObjectFromHexString:second_view_color alpha:0.9];
            cell.m_secondView.backgroundColor = second_viewColor;

        }
        else{
            cell.m_firstView.hidden=YES;
            cell.m_secondView.hidden=YES;
            cell.m_first_image.hidden=NO;
            cell.m_second_image.hidden=NO;
  cell.m_first_pic_lbl.text =[NSString stringWithFormat:@"%@",[[self.m_array_votingNotification  valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]];
            cell.m_sec_pic_lbl.text =[NSString stringWithFormat:@"%@",[[self.m_array_votingNotification  valueForKey:@"overtext_b"]objectAtIndex:indexPath.row]];
            NSString*m_firstImage =[[self.m_array_votingNotification valueForKey:@"option_a"]objectAtIndex:indexPath.row];
            [cell.m_first_image setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_firstImage]]
                                            placeholderImage:[UIImage imageNamed:@"placeholder_A"]
                                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                         cell.m_first_image.image = image;
                                                     } failure:nil];
            
            NSString*m_secondImage =[[self.m_array_votingNotification valueForKey:@"option_b"]objectAtIndex:indexPath.row];
            [cell.m_first_image setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_firstImage]]
                                      placeholderImage:[UIImage imageNamed:@"placeholder_B"]
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   cell.m_second_image.image = image;
                                               } failure:nil];
  
       
        }
NSDate *dateTimeStamping=[NSDate dateWithTimeIntervalSince1970:[[[self.m_array_votingNotification valueForKey:@"updated_at"]objectAtIndex:indexPath.row] doubleValue]];
NSString*timeline=[NSString stringWithFormat:@"%@ ago",[method_Instance timeLeftSinceDate:dateTimeStamping]];
cell.m_time_table.text=[NSString stringWithFormat:@"%@",timeline];
cell.m_title_query.text =[NSString stringWithFormat:[[self.m_array_votingNotification valueForKey:@"question"]objectAtIndex:indexPath.row]];
        cell.m_title_query.hidden=NO;
        [cell.m_queryType sizeToFit];
        cell.m_queryType.numberOfLines =0;
        return cell;
 }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height;
    if(tableView==self.m_tableView || tableView==self.m_tableview2){
        height=0.001f;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view;
    if(tableView==self.m_tableView||tableView==self.m_tableview2){
    if([self tableView:tableView heightForHeaderInSection:section] == 0.0){
        return nil;
    }
    //create header view
  view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
        
    }
    //return header view
   return view; 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString*questionid = @"";
//    RateController *rate = INSTANTIATE(RATE_CONTROLLER_VIEW);
//if(tableView==self.m_tableView){
//    questionid  =[[self.m_array_followersNotification objectAtIndex:indexPath.row]valueForKey:@"question_id"];
//          rate.getQuestion_Id = questionid;
//}
//else if (tableView==self.m_tableview2){
// questionid  =[[self.m_array_votingNotification objectAtIndex:indexPath.row]valueForKey:@"question_id"];
//    rate.getQuestion_Id = questionid;
//}
//[self.navigationController pushViewController:rate animated:YES];
}

#pragma mark : Registering Nib
-(void)RegisterNib{
    UINib *secondcell=[UINib nibWithNibName:@"NotificationCell" bundle:nil];
    UINib*FollowerCell =[UINib nibWithNibName:@"FollowingCell" bundle:nil];
    [self.m_tableView registerNib:FollowerCell  forCellReuseIdentifier:@"reuseIdentifier"];
    [self.m_tableview2 registerNib:secondcell forCellReuseIdentifier:@"reuseIdentifier2"];
    self.m_tableView.dataSource=self;
    self.m_tableView.delegate=self;
    self.m_tableview2.dataSource=self;
    self.m_tableview2.delegate=self;
}

#pragma mark : Register subviews

-(void)registerSubviews{
    btn_following=(UIButton *)[self.view viewWithTag:120];
    [btn_following  setTitle:@"Notification" forState:UIControlStateNormal];
    [btn_following setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_votes=(UIButton *)[self.view viewWithTag:121];
    [btn_votes setTitle:@"Voting" forState:UIControlStateNormal];
    [btn_votes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    m_label_following=(UILabel*)[self.view viewWithTag:122];
    m_label_votes=(UILabel*)[self.view viewWithTag:123];
    [btn_following addTarget:self action:@selector(hitButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn_votes addTarget:self action:@selector(hitButton:) forControlEvents:UIControlEventTouchUpInside];
}

// Action of button
-(void)hitButton:(UIButton *)sender{
    if(sender.tag==120){
        label.hidden = YES;
        segmentSection=@"2";
        self.m_tableview2.hidden=YES;
        m_label_following.backgroundColor=[UIColor whiteColor];
        m_label_votes.backgroundColor=[UIColor clearColor];
        post_URL =[NSString stringWithFormat:@"%@/%@/%d",getNotification_URL,segmentSection,pageNo];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
       [webData gettingFeedResult:post_URL parameters:appDelegate.array_rawData];
        }];
    [firstActivityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:firstActivityIndicator];
    [firstActivityIndicator startAnimating];
    }

    else if (sender.tag==121){
        segmentSection = @"1";
         label.hidden = YES;
        self.m_tableView.hidden = YES;
        m_label_following.backgroundColor=[UIColor clearColor];
        m_label_votes.backgroundColor=[UIColor whiteColor];
        post_URL =[NSString stringWithFormat:@"%@/%@/%d",getNotification_URL,segmentSection,pageNo];
          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [webData gettingFeedResult:post_URL parameters:appDelegate.array_rawData];
        }];
        [secondActivityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        [self.view addSubview: secondActivityIndicator];
        [secondActivityIndicator startAnimating];
    }
}
//MARK: handling delegate response
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSString*statusCode =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"get_notifications"]){
        if([statusCode intValue]==200){
            if([[responseData valueForKey:@"part"]isEqualToString:@"2"]){
                self.m_array_followersNotification =[responseData valueForKey:@"data"];
                if(self.m_array_followersNotification.count>0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [demolbl setHidden:YES];
                        [firstActivityIndicator setHidden:YES];
                        [firstActivityIndicator stopAnimating];
                        [firstActivityIndicator removeFromSuperview];
                        [label setHidden:YES];
                        [self.m_tableView reloadData];
                        self.m_tableView.hidden = NO;
                    });
                }
                else{
                    self.m_tableView.hidden = YES;
                    self.m_tableview2.hidden =YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [label setHidden:NO];
                     label.text =[NSString stringWithFormat:@"No Notification yet"];
                    [firstActivityIndicator setHidden:YES];
                    [firstActivityIndicator stopAnimating];
                    [firstActivityIndicator removeFromSuperview];
                    });
                }
            }
            else{
                self.m_array_votingNotification =[responseData valueForKey:@"data"];
                if(self.m_array_votingNotification.count>0){
                      dispatch_async(dispatch_get_main_queue(), ^{
                        [secondActivityIndicator setHidden:YES];
                        [secondActivityIndicator stopAnimating];
                        [secondActivityIndicator removeFromSuperview];
                        [label setHidden:YES];
                        [self.m_tableview2 reloadData];
                        [self.m_tableview2 setHidden:NO];
                    });
                }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.m_tableview2 setHidden:YES];
                            [self.m_tableView setHidden:YES];
                            [label setHidden:NO];
                            label.text =[NSString stringWithFormat:@"No voting yet"];
                            [secondActivityIndicator setHidden:YES];
                            [secondActivityIndicator stopAnimating];
                            [secondActivityIndicator removeFromSuperview];
                        });
                    }
            }
        }
         else{
            dispatch_async(dispatch_get_main_queue(), ^{
                kAlertView(@"", [responseData valueForKey:@"message"]);
            });
}
    }
    else{
        NSLog(@"Method name not matching");
    }
}



// custom button Appearance

-(void)createUserButtonwithString:(NSString *)match andLabel:(UILabel *)postdataLabel{
      UIFont *font =[UIFont fontWithName:@"ProximaNova-Semibold" size:15.f];
      NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
      if (match != nil && [match length] != 0) {
            CGFloat width= [[[NSAttributedString alloc] initWithString:match attributes:attributes] size].width;
             postdataLabel.userInteractionEnabled=YES;
             NSString *text = postdataLabel.text;
        //     NSString *substring = [text substringToIndex:[text rangeOfString:match].location];
            CGSize size = [match sizeWithFont:postdataLabel.font];
            CGPoint p = CGPointMake((int)size.width % (int)postdataLabel.frame.size.width, ((int)size.width / (int)postdataLabel.frame.size.width) * size.height);
             NSLog(@"Point=%f, %f",p.x, p.y);
            UIButton *btn = [[UIButton  alloc] initWithFrame:CGRectMake(0, p.y, size.width, size.height)];
            btn.titleLabel.text = @"";
            btn.tag = postdataLabel.tag;
            btn.backgroundColor =[UIColor clearColor];
            [btn addTarget:self action:@selector(btnUser2Pressed:) forControlEvents:UIControlEventTouchUpInside];
            [postdataLabel addSubview:btn];
          }
}

-(IBAction)btnUser2Pressed:(UIButton*)sender{
     SearchUsersProfile *search= INSTANTIATE(SEARCH_USERS_PROFILE);
    NSString*user_id =@"";
     if([segmentSection isEqualToString:@"2"]){
        user_id =[[self.m_array_followersNotification valueForKey:@"user_id"]objectAtIndex:sender.tag];
        if([[[self.m_array_followersNotification objectAtIndex:sender.tag]valueForKey:@"my_follow_stauts"]isEqualToString:@"1"]){
        search.buttonTitle = @"Following";
    }
    else{
        search.buttonTitle = @"Follow";
    }

    }
    else{
        user_id =[[self.m_array_votingNotification valueForKey:@"user_id"]objectAtIndex:sender.tag];
            if([[[self.m_array_votingNotification objectAtIndex:sender.tag]valueForKey:@"my_follow_stauts"]isEqualToString:@"1"]){
            search.buttonTitle = @"Following";
        }
        else{
            search.buttonTitle = @"Follow";
        }

    }
    search.profile_id = user_id;
    [self.navigationController pushViewController:search animated:YES];
}

    
#pragma mark : Memory usage warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
