//
//  CommonMethods.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#define SERVER_URL  @"http://avsb.com/webservices/index.php"
@interface CommonMethods : NSObject
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
+ (id)sharedInstance;
+(void)addPaddingView:(UITextField *)textfield;
+(void)addPaddingViewForEditingProfile:(UITextField *)textfield;
+(void)setImageSideCorner:(UIImageView *)imageview;
+(void)setBackgroundAndCornerRadius:(UITextView*)textView;
+(void)setImageCorner:(UIImageView *)imageview;
+(void)addBackgroundColorToTextField:(UITextField *)textfield;
+(void)addBorderLineToTextField:(UITextField*)textField;
-(void)setLabelAsPerScreenSize:(UILabel*)mlabel;
-(void)addCornerRadiusToButton:(UIButton *)button;
+(void)Addindicator:(UIViewController*)controller message:(NSString*)str ;
+(void)Stopindicator:(UIView*)view ;
-(void)addCustomView:(UIViewController*)viewController inAdjustWith:(UINavigationController*)controller;
+(NSString*)filterStringType:(NSString*)encodedString;
+(void)alertStatus:(NSString *)msg :(NSString *)title withController:(UIViewController *)vc;
+(void)alertView:(UIViewController *)controller title:(NSString *)title message:(NSString *)message;
-(void)integrateCollectionView:(UICollectionView*)collectionView withReuseIdentifier:(NSString*)identifier usingLayout:(UICollectionViewFlowLayout*)layout settingTag:(NSInteger)tag;
-(void)integrateTableView:(UITableView*)tableView withreuseIdentifier:(NSString*)identifier settingTag:(NSInteger)tag;
-(BOOL)networkReachable;
+(void)saveUserValue:(id)dataInfo forKey:(NSString*)keyname;
-(void)removeUserDefaultValueForKey:(NSString*)keyname;
+(UIImage*) drawText:(NSString*) text inImage:(UIImage*)image atPoint:(CGPoint)point;
+(UIImage*)getImageFrom:(NSString*)url;
-(void)adjustlabelheight:(UILabel *)m_label;
-(NSMutableString*) timeLeftSinceDate: (NSDate *) dateT;
-(NSString*)timeLeftString:(NSInteger)remainingTime;
- (NSString *)hexStringFromColor:(UIColor *)color;
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
-(BOOL)validatePhoneNumberWithString:(NSString *)string;
+(UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;
-(NSMutableAttributedString*)decorateTags:(NSString *)stringWithTags;
- (NSTimeInterval)timeFromString:(NSString *)str;
@end
