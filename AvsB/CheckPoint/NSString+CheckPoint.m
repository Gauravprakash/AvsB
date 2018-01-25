//
//  NSString+CheckPoint.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 08/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "NSString+CheckPoint.h"

@implementation NSString (CheckPoint)

- (BOOL)isEmpty{
    if ([self isEqualToString:@""]){
        return YES;
    }  else{
        return NO;
    }
}
- (BOOL)validateEmail:(NSString *)emailStr{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
-(BOOL)isValidEmail{
    NSString *emailRegex = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)validatePhoneNumberWithString:(NSString *)string {
        if (nil == string || ([string length] < 2 ) )
            return NO;
        
        NSError *error;
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
        NSArray *matches = [detector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *match in matches) {
            if ([match resultType] == NSTextCheckingTypePhoneNumber) {
                NSString *phoneNumber = [match phoneNumber];
                if ([string isEqualToString:phoneNumber]) {
                    return YES;
                }
            }
        }
        
        return NO;
}

-(BOOL)isEmptyString:(NSString*)str{
    if([str isEqualToString:@""]||[str isKindOfClass:[NSNull class]]||str.length==0||[str isEqualToString:@"null"]||str==nil){
        return YES;
    }
    else
    return NO;
}

@end
