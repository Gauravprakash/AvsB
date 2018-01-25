//
//  AddProfilePicture.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//
#import "AddProfilePicture.h"

@interface AddProfilePicture (){
    WebServices *webData;
    CommonMethods *commonData;
    NSString*headerFile;
    NSOperationQueue*mainQueue;
    UIImage *chosenImage;
    AppDelegate *appDelegate;
    NSString *imgURL;
    NSString *userId;
    NSString *tokenKey;
    NSMutableArray*new_signUpData;
    UIActivityIndicatorView *indicator;
}
@end
@implementation AddProfilePicture

#pragma mark : View Controller life Cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    webData=[[WebServices alloc]init];
    webData.CommonSourcedelegate = self;
    webData.signupimagedelegate = self;
    headerFile = AUTHKEY;
    commonData =[CommonMethods sharedInstance];
    mainQueue=[[NSOperationQueue alloc]init];
    new_signUpData=[[NSMutableArray alloc]init];
    webData.gettingFeeddelegate=self;
    appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//   [CommonMethods saveUserValue:appDelegate.userData forKey:@"userData"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
    webData.CommonSourcedelegate=self;
    webData.profileImageUpdatedelegate=self;
    [CommonMethods setImageCorner:self.m_profileImage];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
    [indicator setHidden:YES];
    [indicator removeFromSuperview];
}
- (IBAction)m_selectPhoto:(id)sender{
    if(self.m_profileImage!=nil){
        [self showActionSheet];
}
}

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
    if  ([buttonTitle isEqualToString:@"Take Photo"]){
        [self takePhoto];
    }
    else if ([buttonTitle isEqualToString:@"Choose From Library"]){
      [self selectPhoto];
    }
    else if ([buttonTitle isEqualToString:@"Remove Current Photo"]){
        self.m_profileImage.image = [UIImage imageNamed:@"roundcamera"];
        self.m_addpicture.text = @"Add profile picture";
        self.m_photo_description.text =@"Add a profile photo so that your friends know it's you.";
        [self.m_skip setTitle:@"Skip" forState:UIControlStateNormal];
        [self.add_photo setTitle:@"Add a Photo" forState:UIControlStateNormal];
    }
}

#pragma mark : Image Controller and its delegate
-(void)selectPhoto{
    UIImagePickerController* img_Picker =[[UIImagePickerController alloc]init];
    img_Picker.delegate = self;
    img_Picker.allowsEditing =YES;
    img_Picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:img_Picker animated:YES completion:nil];
}
-(void)takePhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    UIImagePickerController* img_Picker =[[UIImagePickerController alloc]init];
    img_Picker.delegate = self;
    img_Picker.allowsEditing =YES;
    img_Picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:img_Picker animated:YES completion:nil];

}
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    chosenImage = info[UIImagePickerControllerEditedImage];
    if (chosenImage!=nil) {
     self.m_profileImage.image=nil;
    [self  sendDataTobackendforuploadingPic:chosenImage withheaderFile:AUTHKEY];
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//MARK: Skip button Action
- (IBAction)m_skip:(id)sender {
    if (chosenImage!=nil) {
     [appDelegate.userData setObject:imgURL forKey:@"picture"];
    }
    else{
     [appDelegate.userData setObject:@"imgg4" forKey:@"picture"];
    }
     [self sendDataToBackend:appDelegate.userData];
}

//********* MARK: send Data to backend **************

//webservice calling for signup as a new user
-(void)sendDataToBackend:(NSMutableDictionary*)dic_elements{
    NSString *signup_URL = Signup_URL
   [webData sendhttpDataToBackend:dic_elements withHeader:headerFile passingthroughURL:signup_URL];
}

//webservices calling for uploading profile picture 
-(void)sendDataTobackendforuploadingPic:(UIImage*)imagefile withheaderFile:(NSString*)headerFile{
    [webData signUpImageUploading:headerFile withStringUrl:UploadSignupPic_URL uploadingImage:imagefile];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    [indicator setCenter:self.m_profileImage.center];
    [self.view addSubview:indicator];
}
// hitting webservice to get user profile
-(void)hittingWebServicetoGetuserProfile{
    NSString *url =[NSString stringWithFormat:@"%@/%@",userprofile_URL,userId];
    [webData gettingFeedResult:url parameters:appDelegate.array_rawData];
}

// getting sign up result
-(void)getResults:(NSDictionary*)dataDict{
    NSString *methodName =[dataDict valueForKey:@"method"];
     NSString* m_success= [dataDict valueForKey:@"status"];
    if([methodName isEqualToString:@"signup"]){
    if([m_success intValue]==200){
    [CommonMethods saveUserValue:dataDict forKey:@"signupdata"];
               if([appDelegate.array_rawData count]==0||[appDelegate.array_rawData count]>0){
                [appDelegate.array_rawData removeAllObjects];
                userId = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"id"]];
                tokenKey =[dataDict valueForKey:@"token"];
                new_signUpData =[NSMutableArray arrayWithObjects: userId,tokenKey,AUTHKEY,nil];
                appDelegate.array_rawData = new_signUpData;
                [NSThread detachNewThreadSelector:@selector(hittingWebServicetoGetuserProfile) toTarget:self withObject:nil];
            }
       }
    }
    else{
        NSLog(@"Method name is not matching");
    }
}

// getting result of signup imageuploading
-(void)profilePicUploadingSignupCase:(NSDictionary*)responseData error:(NSError *)error{
    NSString *methodName =[responseData valueForKey:@"method"];
    NSString* m_success= [responseData valueForKey:@"status"];
    if([methodName isEqualToString:@"upload_signup_picture"]){
        if([m_success intValue]==200){
            if([responseData count]>0){
            imgURL = [responseData valueForKey:@"picture"];
                dispatch_queue_t concurrentQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //this will start the image loading in bg
                   dispatch_async(concurrentQueue, ^{
                    NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgURL]];
                    //this will set the image when loading is finished
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.m_profileImage.image = [UIImage imageWithData:image];
                        [indicator stopAnimating];
                        [indicator removeFromSuperview];
                        self.m_addpicture.text = @"Hoila, picture uploaded successfully";
                        self.m_photo_description.text =@"Your friends are waiting to see,Go ahead";
                        [self.m_skip setTitle:@"Done" forState:UIControlStateNormal];
                        [self.add_photo setTitle:@"Change your Picture" forState:UIControlStateNormal];
                    });
                });
               }
            else{
                NSLog(@"Response data is empty");
            }
        }
        else{
        kAlertView(@"", error.localizedDescription);
        }
    }
    else{
    NSLog(@"Method name not matching..try again");
    }
}

// handling delegate of new users sign up data;
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSString *resultStatus = [responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"profile"]){
        if([resultStatus intValue]==200){
            if([appDelegate.userprofile_data count]==0||[appDelegate.userprofile_data count]>0){
                appDelegate.userprofile_data = nil ;
                appDelegate.userprofile_data = responseData;
                appDelegate.totalPosts=[[responseData valueForKey:@"data"]valueForKey:@"totalposts"];
                appDelegate.totalFollowers=[[responseData valueForKey:@"data"]valueForKey:@"totalfollowers"];
                appDelegate.totalFollowing=[[responseData valueForKey:@"data"]valueForKey:@"totalfollowing"];
                appDelegate.user_name = [responseData valueForKey:@"name"];
                appDelegate.user_info = [[responseData valueForKey:@"data"]valueForKey:@"aboutme"];
                appDelegate.user_name =[[responseData valueForKey:@"data"]valueForKey:@"name"];
                appDelegate.user_phone =[[responseData valueForKey:@"data"]valueForKey:@"phone"];
                 appDelegate.nick_name =[[responseData valueForKey:@"data"]valueForKey:@"username"];
                 appDelegate.user_email= [[responseData valueForKey:@"data"]valueForKey:@"email"];
                 appDelegate.user_gender = [[responseData valueForKey:@"data"]valueForKey:@"gender"];
                 appDelegate.user_website = [[responseData valueForKey:@"data"]valueForKey:@"website"];
               [mainQueue addOperationWithBlock:^{
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        TabControlSection *Tab= INSTANTIATE(TAB_CONTROL_SECTION);
                             [self.navigationController pushViewController:Tab animated:YES];
                    }];
                }];
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 [CommonMethods alertView:self  title:@"" message:[responseData objectForKey:@"message"]];
            });
          }
    }
    else{
        NSLog(@"Method name not matching");
    }
}
-(void)errorMethod:(NSError *) error{
NSLog(@"Error result shown : %@",error.localizedDescription);
}
//MARK: Memory usage warning
-(void)didReceiveMemoryWarning{
[super didReceiveMemoryWarning];
}
@end
