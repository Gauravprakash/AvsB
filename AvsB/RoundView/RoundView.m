//
//  RoundView.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 26/08/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "RoundView.h"

@implementation RoundView

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        [self.layer setBorderColor:[UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0].CGColor];
        [self.layer setBorderWidth:1.0];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowPath = shadowPath.CGPath;
    }
    return self;
}
@end
