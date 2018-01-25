//
//  NSString+CheckPoint.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CheckPoint)

-(BOOL)isEmpty;
-(BOOL)validateEmail:(NSString *)emailStr;
-(BOOL)validatePhoneNumberWithString:(NSString *)string;
-(BOOL)isValidEmail;
-(BOOL)isEmptyString:(NSString*)str;

@end
