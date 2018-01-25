//
//  PostaQuestionView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//
#define TEXT_ONE_TAG 1
#define TEXT_TWO_TAG 2
#define TEXT_THREE_TAG 3
#define TEXT_FOUR_TAG 4
#define FIRST_CROSS 120
#define SECOND_CROSS 121
#define kBaseURL @"https://facebook.com/"
#define kDefaultFontSize 16.0
#define minimumFontSize 8.0
#import "PostaQuestionView.h"
@interface PostaQuestionView (){
    UIButton *first_plus_button;
    UIButton *second_plus_button;
    UIButton*sharing_facebook;
    NSInteger buttonSelected;
    UIImagePickerController *pickerController;
    NSString *currentTime;
    AppDelegate*appDelegate;
    NSMutableArray *colorDataArray;
    NSMutableArray *textDataArray;
    NSArray *textColorArray;
    NSMutableArray *TextNameArray;
    NSArray *colorArray;
    NSMutableArray *FontsArray;
    NSString *FontName;
    NSString*indexSelected;
    NSString *tapButton;
    int fonts;
    BOOL isSelected;
    BOOL isSharing;
    UINib*nib_bgdata;
    ColorCollectionCell *cell;
    NSUserDefaults *userDataStore;
    CommonMethods *m_sharedInstance;
    ReviewTask*task;
    SLComposeViewController *controller;
    UIWebView *webView;
    WebServices *webData;
    NSString *picType;
    UIImage *chosenImage;
    int pageNumber;
    NSMutableArray *added_usersData;
    NSString *leftText;
    NSMutableArray *selected_Id;
}
@end
@implementation PostaQuestionView

#pragma Mark : View Controller Life Cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    [self registerCollectionItem];
    [self registerTableCell];
    webData=[[WebServices alloc]init];
    webData.gettingFeeddelegate =self;
     sharing_facebook=[self.view viewWithTag:105];
    [sharing_facebook setSelected:YES];
    [sharing_facebook addTarget:self action:@selector(sharingOnFacebook:) forControlEvents:UIControlEventTouchUpInside];
    self.m_txtView_toplayout.constant = -60.0f;
    const NSInteger numberOfCollectionViewCells = 20;
    buttonSelected=0;
    isSelected = NO;
    if(sharing_facebook.isSelected){
        isSharing=YES;
    }
    else{
        isSharing=NO;
    }
    added_usersData = [[NSMutableArray alloc]init];
    colorDataArray =[[NSMutableArray alloc]init];
    textDataArray=[[NSMutableArray alloc]init];
    m_sharedInstance =[CommonMethods sharedInstance];
    appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    first_plus_button =(UIButton *)[self.view viewWithTag:251];
    second_plus_button=(UIButton *)[self.view viewWithTag:252];
    [first_plus_button addTarget:self action:@selector(pictureSelection:) forControlEvents:UIControlEventTouchUpInside];
    [second_plus_button addTarget:self action:@selector(pictureSelection:) forControlEvents:UIControlEventTouchUpInside];
    self.txtView.text=@"Post a question..";
    self.txtView.tag = TEXT_ONE_TAG;
    self.m_textview_hashTag.text = @"Write description..";
    self.m_textview_hashTag.tag = TEXT_TWO_TAG;
    self.m_textview_hashTag.editable=YES;
    self.m_textview_hashTag.delegate=self;
    self.m_textview_hashTag.returnKeyType = UIReturnKeyDefault;
    self.m_textview_hashTag.keyboardDismissMode = UIKeyboardTypeDefault;
    [self.m_textview_hashTag sizeToFit];
    selected_Id =[[NSMutableArray alloc]init];
    [self.txtView sizeToFit];
    self.txtView.editable=YES;
    self.txtView.delegate=self;
    self.m_txtView.delegate=self;
    self.m_txtView.font =[UIFont fontWithName:@"MarkerFelt-Wide" size:kDefaultFontSize];
    self.m_secondtextView.font =[UIFont fontWithName:@"MarkerFelt-Wide" size:kDefaultFontSize];
    self.m_secondtextView.delegate=self;
    self.txtView.textColor=[UIColor lightGrayColor];
    self.m_txtView.text=@"Write text here";
    self.m_txtView.textContainerInset = UIEdgeInsetsMake(self.m_txtView.frame.origin.y/2, 0, 0, 0);
    self.m_txtView.tag = TEXT_THREE_TAG;
    self.m_txtView.textColor=[UIColor whiteColor];
    self.m_secondtextView.text = @"Write text here";
    self.m_secondtextView.textContainerInset = UIEdgeInsetsMake(self.m_secondtextView.frame.origin.y/2, 0, 0, 0);
    self.m_secondtextView.textColor =[UIColor whiteColor];
    self.m_secondtextView.tag = TEXT_FOUR_TAG;
    self.m_txtView.hidden=YES;
    self.m_secondtextView.hidden=YES;
    UIColor *colorType =[UIColor colorWithRed:86/255.0 green:159/255.0 blue:255/255.0 alpha:1.0];
    colorArray = [NSArray arrayWithObjects:[UIColor blackColor],[UIColor whiteColor],[UIColor blueColor],colorType,[UIColor redColor],[UIColor magentaColor],[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor greenColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],nil];
    textColorArray=[NSArray arrayWithObjects:[UIColor whiteColor],[UIColor blackColor],[UIColor blueColor],[UIColor lightGrayColor],[UIColor orangeColor],[UIColor redColor],[UIColor magentaColor],[UIColor purpleColor],[UIColor brownColor],[UIColor colorWithRed:(132/255) green:(112/255) blue:(255/255) alpha:1],nil];
    [colorDataArray addObjectsFromArray:colorArray];
    [textDataArray addObjectsFromArray:textColorArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNavigation:) name:@"TestNotification" object:nil];
    [self.m_first_cross setTag:FIRST_CROSS];
    [self.m_sec_cross setTag: SECOND_CROSS];
    [self.m_first_cross addTarget:self action:@selector(crossButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.m_sec_cross addTarget:self action:@selector(crossButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.m_first_cross setHidden:YES];
    [self.m_sec_cross setHidden:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanPreviousData) name:@"clearAlldata" object:nil];
    pageNumber =1;
    [self setUpViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.m_suggest_user_tblView.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.m_scrollview.contentSize = self.view.frame.size;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)pictureSelection:(UIButton *)sender{
    [self.view endEditing:YES];
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option to choose:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Photo",
                            @"Select Photo",
                            @"I want to post with text only",
                            nil];
    buttonSelected=sender.tag;
    if(sender.tag==251){
        first_plus_button.hidden=NO;
    }
    else if(sender.tag==252){
        second_plus_button.hidden=NO;
    }
    popup.tag = 1;
    [popup showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (popup.tag){
        case 1:{
            switch (buttonIndex){
                case 0:
                    indexSelected = @"1";
                    [self takePhoto];
                    [self.m_txtView setTintColor:[UIColor whiteColor]];
                    [self.m_secondtextView setTintColor:[UIColor whiteColor]];
                     appDelegate.delegateCalling = NO;
                    break;
                case 1:
                    [self selectPhotos];
                    indexSelected = @"2";
                    [self.m_txtView setTintColor:[UIColor whiteColor]];
                    [self.m_secondtextView setTintColor:[UIColor whiteColor]];
                    appDelegate.delegateCalling = NO;
                       break;
                case 2:
                    indexSelected = @"3";
                    [self.m_txtView setTintColor:[UIColor blackColor]];
                    [self.m_secondtextView setTintColor:[UIColor blackColor]];
                    appDelegate.delegateCalling = YES;
                    [self withTextOnly];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
- (IBAction)backToHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)takePhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    pickerController= [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
   [self presentViewController:pickerController animated:YES completion:nil];
    }
}
-(void)selectPhotos{
    pickerController= [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   [self presentViewController:pickerController animated:YES completion:nil];
}
-(void)withTextOnly{
    self.m_txtView_toplayout.constant = 60.0f;
    self.img_source1.hidden=YES;
    self.img_source2.hidden=YES;
    first_plus_button.hidden = YES;
    second_plus_button.hidden = YES;
    self.m_txtView.hidden=NO;
    self.m_secondtextView.hidden=NO;
    self.m_textCollection.hidden =NO;
    self.m_collectionBackgroundData.hidden = NO;
    self.m_collectionSecondtextfontcolor.hidden =NO;
    self.m_collectionSecondbgData.hidden = NO;
    self.m_lblbgtheme.hidden=NO;
    self.m_secondlblbgtheme.hidden =NO;
    self.m_lblfontcolor.hidden=NO;
    self.m_secondlblfontcolor.hidden = NO;
    self.m_txtView.textColor =[UIColor blackColor];
    self.m_secondtextView.textColor =[UIColor blackColor];
    self.lblOptionA.autoresizesSubviews =YES;
    self.lblOptionB.autoresizesSubviews =YES;
    [self.m_first_cross setHidden:YES];
    [self.m_sec_cross setHidden:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   chosenImage = info[UIImagePickerControllerEditedImage];
    if(chosenImage!=nil){
      if(buttonSelected==251){
        picType=@"1";
        self.img_source1.image = chosenImage;
        self.img_source1.contentMode =UIViewContentModeScaleAspectFill;
        [CommonMethods squareImageFromImage:chosenImage scaledToSize:self.img_source1.frame.size.height];
         self.m_txtView.hidden=NO;
         [self.m_first_cross setHidden:NO];
        [self.m_txtView addSubview:self.m_first_cross];
       
    }
     else if(buttonSelected==252){
        picType=@"2";
        self.img_source2.image = chosenImage;
        self.img_source2.contentMode =UIViewContentModeScaleAspectFill;
  [CommonMethods squareImageFromImage:chosenImage scaledToSize:self.img_source1.frame.size.height];
         self.m_secondtextView.hidden = NO;
        [self.m_sec_cross setHidden:NO];
        [self.m_secondtextView addSubview:self.m_sec_cross];
}
    }
     [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)m_preview_button:(id)sender {
    [self.view endEditing:YES];
    [self checkStatus];
}

#pragma mark => TextView Delegates
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView.tag==TEXT_ONE_TAG){
        if([textView.text isEqualToString:@"Post a question.."]){
        textView.text=@"";
        }
        textView.textColor = [UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:12.0/255.0 alpha:1.0];
}
    else if (textView.tag==TEXT_TWO_TAG){
    if([textView.text isEqualToString:@"Write description.."]){
        textView.text =@"";
        }
     }
    else if(textView.tag==TEXT_THREE_TAG || textView.tag==TEXT_FOUR_TAG){
        if([textView.text isEqualToString:@"Write text here"]){
            textView.text = @"";
        }
        if(appDelegate.delegateCalling ==YES){
             textView.textColor = [UIColor blackColor];
             textView.font =[UIFont fontWithName:@"MarkerFelt-Wide" size:kDefaultFontSize];
            }
        else{
            textView.textColor = [UIColor whiteColor];
            textView.font =[UIFont fontWithName:@"MarkerFelt-Wide" size:kDefaultFontSize];
        }
    }
    [textView becomeFirstResponder];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(textView.tag==TEXT_ONE_TAG||textView.tag==TEXT_THREE_TAG || textView.tag==TEXT_FOUR_TAG){
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
        [self.m_suggest_user_tblView setHidden:YES];
 }
    else if (textView.tag==TEXT_TWO_TAG){
        if([text isEqualToString:@"\n"]){
            [textView resignFirstResponder];
        }
        if([text isEqualToString:@""]||[text isEqualToString:@" "]){
            [self.m_suggest_user_tblView setHidden:YES];
        }
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
     if(textView.tag==TEXT_ONE_TAG){
        if([textView.text isEqualToString:@""]){
        textView.text = @"Post a question..";
            textView.textColor = [UIColor colorWithRed:206.0/255.0 green:212/255.0 blue:217.0/255.0 alpha:1.0];
    }
    }
    else if (textView.tag==TEXT_TWO_TAG){
        if([textView.text isEqualToString:@""]){
         textView.text = @"Write description..";
        textView.textColor = [UIColor colorWithRed:206.0/255.0 green:212/255.0 blue:217.0/255.0 alpha:1.0];
    }
    [self.m_suggest_user_tblView setHidden:YES];
}
    else if(textView.tag==TEXT_THREE_TAG || textView.tag==TEXT_FOUR_TAG){
           if([textView.text isEqualToString:@""]){
            textView.text = @"Write text here";
    }
    }
    [textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView{
if(textView.tag==TEXT_THREE_TAG || textView.tag==TEXT_FOUR_TAG){
       textView.font =[UIFont fontWithName:@"MarkerFelt-Wide" size:kDefaultFontSize];
        textView.font =[UIFont fontWithName:@"MarkerFelt-Wide" size:kDefaultFontSize];
    if (textView.contentSize.height > textView.frame.size.height) {
        int fontIncrement = 1;
        while (textView.contentSize.height > textView.frame.size.height) {
            textView.font = [UIFont systemFontOfSize:kDefaultFontSize-fontIncrement];
            fontIncrement++;
    }
    }
}
    else if (textView.tag==TEXT_TWO_TAG){
    NSString *tweet = textView.text;
    NSArray *words = [tweet componentsSeparatedByString:@" "];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:tweet];
    for (NSString *word in words){
        if ([word hasPrefix:@"#"]){
            NSRange matchRange = [tweet rangeOfString:word];
            UIColor *foregroundColor =[UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0];
            [attrString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:matchRange];
           textView.attributedText = attrString;
            [self.m_suggest_user_tblView setHidden:YES];
   }
       else if ([word hasPrefix:@"@"]){
            if([word length]>0){
                NSArray *componentsSeparatedByWhiteSpace = [word componentsSeparatedByString:@" "];
                if([componentsSeparatedByWhiteSpace count] > 1){
                    NSLog(@"Found whitespace");
                    [self.m_suggest_user_tblView setHidden:YES];
                }
            else{
            NSString *get_username =[NSString stringWithFormat:@"%@",word];
            NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"@"];
            get_username = [get_username stringByTrimmingCharactersInSet:chs];
            [self sendhttpRequestTogetUserName:get_username];
            [self.m_suggest_user_tblView setHidden:YES];
            }
            }
            else{
            [self.m_suggest_user_tblView setHidden:YES];
            }
            NSRange matchRange = [tweet rangeOfString:word];
            UIColor *foregroundColor = [UIColor colorWithRed:18/255.0 green:142/255.0 blue:220.0/255.0 alpha:1.0];
            [attrString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:matchRange];
            textView.attributedText = attrString;
       }
    else{
      textView.textColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:1.0];
    }
    }
}

  else if(textView.tag==TEXT_ONE_TAG){
[textView setFont:[UIFont fontWithName:@"ProximaNova" size: 14.0f]];
}
}

#pragma mark : Collection viewDataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count;
    if(collectionView==self.m_collectionBackgroundData||collectionView ==self.m_collectionSecondbgData){
        count = colorDataArray.count;
    }
    else if(collectionView==self.m_textCollection||self.m_collectionSecondtextfontcolor){
         count = textDataArray.count;
    }
    return count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bgIdentifier =@"bgIdentifier";
    if(collectionView==self.m_collectionBackgroundData){
        ColorCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:bgIdentifier forIndexPath:indexPath];
        [cell.m_button setBackgroundColor:[colorDataArray objectAtIndex:indexPath.row]];
        cell.m_button.layer.cornerRadius = cell.m_button.frame.size.width/2;
        cell.m_button.clipsToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor =[UIColor blackColor].CGColor;
        cell.layer.cornerRadius =cell.frame.size.width/2;
        cell.layer.masksToBounds=YES;
        cell.m_button.tag = (collectionView.tag * 1000 )+(indexPath.row);
        [cell.m_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(collectionView == self.m_collectionSecondbgData){
        ColorCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:bgIdentifier forIndexPath:indexPath];
        [cell.m_button setBackgroundColor:[colorDataArray objectAtIndex:indexPath.row]];
        cell.m_button.layer.cornerRadius = cell.m_button.frame.size.width/2;
        cell.m_button.clipsToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor =[UIColor blackColor].CGColor;
        cell.layer.cornerRadius =cell.frame.size.width/2;
        cell.layer.masksToBounds=YES;
        cell.m_button.tag = (collectionView.tag * 1000 )+(indexPath.row);
        [cell.m_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(collectionView==self.m_textCollection){
        ColorCollectionCell*cell =[collectionView dequeueReusableCellWithReuseIdentifier:bgIdentifier forIndexPath:indexPath];
        [cell.m_button setBackgroundColor:[textDataArray objectAtIndex:indexPath.row]];
        cell.m_button.layer.cornerRadius = cell.m_button.frame.size.width/2;
        cell.m_button.clipsToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.cornerRadius =cell.frame.size.width/2;
        cell.layer.masksToBounds=YES;
        cell.layer.borderColor =[UIColor blackColor].CGColor;
        cell.m_button.tag = (collectionView.tag * 1000 )+(indexPath.row);
        [cell.m_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(collectionView==self.m_collectionSecondtextfontcolor){
        ColorCollectionCell*cell =[collectionView dequeueReusableCellWithReuseIdentifier:bgIdentifier forIndexPath:indexPath];
        [cell.m_button setBackgroundColor:[textDataArray objectAtIndex:indexPath.row]];
        cell.m_button.layer.cornerRadius = cell.m_button.frame.size.width/2;
        cell.m_button.clipsToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor =[UIColor blackColor].CGColor;
        cell.layer.cornerRadius =cell.frame.size.width/2;
        cell.layer.masksToBounds=YES;
        cell.m_button.tag = (collectionView.tag * 1000 )+(indexPath.row);
        [cell.m_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

//collection view tapping button Action
-(void)buttonTapped:(UIButton*)sender{
     int indexValue = sender.tag % 1000;
     if(sender.tag<1000){
        self.m_txtView.backgroundColor = [colorDataArray objectAtIndex:indexValue];
    }
    else if(sender.tag<2000){
        self.m_secondtextView.backgroundColor =[colorDataArray objectAtIndex:indexValue];
    }
    else if(sender.tag<3000){
        self.m_txtView.textColor = [textDataArray objectAtIndex:indexValue];
    }
    else{
        self.m_secondtextView.textColor =[textDataArray objectAtIndex:indexValue];
    }
}

#pragma mark : Collection View delegate Methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"you have clicked =%lu",indexPath.row);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        CGSize size;
        if (collectionView == self.m_collectionBackgroundData) {
                size=CGSizeMake(24, 24);
            }
         else if(collectionView ==self.m_textCollection){
            size=CGSizeMake(24, 24);
            }
        else if (collectionView == self.m_collectionSecondbgData){
                size=CGSizeMake(24, 24);
            }
        else if(collectionView ==self.m_collectionSecondtextfontcolor){
            size=CGSizeMake(24, 24);
            }
    return size;
}

#pragma mark : Registering Collection View

-(void)registerCollectionItem{
    nib_bgdata = [UINib nibWithNibName:@"ColorCollectionCell" bundle:nil ];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [self registerCollectionView:self.m_collectionBackgroundData withReusingIdentifier:@"bgIdentifier" usingLayout:layout settingTag:0];
    UICollectionViewFlowLayout *secondlayout=[[UICollectionViewFlowLayout alloc] init];
    [self registerCollectionView:self.m_collectionSecondbgData withReusingIdentifier:@"bgIdentifier" usingLayout:secondlayout settingTag:1];
    UICollectionViewFlowLayout *collectionViewtextColorFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self registerCollectionView:self.m_textCollection withReusingIdentifier:@"bgIdentifier" usingLayout:collectionViewtextColorFlowLayout settingTag:2];
    UICollectionViewFlowLayout *secondColorFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self registerCollectionView:self.m_collectionSecondtextfontcolor withReusingIdentifier:@"bgIdentifier" usingLayout:secondColorFlowLayout settingTag:3];
    [self.m_collectionBackgroundData setHidden:YES];
    [self.m_collectionSecondbgData setHidden:YES];
    [self.m_textCollection setHidden:YES];
    [self.m_collectionSecondtextfontcolor setHidden:YES];
    [self.m_lblbgtheme setHidden:YES];
    [self.m_secondlblbgtheme setHidden:YES];
    [self.m_lblfontcolor setHidden:YES];
    [self.m_secondlblfontcolor setHidden:YES];
}
-(void)registerCollectionView:(UICollectionView*)collectionView withReusingIdentifier:(NSString*)identifier usingLayout:(UICollectionViewFlowLayout*)layout settingTag:(NSInteger)tag{
    [layout setMinimumInteritemSpacing:5.f];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [collectionView registerNib:nib_bgdata forCellWithReuseIdentifier:@"bgIdentifier"];
    [collectionView setTag:tag];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView setAllowsMultipleSelection:YES];
    [collectionView setCollectionViewLayout:layout];
    [collectionView setPagingEnabled:YES];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setBounces:NO];
}
#pragma mark : Save background and text color in user defaults
-(void)saveBackgroundAndTextColor{
    NSMutableDictionary *m_Dict =[[NSMutableDictionary alloc]init];
    UIColor*color =[self.m_txtView backgroundColor];
    UIColor*secondColor =[self.m_secondtextView backgroundColor];
    UIColor *textColor =self.m_txtView.textColor;
    UIColor *secondTextColor=self.m_secondtextView.textColor;
    if(color!=nil){
    [m_Dict setObject:color forKey:@"firstviewcolor"];
    }else{
    [m_Dict setObject:[UIColor whiteColor] forKey:@"firstviewcolor"];
    }
    if(secondColor !=nil){
    [m_Dict setObject:secondColor forKey:@"secviewcolor"];
    }else{
    [m_Dict setObject:[UIColor whiteColor] forKey:@"secviewcolor"];
    }
    if(textColor!=nil){
    [m_Dict setObject:textColor forKey:@"firsttextcolor"];
    }else{
    [m_Dict setObject:[UIColor blackColor] forKey:@"firsttextcolor"];
    }
    if(secondTextColor!=nil){
        [m_Dict setObject:secondTextColor forKey:@"sectextcolor"];
    }else{
     [m_Dict setObject:[UIColor blackColor] forKey:@"sectextcolor"];
    }
    NSData *colorData =[NSKeyedArchiver archivedDataWithRootObject:m_Dict];
    [appDelegate.userDataStore setObject:colorData forKey:@"colorPrefernce"];
    [appDelegate.userDataStore synchronize];
}

-(void)checkStatus{
    if([self.txtView.text isEqualToString:@"Post a question.."]){
        kAlertView(@"Error!", @"please enter your question first");
    }
    else if([self.m_textview_hashTag.text  isEqualToString:@"Write description.."]){
         kAlertView(@"Error!", @"please enter few description");
    }
   else{
    task=INSTANTIATE(REVIEW_SCREEN_VIEW);
   NSString* tagged_userId = [self convertToCommaSeparatedFromArray:selected_Id];
    NSLog(@"%@",tagged_userId);
    task.m_str_firstImage=self.img_source1.image;
    task.m_str_secondImage=self.img_source2.image;
    task.m_str_title_query=[NSString stringWithFormat:@"%@",self.txtView.text];
    task.m_str_title_hashTag=[NSString stringWithFormat:@"%@",self.m_textview_hashTag.text];
    task.m_str_timeValue=currentTime;
    task.m_firstLabel=self.m_txtView.text;
    task.m_secondLabel=self.m_secondtextView.text;
    task.hashTagContent =  tagged_userId;
    if (appDelegate.delegateCalling==YES){
        [self saveBackgroundAndTextColor];
    }
    if(isSharing==YES){
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [controller setInitialText:@"Posting your post.."];
            [self presentViewController:controller animated:YES completion:Nil];
        }
   else{
    [CommonMethods alertStatus:@"Please login with facebook" :@"Warning" withController:self];
    }
    }
    else{
        [self.navigationController pushViewController:task animated:YES];

    }
    [controller setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         if (result == SLComposeViewControllerResultCancelled) {
             NSLog(@"you have cancelled to share on facebook");
         }
         else if (result == SLComposeViewControllerResultDone) {
                [self.navigationController pushViewController:task animated:YES];
         }
     }];
    
}
}

#pragma mark: TableView dataSourceMethod

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.m_username.count>0){
    return self.m_username.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"followersData";
    FollowersProfileCell *shell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!shell){
        shell = [[FollowersProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    shell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(self.m_username.count>0){
    shell.m_profileName.text =[NSString stringWithFormat:@"%@",[[self.m_username objectAtIndex:indexPath.row]valueForKey:@"name"]];
    shell.m_profileName.textColor=[UIColor colorWithRed:0/255.0 green:114/255.0 blue:215/255.0 alpha:1.0];
    NSString *m_profileURL = [NSString stringWithFormat:@"%@",[[self.m_username objectAtIndex:indexPath.row]valueForKey:@"picture"]];
//    NSLog(@"%@",m_profileURL);
    shell.m_imageFollowers.layer.cornerRadius = shell.m_imageFollowers.frame.size.width/2;
    shell.m_imageFollowers.clipsToBounds = YES;
    [shell.m_imageFollowers setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:m_profileURL]]
                       placeholderImage:[UIImage imageNamed:@"placeholder_user"]
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    shell.m_imageFollowers.image = image;
                                } failure:nil];
    }
    tableView.separatorColor=[UIColor clearColor];
    UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
    shell.m_buttonFolllow.hidden = YES;
    [shell.contentView addSubview:separatorView];
    return shell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f ;
}

#pragma mark : tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *checkString_Value = @"";
     NSString *check_userId = @"";
    if(self.m_username.count>0){
        checkString_Value  = [NSString stringWithFormat:@"@%@",[[self.m_username objectAtIndex:indexPath.row]valueForKey:@"name"]];
        check_userId  = [NSString stringWithFormat:@"%@",[[self.m_username objectAtIndex:indexPath.row]valueForKey:@"user_id"]];
       [selected_Id addObject:check_userId];
    }
    NSArray *data = [self.m_textview_hashTag.text componentsSeparatedByString:@" "];
    added_usersData = [data mutableCopy];
    NSString *textValue = @"";
    NSLog(@"%@",added_usersData);
    if(added_usersData.count ==1){
    [added_usersData removeAllObjects];
    }else{
    [added_usersData removeLastObject];
    }
   if(checkString_Value.length>0){
    [added_usersData addObject:checkString_Value];
    NSString * resultText = [added_usersData componentsJoinedByString:@" "];
    self.m_textview_hashTag.text = resultText;
//    self.m_textview_hashTag.text = [words componentsJoinedByString:@" "];
}
    [self.m_suggest_user_tblView setHidden:YES];

   }

//MARK : pop to Root Controller on Submit button Action
-(void)poptoRootController{
    NSArray*selfVC =[self.navigationController viewControllers];
    TabControlSection *tabbar =nil;
    for(int i= 0; i<[selfVC count];i++){
        UIViewController *viewController = [selfVC objectAtIndex:i];
        if ([viewController isKindOfClass:[TabControlSection class]]){
            tabbar =[ selfVC objectAtIndex:i];
            break;
        }
    }
    if(tabbar)
        [self.navigationController popToViewController:tabbar animated:YES];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark : Facebook Sharing button Action
-(void)sharingOnFacebook:(UIButton*)sender{
    [self.view endEditing:YES];
    if(isSharing==YES){
        isSharing=NO;
        [sender setImage:[UIImage imageNamed:@"fb_uncheck"] forState:UIControlStateNormal];
    }
    else{
          isSharing=YES;
        [sender setImage:[UIImage imageNamed:@"fb_check"] forState:UIControlStateNormal];
    }
}

// MARK: Notification Method
-(void)pushNavigation:(NSNotification*)notification{
    if([notification.name isEqualToString:@"TestNotification"]){
        [self checkStatus];
    }
}

//MARK: AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
//        webView =[[UIWebView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//        NSString *urlString = @"http://www.facebook.com";
//        NSURL *url = [NSURL URLWithString:urlString];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//        [webView loadRequest:urlRequest];
//        [self.view addSubview:webView];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"TestNotification" object:self];
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

//MARK: Custom Methods
-(void)setUpViews{
    dispatch_async(dispatch_get_main_queue(),^{
    self.txtView.textContainerInset = UIEdgeInsetsMake(10, 5, 0, 0);
    [self.txtView setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
    self.m_sharingView.layer.cornerRadius=5.0f;
    self.m_sharingView.clipsToBounds=YES;
    self.m_textview_hashTag.textContainerInset=UIEdgeInsetsMake(10, 5, 0, 0);
    [self.m_textview_hashTag setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
    self.m_txtView.layer.borderWidth =1.5f;
    self.m_txtView.layer.borderColor=[UIColor colorWithRed:215.0/255.0 green:219.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    self.m_txtView.layer.cornerRadius=5.0f;
    self.m_txtView.textAlignment =NSTextAlignmentCenter;
    self.m_secondtextView.layer.borderWidth =1.5f;
    self.m_secondtextView.textAlignment =NSTextAlignmentCenter;
    self.m_secondtextView.layer.borderColor=[UIColor colorWithRed:215.0/255.0 green:219.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    self.m_secondtextView.layer.cornerRadius=5.0f;
    self.txtView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    self.txtView.layer.borderWidth=1.5f;
    self.txtView.layer.cornerRadius=5.0f;
    self.txtView.clipsToBounds=YES;
    self.txtView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [CommonMethods setImageSideCorner:self.img_source1];
    [CommonMethods setImageSideCorner:self.img_source2];
    self.m_textview_hashTag.layer.borderWidth=1.5f;
    self.m_textview_hashTag.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:219.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    self.m_textview_hashTag.layer.cornerRadius=5.0f;
    self.m_textview_hashTag.textContainerInset=UIEdgeInsetsMake(10, 10, 0, 0);
    self.txtView.layer.borderColor=[UIColor colorWithRed:215.0/255.0 green:219.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    self.txtView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 0);
    self.navigationController.navigationBarHidden=YES;
});
}
-(void)crossButtonSelected:(UIButton*)sender{
    if(sender.tag==FIRST_CROSS){
        [self.img_source1 setImage:[UIImage imageNamed:@"shapewithplus"]];
        [self.m_txtView setHidden:YES];
        self.m_txtView.text=@"Write text here";
    }
    else if(sender.tag==SECOND_CROSS){
        [self.img_source2 setImage:[UIImage imageNamed:@"shapewithplus"]];
        [self.m_secondtextView setHidden:YES];
        self.m_secondtextView.text=@"Write text here";
    }
}
-(void)registerTableCell{
    UINib *cell_nib =[UINib nibWithNibName:@"FollowersProfileCell" bundle:nil];
    [self.m_suggest_user_tblView registerNib:cell_nib forCellReuseIdentifier:@"followersData"];
    self.m_suggest_user_tblView.dataSource = self;
    self.m_suggest_user_tblView.delegate = self;
}

-(void)sendhttpRequestTogetUserName:(NSString *)taggedUser{
 NSLog(@"%@",taggedUser);
    NSString *get_followersListing_URL = [NSString stringWithFormat:@"%@/%@/%d", get_Followers_Listing,taggedUser,pageNumber];
    [webData gettingFeedResult:get_followersListing_URL parameters:appDelegate.array_rawData];
}

#pragma Mark : handling delegate Response
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSLog(@"Response data = %@",responseData);
    NSString *resultStatus = [responseData valueForKey:@"status"];
    NSString *methodName = [responseData valueForKey:@"method"];
    if ([methodName isEqualToString:@"search_FollowerForTag"]) {
        if([resultStatus intValue]==200){
            self.m_username =[responseData valueForKey:@"data"];
            if (self.m_username.count>0){
                dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_suggest_user_tblView setHidden:NO];
                 [self.m_suggest_user_tblView reloadData];
            });
            }
        }
    }
}

// create a string of array joined by comma separator value
-(NSString *)convertToCommaSeparatedFromArray:(NSArray*)array{
    return [array componentsJoinedByString:@","];
}

//Notification Method

-(void)cleanPreviousData{
    self.m_textview_hashTag.text = @"" ;
    self.m_txtView.text = @"";
    self.m_secondtextView.text = @"";
    self.txtView.text = @"";
    self.m_txtView_toplayout.constant = -60.0f;
    self.img_source1.hidden = NO;
    self.img_source2.hidden = NO;
    first_plus_button.hidden = NO;
    second_plus_button.hidden = NO;
    self.m_txtView.hidden = YES;
    self.m_secondtextView.hidden = YES;
    self.m_textCollection.hidden =YES;
    self.m_collectionBackgroundData.hidden = YES;
    self.m_collectionSecondtextfontcolor.hidden = YES;
    self.m_collectionSecondbgData.hidden = YES;
    self.m_lblbgtheme.hidden =YES;
    self.m_secondlblbgtheme.hidden = YES;
    self.m_lblfontcolor.hidden = YES;
    self.m_secondlblfontcolor.hidden = YES;
    [self.m_first_cross setHidden: NO];
    [self.m_sec_cross setHidden:NO];
    self.m_txtView.backgroundColor =[UIColor clearColor];
    self.m_secondtextView.backgroundColor =[UIColor clearColor];
    [self.m_first_cross setHidden:YES];
    [self.m_sec_cross setHidden:YES];
    self.m_txtView.text=@"Write text here";
    self.m_secondtextView.text = @"Write text here";
    self.txtView.text=@"Post a question..";
    self.m_textview_hashTag.text = @"Write description..";
    self.txtView.textColor=[UIColor lightGrayColor];
    self.m_textview_hashTag.textColor =[UIColor lightGrayColor];
}

#pragma mark =>Memory usage warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end