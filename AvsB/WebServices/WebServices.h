//
//  WebServices.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 26/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"
#define AUTHKEY  @"haveyouauthkey?Not!Goback!GetFirsT!:D"
@protocol Webservices <NSObject>
@required
-(void)errorMethod:(NSError *) error;
-(void)getResults:(NSDictionary*)dataDict;
@end
@protocol Logoutservice <NSObject>
@required
-(void)logOut:(NSDictionary *)responseData error:(NSError *)error;
@end
@protocol Randomusername <NSObject>
@required
-(void)userNamePick:(NSDictionary*)responseData error:(NSError *)error;
@end
@protocol gettingFeed<NSObject>
@required
-(void)gettingFeed:(NSDictionary*)responseData error:(NSError *)error;
@end
@protocol profileUpdated <NSObject>
@required
-(void)profileUpdated:(NSDictionary*)responseData error:(NSError*)error;
@end
@protocol ProfilepictureUpdated <NSObject>
@required
-(void)profilePictureUpdated:(NSDictionary*)responseDictionary error:(NSError *)error;
@end
@protocol QuestionuploadingWithImage <NSObject>
@required
-(void)questionUpdatedWithImage:(NSDictionary*)responseDictionary error:(NSError*)error;
@end
@protocol QuestionuploadingWithText <NSObject>
@required
-(void)questionUpdatedWithText:(NSDictionary*)responseDictionary error:(NSError*)error;
@end
@protocol getPostData <NSObject>
@required
-(void)getPostResult:(NSDictionary*)responseDictionary error:(NSError*)error;
@end
@protocol hitLikeOrUnLike <NSObject>
-(void)getLikeResult:(NSDictionary*)responseDictionary error:(NSError*)error;
@end
@protocol gettingreplyfeedResult<NSObject>
@required
-(void)gettingreplyFeed:(NSDictionary*)responseData error:(NSError *)error;
@end
@protocol uploadingpicture <NSObject>
-(void)profilePicUploadingSignupCase:(NSDictionary*)responseData error:(NSError *)error;
@end
@protocol usernameSuggestion <NSObject>
-(void)gettingUserName:(NSDictionary*)responseData error:(NSError*)error;
@end
@protocol signupdata <NSObject>
-(void)getsignUpResult:(NSDictionary*)responseData error:(NSError *)error;
@end
@protocol turnedNotificationOn <NSObject>
-(void)getNotificationResult:(NSDictionary*)responseData error:(NSError *)error;
@end
@interface WebServices : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSURLConnectionDownloadDelegate>
@property(nonatomic,strong)id<Webservices>CommonSourcedelegate;
@property(nonatomic,strong)id<Logoutservice>logoutdelegate;
@property(nonatomic,strong)id<Randomusername>usernamedelegate;
@property(nonatomic,strong)id<gettingFeed>gettingFeeddelegate;
@property(nonatomic,strong)id<profileUpdated>profileUpdatedelegate;
@property(nonatomic,strong)id<ProfilepictureUpdated>profileImageUpdatedelegate;
@property(nonatomic,strong)id<QuestionuploadingWithImage>questionwithimagedelegate;
@property(nonatomic,strong)id<QuestionuploadingWithText>questionwithtextdelegate;
@property(nonatomic,strong)id<getPostData>posthandlingdelegate;
@property(nonatomic,strong)id<hitLikeOrUnLike>getLikedelegate;
@property(nonatomic,strong)id<gettingreplyfeedResult>gettingreplydelegate;
@property(nonatomic,strong)id<uploadingpicture>signupimagedelegate;
@property(nonatomic,strong)id<usernameSuggestion>usernamesuggestdelegate;
@property(nonatomic,strong)id<turnedNotificationOn>TurnedNotificationOffdelegate;
-(void)executeRequestmethod:(NSString*)authKey andDictData:(NSDictionary*)dataDict;
-(void)httpPut:(NSString*)url completionHandler:(void(^)(id, NSError*))complete;
-(void)httpDelete: (NSString*)url completionHandler: (void(^)(id, NSError*))complete;
-(void)sendhttpDataToBackend:(NSDictionary *)paramDict withHeader:(NSString*)header passingthroughURL:(NSString*)url;
-(void)webServicelogOut:(NSString *)string parameters:(NSArray *)parameters;
-(void)webserviceuserName:(NSString*)string parameters:(NSArray*)paramz;
-(void)gettingFeedResult:(NSString*)string parameters:(NSArray *)parameters;
-(void)webServiceUpdateProfile:(NSString *)string parameters:(NSDictionary *)parameters withheaderSection:(NSArray*)headerFile;
-(void)executeImageRequestMethod:(NSString *)urlType updatingImage:(NSData*)imageNamed andDictData:(NSArray*)dict;
-(void)imageUploading:(NSArray*)headers withStringUrl:(NSString*)url uploadingImage:(UIImage*)newImage;
-(void)webServiceUpdateQuestion:(NSString*)string parameters:(NSDictionary*)dataheaders withheaderSection:(NSArray*)headerfile;
-(void)webservicesPostData:(NSString*)string parameters:(NSDictionary*)dataheaders withheaderSection:(NSArray*)headerfile;
-(void)webserviceshitLikeorUnlike:(NSString*)string parameters:(NSDictionary*)dataheaders withheaderSection:(NSArray*)headerfile;
-(void)gettingReplyFeedResult:(NSString *)string parameters:(NSArray *)parameters;
-(void)signUpImageUploading:(NSString*)header withStringUrl:(NSString*)url uploadingImage:(UIImage*)newImage;
-(void)suggestUsername:(NSDictionary*)parameters withheaderPath:(NSString*)authKey passingThroughUrl:(NSString*)url;
-(void)questionUploadingWithImageData:(NSArray*)headers WithfirstImage:(UIImage*)first_image  intakeWithAnotherImage:(UIImage *)second_image withFirstString:(NSString*)firstimageName withSecondString:(NSString*)secondImageName hitWithUrl:(NSString*)url withFollowingParameters:(NSDictionary*)newData;
-(void)questionUploadingWithTextData:(NSArray*)headers hitWithUrl:(NSString*)url withFollowingParameters:(NSDictionary*)newData;
-(void)webServiceTurnedNotificationOnOff:(NSString *)string parameters:(NSArray *)parameters;
@end
