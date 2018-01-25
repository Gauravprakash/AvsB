//
//  WebServices.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 26/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "WebServices.h"
#import "JSON.h"

@implementation WebServices{
    CommonMethods *commonSource;
    NSMutableData*lookServerResponseData;
    NSMutableDictionary *dic_property;
    NSData *postTypeData;
}

//MARK:Image uploading to PHP server
-(void)imageUploading:(NSArray*)headers withStringUrl:(NSString*)url uploadingImage:(UIImage*)newImage{
NSData *imageData= UIImageJPEGRepresentation(newImage, 0.6);
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
manager.requestSerializer = [AFHTTPRequestSerializer serializer];
manager.responseSerializer = [AFHTTPResponseSerializer serializer];
[manager.requestSerializer setTimeoutInterval:30];
[manager.requestSerializer setValue:[headers objectAtIndex:0] forHTTPHeaderField:@"User-ID"];
[manager.requestSerializer setValue:[headers objectAtIndex:1] forHTTPHeaderField:@"Authorization"];
[manager.requestSerializer setValue:[headers objectAtIndex:2] forHTTPHeaderField:@"Auth-Key"];
[manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
[manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:imageData
                                name:@"userfile"
                            fileName:@"image.jpg" mimeType:@"image/jpeg"];
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    NSError *parseError = nil;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                         options:0
                                                           error:&parseError];
    NSLog(@"json returned: %@", jsonArray);
    if (!parseError){
        [self.profileImageUpdatedelegate profilePictureUpdated:jsonArray error:nil];
         }
     else{
        NSString *err = [parseError localizedDescription];
    }
} failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    [self.profileImageUpdatedelegate profilePictureUpdated:nil error:error];

}];
}

//MARK: send data to https server using NSURL connection
-(void)sendhttpDataToBackend:(NSDictionary *)paramDict withHeader:(NSString*)header passingthroughURL:(NSString*)url {
        commonSource=[CommonMethods sharedInstance];
        NSError*error=nil;
        BOOL internetCheck = [commonSource networkReachable];
        if(internetCheck==YES){
     NSString*jsonString = @"";
    [SVProgressHUD showWithStatus:@"Loading.."];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted  error:&error];
    if (! jsonData){
        NSLog(@"Got an error: %@", error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                                                        timeoutInterval:10.0];

                                                     [request setHTTPMethod:@"POST"];
                                                     [request addValue:header forHTTPHeaderField:@"Auth-Key"];
                                                     [request setHTTPBody:postData];
                                                     NSURLSession *session = [NSURLSession sharedSession];
                                                     
                                                     NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                                                     if (error) {
                                                                                                         NSLog(@"%@", error);
                                                                                                     } else {
                                                                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                                                                        NSString *retString = [NSString stringWithUTF8String:[data bytes]];
                                                                                                        NSError *parseError = nil;
                                                                                                        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                                              options:0
                                                                                                                                                                error:&parseError];
                                                                                                         if (!parseError){
                                                                                                             NSLog(@"json array is %@", jsonArray);
                                                                                                             [SVProgressHUD dismiss];
                                                                                                             [[self CommonSourcedelegate]getResults:jsonArray];
                                                                                                            } else {
                                                                                                             NSString *err = [parseError localizedDescription];
                                                                                                             NSLog(@"Encountered error parsing: %@", err);
                                                                                                             [[self CommonSourcedelegate]errorMethod:err];
                                                                                                            }
                                                                                                     }
                                                                                                 }];
             [dataTask resume];
        }
        else{
            [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
        }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    lookServerResponseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    [lookServerResponseData appendData:data];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"DONE");
    NSError *errorJson=nil;
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:lookServerResponseData options:kNilOptions error:&errorJson];
    NSLog(@"responseDict=%@",responseDict);
}

-(void)httpDelete: (NSString*)url completionHandler: (void(^)(id, NSError*))complete{
    commonSource =[CommonMethods sharedInstance];
    BOOL internetCheck =[commonSource networkReachable];;
    if(internetCheck==YES){
    NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableDictionary* dictionaryAdditionalHeaders = [[NSMutableDictionary alloc] init];
    NSString* stringBearerToken = @"...";
    NSString* stringApiKey = @"...";
    [dictionaryAdditionalHeaders setObject:stringBearerToken forKey:@"Authorization"];
    [dictionaryAdditionalHeaders setObject:stringApiKey forKey:@"x-api-key"];
    [dictionaryAdditionalHeaders setObject:@"application/json" forKey:@"Content-Type"];
    [dictionaryAdditionalHeaders setObject:@0 forKey:@"Content-Length"];
    [urlSessionConfiguration setHTTPAdditionalHeaders: dictionaryAdditionalHeaders];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration: urlSessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest* mutableUrlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [mutableUrlRequest setHTTPMethod: @"DELETE"];
    [[urlSession dataTaskWithRequest:mutableUrlRequest completionHandler: ^(NSData *data, NSURLResponse* response, NSError* error){
          if(error != nil)
          {
              complete(response, error);
          }
          else
          {
              complete(response, nil);
          }
      }] resume];
    }
    else{
           [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
    }
}

//Logout Method Action
-(void)webServicelogOut:(NSString *)string parameters:(NSArray *)parameters{
        commonSource=[CommonMethods sharedInstance];
        NSError*error=nil;
        BOOL internetCheck = [commonSource networkReachable];
        if(internetCheck==YES){
AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]init];
    NSLog(@"Array parameters = %@",parameters);
     [SVProgressHUD showWithStatus:@"Loading.."];
     [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",nil]];
     [manager.requestSerializer setValue:[parameters objectAtIndex:0] forHTTPHeaderField:@"Authorization"];
     [manager.requestSerializer setValue:[parameters objectAtIndex:1] forHTTPHeaderField:@"User-ID"];
     [manager.requestSerializer setValue:[parameters objectAtIndex:2] forHTTPHeaderField:@"Auth-Key"];
     manager.requestSerializer.timeoutInterval = 300.0;
     manager.responseSerializer.acceptableStatusCodes=[NSIndexSet indexSetWithIndex:400];
     manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
     [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",nil]];
    [manager POST:string parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"json returned: %@", responseObject);
        NSError *parseError = nil;
        if (!parseError){
            NSLog(@"json array is %@", responseObject);
            [SVProgressHUD dismiss];
            [self.logoutdelegate logOut:responseObject error:nil];
             }
         else{
            NSString *err = [parseError localizedDescription];
        }
    }
   failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
      [self.logoutdelegate logOut:nil error:error];
   }];
        }
        else{
               [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];        }
}

//userName method Action
-(void)webserviceuserName:(NSString*)string parameters:(NSArray*)paramz{
    commonSource=[CommonMethods sharedInstance];
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]init];
    NSLog(@"Array parameters = %@",paramz);
     [SVProgressHUD showWithStatus:@"Loading.."];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",nil]];
    [manager.requestSerializer setValue:[paramz objectAtIndex:0] forHTTPHeaderField:@"Auth-Key"];
    [manager.requestSerializer setValue: [paramz objectAtIndex:1] forHTTPHeaderField:@"username"];
     manager.requestSerializer.timeoutInterval = 300.0;
     manager.responseSerializer.acceptableStatusCodes=[NSIndexSet indexSetWithIndex:400];
    manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        [manager POST:string parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"json returned: %@", responseObject);
            NSError *parseError = nil;
            if (!parseError){
                NSLog(@"json array is %@", responseObject);
                [SVProgressHUD dismiss];
                  [self.usernamedelegate userNamePick:responseObject error:nil];
                 }
             else{
                NSString *err = [parseError localizedDescription];
            }
        }
            failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                   [self.usernamedelegate userNamePick:nil error:error];
                }];
    }
    else{
          [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
    }
}

#pragma Mark : GET Method

//getting home feed questions 
//get comments
//get replies on comments
//getting question details
//getting followers list
//getting following list
//getting posting list
// getting usersprofile data
// getting question detail

-(void)gettingFeedResult:(NSString *)string parameters:(NSArray *)parameters{
    commonSource=[CommonMethods sharedInstance];
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
    NSDictionary *headers = @{ @"Auth-Key": [parameters objectAtIndex:2],
                               @"User-ID": [parameters objectAtIndex:0],
                               @"Authorization": [parameters objectAtIndex:1],
                               };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                        NSString *retString = [NSString stringWithUTF8String:[data bytes]];
                                                        NSError *parseError = nil;
                                                        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:0
                                                                                                               error:&parseError];
                                                        if (!parseError){
                                                            NSLog(@"json array is %@", jsonArray);
                                                            [self.gettingFeeddelegate gettingFeed:jsonArray error:nil];
                                                            } else {
                                                                NSString *err = [parseError localizedDescription];
                                                                NSLog(@"Encountered error parsing: %@", err);
                                                              [self.gettingFeeddelegate gettingFeed:nil error:err];
                                                    }
                                                    }
                                                }];
        [dataTask resume];
    }
    else{
        [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep trying to refresh or try after sometime"];
    }

}

//Updating users profile
-(void)webServiceUpdateProfile:(NSString *)string parameters:(NSDictionary *)parameters withheaderSection:(NSArray*)headerFile{
    commonSource=[CommonMethods sharedInstance];
    NSLog(@"%@",headerFile);
    NSLog(@"%@",parameters);
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
  NSString*jsonString = @"";
  NSDictionary *headers = @{ @"Auth-Key": [headerFile objectAtIndex:2],
                                                           @"User-ID": [headerFile objectAtIndex:0],
                                                           @"Authorization": [headerFile objectAtIndex:1]
                                                           };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted  error:&error];
        if (! jsonData){
            NSLog(@"Got an error: %@", error);
        }else{
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSData *putData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

                                                     
                                                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                                                        timeoutInterval:30.0];
                                                     [request setHTTPMethod:@"PUT"];
                                                     [request setAllHTTPHeaderFields:headers];
                                                     [request setHTTPBody:putData];
                                                     
                                                     NSURLSession *session = [NSURLSession sharedSession];
                                                     NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                                                     if (error) {
                                                                                                         NSLog(@"%@", error);
                                                                                                     } else {
                                                                                                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                                                                         NSLog(@"%@", httpResponse);
                                                                                                         NSString *retString = [NSString stringWithUTF8String:[data bytes]];
                                                                                                         NSError *parseError = nil;
                                                                                                         NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                                                   options:0
                                                                                                                                                                     error:&parseError];
                                                                                                         if (!parseError){
                                                                                                             NSLog(@"json array is %@", jsonArray);
                                                                                                             [self.profileUpdatedelegate profileUpdated:jsonArray error:error];
                                                                                                             
                                                                                                         } else {
                                                                                                                 NSString *err = [parseError localizedDescription];
                                                                                                                 NSLog(@"Encountered error parsing: %@", err);
                                                                                                            
                                                                                                             }

                                                                                                     }
                                                                                                 }];
                                                     [dataTask resume];
    }
    else{
        [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
    }
}

//getting voting result
-(void)webservicesPostData:(NSString*)string parameters:(NSDictionary*)dataheaders withheaderSection:(NSArray*)headerfile{
    commonSource=[CommonMethods sharedInstance];
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
    NSDictionary *headers = @{ @"Auth-Key": [headerfile objectAtIndex:2],
                               @"User-ID": [headerfile objectAtIndex:0],
                               @"Authorization": [headerfile objectAtIndex:1],
                               };
NSString*jsonString=@"";
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataheaders options:NSJSONWritingPrettyPrinted  error:&error];
if (! jsonData){
    NSLog(@"Got an error: %@", error);
}else{
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                                                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
                                                     [request setHTTPMethod:@"POST"];
                                                     [request setAllHTTPHeaderFields:headers];
                                                     [request setHTTPBody:postData];
                                                     NSURLSession *session = [NSURLSession sharedSession];
                                                     NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                                                     if (error) {
                                                                                                         NSLog(@"%@", error);
                                                                                                     } else {
                                                                                                         NSString *retString = [NSString stringWithUTF8String:[data bytes]];
                                                                                                         NSError *parseError = nil;
                                                                                                         NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                                                                         if (!parseError){
                                                                                                             NSLog(@"json array is %@", jsonArray);
                                                                                                             [self.posthandlingdelegate getPostResult:jsonArray error:nil];
                                                                                                             } else {
                                                                                                                 NSString *err = [parseError localizedDescription];
                                                                                                                 NSLog(@"Encountered error parsing: %@", err);
                                                                                                                [self.posthandlingdelegate getPostResult:nil error:err];
                                                                                                             }
                                                                                                     }
                                                                                                 }];
                                                     [dataTask resume];
    }
    else{
        [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
    }
}

// webservice for hit like or unlike
// webservice for following or unfollowing

-(void)webserviceshitLikeorUnlike:(NSString*)string parameters:(NSDictionary*)dataheaders withheaderSection:(NSArray*)headerfile{
    commonSource=[CommonMethods sharedInstance];
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
            NSDictionary *headers = @{ @"Auth-Key": [headerfile objectAtIndex:2],
                                       @"User-ID": [headerfile objectAtIndex:0],
                                       @"Authorization": [headerfile objectAtIndex:1],
                                       };
        NSString*jsonString=@"";
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataheaders options:NSJSONWritingPrettyPrinted  error:&error];
        if (! jsonData){
            NSLog(@"Got an error: %@", error);
        }else{
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
         NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                            NSString *retString = [NSString stringWithUTF8String:[data bytes]];
                                                            NSError *parseError = nil;
                                                            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                            if (!parseError){
                                                                NSLog(@"json array is %@", jsonArray);
                                                                [SVProgressHUD dismiss];
                                                                [self.getLikedelegate getLikeResult:jsonArray error:nil];
                                                            } else {
                                                                NSString *err = [parseError localizedDescription];
                                                                NSLog(@"Encountered error parsing: %@", err);
                                                                 [self.getLikedelegate getLikeResult:jsonArray error:nil];
                                                            }
                                                        }
                                                    }];
        [dataTask resume];
    }
    else{
        [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
    }
}

//getting reply feed
-(void)gettingReplyFeedResult:(NSString *)string parameters:(NSArray *)parameters{
    commonSource=[CommonMethods sharedInstance];
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
        NSDictionary *headers = @{ @"Auth-Key": [parameters objectAtIndex:2],
                                   @"User-ID": [parameters objectAtIndex:0],
                                   @"Authorization": [parameters objectAtIndex:1],
                                   };
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:30.0];
        [request setHTTPMethod:@"GET"];
        [request setAllHTTPHeaderFields:headers];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSString *retString = [NSString stringWithUTF8String:[data bytes]];
                                                            NSError *parseError = nil;
                                                            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                      options:0
                                                                                                                        error:&parseError];
                                                            if (!parseError){
                                                                NSLog(@"json array is %@", jsonArray);
                                                                [self.gettingreplydelegate gettingreplyFeed:jsonArray error:nil];
                                                                
                                                                 } else {
                                                                    NSString *err = [parseError localizedDescription];
                                                                    NSLog(@"Encountered error parsing: %@", err);
                                                                     [self.gettingreplydelegate gettingreplyFeed:nil error:err];
                                                                }
                                                        }
                                                    }];
        [dataTask resume];
    }
    else{
        [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep trying to refresh or try after sometime"];
    }
}

// signup profile picture uploading
-(void)signUpImageUploading:(NSString*)header withStringUrl:(NSString*)url uploadingImage:(UIImage*)newImage{
    commonSource=[CommonMethods sharedInstance];
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
    NSData *imageData= UIImageJPEGRepresentation(newImage, 0.6);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:40];
    [manager.requestSerializer setValue:header forHTTPHeaderField:@"Auth-Key"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"userfile"
                                fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSError *parseError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:0
                                                               error:&parseError];
        NSLog(@"json returned: %@", jsonArray);
        if (!parseError){
            [self.signupimagedelegate profilePicUploadingSignupCase:jsonArray error:nil];
            }
         else{
            NSString *err = [parseError localizedDescription];
            [self.signupimagedelegate profilePicUploadingSignupCase:nil error:err];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        
    }];
    }
    else{
          [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep trying to refresh or try after sometime"];
    }
}

// suggest user name
-(void)suggestUsername:(NSDictionary*)parameters withheaderPath:(NSString*)authKey passingThroughUrl:(NSString*)url{
    commonSource=[CommonMethods sharedInstance];
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
        NSDictionary *header = @{ @"Auth-Key": authKey};
        NSString*jsonString=@"";
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted  error:&error];
        if (! jsonData){
            NSLog(@"Got an error: %@", error);
        }else{
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:header];
        [request setHTTPBody:postData];
         NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                            NSString *retString = [NSString stringWithUTF8String:[data bytes]];
                                                            NSError *parseError = nil;
                                                            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                            if (!parseError){
                                                                NSLog(@"json array is %@",jsonArray);
                                                                [self.usernamesuggestdelegate gettingUserName:jsonArray error:nil];

                                                            } else {
                                                                NSString *err = [parseError localizedDescription];
                                                                NSLog(@"Encountered error parsing: %@", err);
                                                                [self.usernamesuggestdelegate gettingUserName:nil error:error];
                                                            }
                                                        }
                                                    }];
        [dataTask resume];
    }
    else{
        [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep trying to refresh or try after sometime"];
    }
}

// question uploading with image

-(void)questionUploadingWithImageData:(NSArray*)headers WithfirstImage:(UIImage*)first_image  intakeWithAnotherImage:(UIImage *)second_image withFirstString:(NSString*)firstimageName withSecondString:(NSString*)secondImageName hitWithUrl:(NSString*)url withFollowingParameters:(NSDictionary*)newData{
    commonSource=[CommonMethods sharedInstance];
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
        NSData *imageToUpload1 = UIImageJPEGRepresentation(first_image,0.3f);
        NSData *imageToUpload2 = UIImageJPEGRepresentation(second_image, 0.3f);
         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
         [manager.requestSerializer setTimeoutInterval:30];
        [manager.requestSerializer setValue:[headers objectAtIndex:0] forHTTPHeaderField:@"User-ID"];
        [manager.requestSerializer setValue:[headers objectAtIndex:1] forHTTPHeaderField:@"Authorization"];
        [SVProgressHUD showWithStatus:@"Loading"];
        [manager.requestSerializer setValue:[headers objectAtIndex:2] forHTTPHeaderField:@"Auth-Key"];
        [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil]];
        NSString  *server_url = [NSString stringWithFormat:@"%@",url];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:server_url parameters:newData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if(imageToUpload1!=nil){
               [formData appendPartWithFileData:imageToUpload1 name:firstimageName fileName:@"option_a.jpg" mimeType:@"image/jpeg"];
            }
            if(imageToUpload2!=nil){
                [formData appendPartWithFileData:imageToUpload2 name:secondImageName fileName:@"option_b.jpg" mimeType:@"image/jpeg"];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
               NSLog(@"SUCCESS");
                NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: responseObject options:kNilOptions error:nil];
                [self.questionwithimagedelegate questionUpdatedWithImage:serializedData error:nil ];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",error.localizedDescription);
              [self.questionwithimagedelegate questionUpdatedWithImage:nil error:error];
    }];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
     [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
        });
}
}

// question uploading with text only
-(void)questionUploadingWithTextData:(NSArray*)headers hitWithUrl:(NSString*)url withFollowingParameters:(NSDictionary*)newData{
    commonSource=[CommonMethods sharedInstance];
        NSError*error=nil;
     BOOL internetCheck = [commonSource networkReachable];
       if(internetCheck==YES){
            [SVProgressHUD showWithStatus:@"Loading"];
             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setTimeoutInterval:30];
          
            [manager.requestSerializer setValue:[headers objectAtIndex:0] forHTTPHeaderField:@"User-ID"];
            [manager.requestSerializer setValue:[headers objectAtIndex:1] forHTTPHeaderField:@"Authorization"];
            [manager.requestSerializer setValue:[headers objectAtIndex:2] forHTTPHeaderField:@"Auth-Key"];
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil]];
            [manager POST:url parameters:newData constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSLog(@"Response: %@", responseObject);
                [self.questionwithtextdelegate questionUpdatedWithText:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error.localizedDescription);
                 [self.questionwithtextdelegate questionUpdatedWithText:nil error:error];
            }];
               }
            else{
            dispatch_async(dispatch_get_main_queue(), ^{
            [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
            });
        }
}

-(void)webServiceTurnedNotificationOnOff:(NSString *)string parameters:(NSArray *)parameters{
    commonSource=[CommonMethods sharedInstance];
    NSLog(@"%@",parameters);
    NSError*error=nil;
    BOOL internetCheck = [commonSource networkReachable];
    if(internetCheck==YES){
    NSString*jsonString = @"";
        NSDictionary *headers = @{ @"Auth-Key": [parameters objectAtIndex:2],
                                   @"User-ID": [parameters objectAtIndex:0],
                                   @"Authorization": [parameters objectAtIndex:1]
                                   };
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:30.0];
        [request setHTTPMethod:@"PUT"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:nil];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"%@", httpResponse);
                                                            NSString *retString = [NSString stringWithUTF8String:[data bytes]];
                                                            NSError *parseError = nil;
                                                            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                      options:0
                                                                                                                        error:&parseError];
                                                            if (!parseError){
                                                                NSLog(@"json array is %@", jsonArray);
                                                                [self.TurnedNotificationOffdelegate getNotificationResult:jsonArray error:nil];
                                                                
                                                                 } else {
                                                                    NSString *err = [parseError localizedDescription];
                                                                    NSLog(@"Encountered error parsing: %@", err);
                                                                    [self.TurnedNotificationOffdelegate getNotificationResult:nil error:err];

                                                                }
                                                            
                                                        }
                                                    }];
        [dataTask resume];
    }
    else{
        [CommonMethods alertView:self title:@"Error!" message:@"It seems your network is down. please keep tryimg to refresh or try after sometime"];
    }
}


@end

