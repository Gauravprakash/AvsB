//
//  HomeScreen.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//
#define kLabelTag 1000
#define kEmbeddedLabelHashtagStyle    @"hashtagStyle"
#define kEmbeddedLabelUsernameStyle  @"usernameStyle"
#define ROW_HEIGHT  500.0
#import "UIImageView+AFNetworking.h"
#import "HomeScreen.h"
@interface HomeScreen (){
    UIWindow *window;
    UIView *viewToAdd;
    NSOperationQueue *myQueue;
    NSMutableArray*headerSectionTitles;
    NSArray *m_header_text_label;
    AppDelegate *appDelegate;
    CommonMethods *m_Instancemethods;
    UIActivityViewController *activityController;
    WebServices *webClass;
    HomeCell *cell;
    NSString *img1_URL;
    NSString *img2_URL;
    NSString *profile_URL;
    NSString*timeline;
    NSString *nextPage;
    NSInteger optionsRow ;
    NSString *question_Id;
    NSString *option_vote;
    NSString*remainingTime;
    NSMutableDictionary *m_receivingElements;
    NSMutableString *rating_URL ;
    NSString *first_txt_color;
    UIColor *first_txtColor;
    NSString*sec_txt_color;
    UIColor *sec_txtColor;
    NSString *first_view_color;
    UIColor *first_viewColor;
    NSString *sec_view_color;
    UIColor *sec_viewColor;
    NSString *userId;
    NSString *tokenKey;
    UIRefreshControl *refreshControl;
    int pageNo;
    int currHour,currMinute,currSeconds;
    NSDate *dueDate;
    NSNumber *demoId;
    BOOL isNewPost, pageIncrement,RefreshAllPost;
    UIActivityIndicatorView *spinner ;
    PatternTapResponder hashTagTapAction;
    PatternTapResponder userHandleTapAction;
    NSTimer *timer;
    NSInteger timeLeft;
    NSString*getting_userid;
    NSArray*data_array;
    NSInteger tagPath;
}
@end
@implementation HomeScreen

#pragma mark : View Controller Cycle Method

-(void)viewDidLoad{
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor =  [UIColor clearColor];
    refreshControl.tintColor = [UIColor colorWithRed:55/255.0f green:129/255.0f blue:221/255.0f alpha:1.0];
   [self.m_tblView addSubview:refreshControl];
    data_array = [[NSArray alloc]init];
     // Setting Frame of Spinner..
    [refreshControl addTarget:self action:@selector(refreshAllpost)
                  forControlEvents:UIControlEventValueChanged];
    webClass=[[WebServices alloc]init];
    webClass.gettingFeeddelegate=self;
    webClass.posthandlingdelegate=self;
    m_Instancemethods =[CommonMethods sharedInstance];
    NSLog(@"%@",appDelegate.array_rawData);
    pageNo = 1;
    isNewPost =YES;
    RefreshAllPost =NO;
    self.m_dict_array=[[NSMutableArray alloc]init];
    window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    myQueue=[[NSOperationQueue alloc]init];
    m_receivingElements=[[NSMutableDictionary alloc]init];
    rating_URL =[[NSMutableString alloc]initWithString:votefeed_URL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAllpost) name:@"updatingHomeFeed" object:nil];
    [self registeringCustomCell];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"signupdata"]!= nil &&[[NSUserDefaults standardUserDefaults]objectForKey:@"signupdata"]){
    [self performSelectorOnMainThread:@selector(sendDetailsToBackendserver) withObject:nil waitUntilDone:YES];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(calculateRemainingTimeHome) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    pageIncrement=NO;
    self.m_firstView.hidden=YES;
    self.m_secondView.hidden=YES;
    self.m_tblView.backgroundColor=[UIColor clearColor];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    hashTagTapAction = ^(NSString *tappedString, NSInteger tag){
        appDelegate.hashableText = tappedString;
        NSLog(@"%@",tappedString);
    TabControlSection *tabbarcontroller = (TabControlSection *)self.tabBarController;
        [tabbarcontroller setSelectedIndex:1];
   };
userHandleTapAction = ^(NSString *tappedString, NSInteger tag){
    NSInteger index = tag - kLabelTag;
    NSLog(@"%d",index);
  data_array = [[self.m_dict_array valueForKey:@"taged"]objectAtIndex:index];
  NSLog(@"%@",data_array);
if(data_array.count>0){
NSLog(@"%@",data_array);
                NSString*get_hashTapId = @"";
                for(int i= 0;i<data_array.count;i++){
                    NSString*get_username = [NSString stringWithFormat:@"@%@",[[data_array objectAtIndex:i]valueForKey:@"name"]];
                    NSLog(@"%@",get_username);
                    if ([tappedString isEqualToString:get_username]){
                        NSDictionary *data_item = [data_array objectAtIndex:i];
                        get_hashTapId = [data_item valueForKey:@"user_id"];
                    }
                }
                if(![get_hashTapId isEqualToString:@""]){
                    NSString*myId = [appDelegate.signup_resultant valueForKey:@"id"];
                    if([myId isEqualToString:get_hashTapId]){
                        TabControlSection *tabbarcontroller = (TabControlSection *)self.tabBarController;
                        [tabbarcontroller setSelectedIndex:4];
                    }
                    else{
                        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        SearchUsersProfile* myVC = [sb instantiateViewControllerWithIdentifier:@"SearchUsersProfile"];
                        myVC.profile_id = get_hashTapId;
                        [self.navigationController pushViewController:myVC animated:YES];
                    }
                }
                else{
                     kAlertView(@"", @"No such users found");
                }
}
else{
          kAlertView(@"", @"you have not tagged any users.");
}
};
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
return YES;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];

}

#pragma mark: Table view Datasource and Delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.m_dict_array.count == 0){
        return 0;
    }
    else{
       return self.m_dict_array.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"simpleidentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.first_visualView.hidden =YES;
    cell.second_visualView.hidden =YES;
    [cell.m_static_query setNumberOfLines:0];
    cell.m_static_query.lineBreakMode=NSLineBreakByWordWrapping;
    [cell.m_buttonvoting setImage:[UIImage imageNamed:@"receiving"]forState:UIControlStateNormal];
    [cell.m_buttonComment setImage:[UIImage imageNamed:@"chat"]forState:UIControlStateNormal];
    [cell.m_buttonShare setImage:[UIImage imageNamed:@"share"]forState:UIControlStateNormal];
    timeLeft = [[[self.m_dict_array valueForKey:@"remainedtime"]objectAtIndex:indexPath.row]intValue];
    // calculating value of time posting date
    NSDate *dateTimeStamp =[NSDate dateWithTimeIntervalSince1970:[[[self.m_dict_array valueForKey:@"posted_on"]objectAtIndex:indexPath.row] doubleValue]];
    NSMutableString *timeLefting = [[NSMutableString alloc]init];
    NSDate *today10am =[NSDate date];
    int seconds = [today10am timeIntervalSinceDate:dateTimeStamp];
    int currentHours =24*3600;
    int currentVal = currentHours - seconds;
    if (currentVal==0) {
         [timer invalidate];
         timer =nil;
    }
    else{
    cell.remainingTime = currentVal;
    }
     if(timeLeft==0){
        [cell.m_timeLabel setHidden:YES];
         remainingTime = @"TimeOut";
     }
    else{
        [cell.m_timeLabel setHidden:NO];
        remainingTime =@"";
        [cell calculateRemainingTime];
        cell.m_timeLabel.text = [NSString stringWithFormat:@"%@",[m_Instancemethods timeLeftString:currentVal]];
    }
    if(hashTagTapAction!=nil){
           [cell.m_hashTag enableHashTagDetectionWithAttributes:
            @{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0], RLTapResponderAttributeName:hashTagTapAction}];
    }
    if(userHandleTapAction!=nil){
           [cell.m_hashTag enableUserHandleDetectionWithAttributes:
            @{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0], RLTapResponderAttributeName:userHandleTapAction}];
    }
  UIActivityIndicatorView *firstactivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIActivityIndicatorView *secondactivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // Setting Frame of Spinner.......
    CGFloat x = (cell.m_pic1.frame.size.width-firstactivityIndicator.frame.size.width)/2;
    CGFloat y = (cell.m_pic1.frame.size.height-firstactivityIndicator.frame.size.height)/2;
    firstactivityIndicator.frame = CGRectMake(x, y, firstactivityIndicator.frame.size.width, firstactivityIndicator.frame.size.height);
      [firstactivityIndicator setCenter:CGPointMake(cell.m_pic1.frame.size.width/2, cell.m_pic1.frame.size.height/2)];
    CGFloat x1 = (cell.m_pic2.frame.size.width-secondactivityIndicator.frame.size.width)/2;
    CGFloat y1 = (cell.m_pic2.frame.size.height-secondactivityIndicator.frame.size.height)/2;
    secondactivityIndicator.frame = CGRectMake(x1, y1, secondactivityIndicator.frame.size.width, secondactivityIndicator.frame.size.height);
    [secondactivityIndicator setCenter:CGPointMake(cell.m_pic2.frame.size.width/2, cell.m_pic2.frame.size.height/2)];
    [cell.m_pic1 addSubview:firstactivityIndicator];
    [cell.m_pic2 addSubview: secondactivityIndicator];
    NSDate *dateTimeStamping=[NSDate dateWithTimeIntervalSince1970:[[[self.m_dict_array valueForKey:@"posted_on"]objectAtIndex:indexPath.row] doubleValue]];
    timeline=[NSString stringWithFormat:@"%@ ago",[m_Instancemethods timeLeftSinceDate:dateTimeStamping]];
    cell.m_hoursLabel.text =[NSString stringWithFormat:@"%@",timeline];
    cell.m_trophy_one.hidden=YES;
    cell.m_trophy_two.hidden =YES;
    cell.round_profilePic.image=nil;
    cell.m_pic1.image=nil;
    cell.m_pic2.image =nil;
    cell.m_pic1.contentMode = UIViewContentModeScaleAspectFill;
    cell.m_pic1.clipsToBounds=YES;
    cell.m_pic2.contentMode = UIViewContentModeScaleAspectFill;
    cell.m_pic2.clipsToBounds=YES;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.m_view1.hidden=YES;
    cell.m_view2.hidden=YES;
      // Add custom separator view between the cells
    tableView.separatorColor=[UIColor clearColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    [cell.contentView addSubview:separatorView];
    [CommonMethods setImageCorner:cell.round_profilePic];
    img1_URL = [NSString stringWithFormat:@"%@", self.m_dict_array[indexPath.row][@"option_a"]];
    img2_URL = [NSString stringWithFormat:@"%@", self.m_dict_array[indexPath.row][@"option_b"]];
    profile_URL = [NSString stringWithFormat:@"%@",self.m_dict_array[indexPath.row][@"picture"]];
    [cell.round_profilePic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:profile_URL]]
                       placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   cell.round_profilePic.image = image;
                                } failure:nil];
if([[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"question_type"]isEqualToString:@"1"]){
    [firstactivityIndicator setHidden:NO];
    [secondactivityIndicator setHidden:NO];
      [cell.m_pic1 bringSubviewToFront:firstactivityIndicator];
      [cell.m_pic2 bringSubviewToFront: secondactivityIndicator];
        [firstactivityIndicator startAnimating];
        [secondactivityIndicator startAnimating];
        [cell.m_pic1 setHidden:NO];
        [cell.m_pic2 setHidden:NO];
        [cell.m_view1 setHidden:YES];
        [cell.m_view2 setHidden:YES];
        cell.m_pic1_title.textColor =[UIColor whiteColor];
        cell.m_pic2_title.textColor =[UIColor whiteColor];
    if ([[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"overtext_a"] isEqualToString:@""]&&[[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"overtext_a"] isEqualToString:@" "]){
            cell.m_pic1_title.hidden =YES;
        }
      else{
        cell.m_pic1_title.hidden =NO;
        cell.m_pic1_title.text=[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]];
        }
       if ([[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"overtext_b"] isEqualToString:@""]&&[[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"overtext_b"] isEqualToString:@" "]){
            cell.m_pic2_title.hidden =YES;
       }
          else{
            cell.m_pic2_title.hidden =NO;
            cell.m_pic2_title.text=[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"overtext_b"]objectAtIndex:indexPath.row]];
         }
     if(![[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"overtext_a"] isEqualToString:@""]&&![[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"overtext_b"] isEqualToString:@""]){
          cell.m_static_query.hidden = NO;
         cell.m_static_query.text=[NSString stringWithFormat:@"%@ or %@? I cannot decide",[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]],[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"overtext_b"]objectAtIndex:indexPath.row]]];
         }
        else{
                cell.m_static_query.hidden = YES;
        }
     
     // Image loading with lazy loading
        [cell.m_pic1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:img1_URL]]
                                placeholderImage:[UIImage imageNamed:@"placeholder_A"]
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             cell.m_pic1.image = image;
                                             cell.m_pic1_title.hidden =NO;
                                             [firstactivityIndicator stopAnimating];
                                              [firstactivityIndicator setHidden:YES];
                                             [firstactivityIndicator removeFromSuperview];
                                         } failure:nil];
        //image 2 uploading with lazy loading
        [cell.m_pic2 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:img2_URL]]
                           placeholderImage:[UIImage imageNamed:@"placeholder_B"]
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        cell.m_pic2.image = image;
                                        cell.m_pic2_title.hidden = NO;
                                        [secondactivityIndicator stopAnimating];
                                         [secondactivityIndicator setHidden:YES];
                                        [secondactivityIndicator removeFromSuperview];
                                    } failure:nil];
    }else{
        [firstactivityIndicator setHidden:YES];
        [secondactivityIndicator setHidden:YES];
        [cell.m_pic1 setHidden:YES];
        [cell.m_pic2 setHidden:YES];
        [cell.m_view1 setHidden:NO];
        [cell.m_view2 setHidden:NO];
        if ([[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"option_a"] isEqualToString:@""]){
            cell.m_pic1_title.hidden = YES;
        }
        else{
        cell.m_pic1_title.hidden = NO;
        cell.m_pic1_title.text=[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"option_a"]objectAtIndex:indexPath.row]];
        }
         if ([[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"option_b"] isEqualToString:@""]){
            cell.m_pic2_title.hidden = YES;
        }
        else{
       cell.m_pic2_title.hidden = NO;
       cell.m_pic2_title.text=[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"option_b"]objectAtIndex:indexPath.row]];
        }
        if (![[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"option_a"] isEqualToString:@""]&&![[[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"option_b"] isEqualToString:@""]){
            cell.m_static_query.hidden = NO;
            cell.m_static_query.text=[NSString stringWithFormat:@"%@ or %@? I cannot decide",[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"option_a"]objectAtIndex:indexPath.row]],[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"option_b"]objectAtIndex:indexPath.row]]];
        }
        else{
          cell.m_static_query.hidden = YES;
        }
    }
        first_txt_color = [NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"textcolor_a"]objectAtIndex:indexPath.row]];
        first_txtColor = [m_Instancemethods getUIColorObjectFromHexString:first_txt_color alpha:0.9];
        cell.m_pic1_title.textColor  = first_txtColor;
        sec_txt_color =  [NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"textcolor_b"]objectAtIndex:indexPath.row]];
        sec_txtColor =  [m_Instancemethods getUIColorObjectFromHexString:sec_txt_color alpha:0.9];
        cell.m_pic2_title.textColor =sec_txtColor;
        first_view_color =[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"background_a"]objectAtIndex:indexPath.row]];
        first_viewColor = [m_Instancemethods getUIColorObjectFromHexString:first_view_color alpha:0.9];
        cell.m_view1.backgroundColor = first_viewColor;
        sec_view_color = [NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"background_b"]objectAtIndex:indexPath.row]];
        sec_viewColor = [m_Instancemethods getUIColorObjectFromHexString:sec_view_color alpha:0.9];
        cell.m_view2.backgroundColor = sec_viewColor;
    cell.m_headerTitle.text=[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"name"]objectAtIndex:indexPath.row]];
    [m_Instancemethods adjustlabelheight:cell.m_headerTitle];
    cell.m_query.text=[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"question"]objectAtIndex:indexPath.row]];
    [m_Instancemethods adjustlabelheight:cell.m_query];
    [m_Instancemethods adjustlabelheight:cell.m_static_query];
    [cell.m_hashTag setTag:kLabelTag+indexPath.row];
    cell.m_hashTag.userInteractionEnabled =YES;
  
    cell.m_hashTag.text=[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"description"]objectAtIndex:indexPath.row]];
    
    [m_Instancemethods adjustlabelheight:cell.m_hashTag];
    NSString *vote_percentA =[[self.m_dict_array valueForKey:@"votepercentage_a"]objectAtIndex:indexPath.row];
    NSString *vote_percentB =[[self.m_dict_array valueForKey:@"votepercentage_b"]objectAtIndex:indexPath.row];
    NSString *new_format_one = [vote_percentA stringByReplacingOccurrencesOfString:@"%" withString:@""];
    NSString *new_format_sec =  [vote_percentB stringByReplacingOccurrencesOfString:@"%" withString:@""];
    int format_one =[new_format_one intValue];
    int format_two =[new_format_sec intValue];
    if(format_one>format_two){
        if([remainingTime isEqualToString:@"TimeOut"]){
        cell.m_trophy_one.hidden =NO;
        }
    }
    else if(format_two>format_one){
        if([remainingTime isEqualToString:@"TimeOut"]){
        cell.m_trophy_two.hidden=NO;
    }
    }
    else{
        cell.m_trophy_one.hidden = YES;
        cell.m_trophy_two.hidden = YES;
    }
  if([[[self.m_dict_array valueForKey:@"isivoted"]objectAtIndex:indexPath.row]isEqualToString:@"0"]){
        [cell.m_precentageA setHidden: YES];
        [cell.m_percentageB setHidden: YES];
    }
    else{
        [cell.m_precentageA setHidden: NO];
        [cell.m_percentageB setHidden: NO];
        [cell.m_precentageA setTitle:[NSString stringWithFormat:@" %@",[[self.m_dict_array valueForKey:@"votepercentage_a"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        [cell.m_percentageB setTitle:[NSString stringWithFormat:@" %@",[[self.m_dict_array valueForKey:@"votepercentage_b"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    }
    [cell.btn_commentSections setTitle:[NSString stringWithFormat:@"View all %@ comments",[[self.m_dict_array valueForKey:@"totalcomments"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [cell.btn_commentSections addTarget:self action:@selector(navigateToCommentScreenThorughLines:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_commentSections setTag:indexPath.row];
    if([[[self.m_dict_array valueForKey:@"totalvotes"]objectAtIndex:indexPath.row]isEqualToString:@"1"]){
    cell.m_countVote.text =[NSString stringWithFormat:@"%@ vote",[[self.m_dict_array valueForKey:@"totalvotes"]objectAtIndex:indexPath.row]];
    }
    else if ([[[self.m_dict_array valueForKey:@"totalvotes"]objectAtIndex:indexPath.row]isEqualToString:@"0"]){
        cell.m_countVote.text =[NSString stringWithFormat:@"0 vote"];
    }
  else{
      cell.m_countVote.text =[NSString stringWithFormat:@"%@ votes",[[self.m_dict_array valueForKey:@"totalvotes"]objectAtIndex:indexPath.row]];
    }
   question_Id=  [NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"question_id"]objectAtIndex:indexPath.row]];
    [cell.m_buttonComment setTag:indexPath.row];
    [cell.m_buttonvoting setTag:indexPath.row];
    [cell.m_buttonvoting addTarget:self action:@selector(navigateToRatingScreen:) forControlEvents:UIControlEventTouchUpInside];
    [cell.m_buttonComment addTarget:self action:@selector(navigateToCommentScreen:) forControlEvents:UIControlEventTouchUpInside];
    [cell.m_buttonShare addTarget:self action:@selector(presentCustomViewForSharing:) forControlEvents:UIControlEventTouchUpInside];

     return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        if([self tableView:tableView heightForHeaderInSection:section] == 0.0){
            return nil;
        }
    //create header view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    //return header view
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return ROW_HEIGHT;
      NSString *labelText = [[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"description"];
        CGSize s = [self sizeForLabel:cell.m_hashTag withText:labelText];
        CGFloat kheight = s.height;
        NSString*questionText = [[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"question"];
    CGSize k = [self sizeForLabel:cell.m_query withText:questionText];
    CGFloat k_queryheight = k.height;
       NSString *profile_name = [[self.m_dict_array objectAtIndex:indexPath.row]valueForKey:@"name"];
      CGSize n = [self sizeForLabel:cell.m_headerTitle withText:profile_name];
      CGFloat k_nameheight = n.height;
    CGFloat rowHeight =  cell.m_pic1.frame.size.height+kheight+ k_queryheight+k_nameheight+cell.m_static_query.frame.size.height+cell.round_profilePic.frame.size.height+cell.m_countVote.frame.size.height+cell.m_buttonvoting.frame.size.height+cell.m_hoursLabel.frame.size.height+30.0f;
     return rowHeight;
}
- (CGSize)sizeForLabel:(UILabel *)label withText:(NSString *)str {
        CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
        CGSize size = [str sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:UILineBreakModeWordWrap];
        return size;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.001;
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
     spinner.frame = CGRectMake(0, 0,self.m_tblView.frame.size.width, 60);
    [spinner startAnimating];
    [headerView addSubview:spinner];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailPost *detail =  INSTANTIATE(DETAIL_POST_VIEW);
    NSString*questionid_detail =[[self.m_dict_array valueForKey:@"question_id"]objectAtIndex:indexPath.row];
    detail.getQuestionId = questionid_detail;
   [self.navigationController pushViewController:detail animated:YES];
}
- (UIView*)resultEndView{
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.text = @"No more results to display";
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.m_tblView.frame.size.width, 40)];
    [footerView addSubview:endLabel];
    return footerView;
}

// Navigate to Rating Screen
-(void)navigateToRatingScreen:(UIButton*)sender{
        [sender setImage:[UIImage imageNamed:@"blue_voting"] forState:UIControlStateNormal];
      NSString *question_id_detail =[NSString stringWithFormat:@"%@",[[self.m_dict_array valueForKey:@"question_id"]objectAtIndex:sender.tag]];
    DetailPost *detail =  INSTANTIATE(DETAIL_POST_VIEW);
    detail.getQuestionId = question_id_detail;
    [self.navigationController pushViewController:detail animated:YES];
//    [sender setImage:[UIImage imageNamed:@"receiving"] forState:UIControlStateNormal];
}

//Navigate to Comment Screen
- (void)navigateToCommentScreen:(UIButton*)sender{
        [sender setImage:[UIImage imageNamed:@"blue_chat"] forState:UIControlStateNormal];
        CommentSection *comment =INSTANTIATE(COMMENT_SCREEN_VIEW);
        comment.kQuestionId=[[self.m_dict_array valueForKey:@"question_id"]objectAtIndex:sender.tag];
        [self.navigationController pushViewController:comment animated:YES];
}

- (void)navigateToCommentScreenThorughLines:(UIButton*)sender{
    CommentSection *comment =INSTANTIATE(COMMENT_SCREEN_VIEW);
    comment.kQuestionId=[[self.m_dict_array valueForKey:@"question_id"]objectAtIndex:sender.tag];
       [self.navigationController pushViewController:comment animated:YES];
}


#pragma mark : sharing Button selected
-(void)presentCustomViewForSharing:(UIButton*)sender{
         [sender setImage:[UIImage imageNamed:@"blue_share"] forState:UIControlStateNormal];
       [self performSelector:@selector(checkActivityController) withObject:nil afterDelay:0.01];
    
}
-(void)checkActivityController{
    NSString *url=@"http://itunes.apple.com/us/app/AvsB/abc001retry";
    NSString * title =[NSString stringWithFormat:@"Download AvsB app %@ and get free reward points!",url];
    NSArray* dataToShare = @[title];
    dispatch_queue_t queue = dispatch_queue_create("openActivityIndicatorQueue", NULL);
    dispatch_async(queue, ^{
            activityController =[[UIActivityViewController alloc]initWithActivityItems:dataToShare applicationActivities:nil];
        activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
            dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityController animated:YES completion:nil];
            [cell.m_buttonShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        });
    });
    [activityController setCompletionHandler:^(NSString *activityType, BOOL completed){
               if (completed){
            NSLog(@"We used activity type%@", activityType);
            [cell.m_buttonShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        }
        else{
            [cell.m_buttonShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
             NSLog(@"We didn't want to share anything after all.");
        }
    }];
}

//sharing Media
-(void)sharingMedia:(UIButton*)sender{
    if(sender.tag==124){
        [viewToAdd removeFromSuperview];
        [self.m_tblView reloadData];
    }
    else if (sender.tag==114){
        [viewToAdd removeFromSuperview];
            }
}

#pragma mark : webservices hitting
-(void)sendDetailsToBackendserver{
    NSLog(@"%d",pageNo);
    NSString *home_feed_url  =[NSString stringWithFormat:@"%@%d",homefeed_URL,pageNo];
    dispatch_async(dispatch_get_main_queue(), ^{
     [webClass gettingFeedResult:home_feed_url  parameters:appDelegate.array_rawData];
    });
 }

//MARK: handling delegate response
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSString*statusCode =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"gethomequestions"]){
        if([statusCode intValue]==200){
            BOOL found = NO;
            NSArray*jsonArray =[responseData objectForKey:@"data"];
            NSLog(@"Data items count = %d",[jsonArray count]);
            nextPage =[ responseData valueForKey:@"next"];
            if([nextPage isEqualToString:@""]||[nextPage isEqualToString:@"0"]){
                pageIncrement =NO;
            }
            else{
                pageIncrement=YES;
            }
            if (RefreshAllPost==YES) {
           [self.m_dict_array removeAllObjects];
            for(int i =0;i<[jsonArray count];i++){
             [self.m_dict_array addObject:[jsonArray objectAtIndex:i]];
            }
            }
            else{
            for(int i =0;i<[jsonArray count];i++){
            if(![self.m_dict_array containsObject:[jsonArray objectAtIndex:i]]){
              [self.m_dict_array addObject:[jsonArray objectAtIndex:i]];
            }
           }
            }
              dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_tblView reloadData];
          });
            self.totalPages  =  [[responseData objectForKey:@"totalpage"] integerValue];
            NSLog(@"%d",self.totalPages);
         }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
            [CommonMethods alertView:self title:@"Error!" message:error.localizedDescription];
            });
        }
        }
    else{
        NSLog(@"Method name is wrong");
    }
}

//Registering customCell
-(void)registeringCustomCell{
    UINib*nib=[UINib nibWithNibName:@"HomeCell" bundle:nil];
    [self.m_tblView registerNib:nib forCellReuseIdentifier:@"simpleidentifier"];
    self.m_tblView.dataSource=self;
    self.m_tblView.delegate=self;
}
-(void)refreshAllpost{
     pageNo =1;
     RefreshAllPost = YES;
     [refreshControl endRefreshing];
     [self performSelector:@selector(sendDetailsToBackendserver) withObject:nil afterDelay:0.01];
     self.m_tblView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark- Scrollview Delegates ..............................................

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        float endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height);
            NSLog(@"%.2f",endScrolling);
            NSLog(@"%.2f",scrollView.contentSize.height);
        if (endScrolling > (float)scrollView.contentSize.height || endScrolling == (float)scrollView.contentSize.height){
              [spinner startAnimating];
              self.m_tblView.tableFooterView.hidden=NO;
              self.m_tblView.tableFooterView = spinner;
              spinner.frame = CGRectMake(0, 0,self.m_tblView.frame.size.width, 60);
             if (pageNo<self.totalPages&&pageIncrement== YES){
             pageNo++;
             [self performSelector:@selector(sendDetailsToBackendserver) withObject:nil afterDelay:0.0];
             pageIncrement=NO;
             RefreshAllPost = NO;
        }
    }
}

// timer functionality 
-(void)calculateRemainingTimeHome{
    [self.m_tblView reloadData];
}

#pragma mark :Memory usage warning
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end

