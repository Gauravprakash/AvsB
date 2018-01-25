//
//  ReviewTask.m
//  AvsB
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "ReviewTask.h"

@interface ReviewTask(){
   CommonMethods *m_Manager;
    BOOL result;
    AppDelegate *appDelegate;
    NSString*text;
    NSArray *m_collection;
    NSMutableArray *FontsArray;
    NSMutableArray*TextNameArray;
    NSString *FontName;
    NSMutableDictionary *data_elements;
    WebServices *webClass;
    CommonMethods *commonMethod;
    NSString *first_viewcolor;
    NSString* sec_viewcolor;
    NSString *first_txtcolor;
    NSString *sec_txtcolor;
    NSString*profile_URL;
    UIImage*profile_image;
    UIActivityIndicatorView *profileIndicatorView;
    PatternTapResponder hashTagTapAction;
}
@end
@implementation ReviewTask

#pragma mark : View Controller Life Cycle
   -(void)viewDidLoad{
    [super viewDidLoad];
    m_Manager=[CommonMethods sharedInstance];
    webClass=[[WebServices alloc]init];
    webClass.questionwithimagedelegate=self;
    webClass.questionwithtextdelegate=self;
    result =NO;
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSData *dataFromDefaults = [appDelegate.userDataStore objectForKey:@"colorPrefernce"];
   data_elements=[[NSMutableDictionary alloc]init];
    self.receivedDict=[[NSMutableDictionary alloc]init];
    self.receivedDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataFromDefaults];
    commonMethod =[CommonMethods sharedInstance];
   profileIndicatorView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat x = (self.m_roundprofilePic.frame.size.width- profileIndicatorView.frame.size.width)/2;
    CGFloat y = (self.m_roundprofilePic.frame.size.height-profileIndicatorView.frame.size.height)/2;
    profileIndicatorView.frame = CGRectMake(x, y,profileIndicatorView.frame.size.width, profileIndicatorView.frame.size.height);
     [self setUpViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton=YES;
    [commonMethod adjustlabelheight:self.m_firstviewlbl];
    [commonMethod adjustlabelheight:self.m_secondviewlbl];
    NSLog(@"%@",self.m_firstLabel);
    NSLog(@"%@",self.m_secondLabel);
    if([self.m_firstLabel isEqualToString:@"Write text here"]||[self.m_firstLabel isEqualToString:@""]){
        self.m_firstviewlbl.hidden =YES;
    }
    else{
        self.m_firstviewlbl.hidden = NO;
        self.m_firstviewlbl.text =[NSString stringWithFormat:@"%@",self.m_firstLabel];
}
    if([self.m_secondLabel isEqualToString:@"Write text here"]||[self.m_secondLabel isEqualToString:@""]){
          self.m_secondviewlbl.text = @"";
          self.m_secondviewlbl.hidden = YES;
    }else{
        self.m_secondviewlbl.hidden =NO;
        self.m_secondviewlbl.text =[NSString stringWithFormat:@"%@",self.m_secondLabel];
    }
    if(![self.m_firstLabel isEqualToString:@""]&&![self.m_secondLabel isEqualToString:@""]){
        self.m_titleQuery.hidden = NO;
          text =[NSString stringWithFormat:@"%@ or %@? I cannot decide.",self.m_firstLabel,self.m_secondLabel];
        self.m_titleQuery.text = text;
        self.m_hashTag_constraint.constant = 10.0f;
    }
    else{
    self.m_titleQuery.hidden =YES;
    self.m_titleQuery.text= @"";
    self.m_hashTag_constraint.constant = -10.0f;
    }
    self.m_titleName.text =[NSString stringWithFormat:@"%@",[[appDelegate.userprofile_data valueForKey:@"data"]valueForKey:@"name"]];
   self.m_navigationMenu.backgroundColor = [UIColor colorWithRed:86/255.0 green:159.0/255.0 blue:245.0/255.0 alpha:1.0];
   self.m_hashTagLabel.userInteractionEnabled = NO;
    if(hashTagTapAction!=nil){
    [self.m_hashTagLabel enableHashTagDetectionWithAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0], RLTapResponderAttributeName:hashTagTapAction}];
    [self.m_hashTagLabel enableUserHandleDetectionWithAttributes:
         @{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0],
           RLTapResponderAttributeName:hashTagTapAction}];
    }
    self.m_hashTagLabel.text = self.m_str_title_hashTag;
    self.m_hashTagLabel.textColor = [UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0];
    [CommonMethods setImageCorner:self.m_roundprofilePic];
    [CommonMethods filterStringType:self.m_str_title_hashTag];
    [CommonMethods filterStringType:self.m_firstLabel];
    [CommonMethods filterStringType:self.m_secondLabel];
    [CommonMethods filterStringType:self.m_str_title_query];
    [self.m_submitButton setEnabled:YES];
    [profileIndicatorView startAnimating];
    [self.m_roundprofilePic addSubview:profileIndicatorView];
    hashTagTapAction = ^(NSString *tappedString, NSInteger tag) {
          kAlertView(@"", @"No post found for such Tags");
    };
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.m_scrollView.contentSize = self.view.frame.size;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
//    self.m_hashTag_constraint.constant = 10.0f;
}

// Cross button Action
- (IBAction)m_crossButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark : Custom Methods
-(void)setUpViews{
     if(appDelegate.delegateCalling==YES){
        self.m_firstView.hidden=NO;
        self.m_secondView.hidden=NO;
        [self.m_firstviewlbl setHidden:NO];
        [self.m_secondviewlbl setHidden:NO];
        self.m_image_firstPost.hidden =YES;
        self.m_image_secondPost.hidden =YES;
        [self setBackgroundColorAndTextColor];
    }
    else{
        [self.m_firstviewlbl setTextColor:[UIColor whiteColor]];
        [self.m_secondviewlbl setTextColor:[UIColor whiteColor]];
        if(self.m_str_firstImage!=nil){
            self.m_image_firstPost.image=self.m_str_firstImage;
            self.m_image_firstPost.contentMode=UIViewContentModeScaleAspectFill;
            self.m_image_firstPost.clipsToBounds=YES;
        }
        if(self.m_str_secondImage!=nil){
            self.m_image_secondPost.image=self.m_str_secondImage;
                self.m_image_secondPost.contentMode =UIViewContentModeScaleAspectFill;
                self.m_image_secondPost.clipsToBounds=YES;
        }
        [self.m_firstviewlbl setHidden:NO];
        [self.m_secondviewlbl setHidden:NO];
    }
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
profile_URL= [NSString stringWithFormat:@"%@",[[appDelegate.userprofile_data valueForKey:@"data"]valueForKey:@"picture"]];
        profile_image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",profile_URL]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (profile_image!=nil) {
             self.m_roundprofilePic.image = profile_image;
                [profileIndicatorView stopAnimating];
                [profileIndicatorView removeFromSuperview];
        }
        });
    });
    self.m_image_secondPost=@"";
    self.m_title_query.text=self.m_str_title_query;
    if(self.m_str_timeValue == nil){
    self.m_timeValue.text = @"24:00:00";
    }
    else{
    self.m_timeValue.text=@"";
    }
    [commonMethod adjustlabelheight:self.m_title_query];
    [commonMethod adjustlabelheight:self.m_titleName];
    [commonMethod adjustlabelheight:self.m_hashTagLabel];
    self.m_title_query.textAlignment=NSTextAlignmentLeft;
    [m_Manager addCornerRadiusToButton:self.m_submitButton];
     self.m_scrollView.showsHorizontalScrollIndicator = NO;
    self.m_scrollView.showsVerticalScrollIndicator = NO; 
    [self setKeysAndValues];
}
-(void)setBackgroundColorAndTextColor{
    if([self.receivedDict count]>0){
    UIColor * viewcolor =  [self.receivedDict objectForKey:@"firstviewcolor"];
    UIColor *secviewcolor =[self.receivedDict objectForKey:@"secviewcolor"];
    UIColor *txtcolor =[self.receivedDict objectForKey:@"firsttextcolor"];
    UIColor *sectxtcolor =[self.receivedDict objectForKey:@"sectextcolor"];
    first_viewcolor =  [commonMethod  hexStringFromColor:viewcolor];
    sec_viewcolor =   [commonMethod hexStringFromColor:secviewcolor];
    first_txtcolor = [commonMethod hexStringFromColor:txtcolor];
    sec_txtcolor = [commonMethod hexStringFromColor:sectxtcolor];
[self.m_firstView setBackgroundColor:viewcolor];
[self.m_secondView setBackgroundColor:secviewcolor];
[self.m_firstviewlbl setTextColor:txtcolor];
[self.m_secondviewlbl setTextColor:sectxtcolor];
    }
}
//MARKS: Submit Button Action
-(IBAction)m_buttonSubmit:(id)sender{
    [self.m_submitButton setEnabled:NO];
    if([data_elements count]>0){
         if(appDelegate.delegateCalling==YES){
        [webClass questionUploadingWithTextData:appDelegate.array_rawData hitWithUrl:questionadd_URL withFollowingParameters:data_elements];
}
         else{
             [webClass questionUploadingWithImageData:appDelegate.array_rawData WithfirstImage:self.m_str_firstImage intakeWithAnotherImage:self.m_str_secondImage withFirstString:@"option_a" withSecondString:@"option_b" hitWithUrl:questionadd_URL withFollowingParameters:data_elements];
        }
    }
}

// delegate handling

-(void)questionUpdatedWithImage:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*statuscode =[responseDictionary valueForKey:@"status"];
    NSString*method_name=[responseDictionary valueForKey:@"method"];
    if([method_name isEqualToString:@"addquestion"]){
        if([statuscode intValue]==200){
            dispatch_async(dispatch_get_main_queue(), ^{
                 kAlertView(@"", @"Posted successfully!");
        });
            [SVProgressHUD dismiss];
          [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingPostingList" object:nil];
          [[NSNotificationCenter defaultCenter]postNotificationName:@"ProfileUpdated" object:nil];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"updatingTableView" object:nil ];
          [[NSNotificationCenter defaultCenter]postNotificationName:@"clearAlldata" object:nil];
          [self goToHomeScreen];
        }
        else{
            dispatch_async(dispatch_get_main_queue(),^{
            kAlertView(@"Error!", error.localizedDescription);
            });
        }
    }
}

-(void)questionUpdatedWithText:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*statuscode =[responseDictionary valueForKey:@"status"];
    NSString*method_name=[responseDictionary valueForKey:@"method"];
    if([method_name isEqualToString:@"addquestion"]){
        if([statuscode intValue]==200){
            dispatch_async(dispatch_get_main_queue(), ^{
                 kAlertView(@"", @"Posted successfully!");
            });
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ProfileUpdated" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingPostingList" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updatingTableView" object:nil ];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clearAlldata" object:nil];
            [self goToHomeScreen];
              }
        else{
            dispatch_async(dispatch_get_main_queue(),^{
                kAlertView(@"Error!", error.localizedDescription);
            });
        }
    }
}

// landing to Home page
-(void)goToHomeScreen{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabControlSection*tab=[storyboard instantiateViewControllerWithIdentifier:@"TabControlSection"];
    appDelegate.navigationController =[[UINavigationController alloc]initWithRootViewController:tab];
    appDelegate.navigationController.navigationBarHidden =YES;
    appDelegate.window.rootViewController = appDelegate.navigationController;
}

// setting key pair and its values
-(void)setKeysAndValues{
    [CommonMethods filterStringType:self.m_str_title_query];
    [CommonMethods filterStringType:self.m_str_title_hashTag];
    NSLog(@"%@",self.m_str_title_query);
    if(self.m_str_title_query.isEmpty){
    [data_elements setObject:@"write any question" forKey:@"question"];
    }
    else{
    [data_elements setObject:self.m_str_title_query forKey:@"question"];
     }
        if(self.m_str_title_hashTag.isEmpty){
                [data_elements setObject:@"" forKey:@"description"];
        }
        else{
               [data_elements setObject:self.m_str_title_hashTag forKey:@"description"];
      }
       if([self.m_firstLabel isEqualToString:@"Write text here"]){
        self.m_firstLabel = @"";
    }
    if([self.m_secondLabel isEqualToString:@"Write text here"]){
        self.m_secondLabel = @"";
    }
    
    if(!self.hashTagContent.isEmpty){
     [data_elements setObject:self.hashTagContent forKey:@"tagedid"];
    }
        if(appDelegate.delegateCalling==YES){
        [data_elements setObject:@"2" forKey:@"question_type"];
        [data_elements setObject:self.m_firstLabel forKey:@"option_a"];
        [data_elements setObject:self.m_secondLabel forKey:@"option_b"];
        [data_elements setObject:first_viewcolor forKey:@"background_a"];
        [data_elements setObject:sec_viewcolor forKey:@"background_b"];
        [data_elements setObject:first_txtcolor forKey:@"textcolor_a"];
        [data_elements setObject:sec_txtcolor forKey:@"textcolor_b"];
        [data_elements setObject:@"" forKey:@"overtext_a"];
        [data_elements setObject:@"" forKey:@"overtext_b"];
    }
    else{
            [data_elements setObject:@"1" forKey:@"question_type"];
            [data_elements setObject:self.m_firstLabel forKey:@"overtext_a"];
            [data_elements setObject:self.m_secondLabel forKey:@"overtext_b"];
            [data_elements setObject: @"" forKey:@"background_a"];
            [data_elements setObject: @"" forKey:@"background_b"];
            [data_elements setObject: @"" forKey:@"textcolor_a"];
            [data_elements setObject: @"" forKey:@"textcolor_b"];
    }
}

#pragma mark :Memory usage warning
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end