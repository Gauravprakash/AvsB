//
//  DetailPost.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 21/09/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//
#define ROW_HEIGHT  420.0
#import "DetailPost.h"

@interface DetailPost (){
WebServices *webData;
CommonMethods *m_sharedClass;
AppDelegate *appDelegate;
UIActivityIndicatorView *spinner, *profileIndicator;
UIActivityViewController* activityController;
NSString*remainingTime, *option_vote;
NSString *firstlbl_txt ;
NSString *seclbl_txt;
PatternTapResponder hashTagTapAction;
PatternTapResponder userHandleTapAction;
int pageNo;
NSInteger totalPages;
BOOL isChecked,pageIncrement,RefreshAllPost;
UIRefreshControl *refreshControl;
HomeCell* headerCell;
CommentCell *detailCell ;
UITapGestureRecognizer *tapgesture;
NSTimer *timer;
CGRect keyboardBounds;
}
@end
@implementation DetailPost

#pragma mark : viewController life cycle Method

-(void)viewDidLoad {
[super viewDidLoad];
webData =[[WebServices alloc]init];
pageNo = 1;
webData.posthandlingdelegate = self;
webData.gettingFeeddelegate = self;
webData.getLikedelegate=self;
appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
m_sharedClass = [CommonMethods sharedInstance];
[self registerCustomCells];
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResultComment) name:@"updatedCommentTable" object:nil];
tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditingView:)];
[self.m_tblView addGestureRecognizer:tapgesture];
spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
[spinner setHidesWhenStopped:YES];
profileIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
[profileIndicator setHidesWhenStopped:YES];
[self performSelector:@selector(gettingQuestiondetail:) withObject:nil afterDelay:0.0];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
[self loadTextViewWithContainerView];
self.m_commentsfeed = [[NSMutableArray alloc]init];
self.m_tblView.hidden =YES;
[spinner setHidden:NO];
spinner.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
[appDelegate.window addSubview:spinner];
}
-(void)viewWillAppear:(BOOL)animated{
[super viewWillAppear:YES];
//    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(calculateleftTime) userInfo:nil  repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
//    [timer fire];
}

-(void)viewDidAppear:(BOOL)animated{
[super viewDidAppear:YES];
 [m_message_txtView setReturnKeyType:UIReturnKeyDefault];hashTagTapAction = ^(NSString *tappedString, NSInteger tag){
};
userHandleTapAction = ^(NSString *tappedString, NSInteger tag){
};
}

-(BOOL)prefersStatusBarHidden{
return NO;
}

-(void)viewWillDisappear:(BOOL)animated{
[super viewWillDisappear:YES];
//[timer invalidate];
[spinner stopAnimating];
[spinner setHidden:YES];
[spinner removeFromSuperview];
    
}

-(void)viewDidDisappear:(BOOL)animated{
[super viewDidDisappear:YES];
}

-(void)endEditingView:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
//MARK:  back button Action
- (IBAction)m_backAction:(id)sender {
[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark : TableView DataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }
    else if (section==1){
    return self.m_commentsfeed.count;
}
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returncell;
    static NSString *cellIdentifier ;
    if(indexPath.section == 0){
        cellIdentifier = @"cell1";
    }
    else if (indexPath.section == 1){
        cellIdentifier = @"cell2";
    }
    HomeCell *headerCell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CommentCell *detailCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.section == 0) {
        if(headerCell == nil){
            headerCell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        tableView.separatorColor=[UIColor clearColor];
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [headerCell.m_buttonvoting setSelected:YES]; // here needed
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        headerCell.btn_commentSections.hidden =YES;
        headerCell.m_hoursLabel.hidden =YES;
        headerCell.m_trophy_one.hidden =YES;
        headerCell.m_trophy_two.hidden = YES;
        headerCell.first_visualView.alpha =0.7f;
        headerCell.second_visualView.alpha =0.7f;
       [headerCell.m_buttonvoting setImage:[UIImage imageNamed:@"blue_voting"] forState:UIControlStateSelected];
        [headerCell.m_buttonComment setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [headerCell.m_buttonShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [headerCell.m_buttonComment setTag:911];
        [headerCell.m_buttonShare setTag:912];
        [headerCell.m_buttonvoting addTarget:self action:@selector(poll_ActionConfigure:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell.m_buttonComment addTarget:self action:@selector(hitFirstSectionButton:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell.m_buttonShare addTarget:self action:@selector(hitFirstSectionButton:) forControlEvents:UIControlEventTouchUpInside];
        headerCell.m_headerTitle.text =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"name"]];
        headerCell.m_query.text =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"question"]];
        [headerCell.m_firstchk_box addTarget:self action:@selector(hitVoting:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell.m_secchk_box addTarget:self action:@selector(hitVoting:) forControlEvents:UIControlEventTouchUpInside];
        [CommonMethods  setImageCorner:headerCell.round_profilePic];
        NSInteger timeLeft =[[self.m_response_data valueForKey:@"remainedtime"]intValue];
        NSDate *dateTimeStamp =[NSDate dateWithTimeIntervalSince1970:[[self.m_response_data valueForKey:@"posted_on"]doubleValue]];
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
            headerCell.remainingTime = currentVal;
        }
        if(timeLeft==0){
            [headerCell.m_timeLabel setHidden:YES];
             remainingTime = @"TimeOut";
            headerCell.first_visualView.hidden = YES;
            headerCell.second_visualView.hidden = YES;
            }
        else{
            [headerCell.m_timeLabel setHidden:YES];
            remainingTime =@"";
            headerCell.first_visualView.hidden = NO;
            headerCell.second_visualView.hidden = NO;
            [headerCell calculateRemainingTime];
            headerCell.m_timeLabel.text = [NSString stringWithFormat:@"%@",[m_sharedClass timeLeftString:currentVal]];
        }
     if([[self.m_response_data valueForKey:@"totalvotes"]isEqualToString:@"0"]){
         headerCell.m_countVote.hidden=YES;
            }
     else if ([[self.m_response_data valueForKey:@"totalvotes"]isEqualToString:@"1"]){
         headerCell.m_countVote.hidden = NO;
          headerCell.m_countVote.text = [NSString stringWithFormat:@"%@ vote",[self.m_response_data valueForKey:@"totalvotes"]];
     }
        else{
        headerCell.m_countVote.hidden = NO;
        headerCell.m_countVote.text=[NSString stringWithFormat:@"%@ votes",[self.m_response_data valueForKey:@"totalvotes"]];
   }
        headerCell.m_hashTag.userInteractionEnabled =YES;
        if([[self.m_response_data valueForKey:@"description"]isEqualToString:@""]){
            headerCell.m_hashTag.hidden =YES;
        }
        else{
        headerCell.m_hashTag.hidden = NO;
            headerCell.m_hashTag.text= [NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"description"]];
            if(hashTagTapAction!=nil){
                   [headerCell.m_hashTag enableHashTagDetectionWithAttributes:
                    @{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0], RLTapResponderAttributeName:hashTagTapAction}];
                hashTagTapAction = ^(NSString *tappedString, NSInteger tag){
                        [self.navigationController popViewControllerAnimated:YES];
//                    appDelegate.hashableText = tappedString;
//                    NSLog(@"%@",tappedString);
//                    TabControlSection *tabbarcontroller = (TabControlSection *)self.tabBarController;
//                    [tabbarcontroller setSelectedIndex:1];
                };
            }
            if(userHandleTapAction!=nil){
                   [headerCell.m_hashTag enableUserHandleDetectionWithAttributes:
                    @{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0], RLTapResponderAttributeName:userHandleTapAction}];
            userHandleTapAction = ^(NSString *tappedString, NSInteger tag){
             [self.navigationController popViewControllerAnimated:YES];
            };
            }
        }
        if([self.m_response_data valueForKey:@"picture"]!=nil){
            NSString*profileimg =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"picture"]];
            [headerCell.round_profilePic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",profileimg]]]
                                     placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  headerCell.round_profilePic.image = image;
                                              } failure:nil];
        }
       if([[self.m_response_data valueForKey:@"isivoted"]isEqualToString:@"0"]){
            [headerCell.m_precentageA setHidden: YES];
            [headerCell.m_percentageB setHidden: YES];
            }
        else{
            [headerCell.m_precentageA setHidden: NO];
            [headerCell.m_percentageB setHidden: NO];
            [headerCell.m_precentageA setTitle:[NSString stringWithFormat:@" %@",[self.m_response_data valueForKey:@"votepercentage_a"]] forState:UIControlStateNormal];
            [headerCell.m_percentageB setTitle:[NSString stringWithFormat:@" %@",[self.m_response_data valueForKey:@"votepercentage_b"]] forState:UIControlStateNormal];
    }
        headerCell.m_pic1.contentMode = UIViewContentModeScaleAspectFill;
        headerCell.m_pic1.clipsToBounds=YES;
        headerCell.m_pic2.contentMode = UIViewContentModeScaleAspectFill;
        headerCell.m_pic2.clipsToBounds=YES;
   if([[self.m_response_data valueForKey:@"question_type"]isEqualToString:@"1"]){
            [headerCell.m_pic1 setHidden:NO];
            [headerCell.m_pic2 setHidden:NO];
            [headerCell.m_view1 setHidden:YES];
            [headerCell.m_view2 setHidden:YES];
            headerCell.m_pic1_title.textColor =[UIColor whiteColor];
            headerCell.m_pic2_title.textColor =[UIColor whiteColor];
            NSString *first_imgURL =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"option_a"]];
            NSString *sec_imgURL =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"option_b"]];
            firstlbl_txt = [self.m_response_data valueForKey:@"overtext_a"];
            seclbl_txt = [self.m_response_data valueForKey:@"overtext_b"];
          
            // Image loading with lazy loading
            [headerCell.m_pic1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:first_imgURL]]
                               placeholderImage:[UIImage imageNamed:@"placeholder_A"]
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            headerCell.m_pic1.image = image;
                                        } failure:nil];
            //image 2 uploading with lazy loading
            [headerCell.m_pic2 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sec_imgURL]]
                               placeholderImage:[UIImage imageNamed:@"placeholder_B"]
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            headerCell.m_pic2.image = image;
                                        } failure:nil];
        }
        else{
            [headerCell.m_pic1 setHidden:YES];
            [headerCell.m_pic2 setHidden:YES];
            [headerCell.m_view1 setHidden:NO];
            [headerCell.m_view2 setHidden:NO];
            firstlbl_txt = [self.m_response_data valueForKey:@"option_a"];
            seclbl_txt = [self.m_response_data valueForKey:@"option_b"];
            NSString *first_image_txtColor =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"textcolor_a"]];
            UIColor *first_txt_Color = [m_sharedClass  getUIColorObjectFromHexString:first_image_txtColor alpha:0.9];
            headerCell.m_pic1_title.textColor = first_txt_Color;
            NSString *sec_image_txtColor =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"textcolor_b"]];
            UIColor *sec_txt_Color = [m_sharedClass getUIColorObjectFromHexString:sec_image_txtColor alpha:0.9];
            headerCell.m_pic2_title.textColor = sec_txt_Color;
             NSString *first_view_bgcolor =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"background_a"]];
                UIColor *first_bgColor = [m_sharedClass getUIColorObjectFromHexString:first_view_bgcolor alpha:0.9];
             headerCell.m_view1.backgroundColor = first_bgColor;
             NSString *sec_view_bgcolor =[NSString stringWithFormat:@"%@",[self.m_response_data valueForKey:@"background_b"]];
             UIColor *sec_bgColor = [m_sharedClass getUIColorObjectFromHexString:sec_view_bgcolor alpha:0.9];
             headerCell.m_view2.backgroundColor = sec_bgColor;
        }
        headerCell.m_pic1_title.text =[NSString stringWithFormat:@"%@",firstlbl_txt];
        headerCell.m_pic2_title.text =[NSString stringWithFormat:@"%@",seclbl_txt];
        if([firstlbl_txt isEqualToString:@""]&&[seclbl_txt isEqualToString:@""]){
            headerCell.m_pic1_title.hidden =YES;
            headerCell.m_pic2_title.hidden =YES;
            headerCell.m_static_query.hidden =YES;
        }
        else if ([firstlbl_txt isEqualToString:@""]){
            headerCell.m_pic1_title.hidden =YES;
            headerCell.m_pic2_title.hidden = NO;
            headerCell.m_static_query.hidden =YES;
        }
        else if ([seclbl_txt isEqualToString:@""]){
            headerCell.m_pic1_title.hidden = NO;
            headerCell.m_pic2_title.hidden = YES;
            headerCell.m_static_query.hidden =YES;
        }
        else{
            headerCell.m_pic1_title.hidden = NO;
            headerCell.m_pic2_title.hidden = NO;
            headerCell.m_static_query.text=[NSString stringWithFormat:@"%@ or %@? I cannot decide",firstlbl_txt,seclbl_txt];
        }
        [m_sharedClass adjustlabelheight:headerCell.m_hashTag];
        [m_sharedClass adjustlabelheight:headerCell.m_query];
        [m_sharedClass adjustlabelheight: headerCell.m_pic1_title];
        [m_sharedClass adjustlabelheight: headerCell.m_pic2_title];
        returncell = headerCell;
        }
        else if(indexPath.section == 1){
            if (detailCell == nil){
                detailCell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
        detailCell.selectionStyle =UITableViewCellSelectionStyleNone;
        detailCell.m_roundImage.layer.cornerRadius = detailCell.m_roundImage.frame.size.width/2;
        detailCell.m_roundImage.clipsToBounds = YES;
        NSString *string_url =[[self.m_commentsfeed valueForKey:@"picture"]objectAtIndex:indexPath.row];
            [ detailCell.m_roundImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",string_url]]]
                                     placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  detailCell.m_roundImage.image = image;
      
                                              } failure:nil];
        tableView.separatorColor=[UIColor clearColor];
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, detailCell.frame.size.width, 1)];
            separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
            [detailCell.contentView addSubview:separatorView];
        NSString*m_profileName =[[self.m_commentsfeed objectAtIndex:indexPath.row]valueForKey:@"name"];
        NSString*m_comment = [[self.m_commentsfeed objectAtIndex:indexPath.row]valueForKey:@"comment"];
        NSString*commentSection =[NSString stringWithFormat:@"%@:%@",m_profileName,m_comment];
        NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc]initWithString:commentSection];
           [ attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0]}range:(NSRange){0,m_profileName.length}];
        detailCell.m_comment_lbl.attributedText = attrString;
        detailCell.m_comment_lbl.tag =indexPath.row;
        NSString *likeStatus = [NSString stringWithFormat:@"%@", [[self.m_commentsfeed objectAtIndex:indexPath.row]valueForKey:@"mylikestatus"]];
                    NSDate *dateTimeStamping=[NSDate dateWithTimeIntervalSince1970:[[[self.m_commentsfeed valueForKey:@"commented_at"]objectAtIndex:indexPath.row]doubleValue]];
            NSString* m_commentAt =[NSString stringWithFormat:@"%@ ago",[m_sharedClass timeLeftSinceDate:dateTimeStamping]];
        NSString*likeCount =[[self.m_commentsfeed objectAtIndex:indexPath.row]valueForKey:@"likecount"];
        NSString*replyCount=[[self.m_commentsfeed objectAtIndex:indexPath.row]valueForKey:@"replycount"];
          
        [detailCell.m_time_lbl setText:[NSString stringWithFormat:@"%@",m_commentAt]];
        [detailCell.m_likebutton setTag:indexPath.row];
        if([[[self.m_commentsfeed objectAtIndex:indexPath.row] valueForKey:@"mylikestatus"] integerValue]==1){
                [detailCell.m_likebutton setImage:[UIImage imageNamed:@"blue_like"] forState:UIControlStateNormal];
        }else{
                [detailCell.m_likebutton setImage:[UIImage imageNamed:@"black_like"] forState:UIControlStateNormal];
        }
        [detailCell.m_replybutton setTag:indexPath.row];
            if([replyCount isEqualToString:@"0"]||[replyCount isEqualToString:@"1"]){
                replyCount=[NSString stringWithFormat:@"%@ reply",replyCount];
            }
            else{
                replyCount=[NSString stringWithFormat:@"%@ replies",replyCount];
            }
        [detailCell.m_replybutton setTitle:replyCount forState:UIControlStateNormal];
        [detailCell.m_lblCount setText:[NSString stringWithFormat:@"%@",likeCount]];
        [detailCell.m_replybutton addTarget:self action:@selector(hitReply:) forControlEvents:UIControlEventTouchUpInside];
        [detailCell.m_likebutton  addTarget:self action:@selector(hitLike:) forControlEvents:UIControlEventTouchUpInside];
       tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
       returncell =detailCell;
    }
        return returncell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =0.0f;
    if(indexPath.section==0){
            static NSString *cellIdentifier=@"cell1";
            HomeCell *cell=(HomeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell==nil) {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HomeCell" owner:nil options:nil];
                    cell=[nib objectAtIndex:0];
                }
        NSString *profile_name =[self.m_response_data valueForKey:@"name"];
        NSString*questiontext = [self.m_response_data valueForKey:@"question"];
        NSString *hashtext =[self.m_response_data valueForKey:@"description"];
        CGSize expectedSize = [self sizeForLabel:cell.m_query withText:questiontext];
        CGSize expectedhashSize = [self sizeForLabel:cell.m_hashTag withText:hashtext];
         height = expectedSize.height+expectedhashSize.height+cell.m_pic1.frame.size.height+cell.m_headerTitle.frame.size.height+cell.m_buttonvoting.frame.size.height+cell.round_profilePic.frame.size.height+cell.m_countVote.frame.size.height +40.0f;
      }
    else if(indexPath.section==1){
    static NSString *cellIdentifier=@"cell2";
               CommentCell *cell=(CommentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
               if (cell==nil) {
                       NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:nil options:nil];
                       cell=[nib objectAtIndex:0];
                   }
              CGFloat rowHeight =0.0f;
               NSString *labelText = [[self.m_commentsfeed objectAtIndex:indexPath.row]valueForKey:@"comment"];
               CGSize expectedSize = [self sizeForLabel:cell.m_comment_lbl withText:labelText];
               rowHeight= cell.m_roundImage.frame.size.height+ expectedSize.height+cell.m_replybutton.frame.size.height;
               height = rowHeight;
}
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
    return self.m_tblView.sectionHeaderHeight;
}
// gettting  custom height for label
- (CGSize)sizeForLabel:(UILabel *)label withText:(NSString *)str {
        CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
        CGSize size = [str sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:UILineBreakModeWordWrap];
        return size;
}
-(void)hitReply:(UIButton*)sender{
    CommentSection *comment =INSTANTIATE(COMMENT_SCREEN_VIEW);
    comment.kQuestionId= self.getQuestionId;
    [self.navigationController pushViewController:comment animated:YES];
}

-(void)hitLike:(UIButton*)sender{
    UIButton *clickedButton = (UIButton*)sender;
    NSLog(@"section : %i",clickedButton.tag);
NSString *commentid = [[self.m_commentsfeed objectAtIndex:clickedButton.tag]valueForKey:@"comment_id"];
    if ([[sender imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"black_like"]]) {
        [sender setImage:[UIImage imageNamed:@"blue_like"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"black_like"] forState:UIControlStateNormal];
    }
    NSMutableDictionary *m_hitLike =[NSMutableDictionary new];
     [m_hitLike setObject:commentid forKey:@"comment_id"];
    [webData webserviceshitLikeorUnlike:likeOrUnlikeComment_URL parameters:m_hitLike withheaderSection:appDelegate.array_rawData];
}

#pragma mark: hitting webservices
-(void)gettingQuestiondetail:(NSArray*)parameters{
NSString *questiondetail_URL =[NSString stringWithFormat:@"%@/%@",getQuestionDetail_URL,self.getQuestionId];
[webData gettingFeedResult:questiondetail_URL  parameters:appDelegate.array_rawData];
}

-(void)getResultComment{
    NSString*getComment_URL= [NSString stringWithFormat:@"%@/%@/%d",getComments_URL,self.getQuestionId,pageNo];
       [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [webData gettingFeedResult:getComment_URL  parameters:appDelegate.array_rawData];
    }];
}

-(void)postCommentsOnQuestion:(NSDictionary*)paramz withheaderFile:(NSArray*)headerPath{
      [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [webData webservicesPostData:postComment_URL parameters:paramz withheaderSection:headerPath];
    }];
}
-(void)sendVoteDetailsToBackend{
    NSString *rating_URL =[NSString stringWithFormat:@"%@/%@",votefeed_URL,self.getQuestionId];
    NSMutableDictionary *m_data =[[NSMutableDictionary alloc]init];
    [m_data setObject:self.getQuestionId forKey:@"question_id"];
    [m_data setObject:option_vote forKey:@"option_vote"];
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [webData webservicesPostData:rating_URL parameters:m_data withheaderSection:appDelegate.array_rawData];
    }];

}
- (IBAction)poll_ActionConfigure:(UIButton*)sender {
//    UIButton *button = (UIButton *)sender;
//     HomeCell *cell = [self.m_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    if(![sender isSelected]){
//        sender.selected=YES;
//        [sender setImage:[UIImage imageNamed:@"blue_voting"] forState:UIControlStateSelected];
//        cell.first_visualView.hidden =NO;
//        cell.second_visualView.hidden =NO;
//        cell.first_visualView.alpha = 0.7f;
//        cell.second_visualView.alpha = 0.7f;
//   
//}
//    else{
//         sender.selected=NO;
//         [sender setImage:[UIImage imageNamed:@"receiving"] forState:UIControlStateNormal];
//        cell.first_visualView.hidden = YES;
//        cell.second_visualView.hidden = YES;
//}
}

-(IBAction)hitVoting:(UIButton*)sender {
    if(sender.tag ==201){
    if([remainingTime  isEqualToString:@"TimeOut"]){
  [CommonMethods alertStatus:@"This post has been outdated you can't vote right now":@"" withController:self];
        }
        else{
            if (isChecked){
                isChecked = NO;
                [sender setImage:[UIImage imageNamed:@"white_blank"] forState:UIControlStateNormal];
//                headerCell.m_countVote.text = [NSString stringWithFormat:@"0 vote"];
            }else{
                isChecked = YES;
                [sender setImage:[UIImage imageNamed:@"white_check"] forState:UIControlStateNormal];
                option_vote =@"1";
                [self sendVoteDetailsToBackend];
            }
        }
    }
      else if (sender.tag==202){
        if([remainingTime  isEqualToString:@"TimeOut"]){
            [CommonMethods alertStatus:@"This post has been outdated you can't vote right now" :@"" withController:self];
        }
        else{
                if (isChecked){
                isChecked = NO;
                [sender setImage:[UIImage imageNamed:@"white_blank"] forState:UIControlStateNormal];
//                headerCell.m_countVote.text= [NSString stringWithFormat:@"0 vote"];
            }else{
                isChecked = YES;
                [sender setImage:[UIImage imageNamed:@"white_check"] forState:UIControlStateNormal];
                option_vote=@"2";
                [self sendVoteDetailsToBackend];
            }
            
        }
    }
}

//MARK: Registering Tableview

-(void)registerCustomCells{
    [self.m_tblView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier: @"cell1"];
    [self.m_tblView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier: @"cell2"];
    self.m_tblView.dataSource = self;
    self.m_tblView.delegate = self;
}

#pragma mark : handling get Method delegate
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
NSString*statusCode =[responseData valueForKey:@"status"];
NSString *methodName =[responseData valueForKey:@"method"];
if([methodName isEqualToString:@"viewquestion"]){
    if([statusCode intValue]==200){
    if([responseData count]>0){
          self.m_response_data =[responseData valueForKey:@"data"];
        if([[self.m_response_data valueForKey:@"totalcomments"]isEqualToString:@"0"]){
            NSLog(@"No comment found");
        }
        else{
            [self getResultComment];
        }
    }
    else{
    dispatch_async(dispatch_get_main_queue(), ^{
           kAlertView(@"", @"No data found!");
    });
    }
    }
    else{
    dispatch_async(dispatch_get_main_queue(), ^{
      [CommonMethods alertView:self title:@"Error!" message:error.localizedDescription];
    });
    }
}
else if([methodName isEqualToString:@"getcomments"]){
    if([statusCode intValue]==200){
        totalPages=[responseData valueForKey:@"totalpage"];
        NSString*nextPage =[responseData valueForKey:@"next"];
        NSArray *jsonData =[responseData valueForKey:@"data"];
        if([nextPage isEqualToString:@"0"]){
            pageIncrement =NO;
        }
        else{
            pageIncrement =YES;
        }
        if(RefreshAllPost ==YES){
            [self.m_commentsfeed  removeAllObjects];
               for(int i =0;i<[jsonData count];i++){
                 [self.m_commentsfeed addObject:[jsonData objectAtIndex:i]];
            }
        }
        else{
            [self.m_commentsfeed removeAllObjects];
            for(int i =0;i<[jsonData count];i++){
//                if(![self.m_commentsfeed containsObject:[jsonData objectAtIndex:i]]){
                      [self.m_commentsfeed addObject:[jsonData objectAtIndex:i]];
//                }
            }
        }
    }
}
else{
    NSLog(@"Method name is not matching");
}
dispatch_async(dispatch_get_main_queue(), ^{
     [spinner stopAnimating];
     [spinner setHidden:YES];
     [spinner removeFromSuperview];
    [self.m_tblView reloadData];
    self.m_tblView.hidden = NO;
});

}

#pragma Mark : handling post delegate method

-(void)getPostResult:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*statusCode =[responseDictionary valueForKey:@"status"];
    NSString *methodName =[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"postcomment"]){
        if([statusCode intValue]==200){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getResultComment];
               [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingHomeFeed" object:nil];
    });
        }
        else{
               [CommonMethods alertView:self title:@"Error!" message:error.localizedDescription];
        }
    }
    else if([methodName isEqualToString:@"votequestion"]){
        if([statusCode intValue]==200){
            dispatch_async(dispatch_get_main_queue(), ^{
        HomeCell *cell = [self.m_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.m_countVote.text = [NSString stringWithFormat:@"voted successfully"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingHomeFeed" object:nil];
                 [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    }
}

#pragma Mark : handling Like or Unlike hitting

//getting like feeds delegate handling

-(void)getLikeResult:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*statusCode =[responseDictionary valueForKey:@"status"];
    NSString *methodName =[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"likeunlikecomment"]){
        if([statusCode intValue]==200){
            NSLog(@"Successfully liked");
            [self getResultComment];
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

//MARK: hitActionButton
- (IBAction)hitFirstSectionButton:(UIButton*)sender {
  if (sender.tag==911){
      [sender setImage:[UIImage imageNamed:@"blue_chat"] forState:UIControlStateNormal];
        CommentSection *comment =INSTANTIATE(COMMENT_SCREEN_VIEW);
        comment.kQuestionId = self.getQuestionId;
        [self.navigationController pushViewController:comment animated:YES];
       [sender setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    }
    else if (sender.tag==912){
        [sender setImage:[UIImage imageNamed:@"blue_share"] forState:UIControlStateSelected];
        [self performSelector:@selector(checkActivityController:) withObject:nil afterDelay:0.01];
        [sender setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    }
}

-(void)checkActivityController:(UIButton*)sender{
    NSString *url=@"http://itunes.apple.com/us/app/AvsB/abc001retry";
    NSString * title =[NSString stringWithFormat:@"Download AvsB app %@ and get free reward points!",url];
    NSArray* dataToShare = @[title];
    dispatch_queue_t queue = dispatch_queue_create("openActivityIndicatorQueue", NULL);
    dispatch_async(queue, ^{
            activityController =[[UIActivityViewController alloc]initWithActivityItems:dataToShare applicationActivities:nil];
        activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
            dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityController animated:YES completion:nil];
            [sender setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        });
    });
    [activityController setCompletionHandler:^(NSString *activityType, BOOL completed){
               if (completed){
            NSLog(@"We used activity type%@", activityType);
            [sender setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        }
        else{
            [sender setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
             NSLog(@"We didn't want to share anything after all.");
        }
    }];
}

-(void)loadTextViewWithContainerView{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
      m_message_txtView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.view.frame.size.width-80, 40)];
    m_message_txtView.isScrollable = NO;
    m_message_txtView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
     m_message_txtView.minNumberOfLines = 1;
    m_message_txtView.maxNumberOfLines = 6;
    m_message_txtView.returnKeyType = UIReturnKeyDefault; //just as an example
    m_message_txtView.font = [UIFont systemFontOfSize:15.0f];
    m_message_txtView.delegate = self;
    m_message_txtView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    m_message_txtView.backgroundColor = [UIColor whiteColor];
    m_message_txtView.placeholder = @"Type a comment..";
    m_message_txtView.textColor =[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0];
       [self.view addSubview:containerView];
    UIImage *rawEntryBackground = [UIImage imageNamed:@"message_inputfield"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, self.view.frame.size.width-72, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"message_entry"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    m_message_txtView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview: m_message_txtView];
    [containerView addSubview:entryImageView];
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"message_send"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"message_send_pressed"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    [doneBtn setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn addTarget:self action:@selector(m_postComment:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
- (IBAction)m_postComment:(UIButton*)sender{
    [self.view endEditing:YES];
    NSMutableDictionary *m_commentsData =[[NSMutableDictionary alloc]init];
    if([m_message_txtView.text isEqualToString:@""]){
          kAlertView(@"", @"please enter text first");
         }
    else{
        [m_commentsData setObject:self.getQuestionId forKey:@"question_id"];
        [m_commentsData setObject:m_message_txtView.text forKey:@"comment"];
        [self postCommentsOnQuestion:m_commentsData withheaderFile:appDelegate.array_rawData];
        m_message_txtView.text =@"";
        m_message_txtView.placeholder=@"Type a comment..";
        m_message_txtView.placeholderColor =[UIColor lightGrayColor];
    }
}


//MARK: scroll view delegate methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling > (float)scrollView.contentSize.height || endScrolling == (float)scrollView.contentSize.height){
                 if (pageNo<totalPages&&pageIncrement== YES){
                 pageNo++;
                 [self performSelector:@selector(getResultComment) withObject:nil afterDelay:0.01];
                pageIncrement=NO;
                RefreshAllPost = NO;
        }
    }}

// Resigning textview
-(void)resignTextView{
    [ m_message_txtView resignFirstResponder];
}

//Keyboard show
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
       CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect frame = self.m_tblView.frame;
     containerView.frame = containerFrame;
    // commit animations
    [UIView commitAnimations];
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    if (m_message_txtView) {
    CGRect textViewRect = [self.m_tblView convertRect:m_message_txtView.bounds fromView:m_message_txtView];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
            frame.size.height -= keyboardBounds.size.height;
        else
            frame.size.height -= keyboardBounds.size.width;
         self.m_tblView.frame = frame;
        
    //getting new size of tableview
        if (self.m_commentsfeed.count>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.m_tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.m_tblView numberOfRowsInSection:1]-1) inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
        }   else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.m_tblView numberOfRowsInSection:1]inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }
    }
}

// Keyboard Hide
-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve =    [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
//   CGRect keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
   
    CGRect frame = self.m_tblView.frame;
   
    // Increase size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Retreiving original size of table view
    self.m_tblView.frame = frame;
    // commit animations
    [UIView commitAnimations];
}


-(BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    return YES;

}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    return YES;
}
-(void)calculateleftTime{
    [self.m_tblView reloadData];
}

#pragma mark: Memory usage Warning
- (void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}


@end
