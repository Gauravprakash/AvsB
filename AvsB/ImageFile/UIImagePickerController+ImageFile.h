//
//  UIImagePickerController+ImageFile.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 14/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (ImageFile)<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

-(void)setImageOnView:(UIViewController*)viewController;
-(NSUInteger)supportedInterfaceOrientations;


@end
