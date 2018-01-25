//
//  RateController.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 06/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "RateController.h"

@interface RateController (){
    BOOL isChecked,pageIncrement,RefreshAllPost;
    getReplyOnComment* shell;
    NSString*rating_URL;
    NSString *option_vote;
    NSMutableDictionary *m_data;
    AppDelegate*appDelegate;
    WebServices *webClass;
    UIActivityIndicatorView *spinner;
    CommonMethods* commonMethod;
    UIActivityViewController *activityController;
    UIActivityIndicatorView *indicator_View, *firstActivityIndicator, *secondActivityIndicator;
    PatternTapResponder hashTagTapAction;
    NSString *remainingTime;
    NSString *firstlbl_txt;
    NSString *seclbl_txt;
    UILabel * m_first_title, *m_second_title;
    NSMutableDictionary *m_commentData;
    NSInteger totalPages;
    int pageNo;
    UIRefreshControl *refreshControl;
}
@end

@implementation RateController

#pragma Mark : View Controller Life Cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self registerCommentView];
    UIActivityIndicatorView *firstActivityIndicator, *secondActivityIndicator;
    CGRect frame=[[UIScreen mainScreen]bounds];
    webClass=[[WebServices alloc]init];
    webClass.posthandlingdelegate = self;
    webClass.gettingFeeddelegate = self;
    isChecked=NO;
    m_data=[[NSMutableDictionary alloc]init];
    m_first_title = [self.view viewWithTag:904];
    m_second_title = [self.view viewWithTag:905];
     appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    commonMethod=[CommonMethods sharedInstance];
    [self.m_voting setSelected:YES];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor =  [UIColor clearColor];
    refreshControl.tintColor = [UIColor colorWithRed:55/255.0f green:129/255.0f blue:221/255.0f alpha:1.0];
    self.m_commentdata =[[NSMutableArray alloc]init];
    [self.m_commentfeed addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshnewPost)
             forControlEvents:UIControlEventValueChanged];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat x3 = (self.m_commentfeed.frame.size.width- spinner.frame.size.width)/2;
    CGFloat y3 = (self.m_commentfeed.frame.size.height-spinner.frame.size.height)/2;
    spinner.frame = CGRectMake(x3, y3,spinner.frame.size.width, spinner.frame.size.height);
//  [self loadTextViewWithContainerViewSupport];
    [self performSelectorOnMainThread:@selector(hittingWebServices) withObject:nil waitUntilDone:YES];
    indicator_View = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    firstActivityIndicator =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
      secondActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator_View setHidden:NO];
    [firstActivityIndicator setHidden:NO];
    [secondActivityIndicator setHidden:NO];
    m_data =[[NSMutableDictionary alloc]init];
    m_commentData = [[NSMutableDictionary alloc]init];
    CGFloat x = (self.m_profilePic.frame.size.width-indicator_View.frame.size.width)/2;
    CGFloat y = (self.m_profilePic.frame.size.height-indicator_View.frame.size.height)/2;
    CGFloat x1 = (self.m_image1.frame.size.width - firstActivityIndicator.frame.size.width)/2;
    CGFloat y1 = (self.m_image1.frame.size.height - firstActivityIndicator.frame.size.height)/2;
    CGFloat x2 = (self.m_image2.frame.size.width - secondActivityIndicator.frame.size.width)/2;
    CGFloat y2 = (self.m_image2.frame.size.height - secondActivityIndicator.frame.size.height)/2;
    indicator_View.frame = CGRectMake(x, y, indicator_View.frame.size.width, indicator_View.frame.size.height);
    firstActivityIndicator.frame = CGRectMake(x1, y1, firstActivityIndicator.frame.size.width, firstActivityIndicator.frame.size.height);
    secondActivityIndicator.frame = CGRectMake(x2, y2, secondActivityIndicator.frame.size.width, secondActivityIndicator.frame.size.height);
    [indicator_View startAnimating];
    [firstActivityIndicator startAnimating];
    [secondActivityIndicator startAnimating];
    indicator_View.center = CGPointMake(self.m_profilePic.frame.size.width /2, self.m_profilePic.frame.size.height/2);
    firstActivityIndicator.center = CGPointMake(self.m_image1.frame.size.width /2, self.m_image1.frame.size.height/2);
    [self.m_profilePic addSubview:indicator_View];
    [self.m_image1 addSubview:firstActivityIndicator];
    [self.m_image2 addSubview:secondActivityIndicator];
    [self loadTextViewWithContainerViewSupport];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     [self setUpViews];
     if([[self.m_responseData valueForKey:@"totalcomments"]isEqualToString:@"0"]){
        self.m_commentfeed.hidden =YES;
    }
    else{
        [self performSelector:@selector(getCommentFeed) withObject:nil afterDelay:0.01];
    }
    pageNo =1;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.m_voting setSelected:YES];
    self.m_headingQuery.text = @"";
    [self.m_voting setImage:[UIImage imageNamed:@"blue_voting"] forState:UIControlStateSelected];
    [self.m_voting setImage:[UIImage imageNamed:@"receiving"] forState:UIControlStateNormal];
    [self.m_chat setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    self.m_scrollView.showsVerticalScrollIndicator=YES;
    m_first_title.hidden = YES;
    m_second_title.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    hashTagTapAction = ^(NSString *tappedString, NSInteger tag) {
        kAlertView(@"", @"No post found for such Tags");
    };

    }
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.m_scrollView.contentSize =self.view.frame.size;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [self.m_scrollView addSubview:self.m_subView];//if the contentView is not already inside your scrollview in your xib/StoryBoard doc
//        self.m_scrollView.contentSize = self.m_subView.frame.size;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
    [indicator_View stopAnimating];
    [indicator_View removeFromSuperview];
}
- (IBAction)m_backControl:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)poll_Action:(UIButton*)sender {
    UIButton *button = (UIButton *)sender;
    if(![sender isSelected]){
        sender.selected=YES;
        [self.m_voting setImage:[UIImage imageNamed:@"blue_voting"] forState:UIControlStateSelected];
        self.m_visualEffect_one.hidden=NO;
        self.m_visualEffect_two.hidden=NO;
    }
    else{
         sender.selected=NO;
        [self.m_voting setTintColor:[UIColor clearColor]];
        [self.m_voting setImage:[UIImage imageNamed:@"receiving"] forState:UIControlStateNormal];
        self.m_visualEffect_one.hidden=YES;
        self.m_visualEffect_two.hidden=YES;
    }
}
- (IBAction)m_Chat:(UIButton*)sender {
[sender setImage:[UIImage imageNamed:@"blue_chat"] forState:UIControlStateNormal];
CommentSection *comment = INSTANTIATE(COMMENT_SCREEN_VIEW);
    NSLog(@"%@",self.getQuestion_Id);
comment.kQuestionId = self.getQuestion_Id;
[self.navigationController pushViewController:comment animated:YES];
[sender setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
}

-(IBAction)m_Sharing:(UIButton*)sender{
[sender setImage:[UIImage imageNamed:@"blue_share"] forState:UIControlStateNormal];
[self setActivityController];
}
-(void)setActivityController{
    NSString *url=@"http://itunes.apple.com/us/app/AvsB/abc001retry";
    NSString * title =[NSString stringWithFormat:@"Download AvsB app %@ and get free reward points!",url];
    NSArray* dataToShare = @[title];
    dispatch_queue_t queue = dispatch_queue_create("openActivityIndicatorQueue", NULL);
    dispatch_async(queue, ^{
        activityController =[[UIActivityViewController alloc]initWithActivityItems:dataToShare applicationActivities:nil];
        activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
            dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityController animated:YES completion:nil];
            [self.m_sharing setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        });
    });
    [activityController setCompletionHandler:^(NSString *activityType, BOOL completed){
         if (completed){
         NSLog(@"We used activity type%@", activityType);
        [self.m_sharing setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        }
        else{
            [self.m_sharing setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
             NSLog(@"We didn't want to share anything after all.");
        }
    }];
}

- (IBAction)setCheckImage:(UIButton*)sender {
    if(sender.tag ==201){
        if([remainingTime  isEqualToString:@"TimeOut"]){
    [CommonMethods alertStatus:@"This post has been outdated you can't vote right now":@"" withController:self];
            }
        else{
          if (isChecked) {
                isChecked = NO;
                [self.m_firstImage_checkBox  setImage:[UIImage imageNamed:@"white_blank"] forState:UIControlStateNormal];
                self.m_voteCount.text = [NSString stringWithFormat:@"0 vote"];
            }else{
                isChecked = YES;
                [self.m_firstImage_checkBox  setImage:[UIImage imageNamed:@"white_check"] forState:UIControlStateNormal];
                option_vote=@"1";
                [self sendVotingDetailsToBackend];
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
                [self.m_secondImage_checkBox  setImage:[UIImage imageNamed:@"white_blank"] forState:UIControlStateNormal];
                self.m_voteCount.text = [NSString stringWithFormat:@"0 vote"];
            }else{
                isChecked = YES;
                [self.m_secondImage_checkBox  setImage:[UIImage imageNamed:@"white_check"] forState:UIControlStateNormal];
                option_vote=@"2";
                [self sendVotingDetailsToBackend];
            }

        }
    }
}

#pragma mark: setUpViews

-(void)setUpViews{
    self.m_hashTag.userInteractionEnabled = YES;
//    [self.m_hashTag enableHashTagDetectionWithAttributes:
//     @{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0], RLTapResponderAttributeName:hashTagTapAction}];
    self.textView.delegate=self;
    self.textView.editable=YES;
    self.m_visualEffect_one.alpha=0.8f;
    self.m_visualEffect_two.alpha=0.8f;
    self.m_visualEffect_one.hidden=NO;
    self.m_visualEffect_two.hidden=NO;
    [CommonMethods setImageCorner:self.m_profilePic];
    [commonMethod adjustlabelheight:self.m_hashTag];
    [commonMethod adjustlabelheight:self.m_votingQuery];
    [commonMethod adjustlabelheight:m_first_title];
    [commonMethod adjustlabelheight:m_second_title];
    self.m_image1.contentMode=UIViewContentModeScaleAspectFill;
    self.m_image2.contentMode =UIViewContentModeScaleAspectFill;
    self.m_image1.clipsToBounds=YES;
    self.m_image2.clipsToBounds=YES;
}

//set CustomView
-(void)setCustomView{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSString*profile_name =[self.m_responseData valueForKey:@"name"];
                self.m_headinglabel.text=[NSString stringWithFormat:@"%@",profile_name];
                NSString*text_query =[self.m_responseData valueForKey:@"question"];
                self.m_headingQuery.text=[NSString stringWithFormat:@"%@",text_query];
                NSInteger timeLeft =[[self.m_responseData valueForKey:@"remainedtime"]intValue];
                remainingTime = [NSString stringWithFormat:@"%@",[commonMethod timeLeftString:timeLeft]];
            
                if([remainingTime isEqualToString:@""]||[remainingTime isEqualToString:@" "]){
                    [self.m_timeLabel setHidden:YES];
                        remainingTime = @"TimeOut";
                }
                else{
                    [self.m_timeLabel setHidden: NO];
                    [self.m_timeLabel setText:remainingTime];
                }
                
                if([[self.m_responseData valueForKey:@"totalvotes"]isEqualToString:@"1"]){
                    self.m_voteCount.text=[NSString stringWithFormat:@"%@ vote",[self.m_responseData valueForKey:@"totalvotes"]];
                }
                else if ([[self.m_responseData valueForKey:@"totalvotes"]isEqualToString:@"0"]){
                    self.m_voteCount.text=[NSString stringWithFormat:@"No voted"];
                }
                else{
                    self.m_voteCount.text=[NSString stringWithFormat:@"%@ votes",[self.m_responseData valueForKey:@"totalvotes"]];
                }
                if([[self.m_responseData valueForKey:@"description"]isEqualToString:@""]){
                    self.m_hashTag.hidden =YES;
                }
                else{
                    self.m_hashTag.hidden = NO;
                    self.m_hashTag.text= [NSString stringWithFormat:@"%@",[self.m_responseData valueForKey:@"description"]];
                    self.m_hashTag.userInteractionEnabled =YES;
                    //    [self.m_hashtaglbl enableHashTagDetectionWithAttributes:
                    //     @{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0], RLTapResponderAttributeName:hashTagTapAction}];
                }
                if([self.m_responseData valueForKey:@"picture"]!=nil){
                    NSString*profileimg =[NSString stringWithFormat:@"%@",[self.m_responseData valueForKey:@"picture"]];
                    [self.m_profilePic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:profileimg]]
                                               placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                            self.m_profilePic.image = image;
                                                            [indicator_View stopAnimating];
                                                             [indicator_View setHidden:YES];
                                                            [indicator_View removeFromSuperview];
                                                        } failure:nil];
                }
                
                if([[self.m_responseData valueForKey:@"question_type"]isEqualToString:@"1"]){
                    self.m_view_one.hidden=YES;
                    self.m_view_sec.hidden =YES;
                    self.m_image1.hidden = NO;
                    self.m_image2.hidden= NO;
                    [firstActivityIndicator setHidden:NO];
                    [secondActivityIndicator setHidden:NO];
                    NSString *first_imgURL =[NSString stringWithFormat:@"%@",[self.m_responseData valueForKey:@"option_a"]];
                    NSString *sec_imgURL =[NSString stringWithFormat:@"%@",[self.m_responseData valueForKey:@"option_b"]];
                    [self.m_image1 bringSubviewToFront:m_first_title];
                    [self.m_image2 bringSubviewToFront:m_second_title];
                    [self.m_image1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:first_imgURL]]
                                             placeholderImage:[UIImage imageNamed:@"placeholder_A"]
                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                          self.m_image1.image = image;
                                                          [firstActivityIndicator stopAnimating];
                                                           [firstActivityIndicator setHidden:YES];
                                                          [firstActivityIndicator removeFromSuperview];
                                                      } failure:nil];
                    
                    [self.m_image2 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sec_imgURL]]
                                           placeholderImage:[UIImage imageNamed:@"placeholder_B"]
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                       self.m_image2.image = image;
                                                        [secondActivityIndicator stopAnimating];
                                                         [secondActivityIndicator setHidden:YES];
                                                        [secondActivityIndicator removeFromSuperview];
                                                    } failure:nil];
                    self.m_image1.contentMode = UIViewContentModeScaleAspectFill;
                    self.m_image1.clipsToBounds = YES;
                    self.m_image2.contentMode = UIViewContentModeScaleAspectFill;
                    self.m_image2.clipsToBounds = YES;
                    m_second_title.textColor =[UIColor whiteColor];
                   m_first_title.textColor =[UIColor whiteColor];
                }
                else{
                    [firstActivityIndicator setHidden:YES];
                    [secondActivityIndicator setHidden:YES];
                    self.m_view_one.hidden= NO;
                    self.m_view_sec.hidden = NO;
                    self.m_image1.hidden = YES;
                    self.m_image2.hidden= YES;
                    [self.m_view_one bringSubviewToFront:m_first_title];
                    [self.m_view_sec bringSubviewToFront:m_second_title];
                    firstlbl_txt = [self.m_responseData valueForKey:@"option_a"];
                    seclbl_txt = [self.m_responseData valueForKey:@"option_b"];
                    NSString *first_image_txtColor =[NSString stringWithFormat:@"%@",[self.m_responseData valueForKey:@"textcolor_a"]];
                    UIColor *first_txt_Color = [commonMethod getUIColorObjectFromHexString:first_image_txtColor alpha:0.9];
                          m_first_title.textColor = first_txt_Color;
                    NSString *sec_image_txtColor =[NSString stringWithFormat:@"%@",[self.m_responseData valueForKey:@"textcolor_b"]];
                    UIColor *sec_txt_Color = [commonMethod getUIColorObjectFromHexString:sec_image_txtColor alpha:0.9];
                    m_second_title.textColor = sec_txt_Color;
                     NSString *first_view_bgcolor =[NSString stringWithFormat:@"%@",[self.m_responseData valueForKey:@"background_a"]];
                        UIColor *first_bgColor = [commonMethod getUIColorObjectFromHexString:first_view_bgcolor alpha:0.9];
                       self.m_view_one.backgroundColor = first_bgColor;
                        NSString *sec_view_bgcolor =[NSString stringWithFormat:@"%@",[self.m_responseData valueForKey:@"background_b"]];
                       UIColor *sec_bgColor = [commonMethod getUIColorObjectFromHexString:sec_view_bgcolor alpha:0.9];
                      self.m_view_sec.backgroundColor = sec_bgColor;
                }
                if([firstlbl_txt isEqualToString:@""]){
                m_first_title.hidden = YES;
                }
                else{
                    m_first_title.hidden = NO;
                    m_first_title.text =[NSString stringWithFormat:@"%@",firstlbl_txt];
                }
                
                if([seclbl_txt isEqualToString:@""]){
                    m_second_title.hidden = YES;
                }
                else{
                     m_second_title.hidden = YES;
                    m_second_title.text =[NSString stringWithFormat:@"%@",seclbl_txt];
                }
                
                if([firstlbl_txt isEqualToString:@""]&&[seclbl_txt isEqualToString:@""]){
                    m_first_title.hidden = YES;
                   m_second_title.hidden = YES;
                }
                else{
                    m_first_title.hidden = NO;
                    m_second_title.hidden = NO;
                }
//                else{
                self.m_votingQuery.hidden = NO;
                self.m_votingQuery.text =[NSString stringWithFormat:@"%@ or %@? I can not decide.",firstlbl_txt,seclbl_txt];
//                }
            });
        });
}


-(void)sendDetailsForVotingWebService:(NSMutableDictionary*)parameters withHeader:(NSArray*)headerFile{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [webClass webservicesPostData:rating_URL parameters:parameters withheaderSection:headerFile];
    }];
}

-(void)sendVotingDetailsToBackend{
    rating_URL =[NSString stringWithFormat:@"%@/%@",votefeed_URL,self.getQuestion_Id];
    [m_data setObject:self.getQuestion_Id forKey:@"question_id"];
    [m_data setObject:option_vote forKey:@"option_vote"];
    [self sendDetailsForVotingWebService:m_data withHeader:appDelegate.array_rawData];
}

#pragma mark: handling delegate response
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSString*statusCode =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"viewquestion"]){
        if([statusCode intValue]==200){
            if([responseData count]>0){
                 self.m_responseData =[responseData valueForKey:@"data"];
                   [self setCustomView];
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
                NSString*nextPage =[responseData valueForKey:@"next"];
            NSArray *jsonData =[responseData valueForKey:@"data"];
                if([nextPage isEqualToString:@"0"]){
                    pageIncrement =NO;
                }
                else{
                    pageIncrement =YES;
                }
                if(RefreshAllPost ==YES){
                [self.m_commentdata  removeAllObjects];
               for(int i =0;i<[jsonData count];i++){
             [self.m_commentdata addObject:[jsonData objectAtIndex:i]];
                    }
                }
        else{
            for(int i =0;i<[jsonData count];i++){
                if(![self.m_commentdata containsObject:[jsonData objectAtIndex:i]]){
                      [self.m_commentdata addObject:[jsonData objectAtIndex:i]];
                }
            }
        }
      
            dispatch_async(dispatch_get_main_queue(), ^{
                     [spinner stopAnimating];
                     [spinner setHidden:YES];
                     [spinner removeFromSuperview];
                    [self.m_commentfeed reloadData];
                    self.m_commentfeed.hidden = NO;
                });
            }
               
    }
else{
        NSLog(@"Method name is not matching");
    }
}

//MARK: handling Post delegate response
-(void)getPostResult:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString *statusCode =[responseDictionary valueForKey:@"status"];
    NSString *methodName=[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"votequestion"]){
        if([statusCode intValue]==200){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_voteCount.text = [NSString stringWithFormat:@"voted successfully"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingHomeFeed" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [CommonMethods alertView:self title:@"Error!" message:error.localizedDescription];
        }
        [SVProgressHUD dismiss];
    }
    else if([methodName isEqualToString:@"postcomment"]){
        if([statusCode intValue]==200){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getCommentFeed];
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
    else{
        NSLog(@"Method name not matched");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [SVProgressHUD dismiss];
        self.m_visualEffect_one.hidden=YES;
        self.m_visualEffect_two.hidden=YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//sending post comment to backend to handle forward button
-(void)sendcommentforhttpserver{
    if(![m_message_txtView.text isEqualToString:@""]){
        spinner.hidden =NO;
        [spinner startAnimating];
        spinner.center =self.m_commentfeed.center;
        [self.view addSubview:spinner];
        [m_commentData setObject:self.getQuestion_Id forKey:@"question_id"];
        [m_commentData setObject:m_message_txtView.text forKey:@"comment"];
     [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [webClass webservicesPostData:postComment_URL parameters:m_commentData withheaderSection:appDelegate.array_rawData];
    }];
    
    }
    else{
        kAlertView(@"", @"Text can't be empty");
    }
}

#pragma mark : load textview programatically
-(void)loadTextViewWithContainerViewSupport{
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
    [doneBtn addTarget:self action:@selector(m_button_pushComment:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

// push comment
-(IBAction)m_button_pushComment:(UIButton*)sender{
    [self.view endEditing:YES];
    [self sendcommentforhttpserver];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [appDelegate.window endEditing:YES];
}

#pragma Mark : Keyboard hiding and showing functionalities 

-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion

    CGRect keyboardBounds;
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
    // set views with new info
    containerView.frame = containerFrame;
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
    // commit animations
    [UIView commitAnimations];
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

#pragma Mark :Tableview Datasource and Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
   }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.m_commentdata.count > 0){
     return self.m_commentdata.count;
}
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
            NSString *m_comment =[[self.m_commentdata valueForKey:@"comment"]objectAtIndex:indexPath.row];
            NSString *m_username =[[self.m_commentdata valueForKey:@"name"] objectAtIndex: indexPath.row];
            NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@: %@",m_username,m_comment]];
            [attrString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:50/255.0 green:82/255.0 blue:213/255.0 alpha:1.0]}range:(NSRange){0,m_username.length}];
               shell.m_comment.attributedText = attrString;
              NSString *profile_URL =[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[self.m_commentdata objectAtIndex:indexPath.row]valueForKey:@"picture"]]];
           [shell.m_profilepic setImageWithURLRequest:[NSURLRequest requestWithURL:profile_URL]
                                     placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                       shell.m_profilepic.image = image;
                                              }
                                              failure:nil];
      [CommonMethods setImageCorner:shell.m_profilepic];
         return shell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString*text =[[self.m_commentdata objectAtIndex:indexPath.row]valueForKey:@"comment"];
       CGFloat height=[text length];
       CGFloat rowHeight= shell.m_profilepic.frame.size.height+ height;
       return rowHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void)registerCommentView{
    UINib *replyNib =[UINib nibWithNibName:@"getReplyOnComment" bundle:nil];
    [self.m_commentfeed registerNib:replyNib forCellReuseIdentifier:@"reuseidentity"];
    self.m_commentfeed.delegate=self;
    self.m_commentfeed.dataSource=self;
}

#pragma mark: hitting web service
    -(void)hittingWebServices{
        NSString *questiondetail_URL =[NSString stringWithFormat:@"%@/%@",getQuestionDetail_URL,self.getQuestion_Id];
        [webClass gettingFeedResult:questiondetail_URL  parameters:appDelegate.array_rawData];
}
-(void)getCommentFeed{
        NSString*getComment_URL= [NSString stringWithFormat:@"%@/%@/%d",getComments_URL,self.getQuestion_Id,pageNo];
           [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [webClass gettingFeedResult:getComment_URL  parameters:appDelegate.array_rawData];
}];
}

#pragma mark- Scrollview Delegates  ................

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.m_commentfeed){
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        NSLog(@"%.2f",endScrolling);
        NSLog(@"%.2f",scrollView.contentSize.height);
        if (endScrolling > (float)scrollView.contentSize.height || endScrolling == (float)scrollView.contentSize.height){
              [spinner startAnimating];
            self.m_commentfeed.tableFooterView.hidden=NO;
            self.m_commentfeed.tableFooterView = spinner;
              spinner.frame = CGRectMake(0, 0,self.m_commentfeed.frame.size.width, 60);
                         if (pageNo<totalPages&&pageIncrement== YES){
                         pageNo++;
                 [self performSelector:@selector(getCommentFeed) withObject:nil afterDelay:0.01];
                pageIncrement=NO;
                RefreshAllPost = NO;
            }
        }
    }}

-(void)refreshnewPost{
     pageNo =1;
     RefreshAllPost = YES;
    [refreshControl endRefreshing];
    [self performSelector:@selector(getCommentFeed) withObject:nil afterDelay:0.01];
    self.m_commentfeed.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
}

# pragma Mark : Memory Usage Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
