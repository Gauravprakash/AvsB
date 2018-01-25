//
//  CALayer+BorderProperties.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 20/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "CALayer+BorderProperties.h"

@implementation CALayer (BorderProperties)

- (void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
