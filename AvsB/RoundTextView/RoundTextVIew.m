//
//  RoundTextVIew.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 25/08/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "RoundTextVIew.h"

@implementation RoundTextVIew

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        [self.layer setBorderColor:[UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0].CGColor];
        [self.layer setBorderWidth:1.0];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
    }
@end
