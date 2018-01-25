//
//  UIImagePickerController+ImageFile.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 14/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "UIImagePickerController+ImageFile.h"

@implementation UIImagePickerController (ImageFile)

- (void)setImageOnView:(UIViewController*)viewController{
    UIImagePickerController *controller =[[UIImagePickerController alloc]init];
    controller.delegate=self;
    controller.allowsEditing=YES;
    controller.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:controller animated:YES completion:nil];
    controller.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   UIImage *chosenImage =info[UIImagePickerControllerEditedImage];
}

-(NSUInteger)supportedInterfaceOrientations{
    UIDeviceOrientation orientation= [[UIDevice currentDevice]orientation];
    if(orientation==UIDeviceOrientationLandscapeRight  || orientation ==UIDeviceOrientationLandscapeLeft){
        return UIInterfaceOrientationLandscapeLeft;
    }
    else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
