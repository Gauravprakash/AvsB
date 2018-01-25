//
//  NSMutableAttributedString+FormatLabel.h
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 27/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (FormatLabel)

- (NSMutableAttributedString*)setLabelAttributes:(NSString *)input col:(UIColor *)col size:(Size)size;
-(void)resizeToStretch;
-(float)expectedWidth;
@end
