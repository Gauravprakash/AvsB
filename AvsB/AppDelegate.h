//
//  AppDelegate.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 05/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "WebServices.h"
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,gettingFeed>{
    BOOL delegateCalling;
    NSUserDefaults *userDataStore;
    BOOL cancelSelected;
    NSMutableArray *m_hashTagValue;
    NSMutableArray *m_commentSection;
    NSMutableArray *m_titleQuery;
    UIActivityIndicatorView *activityIndicator;
}
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)NSString*hashableText;
@property(strong,nonatomic)NSString *totalPosts;
@property(strong,nonatomic)NSString* totalFollowers;
@property(strong,nonatomic)NSString *totalFollowing;
@property(strong,nonatomic)NSString* signup_Type;
@property(nonatomic,strong)NSMutableDictionary *userData;
@property(nonatomic, assign) BOOL delegateCalling;
@property(nonatomic,assign)NSUserDefaults *userDataStore;
@property(nonatomic,assign)BOOL cancelSelected;
@property(nonatomic,strong)NSMutableArray *array_rawData;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) UINavigationController*navigationController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic)UIImage*img_profile;
@property(strong,nonatomic)NSString * m_tokenKey;
@property(strong,nonatomic)NSString*  m_userID;
@property(strong,nonatomic)NSString *user_info;
@property(strong,nonatomic)NSString *user_name;
@property(strong,nonatomic)NSString *nick_name;
@property(strong,nonatomic)NSString*user_website;
@property(strong,nonatomic)NSString*user_email;
@property(strong,nonatomic)NSString*user_phone;
@property(strong,nonatomic)NSString*user_gender;
@property(strong,nonatomic)NSMutableDictionary*userprofile_data;
@property(strong,nonatomic)NSDictionary*signup_resultant;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (id)sharedInstance;

@end

