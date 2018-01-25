//
//  EditProfile.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 09/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#define kUsernameType 1
#define kNickNameType 2
#define kWebSiteType 3
#define kInfoType 4
#define kEmailType 5
#define kPhoneType 6
#define kGenderType 7
#import "EditProfile.h"
#import "WebServices.h"

@interface EditProfile (){
    NSData*dataImage;
    AppDelegate *app;
    WebServices *webclass;
    NSString *m_userId, *m_tokenKey;
    NSMutableDictionary *m_dict;
    NSArray *parameters;
    UIImage *chosenImage;
    UIActivityIndicatorView *indicator;
}
@end

@implementation EditProfile

#pragma mark : ViewController lefe Cycle Method
-(void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    m_dict=[[NSMutableDictionary alloc]init];
    parameters=[[NSArray alloc]init];
    webclass =[[WebServices alloc]init];
    webclass.profileUpdatedelegate=self;
    webclass.profileImageUpdatedelegate=self;
    m_userId=[NSString stringWithFormat:@"%@",[app.array_rawData objectAtIndex:0]];
    m_tokenKey=[NSString stringWithFormat:@"%@",[app.array_rawData objectAtIndex:1]];
    NSLog(@"%@",app.userprofile_data);
    UIActivityIndicatorView *indicator;
    [self.m_txt_username setTag:kUsernameType];
    [self.m_txt_nickName setTag: kNickNameType];
    [self.m_txt_website setTag:kWebSiteType];
    [self.m_txt_info setTag:kInfoType];
    [self.m_txt_email setTag:kEmailType];
    [self.m_txt_phone setTag:kPhoneType];
    [self.m_txt_gender setTag:kGenderType];
    self.m_txt_username.delegate = self;
    self.m_txt_nickName.delegate = self;
    self.m_txt_website.delegate = self;
    self.m_txt_info.delegate = self;
    self.m_txt_email.delegate =self;
    self.m_txt_phone.delegate = self;
    self.m_txt_gender.delegate = self;
    parameters=[NSArray arrayWithObjects:m_userId,m_tokenKey,AUTHKEY, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
     [self setUpViews];
    });
 
  }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
    app.nick_name = self.m_txt_nickName.text;
    app.user_name =self.m_txt_username.text;
    app.user_info =   self.m_txt_info.text;
    app.user_gender =self.m_txt_gender.text;
    app.user_phone = self.m_txt_phone.text;
    app.user_website=self.m_txt_website.text;
    app.img_profile =self.m_profile_image.image;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.m_ScrollView.contentSize =CGSizeMake(self.view.frame.size.width, self.m_ScrollView.contentSize.height);
}
- (IBAction)m_updateYourProfile:(id)sender {
        [self showActionSheet];
}

//Action sheet method
-(void)showActionSheet{
    NSString *actionSheetTitle = @"Change Profile Picture"; //Action Sheet Title
    NSString *other1 = @"Take Photo";
    NSString *other2 = @"Choose From Library";
    NSString *cancelTitle = @"Cancel";
    NSString *destructiveButton = @"Remove Current Photo";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveButton
                                  otherButtonTitles:other1, other2, nil];
    [self changeTextColorForUIActionSheet:actionSheet];
    [actionSheet setTag:1];
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
    if  ([buttonTitle isEqualToString:@"Take Photo"]){
        [self takePhoto];
    }
    else if ([buttonTitle isEqualToString:@"Choose From Library"]){
                    [self selectPhoto];
    }
    else if ([buttonTitle isEqualToString:@"Remove Current Photo"]){
                 self.m_profile_image.image =[UIImage imageNamed:@"placeholder_user"];
    }
}

#pragma mark : Imagepicker controller and its delegates
-(void)takePhoto{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
          UIImagePickerController *picker_Controller=[[UIImagePickerController alloc]init];
        picker_Controller.delegate=self;
        picker_Controller.allowsEditing =YES;
        picker_Controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker_Controller animated:YES completion:nil];
    }
}
- (void)selectPhoto{
    UIImagePickerController *picker_controller =[[UIImagePickerController alloc]init];
    picker_controller.delegate=self;
    picker_controller.allowsEditing=YES;
    picker_controller.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker_controller animated:YES completion:nil];
      }
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.btn_profile_image.hidden=YES;
    chosenImage= info[UIImagePickerControllerEditedImage];
        if(chosenImage!=nil){
        self.m_profile_image.image = nil;
    [self  sendDataTobackendforuploadingPic:chosenImage withheaderFile:parameters];
    }
       [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)done_button:(id)sender {
     [self.view endEditing:YES];
    [self setKeysForAllObjects];
    [self sendDataTobackendserver:m_dict withheaderFile:parameters];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)back_button:(id)sender {
 [self.view endEditing:YES];
 [self.navigationController popViewControllerAnimated:YES];
}
# pragma mark : custom Methods

-(void)setUpViews{
    [CommonMethods setImageCorner: self.m_profile_image];
    [CommonMethods addPaddingView:self.m_txt_username];
    [CommonMethods addPaddingView:self.m_txt_nickName];
    [CommonMethods addPaddingView:self.m_txt_website];
    [CommonMethods addPaddingView:self.m_txt_info];
    [CommonMethods addPaddingView:self.m_txt_email];
    [CommonMethods addPaddingView:self.m_txt_phone];
    [CommonMethods addPaddingView:self.m_txt_gender];
    NSString * email = app.user_email;
    if([email isEqualToString:@""]||[email isEqualToString:@" "]||[email isEqualToString:@"(null)"]){
        self.m_txt_email.text =@"";
    }
    else{
        self.m_txt_email.text =[NSString stringWithFormat:@"%@",email];
    }
      NSString *nick_name = app.nick_name;
      NSString *user_name =app.user_name;
      NSString *about_me = app.user_info;
      NSString *gender = app.user_gender;
      NSString*contactinfo = app.user_phone;
      NSString*websitedetails =app.user_website;
     if([gender isEqualToString:@""]){
        self.m_txt_gender.text =@"";
    }
    else{
        self.m_txt_gender.text = [NSString stringWithFormat:@"%@",gender];
    }
    
    if([contactinfo isEqualToString:@""]){
        self.m_txt_phone.text=@"";
    }
    else{
        self.m_txt_phone.text = [NSString stringWithFormat:@"%@",contactinfo];
    }
    if([websitedetails isEqualToString:@""]){
        self.m_txt_website.text=@"";
    }
    else{
         self.m_txt_website.text = [NSString stringWithFormat:@"%@",websitedetails];
    }
    if([nick_name isEqualToString:@""]||[nick_name isEqualToString:@" "]||[nick_name isEqualToString:@"(null)"]||[nick_name isEqualToString:@"null"]){
         self.m_txt_nickName.text=@"";
        }
    else{
        self.m_txt_nickName.text=[NSString stringWithFormat:@"%@",nick_name];
    }
    if ([user_name isEqualToString:@""]||[user_name isEqualToString:@" "]||[user_name isEqualToString:@"(null)"]||[user_name isEqualToString:@"null"]) {
        self.m_txt_username.text =@"";
    }
    else{
        self.m_txt_username.text =[NSString stringWithFormat:@"%@",user_name];
    }
    if ([about_me isEqualToString:@""]||[about_me isEqualToString:@" "]||[about_me isEqualToString:@"(null)"]||[about_me isEqualToString:@"null"]){
        self.m_txt_info.text = @"";
    }
    else{
        self.m_txt_info.text =[NSString stringWithFormat:@"%@",about_me];
    }
    if ([gender isEqualToString:@""]||[gender isEqualToString:@" "]||[gender isEqualToString:@"(null)"]||[gender isEqualToString:@"null"]) {
        self.m_txt_gender.text=@"";
          }
    else{
           self.m_txt_gender.text=[NSString stringWithFormat:@"%@",gender];
    }
      if(app.img_profile!=nil){
        self.m_profile_image.image= app.img_profile;
    }
    else{
         indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat x = (self.m_profile_image.frame.size.width- indicator.frame.size.width)/2;
        CGFloat y = (self.m_profile_image.frame.size.height- indicator.frame.size.height)/2;
        indicator.frame = CGRectMake(x, y,indicator.frame.size.width, indicator.frame.size.height);
            [indicator startAnimating];
            [indicator setCenter:CGPointMake(self.m_profile_image.frame.size.width/2, self.m_profile_image.frame.size.height/2)];
        [self.m_profile_image addSubview:indicator];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString*url =[[app.userprofile_data valueForKey:@"data"]valueForKey:@"picture"];
            NSURL * string_url = [NSURL URLWithString:url];
            NSData * data = [NSData dataWithContentsOfURL:string_url];
            UIImage * image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_profile_image.image =image;
                [indicator stopAnimating];
                [indicator removeFromSuperview];
            });
        });
    }
}

// api calling
-(void)sendDataTobackendserver:(NSDictionary *)data_dict withheaderFile:(NSArray*)raw_data{
    [webclass webServiceUpdateProfile:profileUpdated_URL  parameters:data_dict withheaderSection:raw_data];
}

-(void)sendDataTobackendforuploadingPic:(UIImage*)imageType withheaderFile:(NSArray*)raw_data{
     indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat x = (self.m_profile_image.frame.size.width- indicator.frame.size.width)/2;
    CGFloat y = (self.m_profile_image.frame.size.height- indicator.frame.size.height)/2;
    indicator.frame = CGRectMake(x, y,indicator.frame.size.width, indicator.frame.size.height);
        [indicator startAnimating];
        [indicator setCenter:CGPointMake(self.m_profile_image.frame.size.width/2, self.m_profile_image.frame.size.height/2)];
        [self.m_profile_image addSubview:indicator];
      [webclass imageUploading:raw_data withStringUrl:picUpdated_URL uploadingImage:imageType];
}


//MARK:delegate results handling
-(void)profileUpdated:(NSDictionary*)responseDictionary error:(NSError*)error{
    NSString*status =[responseDictionary valueForKey:@"status"];
        NSString *methodName =[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"updateprofile"]){
        if([status intValue]==200){
            NSLog(@"updated successfully!");
            NSLog(@"data = %@",[responseDictionary valueForKey:@
                                "data"]);
        }
        else{
            NSLog(@"Not updated, try again");
        }
    }
}
// setting keys for all objects
-(void)setKeysForAllObjects{
    [m_dict setObject:self.m_txt_email.text forKey:@"email"];
    [m_dict setObject:self.m_txt_website.text forKey:@"website"];
    [m_dict setObject:self.m_txt_phone.text forKey:@"phone"];
    [m_dict setObject:self.m_txt_gender.text forKey:@"gender"];
    [m_dict setObject:self.m_txt_username.text forKey:@"name"];
    [m_dict setObject:self.m_txt_nickName.text forKey:@"username"];
    [m_dict setObject:@"91" forKey:@"countrycode"];
    [m_dict setObject:self.m_txt_info.text forKey:@"aboutme"];
}

//getting result of picture uploading
-(void)profilePictureUpdated:(NSDictionary*)responseDictionary error:(NSError *)error{
    NSString*status =[responseDictionary valueForKey:@"status"];
    NSString *methodName =[responseDictionary valueForKey:@"method"];
    if([methodName isEqualToString:@"uploadprofilepicture"]){
        if([status intValue]==200){
                 kAlertView(@"", @"Picture uploaded successfully!");
                  app.img_profile = chosenImage;
                self.m_profile_image.image = app.img_profile;
                [indicator stopAnimating];
                [indicator removeFromSuperview];
}
    }else{
        NSLog(@"Error in uploading picture");
    }
}

#pragma mark : TextField delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case kUsernameType:
            [self.m_txt_username becomeFirstResponder];
             textField.returnKeyType = UIReturnKeyDefault;
            break;
        case kNickNameType:
            [self.m_txt_nickName becomeFirstResponder];
             textField.returnKeyType = UIReturnKeyDefault;
            break;
        case kWebSiteType:
            [self.m_txt_website becomeFirstResponder];
             textField.returnKeyType = UIReturnKeyDefault;
            break;
        case kInfoType:
            [self.m_txt_info becomeFirstResponder];
             textField.returnKeyType = UIReturnKeyDefault;
            break;
        case kEmailType:
            [self.m_txt_email becomeFirstResponder];
             textField.returnKeyType = UIReturnKeyDefault;
            break;
        case kPhoneType:
            [self.m_txt_phone becomeFirstResponder];
             textField.returnKeyType = UIReturnKeyDefault;
            break;
        case kGenderType:
            [self.m_txt_gender becomeFirstResponder];
             textField.returnKeyType = UIReturnKeyDefault;
            break;
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }
   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag==kNickNameType){
    [self.m_txt_username becomeFirstResponder];
    }
    else if(textField.tag==kUsernameType){
    [self.m_txt_website becomeFirstResponder];
    }
    else if(textField.tag==kWebSiteType){
    [self.m_txt_info becomeFirstResponder];
    }
    else if(textField.tag==kInfoType){
    [self.m_txt_email becomeFirstResponder];
    }
    else if(textField.tag==kEmailType){
    [self.m_txt_phone becomeFirstResponder];
    }
    else if(textField.tag==kPhoneType){
    [self.m_txt_gender becomeFirstResponder];
    }
    else if(textField.tag==kGenderType){
    [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case kUsernameType:
            [self.m_txt_nickName becomeFirstResponder];
            break;
            
        case kNickNameType:
            [self.m_txt_website becomeFirstResponder];
            break;
        
        case kInfoType:
            [self.m_txt_email becomeFirstResponder];
            break;
        
        case kEmailType:
            [self.m_txt_phone becomeFirstResponder];
            break;
        
        case kPhoneType:
            [self.m_txt_gender becomeFirstResponder];
            break;
            
        case kGenderType:
            [textField resignFirstResponder];
            break;
        default:
            NSLog(@"No case statement for %@", [textField description]);
            break;
    }
    
}





# pragma mark :Memory usage warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end


