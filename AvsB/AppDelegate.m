//
//  AppDelegate.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 05/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.

//we need to perfect the text based feed UI preview
//and with images one also
//this is major task of today
//

#import "AppDelegate.h"
@interface AppDelegate (){
    UIStoryboard *storyboard;
    UIWindow*window;
    UINavigationController*navController;
    WebServices *webClass;
}
@end
@implementation AppDelegate
@synthesize img_profile;
@synthesize delegateCalling;
static AppDelegate * gSharedClient = nil;

+ (id)  sharedInstance{
    if (!gSharedClient)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            gSharedClient = [[AppDelegate alloc] init];
        });
    }
    return gSharedClient;
}

#pragma Mark : Application Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    // To avoid Memory releasing issue
    if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled"))
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
    self.userData =[[NSMutableDictionary alloc]init];
    self.array_rawData=[[NSMutableArray alloc]init];
    self.userprofile_data=[[NSMutableDictionary alloc]init];
    self.signup_resultant=[[NSDictionary alloc]init];
    webClass=[[WebServices alloc]init];
    webClass.gettingFeeddelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(landOnHomePage:) name:@"HomeNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(landOnLoginPage:) name:@"LoginNotification" object:nil];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"signupdata"]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"signupdata"]!=nil){
                       [self getRawData];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *url =[NSString stringWithFormat:@"%@/%@",userprofile_URL,self.m_userID];
                  [webClass gettingFeedResult:url parameters:self.array_rawData];
        });
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    delegateCalling=NO;
    img_profile=[UIImage imageNamed:@"placeholder_user"];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    Reachability *rHostName =[Reachability reachabilityWithHostName:@"http://54.229.178.2/avsb/api/index.php"];
    [rHostName startNotifier];
    [rHostName currentReachabilityStatus];
    NetworkStatus status=[rHostName currentReachabilityStatus];
    if(status!=NotReachable){
        NSLog(@"You're connected with internet successfully");
    }
    else{
      NSLog(@"No Connection found, Please try after sometime or keep trying to refresh your page");
    }
}
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]){
      [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeNotification" object:self];
    }
    else{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:self];
    }
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatingProfile:) name:@"ProfileUpdated" object:nil];
    self.signup_Type=@"0";
    m_hashTagValue =[[NSMutableArray alloc]init];
    m_commentSection =[[NSMutableArray alloc]init];
    m_titleQuery =[[NSMutableArray alloc]init];
    self.userDataStore = [NSUserDefaults standardUserDefaults];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication  annotation:annotation];
  return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(void)goToLogin
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginView*login =[storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    self.navigationController =[[UINavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController = self.navigationController;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Techwin.AvsB" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AvsB" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AvsB.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark : NsNotificationcenter Methods
-(void)landOnHomePage:(NSNotification*)notification{
    if([notification.name isEqualToString:@"HomeNotification"]){
        storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabControlSection*tab=[storyboard instantiateViewControllerWithIdentifier:TAB_CONTROL_SECTION];
         navController=[[UINavigationController alloc]initWithRootViewController:tab];
        [[navController navigationBar] setHidden:YES];
        self.window.rootViewController=navController;
    }
}
-(void)landOnLoginPage:(NSNotification*)notification{
    if([notification.name isEqualToString:@"LoginNotification"]){
        storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginView*login=[storyboard instantiateViewControllerWithIdentifier:LOGIN_VIEW_SCREEN];
        navController=[[UINavigationController alloc]initWithRootViewController:login];
        [[navController navigationBar]setHidden:YES];
        self.window.rootViewController=navController;
    }
}

-(void)getRawData{
  self.signup_resultant=[[NSUserDefaults standardUserDefaults]objectForKey:@"signupdata"];
    NSLog(@" Dictionary items are: %@",self.signup_resultant);
    if([self.signup_resultant count]>0){
        self.m_userID = [NSString stringWithFormat:@"%@",[self.signup_resultant valueForKey:@"id"]];
        self.m_tokenKey=[self.signup_resultant valueForKey:@"token"];
        self.array_rawData =[NSMutableArray arrayWithObjects: self.m_userID,self.m_tokenKey,AUTHKEY, nil];
    }
    else{
      NSLog(@"Dictionary having no data ");
    }
}

-(void)updatingProfile:(NSNotification*)notification{
    if([notification.name isEqualToString:@"ProfileUpdated"]){
        NSString *url =[NSString stringWithFormat:@"%@/%@",userprofile_URL,self.m_userID];
              [webClass gettingFeedResult:url parameters:self.array_rawData];
    }
}

// handle delegate response
-(void)gettingFeed:(NSDictionary *)responseData error:(NSError *)error{
    NSLog(@"Response data = %@",responseData);
    NSString *resultStatus = [responseData valueForKey:@"status"];
    NSString *methodName =[responseData valueForKey:@"method"];
    if([methodName isEqualToString:@"profile"]){
        if([resultStatus intValue]==200){
            if([responseData count]>0){
            self.userprofile_data = responseData;
            self.totalPosts=[[responseData valueForKey:@"data"]valueForKey:@"totalposts"];
            self.totalFollowers=[[responseData valueForKey:@"data"]valueForKey:@"totalfollowers"];
            self.totalFollowing=[[responseData valueForKey:@"data"]valueForKey:@"totalfollowing"];
            self.user_info =[[responseData valueForKey:@"data"]valueForKey:@"aboutme"];
            self.user_name =[[responseData valueForKey:@"data"]valueForKey:@"name"];
            self.user_phone =[[responseData valueForKey:@"data"]valueForKey:@"phone"];
            self.nick_name =[[responseData valueForKey:@"data"]valueForKey:@"username"];
            self.user_email= [[responseData valueForKey:@"data"]valueForKey:@"email"];
            self.user_gender = [[responseData valueForKey:@"data"]valueForKey:@"gender"];
            self.user_website = [[responseData valueForKey:@"data"]valueForKey:@"website"];
            }
        }
        else{
//          [CommonMethods alertView:self  title:@"" message:[responseData objectForKey:@"message"]];
        }
    }
}
@end