//
//  CommentSection.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 19/06/17.  // if section is
//  Copyright © 2017 Techwin Labs. All rights reserved.


#import "CommentSection.h"

@implementation CommentSection{
    getReplyOnComment* shell;
    NSMutableArray* headerSectionTitles;
    NSArray *m_header_text_label;
    NSArray*m_profile_round_pic;
    NSArray*m_estimated_text_label;
    NSArray *m_array_second_cell_elements;
    AppDelegate *appDelegate;
    UIView *viewToAdd;
    UITextView* txt_view;
    WebServices *webClass;
    int pageNumber;
    NSInteger totalPages;
    BOOL loadingMoreComments, loadingMoreReplies,refreshAllComments;
    int sectionCount;
    UIRefreshControl *refreshControl;
    NSMutableString*getComment_URL;
    NSString*m_commentTime ,*m_username ,*m_userComment,*likeCount, *replyCount, *commentId,*nextPage;
    CommonMethods*commonMethods;
    UIButton*hitLikeOrUnLike;
    NSURL *profile_URL;
    BOOL allowsMultipleSelection, replyTarget, isSelected;
    int section;
    UIButton *clickedButton;
    UIActivityIndicatorView *spinner;
    UILabel *m_likeCount;
    NSMutableArray *testHeaderArray;
    UIImageView *m_profile_Image;
    UILabel *label;
    CGRect keyboardBounds;
    CGFloat sectionHeaderHeight;
}

# pragma mark : Life Cycle Methods

-(void)viewDidLoad{
    [super viewDidLoad];
    testHeaderArray= [[NSMutableArray alloc]init];
    [self RegisterNibFile];
    self.hidesBottomBarWhenPushed=YES;
    pageNumber = 1;
    isSelected=NO;
    replyTarget=NO;
    refreshAllComments = NO;
    loadingMoreComments = NO;
    loadingMoreReplies = NO;
    allowsMultipleSelection = YES;
    self.expandedSections = [NSMutableArray array];
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.m_commentsFeed=[[NSMutableArray alloc]init];
    self.m_repliesFeed=[[NSMutableArray alloc]init];
    self.m_Comment_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGRect frame =[[UIScreen mainScreen]bounds];
    label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width, 21.0f)] ;
    [label setFont:[UIFont fontWithName:@"ProximaNova-SemiBold" size:10]];
    [label setText:[NSString stringWithFormat:@"No comments found.."]];
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
    shell.m_reply_txtview.delegate=self;
    webClass=[[WebServices alloc]init];
    self.m_commentsData=[[NSMutableDictionary alloc]init];
    self.m_repliesData=[[NSMutableDictionary alloc]init];
    self.m_hitLikeData=[[NSMutableDictionary alloc]init];
    webClass.gettingFeeddelegate=self;
    webClass.posthandlingdelegate=self;
    webClass.getLikedelegate=self;
    webClass.gettingreplydelegate=self;
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor =  [UIColor clearColor];
    refreshControl.tintColor = [UIColor colorWithRed:55/255.0f green:129/255.0f blue:221/255.0f alpha:1.0];
    [self.m_Comment_tableView addSubview:refreshControl];
//    self.m_Comment_tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        // Setting Frame of Spinner..
    [refreshControl addTarget:self action:@selector(refreshAllComments)
             forControlEvents:UIControlEventValueChanged];
    [self.m_Comment_tableView addSubview:refreshControl];
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner setHidesWhenStopped:YES];
  commonMethods=[CommonMethods sharedInstance];
    NSLog(@"question id = %@",self.kQuestionId);
    [self getCommentsFeed];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.m_Comment_tableView addGestureRecognizer:gestureRecognizer];
    //sectionButtonTouchUpInside
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self loadTextViewWithContainerView];
    self.m_Comment_sectionView.layer.borderWidth=0.5f;
    self.m_Comment_tableView.layer.borderWidth=0.5f;
    self.m_Comment_sectionView.layer.borderUIColor=[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    self.m_Comment_tableView.layer.borderUIColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    [label setHidden:YES];
    [m_message_txtView setReturnKeyType:UIReturnKeyDefault];
    [m_message_txtView setDelegate:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [spinner setHidden:NO];
    spinner.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [appDelegate.window addSubview:spinner];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
    [SVProgressHUD dismiss];
    [spinner setHidden:YES];
    [spinner removeFromSuperview];
    [m_message_txtView resignFirstResponder];
    replyTarget = NO;
}

# pragma mark: Tableview datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.self.m_commentsFeed.count > 0) {
        self.m_Comment_tableView.backgroundView = nil;
        return self.m_commentsFeed.count;
    }
    else {
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSNumber *currentSection = [NSNumber numberWithInt:section];
    if ([self.expandedSections containsObject:currentSection])
        return self.m_repliesFeed.count;
    else
        return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier= @"reuseidentity";
    shell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!shell){
        shell =[[getReplyOnComment alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
          }
            shell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.showsHorizontalScrollIndicator =NO;
            tableView.showsVerticalScrollIndicator = YES;
            tableView.separatorColor=[UIColor clearColor];
            tableView.bounces =YES;
            NSString *m_comment =[[self.m_repliesFeed  valueForKey:@"comment"]objectAtIndex:indexPath.row];
            NSString *m_username =[[self.m_repliesFeed  valueForKey:@"name"] objectAtIndex: indexPath.row];
            NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@: %@",m_username,m_comment]];
            [attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0]}range:(NSRange){0,m_username.length}];
        shell.m_comment.attributedText = attrString;
        NSString *profile_URL =[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[self.m_repliesFeed objectAtIndex:indexPath.row]valueForKey:@"picture"]]];
         [shell.m_profilepic setImageWithURLRequest:[NSURLRequest requestWithURL:profile_URL]
                            placeholderImage:[UIImage imageNamed:@"imgg4"]
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              shell.m_profilepic.image = image;
                                     }
                                     failure:nil];
        [CommonMethods setImageCorner:shell.m_profilepic];
         return shell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *cellIdentifier=@"reuseidentity";
        getReplyOnComment *cell=(getReplyOnComment *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"getReplyOnComment" owner:nil options:nil];
                cell=[nib objectAtIndex:0];
      }
    NSString *textHeight =[[self.m_repliesFeed objectAtIndex:indexPath.row]valueForKey:@"comment"];
   CGFloat height=[textHeight length];
   CGFloat rowHeight= cell.m_profilepic.frame.size.height+ height;
   return rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)self.view;
    NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"SectionHeaderView" owner:self options:nil];
    viewToAdd = [viewArray objectAtIndex:0];
    viewToAdd.tag=section;
    UILabel *commentTitle=(UILabel*)[viewToAdd viewWithTag:152];
    [commentTitle setNumberOfLines:0];
    UIImageView *m_image =(UIImageView*)[viewToAdd viewWithTag:155];
    NSString *labelText = [[self.m_commentsFeed objectAtIndex:section]valueForKey:@"comment"];
//    CGSize expectedSize = [self sizeForLabel:commentTitle withText:labelText];
     sectionHeaderHeight = m_image.frame.size.height+ labelText.length+commentTitle.frame.size.height;
    return sectionHeaderHeight;
}

//Adjust label Height
- (CGSize)sizeForLabel:(UILabel *)label withText:(NSString *)str{
        CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
        CGSize size = [str sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:UILineBreakModeWordWrap];
        return size;
}
- (IBAction)m_backAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)self.view;
    CGRect sepFrame = CGRectMake(0, self.view.frame.size.height-1, self.view.frame.size.width, 1);
    NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"SectionHeaderView" owner:self options:nil];
    viewToAdd = [viewArray objectAtIndex:0];
    viewToAdd.tag=section;
    [viewToAdd layoutIfNeeded];
    m_userComment=[[self.m_commentsFeed objectAtIndex:section]valueForKey:@"comment"];
    m_username=[[self.m_commentsFeed objectAtIndex:section]valueForKey:@"name"];
    NSDate *dateTimeStamping=[NSDate dateWithTimeIntervalSince1970:[[[self.m_commentsFeed valueForKey:@"commented_at"]objectAtIndex:section]doubleValue]];
    m_commentTime =[NSString stringWithFormat:@"%@ ago",[commonMethods timeLeftSinceDate:dateTimeStamping]];
    likeCount =[[self.m_commentsFeed objectAtIndex:section]valueForKey:@"likecount"];
    replyCount=[[self.m_commentsFeed objectAtIndex:section]valueForKey:@"replycount"];
    UILabel *commentTitle=(UILabel*)[viewToAdd viewWithTag:152];
       NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@: %@",m_username,m_userComment]];
       [attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0]}range:(NSRange){0,m_username.length}];
    if([replyCount isEqualToString:@"0"]||[replyCount isEqualToString:@"1"]){
        replyCount=[NSString stringWithFormat:@"%@ reply",replyCount];
    }
    else{
        replyCount=[NSString stringWithFormat:@"%@ replies",replyCount];
     }
    NSString *likeStatus = [NSString stringWithFormat:@"%@", [[self.m_commentsFeed objectAtIndex:section]valueForKey:@"mylikestatus"]];
    [commentTitle setAttributedText:attrString];
    [commonMethods adjustlabelheight:commentTitle];
    UIButton *reply_button = (UIButton*)[viewToAdd viewWithTag:153];
    [reply_button setTag:section];
    [reply_button setTitle:replyCount forState:UIControlStateNormal];
    [reply_button addTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *comment_time=(UILabel*)[viewToAdd viewWithTag:154];
    comment_time.text=[NSString stringWithFormat:@"%@",m_commentTime];
    m_profile_Image=(UIImageView*)[viewToAdd viewWithTag:155];
    [CommonMethods setImageCorner:m_profile_Image];
    m_profile_Image.image =nil;
    profile_URL =[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[self.m_commentsFeed objectAtIndex:section]valueForKey:@"picture"]]];
    [ m_profile_Image setImageWithURLRequest:[NSURLRequest requestWithURL:profile_URL]
                       placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         m_profile_Image.image = image;
                                }
                                failure:nil];
    CGFloat height = m_profile_Image.frame.size.height+ m_userComment.length;
        viewToAdd.frame = CGRectMake(0, 0, self.view.frame.size.width,height);
    m_likeCount=(UILabel*)[viewToAdd viewWithTag:160];
 //   [m_likeCount setTag:section];
    [m_likeCount setText:[NSString stringWithFormat:@"%@",likeCount]];
    hitLikeOrUnLike=(UIButton*)[viewToAdd viewWithTag:157];
    [hitLikeOrUnLike setTag:section];
    if([[[self.m_commentsFeed objectAtIndex:section] objectForKey:@"mylikestatus"] integerValue]==1){
        [hitLikeOrUnLike setImage:[UIImage imageNamed:@"blue_like"] forState:UIControlStateNormal];
    }else{
         [hitLikeOrUnLike setImage:[UIImage imageNamed:@"black_like"] forState:UIControlStateNormal];
    }
   [hitLikeOrUnLike addTarget:self action:@selector(hitLikeMethod:) forControlEvents:UIControlEventTouchUpInside];
    if (![testHeaderArray containsObject:viewToAdd]){
        [testHeaderArray addObject:viewToAdd];
    }
   return  viewToAdd;
}

// hit like or unlike the comment
-(void)hitLikeMethod:(UIButton*)sender{
    UIButton *clickedButton = (UIButton*)sender;
    NSLog(@"section : %i",clickedButton.tag);
 NSString *commentid = [[self.m_commentsFeed objectAtIndex:clickedButton.tag]valueForKey:@"comment_id"];
    if ([[sender imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"black_like"]]) {
        [sender setImage:[UIImage imageNamed:@"blue_like"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"black_like"] forState:UIControlStateNormal];
    }
     [self.m_hitLikeData setObject:commentid forKey:@"comment_id"];
     [webClass webserviceshitLikeorUnlike:likeOrUnlikeComment_URL parameters:self.m_hitLikeData withheaderSection:appDelegate.array_rawData];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView‌​.contentOffset.y>=0) {
//          scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight){
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0); }
//}

# pragma mark  => Textview delegates

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Type a comment.."]||[textView.text isEqualToString:@"post your reply.."]){
        textView.text = @"";
        textView.textColor = [UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:12.0/255.0 alpha:1.0];
        [[NSNotificationCenter defaultCenter]postNotificationName:UIKeyboardDidShowNotification object:nil];
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if(replyTarget==YES){
        if([textView.text isEqualToString:@""]){
            textView.text = @"post your reply..";
            textView.textColor = [UIColor lightGrayColor];
        }
    }
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Type a comment..";
        textView.textColor = [UIColor lightGrayColor]; 
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:UIKeyboardWillHideNotification object:nil];
      [textView resignFirstResponder];
}

//MARK: web services calling

// get comment feeds
-(void)getCommentsFeed{
    getComment_URL=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@/%@/%d",getComments_URL,self.kQuestionId,pageNumber]];
   [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    [webClass gettingFeedResult:getComment_URL  parameters:appDelegate.array_rawData];
    }];
}
//get replies feeds
-(void)getRepliesFeed:(NSArray*)parameters withSectionCount:(NSInteger)sectionCount{
    commentId = [[self.m_commentsFeed objectAtIndex:sectionCount]valueForKey:@"comment_id"];
    NSLog(@"%@",commentId);
    NSString*getreply_URL =[NSString stringWithFormat:@"%@/%@/%d",getReplies_URL,commentId,pageNumber];
    parameters=appDelegate.array_rawData;
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    [webClass gettingReplyFeedResult: getreply_URL  parameters:parameters];
    }];
}
//hit like or unlike the comment
-(void)hitLikeOrUnlikeComment:(NSDictionary *)paramz withheaderFile:(NSArray*)headerPath{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [webClass webserviceshitLikeorUnlike:likeOrUnlikeComment_URL parameters:headerPath withheaderSection:headerPath];
 }];
}

// post comment on question
-(void)postCommentsOnQuestion:(NSDictionary*)parameters withheaderFile:(NSArray*)headerPath{
  [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [webClass webservicesPostData:postComment_URL parameters:parameters withheaderSection:headerPath];
    }];
}

//post reply on comment
-(void)postReplyOnComments:(NSDictionary*)parameters withheaderFile:(NSArray*)headerPath{
   [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [webClass webservicesPostData:postReply_URL parameters:parameters withheaderSection:headerPath];
    }];
}

#pragma mark : handling delegate
-(void)gettingFeed:(NSDictionary*)responseData error:(NSError *)error{
    NSString*statusCode =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"getcomments"]){
        if([statusCode intValue]==200){
           [[NSNotificationCenter defaultCenter]postNotificationName:@"updatedCommentTable" object:nil];
            self.m_commentsFeed =[responseData objectForKey:@"data"];
            nextPage =[responseData valueForKey:@"next"];
            if([nextPage isEqualToString:@""]||[nextPage isEqualToString:@"0"]){
                loadingMoreComments = NO;
               }
            else{
                loadingMoreComments = YES;
               }
            totalPages = [[responseData valueForKey:@"totalpage"]integerValue];
            NSLog(@"%d",totalPages);
            if([self.m_commentsFeed count]>0){
                dispatch_async(dispatch_get_main_queue(), ^{
               [self.m_Comment_tableView reloadData];
               [label setHidden:YES];
                NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.m_Comment_tableView]);
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                [self.m_Comment_tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
                });
               }
              else{
                dispatch_async(dispatch_get_main_queue(), ^{
                          [label setHidden:NO];
                });
              }
            }
      else{
        dispatch_async(dispatch_get_main_queue(), ^{
       [CommonMethods alertView:self title:@"Error!" message:error.localizedDescription];
        });
     }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner stopAnimating];
        [spinner setHidden:YES];
        [spinner removeFromSuperview];
    });
}

-(void)gettingreplyFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSString*statusCode =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"getreplyoncomment"]){
        if([statusCode intValue]==200){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updatedCommentTable" object:nil];
            self.m_repliesFeed =[responseData valueForKey:@"data"];
            if([self.m_repliesFeed count]>0){
                NSNumber *currentSection = [NSNumber numberWithInt:section];
                    [self.m_Comment_tableView beginUpdates];
                if ([self.expandedSections containsObject:currentSection]) {
                    [self.expandedSections removeObject:currentSection];
                    [self deleteRowsInSection:currentSection.intValue];
                    if(![m_message_txtView.text isEqualToString:@""]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            m_message_txtView.text =@"";
                        });
                    }}
            else{
                    if (!allowsMultipleSelection) {
                        [self.expandedSections removeAllObjects];
                        [self deleteAllRows];
                    }
                    [self.expandedSections addObject:currentSection];
                    [self insertRowsInSection:currentSection.intValue];
//                    replyTarget =YES;
                    if(![m_message_txtView.text isEqualToString:@""]){
                    dispatch_async(dispatch_get_main_queue(), ^{
//                     m_message_txtView.text =@"";
//                    m_message_txtView.placeholder = @"post your reply..";
                    });
                   }
            }
        dispatch_async(dispatch_get_main_queue(), ^{
                   [self.m_Comment_tableView endUpdates];
                     [spinner stopAnimating];
                     [spinner setHidden:YES];
                     [spinner removeFromSuperview];
                });
            }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
//                m_message_txtView.placeholder = @"post your reply..";
            });
        }}
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [CommonMethods alertStatus:[responseData valueForKey:@"message"] :@"" withController:self];
            });
        }}
        else{
            NSLog(@"Method name is not matching..");
        
        }
}
//getting like feeds delegate handling

-(void)getLikeResult:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*statusCode =[responseDictionary valueForKey:@"status"];
    NSString *methodName =[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"likeunlikecomment"]){
        if([statusCode intValue]==200){
            NSLog(@"Successfully liked");
            NSString * count_like =[responseDictionary valueForKey:@"likecount"];
            likeCount =[NSString stringWithFormat:@"%@",count_like];
            [self getCommentsFeed];
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

// handling post delegate
-(void)getPostResult:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*statusCode =[responseDictionary valueForKey:@"status"];
    NSString *methodName =[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"postcomment"]){
        if([statusCode intValue]==200){
            dispatch_async(dispatch_get_main_queue(), ^{
               [self getCommentsFeed];
                [spinner stopAnimating];
                [spinner setHidden:YES];
                [spinner removeFromSuperview];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingHomeFeed" object:nil];
                });
            }
        else{
               [CommonMethods alertView:self title:@"Error!" message:error.localizedDescription];
        }
         }
    else if([methodName isEqualToString:@"postreplyoncomment"]){
        if([statusCode intValue]==200){
            dispatch_async(dispatch_get_main_queue(),^{
                [self getRepliesFeed:appDelegate.array_rawData withSectionCount:section];
                [self getCommentsFeed];
                [spinner stopAnimating];
                [spinner setHidden:YES];
                [spinner removeFromSuperview];
                
            });
        }
        else{
               [CommonMethods alertView:self title:@"Error!" message:error.localizedDescription];
        }}
        else{
            NSLog(@"Method name not matching..");
        }
       [SVProgressHUD dismiss];
}

//**Pagination in TableView //

// Registering Nib file
-(void)RegisterNibFile{
    self.m_Comment_tableView.bounces=NO;
    self.m_Comment_tableView.delegate=self;
    self.m_Comment_tableView.dataSource=self;
    UINib *replyNib =[UINib nibWithNibName:@"getReplyOnComment" bundle:nil];
    [self.m_Comment_tableView registerNib:replyNib forCellReuseIdentifier:@"reuseidentity"];
}
- (IBAction)m_button_forward:(UIButton*)sender {
    [self.view endEditing:YES];
   if(replyTarget==YES){
        if([m_message_txtView.text isEqualToString:@""]){
             [CommonMethods alertStatus:@"please add few text to your reply" :@"" withController:self];
           }
        else{
            [self.m_repliesData setObject:commentId forKey:@"comment_id"];
            [self.m_repliesData setObject:m_message_txtView.text forKey:@"comment"];
            [self postReplyOnComments:self.m_repliesData withheaderFile:appDelegate.array_rawData];
            m_message_txtView.placeholder =@"Type a comment..";
        }
   }else{
            if([m_message_txtView.text isEqualToString:@""]){
            [CommonMethods alertStatus:@"please add few text to your comment" :@"" withController:self];
            }
     else{
    [self.m_commentsData setObject:self.kQuestionId forKey:@"question_id"];
    [self.m_commentsData setObject:m_message_txtView.text forKey:@"comment"];
    [self postCommentsOnQuestion:self.m_commentsData withheaderFile:appDelegate.array_rawData];
    m_message_txtView.placeholder=@"Type a comment..";
    m_message_txtView.placeholderColor =[UIColor lightGrayColor];
    [spinner startAnimating];
    [spinner setCenter:self.m_Comment_tableView.center];
//    [spinner setCenter:CGPointMake(self.m_Comment_tableView.frame.size.width/2, self.m_Comment_tableView.frame.size.height/2)];
    [self.m_Comment_tableView addSubview:spinner];
    [spinner setHidden:NO];

        }
   }
        m_message_txtView.text=@"";
}
//Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [SVProgressHUD dismiss];
        [spinner stopAnimating];
        [spinner setHidden:YES];
        [spinner removeFromSuperview];
}
}

//collapse and expanding rows:
-(void)sectionButtonTouchUpInside:(UIButton*)sender{
    replyTarget =YES;
   m_message_txtView.placeholder = @"post your reply..";
    UIButton *clickedButton = (UIButton*)sender;
    NSLog(@"section : %i",clickedButton.tag);
    [self getRepliesFeed:appDelegate.array_rawData withSectionCount:clickedButton.tag];
    section = clickedButton.tag;
 }

//touches began method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [appDelegate.window  endEditing:YES];
    [self.m_Comment_tableView endEditing:YES];
}

#pragma mark - Private Methods -

- (void)deleteAllRows {
    NSInteger sections = [self.m_Comment_tableView numberOfSections];
    for (int i=0 ; i<sections ; i++) {
        [self deleteRowsInSection:i];
    }
}
- (void)deleteRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = [self.m_Comment_tableView numberOfRowsInSection:section];
    for (int i=0 ; i<numberOfRowsInSection ; i++) {
        NSIndexPath *insertingIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [self.m_Comment_tableView deleteRowsAtIndexPaths:@[insertingIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        m_message_txtView.placeholder = @"Type a comment..";
        replyTarget =NO;
    });
}

- (void)insertRowsInSection:(NSInteger)section {
       for (int i=0 ; i<self.m_repliesFeed.count ; i++) {
        NSIndexPath *insertingIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [self.m_Comment_tableView insertRowsAtIndexPaths:@[insertingIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        m_message_txtView.placeholder = @"post your reply..";
        replyTarget =YES;
    });
  
}

//reloading of tableview components
-(void)reloadData{
    [self.m_Comment_tableView reloadData];
}
//Refresh All data
-(void)refreshAllComments{
    pageNumber=1;
    refreshAllComments =YES;
    [refreshControl endRefreshing];
    [self performSelector:@selector(getCommentsFeed) withObject:nil afterDelay:0.01];
    self.m_Comment_tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
}
// Tap Gesture method
- (void)hideKeyboard{
    [self.view endEditing:YES];
}


//MARK : Third Party usage and its delegate..

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
    [doneBtn addTarget:self action:@selector(m_button_forward:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

-(void)resignTextView{
[m_message_txtView resignFirstResponder];
}

//Code from Brett Schumann
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
    CGRect frame = self.m_Comment_tableView.frame;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    containerView.frame = containerFrame;
    if (m_message_txtView){
        CGRect textViewRect = [self.m_Comment_tableView convertRect:m_message_txtView.bounds fromView:m_message_txtView];
        float endScrolling = self.m_Comment_tableView.frame.size.height - keyboardBounds.size.height;
        if (self.m_Comment_tableView.contentSize.height>endScrolling) {
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
                frame.size.height -= keyboardBounds.size.height;
            else
                frame.size.height -= keyboardBounds.size.width;
            // Apply new size of table view
            self.m_Comment_tableView.frame = frame;
            NSInteger lastSectionIndex = [self.m_Comment_tableView numberOfSections] - 1;
            NSInteger lastRowIndex = [self.m_Comment_tableView numberOfRowsInSection:lastSectionIndex] - 1;
            NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
            [self.m_Comment_tableView scrollRectToVisible:keyboardBounds animated:YES];
        }
    }
    // commit animations
    [UIView commitAnimations];
}


-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
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
    CGRect frame = self.m_Comment_tableView.frame;
    float endScrolling = self.m_Comment_tableView.frame.size.height - keyboardBounds.size.height;
    if (self.m_Comment_tableView.contentSize.height>endScrolling){
    // Increase size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Resizing  table view
    self.m_Comment_tableView.frame = frame;
    }
    // commit animations
    [UIView commitAnimations];
}
-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
        return YES;
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

#pragma mark- Scrollview Delegates ..............................................

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.m_Comment_tableView){
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        NSLog(@"%.2f",endScrolling);
        NSLog(@"%.2f",scrollView.contentSize.height);
        if (endScrolling > (float)scrollView.contentSize.height || endScrolling == (float)scrollView.contentSize.height){
              [spinner startAnimating];
              self.m_Comment_tableView.tableFooterView.hidden=NO;
              self.m_Comment_tableView.tableFooterView = spinner;
              spinner.frame = CGRectMake(0, 0,self.m_Comment_tableView.frame.size.width, 60);
                if (pageNumber<totalPages&&loadingMoreComments== YES){
                 pageNumber++;
                [self performSelector:@selector(getCommentsFeed) withObject:nil afterDelay:0.5];
                loadingMoreComments = NO;
                 refreshAllComments = NO;
            }
        }
    }
}
# pragma mark => Memory usage
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}





@end
