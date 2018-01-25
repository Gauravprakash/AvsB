//
//  Facebookdelegates.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 21/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

@protocol FacebookDelegate <NSObject>
@required
-(void)getFacebookResult:(NSDictionary *)dict;
-(void)errorResult:(NSError *)error;

@end
@interface Facebookdelegates : NSObject
@property(nonatomic,assign)id<FacebookDelegate>delegate;
-(void)FaceboookLogin:(UIViewController*)viewController;
-(void)fetchInfoFromFacebookResult;
@end
