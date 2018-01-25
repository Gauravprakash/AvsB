
//  SearchProfile.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.

#import "SearchProfile.h"

  @interface SearchProfile (){
    SearchViewCell *cell;
    NSMutableArray *arrSearch;
    NSArray *resultArray;
    CGSize cellSize;
    CommonMethods *commonSource;
    WebServices *webData;
    AppDelegate *appDelegate;
    NSString *remainingTime;
    int pageNo,segmentNo,searchpageNo;
    NSString* nextPage, *nextSearchingPage;
    NSString *first_txt_color,*sec_txt_color,*sec_view_color,*first_view_color, *m_userID,*timeline,*img1_URL,*img2_URL ;
    UIColor *first_txtColor,*sec_txtColor,*first_viewColor,* sec_viewColor;
    BOOL pageIncrement,searchPageIncrement,RefreshAllPost;
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *activityIndicator;
    NSString *searchText;
    FollowersProfileCell *shell;
    NSString *searchingText;
    BOOL isSearching;
    UISegmentedControl *m_segment;
    UILabel *m_first_title, *m_second_title, *m_userFound;
    NSTimer *timer;
}
@end
@implementation SearchProfile

#pragma mark: View Life Cycle Methods
-(void)viewDidLoad{
    [super viewDidLoad];
    arrSearch=[[NSMutableArray alloc]init];
    resultArray=[[NSMutableArray alloc]init];
    webData =[[WebServices alloc]init];
    webData.gettingFeeddelegate =self;
    self.dataitems = [[NSMutableArray alloc]init];
    self.m_userFeeddata =[[NSArray alloc]init];
    self.m_usersSearchdata =[[NSMutableArray alloc]init];
    self.m_feedsSearchdata =[[NSArray alloc]init];
    self.m_txtField.delegate=self;
    [self registerNib];
    [self registertableCell];
    CGRect frame =[[UIScreen mainScreen]bounds];
    appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    commonSource=[CommonMethods sharedInstance];
    NSTextAlignment alignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle* alignmentSetting = [[NSMutableParagraphStyle alloc] init];
    alignmentSetting.alignment = alignment;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : alignmentSetting};
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search" attributes: attributes];
    self.m_txtField.attributedPlaceholder = str;
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
//    [self.m_collectionView addSubview:refreshControl];
//    [refreshControl addTarget:self action:@selector(refreshAllEvent) forControlEvents:UIControlEventValueChanged];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self setUpViews];
    m_segment =[self.view viewWithTag:511];
    m_userFound = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width, 21.0f)] ;
    [m_userFound setFont:[UIFont fontWithName:@"ProximaNova-SemiBold" size:10]];
    m_userFound.center = self.view.center;
    m_userFound.adjustsFontSizeToFitWidth = YES;
    m_userFound.adjustsLetterSpacingToFitWidth = YES;
    m_userFound.minimumScaleFactor = 10.0f/12.0f;
    m_userFound.clipsToBounds = YES;
    m_userFound.backgroundColor = [UIColor clearColor];
    m_userFound.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    m_userFound.textAlignment =NSTextAlignmentCenter;
    m_userFound.numberOfLines = 0;
    [self.view addSubview:m_userFound];
    [SVProgressHUD showWithStatus:@"Loading.."];
    self.m_tableView.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    m_userFound.hidden = YES;
     pageNo =1;
    searchpageNo =1;
    segmentNo =1;
    pageIncrement = NO;
    RefreshAllPost =NO;
    searchPageIncrement = NO;
    m_segment.selectedSegmentIndex = 0;
      self.m_tableView.hidden = YES;
   if(appDelegate.hashableText.length>0){
        isSearching =YES;
        self.m_collectionView.hidden = NO;
        self.m_txtField.text=appDelegate.hashableText;
        if(self.m_txtField.text.length>0){
            NSString* encodedUrl = [self.m_txtField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            NSLog(@"%@",encodedUrl);
            NSString* search_URL =[NSString stringWithFormat:@"%@/%@/%d/%ld",SearchQuery_URL,encodedUrl,searchpageNo,(long)segmentNo];
            [webData gettingFeedResult:search_URL parameters:appDelegate.array_rawData];
            [SVProgressHUD showWithStatus:@"Loading.."];
        }
        else{
             self.m_collectionView.hidden = NO;
            NSString* search_URL =[NSString stringWithFormat:@"%@/%@/%d/%ld",SearchQuery_URL,@"null",searchpageNo,(long)segmentNo];
            [webData gettingFeedResult:search_URL parameters:appDelegate.array_rawData];
        }
    }
    else{
        isSearching = NO;
        self.m_collectionView.hidden = NO;
        self.m_txtField.placeholder=@"Search..";
        [self performSelector:@selector(hittingWebServices) withObject:nil afterDelay:0.00];
    }
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
    appDelegate.hashableText =@"";
    self.m_txtField.text=@"";
    [self.view endEditing:YES];
}

#pragma mark - CollectionView
#pragma mark DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(isSearching==YES){
    return 1;
    }
    else{
        return 1;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     if(isSearching==YES){
         return self.m_feedsSearchdata.count;
     }
     else{
      return self.dataitems.count;
     }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"reuseIdentity";
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.borderWidth= 3.0f;
    cell.m_searchCell_img1.layer.borderWidth=0.5f;
    cell.m_searchCell_img2.layer.borderWidth=0.5f;
    cell.m_first_view.layer.borderWidth=0.5f;
    cell.m_second_veiw.layer.borderWidth=0.5f;
    cell.m_searchCell_img1.layer.borderColor =[UIColor colorWithRed:54/255.0 green:129/255.0 blue:220/255.0 alpha:1.0].CGColor;
    cell.m_searchCell_img2.layer.borderColor =[UIColor colorWithRed:54/255.0 green:129/255.0 blue:220/255.0 alpha:1.0].CGColor;
    cell.m_first_view.layer.borderColor=[UIColor colorWithRed:54/255.0 green:129/255.0 blue:220/255.0 alpha:1.0].CGColor;
    cell.m_second_veiw.layer.borderColor =[UIColor colorWithRed:54/255.0 green:129/255.0 blue:220/255.0 alpha:1.0].CGColor;
    cell.layer.borderColor =[UIColor colorWithRed:54/255.0 green:129/255.0 blue:220/255.0 alpha:1.0].CGColor;
    cell.backgroundColor =[UIColor clearColor];
     if(isSearching==YES){
     if([[[self.m_feedsSearchdata objectAtIndex:indexPath.row]valueForKey:@"isivoted"]isEqualToString:@"0"]){
            [cell.m_first_view_lbl setHidden:YES];
            [cell.m_sec_view_lbl setHidden:YES];
        }
        else{
            [cell.m_first_view_lbl setHidden:NO];
            [cell.m_sec_view_lbl setHidden:NO];
            [cell.m_first_view_lbl setTitle:[NSString stringWithFormat:@" %@",[[self.m_feedsSearchdata valueForKey:@"votepercentage_a"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            [cell.m_sec_view_lbl setTitle:[NSString stringWithFormat:@" %@",[[self.m_feedsSearchdata valueForKey:@"votepercentage_b"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        }
        [cell.m_timelabel setHidden:YES];
        NSDate *dateTimeStamping=[NSDate dateWithTimeIntervalSince1970:[[[self.m_feedsSearchdata valueForKey:@"posted_on"]objectAtIndex:indexPath.row] doubleValue]];
        timeline=[NSString stringWithFormat:@"%@ ago",[commonSource timeLeftSinceDate:dateTimeStamping]];
        cell.m_profileDate.text =[NSString stringWithFormat:@"%@",timeline];
        cell.m_first_txtlbl.numberOfLines =2;
        cell.m_sec_txtlbl.numberOfLines=2;
        if([[[self.m_feedsSearchdata objectAtIndex:indexPath.row]valueForKey:@"question_type"]isEqualToString:@"1"]){
            img1_URL =[[self.m_feedsSearchdata valueForKey:@"option_a"]objectAtIndex:indexPath.row];
            img2_URL= [[self.m_feedsSearchdata valueForKey:@"option_b"]objectAtIndex:indexPath.row];
             [cell.m_first_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata valueForKey:@"overtext_a"]objectAtIndex:indexPath.row]]];
             [cell.m_sec_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata valueForKey:@"overtext_b"]objectAtIndex:indexPath.row]]];
             [cell.m_first_txtlbl setTextColor:[UIColor whiteColor]];
             [cell.m_sec_txtlbl setTextColor:[UIColor whiteColor]];
             [cell.m_first_view setHidden:YES];
            [cell.m_second_veiw setHidden:YES];
            [cell.m_searchCell_img1 setHidden:NO];
            [cell.m_searchCell_img2 setHidden:NO];
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
            [cell.contentView bringSubviewToFront:cell.m_profileDate];
                [cell.contentView bringSubviewToFront: cell.m_first_view_lbl];
            [cell.contentView bringSubviewToFront: cell.m_sec_view_lbl];
            [cell.m_first_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata objectAtIndex:indexPath.row]valueForKey:@"option_a"]]];
            [cell.m_sec_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata objectAtIndex:indexPath.row]valueForKey:@"option_b"]]];
            [cell.m_first_view setHidden:NO];
            [cell.m_second_veiw setHidden:NO];
            [cell.m_searchCell_img1 setHidden:YES];
            [cell.m_searchCell_img2 setHidden:YES];
                  [cell.m_first_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata objectAtIndex:indexPath.row]valueForKey:@"option_a"]]];
            [cell.m_sec_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata objectAtIndex:indexPath.row]valueForKey:@"option_b"]]];
            first_txt_color = [NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata valueForKey:@"textcolor_a"]objectAtIndex:indexPath.row]];
            first_txtColor = [commonSource getUIColorObjectFromHexString:first_txt_color alpha:0.9];
            cell.m_first_txtlbl.textColor = first_txtColor;
            sec_txt_color = [NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata valueForKey:@"textcolor_b"]objectAtIndex:indexPath.row]];
            sec_txtColor = [commonSource getUIColorObjectFromHexString:first_txt_color alpha:0.9];
            cell.m_sec_txtlbl.textColor = sec_txtColor;
            first_view_color = [NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata valueForKey:@"background_a"]objectAtIndex:indexPath.row]];
            first_viewColor=[commonSource getUIColorObjectFromHexString:first_view_color alpha:0.9];
            cell.m_first_view.backgroundColor = first_viewColor;
            sec_view_color = [NSString stringWithFormat:@"%@",[[self.m_feedsSearchdata valueForKey:@"background_b"]objectAtIndex:indexPath.row]];
            sec_viewColor=[commonSource getUIColorObjectFromHexString:sec_view_color alpha:0.9];
            cell.m_second_veiw.backgroundColor = sec_viewColor;
        }
    }
    else{
    if([[[self.dataitems objectAtIndex:indexPath.row]valueForKey:@"isivoted"]isEqualToString:@"0"]){
        [cell.m_first_view_lbl setHidden:YES];
        [cell.m_sec_view_lbl setHidden:YES];
    }
    else{
        [cell.m_first_view_lbl setHidden:NO];
        [cell.m_sec_view_lbl setHidden:NO];
        [cell.m_first_view_lbl setTitle:[NSString stringWithFormat:@" %@",[[self.dataitems valueForKey:@"votepercentage_a"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        [cell.m_sec_view_lbl setTitle:[NSString stringWithFormat:@" %@",[[self.dataitems valueForKey:@"votepercentage_b"]objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    }
        [cell.m_timelabel setHidden:YES];
    NSDate *dateTimeStamping=[NSDate dateWithTimeIntervalSince1970:[[[self.dataitems valueForKey:@"posted_on"]objectAtIndex:indexPath.row] doubleValue]];
    timeline=[NSString stringWithFormat:@"%@ ago",[commonSource timeLeftSinceDate:dateTimeStamping]];
    cell.m_profileDate.text =[NSString stringWithFormat:@"%@",timeline];
    if([[[self.dataitems objectAtIndex:indexPath.row]valueForKey:@"question_type"]isEqualToString:@"1"]){
        img1_URL =[[self.dataitems valueForKey:@"option_a"]objectAtIndex:indexPath.row];
        img2_URL= [[self.dataitems valueForKey:@"option_b"]objectAtIndex:indexPath.row];
        [cell.m_first_view setHidden:YES];
        [cell.m_second_veiw setHidden:YES];
        [cell.m_searchCell_img1 setHidden:NO];
        [cell.m_searchCell_img2 setHidden:NO];
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
        [cell.contentView bringSubviewToFront:cell.m_profileDate];
        [cell.contentView bringSubviewToFront: cell.m_first_view_lbl];
        [cell.contentView bringSubviewToFront: cell.m_sec_view_lbl];
        [cell.m_first_view setHidden:NO];
        [cell.m_second_veiw setHidden:NO];
        [cell.m_searchCell_img1 setHidden:YES];
        [cell.m_searchCell_img2 setHidden:YES];
      [cell.m_first_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.dataitems objectAtIndex:indexPath.row]valueForKey:@"option_a"]]];
        [cell.m_sec_txtlbl setText:[NSString stringWithFormat:@"%@",[[self.dataitems objectAtIndex:indexPath.row]valueForKey:@"option_b"]]];
        first_txt_color = [NSString stringWithFormat:@"%@",[[self.dataitems valueForKey:@"textcolor_a"]objectAtIndex:indexPath.row]];
        first_txtColor = [commonSource getUIColorObjectFromHexString:first_txt_color alpha:0.9];
        cell.m_first_txtlbl.textColor = first_txtColor;
        sec_txt_color = [NSString stringWithFormat:@"%@",[[self.dataitems valueForKey:@"textcolor_b"]objectAtIndex:indexPath.row]];
        sec_txtColor = [commonSource getUIColorObjectFromHexString:first_txt_color alpha:0.9];
        cell.m_first_txtlbl.textColor = first_txtColor;
        first_view_color = [NSString stringWithFormat:@"%@",[[self.dataitems valueForKey:@"background_a"]objectAtIndex:indexPath.row]];
        first_viewColor=[commonSource getUIColorObjectFromHexString:first_view_color alpha:0.9];
        cell.m_first_view.backgroundColor = first_viewColor;
        sec_view_color = [NSString stringWithFormat:@"%@",[[self.dataitems valueForKey:@"background_b"]objectAtIndex:indexPath.row]];
        sec_viewColor=[commonSource getUIColorObjectFromHexString:sec_view_color alpha:0.9];
        cell.m_second_veiw.backgroundColor = sec_viewColor;
         }
    }
   return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.01f; //Replace the divisor with the column count requirement. Make sure to have it in float.
    float cellHeight =0.0f;
    if(screenRect.size.width ==320.0f){
        cellHeight = 80.0f;
    }
    else{
        cellHeight = 102.0f;
    }
    
    cellSize = CGSizeMake(cellWidth, cellHeight);
    return cellSize;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.5f;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      DetailPost *detail = INSTANTIATE(DETAIL_POST_VIEW)
      NSString*questionId=@"";
    if(isSearching==YES){
   questionId =[[self.m_feedsSearchdata valueForKey:@"question_id"]objectAtIndex:indexPath.row];
  }else{
   questionId =[[self.dataitems valueForKey:@"question_id"]objectAtIndex:indexPath.row];
 }
    detail.getQuestionId= questionId;
[self.navigationController pushViewController:detail animated:YES];
}
// hitting webservices to backend
-(void)hittingWebServices{
    NSLog(@"%d",pageNo);
    NSString *post_URL =[NSString stringWithFormat:@"%@%d",homefeed_URL,pageNo];
    [webData gettingFeedResult:post_URL parameters:appDelegate.array_rawData];
    }

#pragma mark : TableView dataSource Method and Delegatemethod

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isSearching==YES){
        return self.m_usersSearchdata.count;
    }
    else{
        NSLog(@"%lu",self.m_userFeeddata.count);
        return self.m_userFeeddata.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"followersData";
    shell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!shell){
        shell = [[FollowersProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    tableView.separatorColor=[UIColor clearColor];
    shell.selectionStyle =UITableViewCellSelectionStyleNone;
    UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, shell.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    shell.m_buttonFolllow.tag=indexPath.row;
    [shell.contentView addSubview:separatorView];
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [CommonMethods setImageCorner:shell.m_imageFollowers];
    if(isSearching==YES){
    shell.m_profileName.text =[NSString stringWithFormat:@"%@",[[self.m_usersSearchdata objectAtIndex:indexPath.row]valueForKey:@"name"]];
    NSString*profile_url =[[self.m_usersSearchdata objectAtIndex:indexPath.row]valueForKey:@"picture"];
    [shell.m_imageFollowers setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:profile_url]]
                                 placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              shell.m_imageFollowers.image = image;
                                          } failure:nil];
    }
    else{
        shell.m_profileName.text =[NSString stringWithFormat:@"%@",[[self.m_userFeeddata objectAtIndex:indexPath.row]valueForKey:@"name"]];
        NSString*profile_url =[[self.m_userFeeddata objectAtIndex:indexPath.row]valueForKey:@"picture"];
        [shell.m_imageFollowers setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:profile_url]]
                                      placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   shell.m_imageFollowers.image = image;
                                               } failure:nil];
  
    }
    shell.m_buttonFolllow.hidden =YES;
    return shell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *profile_data =@"";
    if(isSearching==YES){
   profile_data = [[self.m_usersSearchdata valueForKey:@"id"]objectAtIndex:indexPath.row];
    }
else{
   profile_data = [[self.m_userFeeddata valueForKey:@"id"]objectAtIndex:indexPath.row];
}
    NSString*myId = [appDelegate.signup_resultant valueForKey:@"id"];
    if([profile_data isEqualToString:myId]){
        TabControlSection *tabbarcontroller = (TabControlSection *)self.tabBarController;
        [tabbarcontroller setSelectedIndex:4];
      }
    else{
    SearchUsersProfile *search= INSTANTIATE(SEARCH_USERS_PROFILE);
    if(isSearching==YES){
    if([[[self.m_usersSearchdata objectAtIndex:indexPath.row]valueForKey:@"my_follow_stauts"]isEqualToString:@"1"]){
        search.buttonTitle = @"Following";
    }
    else{
        search.buttonTitle = @"Follow";
    }
        }else{
    if([[[self.m_userFeeddata objectAtIndex:indexPath.row]valueForKey:@"my_follow_stauts"]isEqualToString:@"1"]){
                search.buttonTitle = @"Following";
        }
            else{
                search.buttonTitle = @"Follow";
        }
     
}
    search.profile_id = profile_data;
    [self.navigationController pushViewController:search animated:YES];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

#pragma mark: handling delegate of response
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSString*statusCode =[responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"gethomequestions"]){
        if([statusCode intValue]==200){
             NSArray *array_data = [responseData objectForKey:@"data"];
             if ([array_data count]>0){
                [m_userFound setHidden:YES];
                [self.m_collectionView setHidden:NO];
                if (RefreshAllPost==YES) {
                [self.dataitems removeAllObjects];
                for(int i= 0; i<array_data.count;i++){
                [self.dataitems addObject:[array_data objectAtIndex:i]];
                }
            }
                else{
                    for(int i =0;i<[array_data count];i++){
                        if(![self.dataitems containsObject:[array_data objectAtIndex:i]]){
                        [self.dataitems addObject:[array_data objectAtIndex:i]];
                        }
                }
            }
                self.totalPages  =  [[responseData objectForKey:@"totalpage"] integerValue];
                nextPage =[responseData valueForKey:@"next"];
                if([nextPage isEqualToString:@""]||[nextPage isEqualToString:@" "]){
                    pageIncrement =NO;
                }
                else{
                    pageIncrement =YES;
                }
                NSLog(@"%d",self.totalPages);
                   dispatch_async(dispatch_get_main_queue(),^{
                    [self.m_collectionView reloadData];
                    [self.m_collectionView setHidden:NO];
                });
            }
         else{
                dispatch_async(dispatch_get_main_queue(), ^{\
                    [m_userFound setHidden:NO];
                    [m_userFound setText:@"No post found.."];
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                kAlertView(@"No Network", @"Error in connection..");
            });
        }
    }
    else if([methodName isEqualToString:@"globalSearch"]){
        if([statusCode intValue]==200){
            self.searchingtotalPage = [[responseData objectForKey:@"totalpage"] integerValue];
            NSString*nextPage = [responseData valueForKey:@"next"];
            if ([nextPage isEqualToString:@"0"]||[nextPage isEqualToString:@""]) {
                searchPageIncrement = NO;
            }
            else{
                 searchPageIncrement = YES;
            }
               if([[responseData valueForKey:@"section"]isEqualToString:@"1"]){
                     [self.m_tableView setHidden:YES];
                     self.m_feedsSearchdata = [responseData valueForKey:@"data"];
                      if([self.m_feedsSearchdata count]>0){
                      dispatch_async(dispatch_get_main_queue(), ^{
                        [m_userFound setHidden:YES];
                        [self.m_collectionView reloadData];
                        [self.m_collectionView setHidden:NO];
                      });
                      }
                 else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.m_collectionView setHidden:YES];
                        [m_userFound setHidden: NO];
                        [m_userFound setText:@"No Matching post found.."];
                    });
                }
            }
                else{
                    [self.m_collectionView setHidden:YES];
                    if(isSearching==YES){
                    self.m_usersSearchdata =[responseData valueForKey:@"data"];
                   if([self.m_usersSearchdata count]>0){
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [m_userFound setHidden: YES];
                           [self.m_tableView setHidden:NO];
                           [self.m_tableView reloadData];
                       });
                    }
                   else{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [m_userFound setHidden: NO];
                          [m_userFound setText:@"No such user found.."];
                          [self.m_tableView setHidden:YES];
                      });
                   }
                    }
                    else{
                    self.m_userFeeddata =[responseData valueForKey:@"data"];
                        if ([self.m_userFeeddata count]>0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                            [m_userFound setHidden: YES];
                            [self.m_tableView setHidden:NO];
                            [self.m_tableView reloadData];
                             });
                     }
                        else{
                           dispatch_async(dispatch_get_main_queue(), ^{
                            [self.m_tableView setHidden:YES];
                            [m_userFound setHidden: NO];
                            [m_userFound setText:@"Users list not found.."];
   });
}
}
}
}
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
            [CommonMethods alertView:self title:@"Error!" message:[responseData valueForKey:@"message"]];
            });
        }
    }
    else{
        NSLog(@"method Name is wṙong");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
     [SVProgressHUD dismiss];
    });
    
}
#pragma mark : Textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.m_txtButton.hidden=YES;
    self.m_cancelbtn.hidden=NO;

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.m_txtButton.hidden=YES;
    self.m_cancelbtn.hidden=YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString*search_URL= @"";
    self.m_cancelbtn.hidden=NO;
    self.m_txtButton.hidden=YES;
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (searchStr.length > 0) {
    NSLog(searchStr);
    NSString* encodedUrl = [searchStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSLog(@"%@",encodedUrl);
        search_URL =[NSString stringWithFormat:@"%@/%@/%d/%ld",SearchQuery_URL,encodedUrl,searchpageNo,(long)segmentNo];
        isSearching=YES;
    }
        else{
    search_URL =[NSString stringWithFormat:@"%@/%@/%d/%ld",SearchQuery_URL,@"null",searchpageNo,(long)segmentNo];
    isSearching=NO;
    }
    [self sendinghttpdetailstobackendforsearchingtext:search_URL];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.m_cancelbtn.hidden=NO;
    return YES;
}
- (IBAction)m_cancelAction:(id)sender{
     self.m_txtField.text=@"";
    [self.view endEditing:YES];
    [self.m_txtField resignFirstResponder];
    self.m_txtButton.hidden=NO;
    self.m_cancelbtn.hidden=YES;
    isSearching = NO;
    if(segmentNo==1){
    segmentNo = 1;
   [self performSelector:@selector(hittingWebServices) withObject:nil afterDelay:0.00];
    }
    else{
        segmentNo = 2;
        NSString* search_URL =[NSString stringWithFormat:@"%@/%@/%d/%ld",SearchQuery_URL,@"null",searchpageNo,(long)segmentNo];
        [webData gettingFeedResult:search_URL parameters:appDelegate.array_rawData];
    }
    [m_userFound setHidden:YES];
}


//custom Method
-(void)setUpViews{
    self.m_txtField.layer.cornerRadius=5.0f;
    self.m_txtField.clipsToBounds=YES;
    self.m_txtButton.userInteractionEnabled=NO;
    self.m_cancelbtn.userInteractionEnabled=YES;
    self.m_txtButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 0.0f);
    self.m_txtField.textColor=[UIColor blueColor];
    [self.m_txtButton setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
    self.m_cancelbtn.hidden=YES;
    [CommonMethods addPaddingView:self.m_txtField];
}

-(void)registerNib{
[self.m_collectionView registerNib:[UINib nibWithNibName:@"SearchViewCell" bundle:nil] forCellWithReuseIdentifier:@"reuseIdentity"];
self.m_collectionView.backgroundColor = [UIColor clearColor];
self.m_collectionView.dataSource = self;
self.m_collectionView.delegate = self;
self.m_collectionView.showsVerticalScrollIndicator =YES;
self.m_collectionView.showsHorizontalScrollIndicator = YES;
self.m_collectionView.alwaysBounceVertical = YES;
}

- (void)registertableCell{
    UINib*nib=[UINib nibWithNibName:@"FollowersProfileCell" bundle:nil];
    [self.m_tableView registerNib:nib forCellReuseIdentifier:@"followersData"];
    self.m_tableView.backgroundColor = [UIColor clearColor];
    self.m_tableView.showsVerticalScrollIndicator =YES;
    self.m_tableView.dataSource=self;
    self.m_tableView.delegate=self;
}

-(void)refreshAllEvent{
[self performSelector:@selector(refreshAllData) withObject:nil afterDelay:0.00];
}
-(void)refreshAllData{
    pageNo =1;
    RefreshAllPost =YES;
    [refreshControl endRefreshing];
    NSString *post_URL =[NSString stringWithFormat:@"%@%d",homefeed_URL,pageNo];
    [webData gettingFeedResult:post_URL parameters:appDelegate.array_rawData];
}

#pragma mark- Scrollview Delegates ..............................................

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height);
    if (endScrolling > (float)scrollView.contentSize.height || endScrolling == (float)scrollView.contentSize.height){
        if(segmentNo == 1){
         if (pageNo<self.totalPages&&pageIncrement== YES){
            pageNo++;
            [self performSelector:@selector(hittingWebServices) withObject:nil afterDelay:0.00];
            pageIncrement=NO;
            RefreshAllPost=NO;
      }
        }
        else if (segmentNo == 2){
            if(searchpageNo<self.searchingtotalPage&&searchPageIncrement == YES){
                searchpageNo++;
                NSString* encodedUrl = [self.m_txtField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                NSLog(@"%@",encodedUrl);
                NSString* search_URL =[NSString stringWithFormat:@"%@/%@/%d/%ld",SearchQuery_URL,encodedUrl,searchpageNo,(long)segmentNo];
                [webData gettingFeedResult:search_URL parameters:appDelegate.array_rawData];
                searchPageIncrement = NO;
                RefreshAllPost = NO;
            }
        }
    }
}
-(void)sendinghttpdetailstobackendforsearchingtext:(NSString*)searching_URL{
    NSLog(@"%@",searching_URL);
     [webData gettingFeedResult:searching_URL parameters:appDelegate.array_rawData];
}

#pragma mark : Segment Control Action
- (IBAction)m_segmentDetails:(UISegmentedControl*)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_userFound setHidden:YES];
            self.m_collectionView.hidden = NO;
            self.m_tableView.hidden = YES;
        });
        segmentNo = 1;
       
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
         [m_userFound setHidden:YES];
        self.m_collectionView.hidden = YES;
        self.m_tableView.hidden = YES;
        });
        segmentNo = 2;
    }
    if(self.m_txtField.text.length>0){
        NSString* encodedUrl = [self.m_txtField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSLog(@"%@",encodedUrl);
        NSString* search_URL =[NSString stringWithFormat:@"%@/%@/%d/%ld",SearchQuery_URL,encodedUrl,searchpageNo,(long)segmentNo];
        [webData gettingFeedResult:search_URL parameters:appDelegate.array_rawData];
    }
    else{
        NSString* search_URL =[NSString stringWithFormat:@"%@/%@/%d/%ld",SearchQuery_URL,@"null",searchpageNo,(long)segmentNo];
        [webData gettingFeedResult:search_URL parameters:appDelegate.array_rawData];
    }
    if(segmentNo==2){
       [SVProgressHUD showWithStatus:@"Loading.."];
    }
}

-(void)hideKeyboard{
//    [self.view endEditing:YES];
}
-(void)calculateRemainingTimeSearch{
    [self.m_collectionView reloadData];
}

# pragma mark => Memory usage warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
