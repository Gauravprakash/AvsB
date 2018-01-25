//
//  NSMutableAttributedString+FormatLabel.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 27/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "NSMutableAttributedString+FormatLabel.h"

@implementation NSMutableAttributedString (FormatLabel)
- (NSMutableAttributedString*)setLabelAttributes:(NSString *)input col:(UIColor *)col size:(Size)size{
    NSMutableAttributedString *labelAttributes = [[NSMutableAttributedString alloc] initWithString:input];
    UIFont *font=[UIFont fontWithName:@"Helvetica Neue" size:size];
    NSMutableParagraphStyle* style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    [labelAttributes addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, labelAttributes.length)];
    [labelAttributes addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, labelAttributes.length)];
    [labelAttributes addAttribute:NSForegroundColorAttributeName value:col range:NSMakeRange(0, labelAttributes.length)];
    return labelAttributes;
}

@end
