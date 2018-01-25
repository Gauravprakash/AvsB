//
//  SignUpView.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 05/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "WebServices.h"
#import "Facebookdelegates.h"
@interface SignUpView : UIViewController<FacebookDelegate,Webservices,signupdata,gettingFeed>
@property(strong,nonatomic)NSMutableDictionary *dataDict;
@property(strong,nonatomic)NSMutableArray *raw_signUpData;
@end
