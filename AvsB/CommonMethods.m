//
//  CommonMethods.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 07/06/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods{
    UIView *viewToAdd;
    UIWindow *window;
    AppDelegate*appDelegate;
}

//Shared Instance for this class
static CommonMethods * gSharedClient = nil;
+ (id)  sharedInstance
{
    if (!gSharedClient)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            gSharedClient = [[CommonMethods alloc] init];
        });
    }
    return gSharedClient;
}
# pragma mark : Add Padding view to text field
+(void)addPaddingView:(UITextField *)textfield{
    CGRect screenBounds=[[UIScreen mainScreen]bounds];
    UIView *paddingView;
    if(screenBounds.size.height ==568.0f){
     paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,8,5)];
    }
    else{
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,5)];
    }
    textfield.leftView=paddingView;
    textfield.leftViewMode=UITextFieldViewModeAlways;
}

# pragma mark : Add padding view    to Uitextfield
+(void)addPaddingViewForEditingProfile:(UITextField *)textfield{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,5)];
    textfield.leftView=paddingView;
    textfield.leftViewMode=UITextFieldViewModeAlways;
}
# pragma mark : Round image Corner
+(void)setImageCorner:(UIImageView *)imageview{
    imageview.layer.cornerRadius=imageview.frame.size.width/2;
    imageview.clipsToBounds=YES;
}

#pragma mark : Side Corner for ImageView
+(void)setImageSideCorner:(UIImageView *)imageview{
    imageview.layer.cornerRadius = 10.0f;
    imageview.layer.borderWidth = 1.5f;
    imageview.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:219.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    imageview.clipsToBounds = YES; 
}


# pragma mark : Add BackgroundColor to textfield
+(void)addBackgroundColorToTextField:(UITextField *)textfield{
    textfield.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
}
# pragma mark : Add Border line to textfield
+(void)addBorderLineToTextField:(UITextField*)textField{
    textField.layer.borderWidth=1.0f;
    textField.layer.borderColor=[UIColor colorWithRed:217/255.0 green:221/255.0 blue:225/255.0 alpha:1.0].CGColor;
    textField.layer.cornerRadius=5.0f;
    textField.clipsToBounds=YES;
}
# pragma mark : Add Alertview style
+(void)alertView:(UIViewController *)controller title:(NSString *)title message:(NSString *)message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:action];
    dispatch_async(dispatch_get_main_queue(), ^{
    [controller presentViewController:alertController animated:YES completion:nil];
    });
}
# pragma mark : Add Corner Radius to Button
-(void)addCornerRadiusToButton:(UIButton *)button{
    button.layer.cornerRadius=5.0f;
    button.clipsToBounds=YES;
}
#pragma mark : Add Property To TextView
+(void)setBackgroundAndCornerRadius:(UITextView*)textView{
    textView.layer.borderWidth =1.5f;
    textView.layer.cornerRadius = 5.0f;
    textView.clipsToBounds = YES;
    textView.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:219.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    [textView setTintColor:[UIColor colorWithRed:54.0/255.0 green:126.0/255.0 blue:240/255.0 alpha:1.0]];
    [textView setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]];
}

#pragma mark : To check internet connection

-(BOOL)networkReachable{
    Reachability *reachable = [Reachability reachabilityForInternetConnection];
    [reachable startNotifier];
    NetworkStatus status =[reachable currentReachabilityStatus];
    if(status!=NotReachable){
         return YES;
    }
    else{
          return NO;
    }
}

#pragma mark : To set Alert Status
+(void)alertStatus:(NSString *)msg :(NSString *)title withController:(UIViewController *)vc {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:msg delegate:vc cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tintColor=[UIColor redColor];
    [alert show];
}

#pragma mark : To set label size as per screen sizes
-(void)setLabelAsPerScreenSize:(UILabel *)mlabel{
    mlabel.numberOfLines = 0;
    mlabel.minimumFontSize=10.0f;
    mlabel.adjustsFontSizeToFitWidth = YES;
}
#pragma mark :customized Image
+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0.0f);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    if([text respondsToSelector:@selector(drawInRect:withAttributes:)]){
        NSDictionary *att = @{NSFontAttributeName:font};
        [text drawInRect:rect withAttributes:att];
    }
    else{
        [text drawInRect:CGRectIntegral(rect) withFont:font];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark :RegisteringCollectionView
-(void)integrateCollectionView:(UICollectionView*)collectionView  withReuseIdentifier:(NSString*)identifier usingLayout:(UICollectionViewFlowLayout*)layout settingTag:(NSInteger)tag{
    UINib *nibfile = [UINib nibWithNibName:@"ColorCollectionCell" bundle:nil];
    [layout setMinimumInteritemSpacing:5.f];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [collectionView registerNib:nibfile forCellWithReuseIdentifier:identifier];
    [collectionView setTag:tag];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView setAllowsMultipleSelection:YES];
    [collectionView setCollectionViewLayout:layout];
    [collectionView setPagingEnabled:YES];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setBounces:NO];
}

#pragma mark :Registering TableView
-(void)integrateTableView:(UITableView*)tableView withreuseIdentifier:(NSString*)identifier settingTag:(NSInteger)tag{
    UINib *nibfile =[UINib nibWithNibName:@"UITableViewCell" bundle:nil];
    [tableView registerNib:nibfile forCellReuseIdentifier:@"reuseIdentifier"];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setScrollEnabled:YES];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setTag:tag];
    [tableView setUserInteractionEnabled:YES];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setSeparatorColor:[UIColor clearColor]];
}

#pragma mark - To save value

+(void)saveUserValue:(id)dataInfo forKey:(NSString*)keyname{
    NSLog(@"values are saved");
    [[NSUserDefaults standardUserDefaults] setObject:dataInfo forKey:keyname];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Remove nsuserdefault values

-(void)removeUserDefaultValueForKey:(NSString*)keyname{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyname];
    NSLog(@"values removed successfully");
}
#pragma mark - Add indicator

+(void)Addindicator:(UIViewController*)controller message:(NSString*)str
{
    UIView*m_Indicatorview=[[UIView alloc] init];
    m_Indicatorview.frame=CGRectMake(135 ,259,50,50);
    m_Indicatorview.backgroundColor=[UIColor blackColor];
    m_Indicatorview.layer.cornerRadius=7.0;
    m_Indicatorview.layer.masksToBounds=7.0;
    m_Indicatorview.alpha=0.8f;
    m_Indicatorview.tag=2000;
    
    UIActivityIndicatorView*m_Indicator=[[UIActivityIndicatorView alloc] init];
    [m_Indicator startAnimating];
    m_Indicator.hidden=NO;
    m_Indicator.color=[UIColor whiteColor];
    m_Indicator.frame=CGRectMake(25,25,m_Indicator.frame.size.width,m_Indicator.frame.size.height);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    m_Indicator.transform = transform;
    [m_Indicatorview addSubview:m_Indicator];
    
    [controller.view addSubview:m_Indicatorview];
}
#pragma mark - Stop indicator
+(void)Stopindicator:(UIView*)view
{
    UIView*indicator=(UIView*)[view viewWithTag:2000];
    [indicator removeFromSuperview];
}
+(NSString*)filterStringType:(NSString*)encodedString{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\\"];
    encodedString = [[encodedString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    NSLog(@"%@", encodedString);
    return encodedString;
}
+(UIImage*)getImageFrom:(NSString*)url{
    UIImage *imgtype = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                              [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]]];
    return imgtype;
}
-(void)adjustlabelheight:(UILabel *)m_label{
m_label.numberOfLines = 0;
m_label.lineBreakMode=NSLineBreakByWordWrapping;
[m_label sizeToFit];
}

-(NSMutableString*) timeLeftSinceDate: (NSDate *)dateT {
    NSMutableString *timeLeft = [[NSMutableString alloc]init];
    NSDate *today10am =[NSDate date];
    NSInteger seconds = [today10am timeIntervalSinceDate:dateT];
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    NSInteger minutes = (int) (floor(seconds / 60));
    if(days){
        if (days == 1) {
            [timeLeft appendString:[NSString stringWithFormat:@"%ld Day ", (long)days]];
        } else {
            [timeLeft appendString:[NSString stringWithFormat:@"%ld Days ", (long)days]];
        }
    }
    else if(hours){
        if(hours==1){
        [timeLeft appendString:[NSString stringWithFormat: @"%ld hr ", (long)hours]];
        }
        else{
           [timeLeft appendString:[NSString stringWithFormat: @"%ld hrs ", (long)hours]];
        }
    }
    else{
        [timeLeft appendString: [NSString stringWithFormat: @"%ld min",(long)minutes]];
    }
    return timeLeft;
}

-(NSString*)timeLeftString:(NSInteger)remainingTime{
    NSUInteger h = remainingTime / 3600;
    NSUInteger m = (remainingTime / 60) % 60;
    NSUInteger s = remainingTime% 60;
    NSMutableString*formattedTime = [NSMutableString stringWithFormat:@"%u:%02u:%02u", h, m, s];
    if([formattedTime  isEqualToString:@"00:00:00"]){
        formattedTime =@" ";
    }
    else{
//        [formattedTime appendString:@"  left"];
    }
    return formattedTime;
}
- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

// Helper method..

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    return hexInt;
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

+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(NSMutableAttributedString*)decorateTags:(NSString *)stringWithTags{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
    NSArray *matches = [regex matchesInString:stringWithTags options:0 range:NSMakeRange(0, stringWithTags.length)];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:stringWithTags];
    
    NSInteger stringLength=[stringWithTags length];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSRange wordRange = [match rangeAtIndex:1];
        
        NSString* word = [stringWithTags substringWithRange:wordRange];
        
        //Set Font
        UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, stringLength)];
        
        
        //Set Background Color
        UIColor *backgroundColor=[UIColor orangeColor];
        [attString addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:wordRange];
        
        //Set Foreground Color
        UIColor *foregroundColor=[UIColor blueColor];
        [attString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:wordRange];
        NSLog(@"Found tag %@", word);
    }
    
    // Set up your text field or label to show up the result
    
    //    yourTextField.attributedText = attString;
    //
    //    yourLabel.attributedText = attString;
    
    return attString;
}
- (NSTimeInterval)timeFromString:(NSString *)str{
    NSScanner *scn = [NSScanner scannerWithString:str];
    int h, m, s, c;
    [scn scanInt:&h];
    [scn scanString:@":" intoString:NULL];
    [scn scanInt:&m];
    [scn scanString:@":" intoString:NULL];
    [scn scanInt:&s];
    [scn scanString:@"." intoString:NULL];
    [scn scanInt:&c];
    return h * 3600 + m * 60 + s + c / 100.0;
}
//[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//- (void)keyboardWillShow:(NSNotification*)n
//{
//    [self updateKeyboardProperties:n];
//}
//
//- (void)keyboardWillHide:(NSNotification*)n
//{
//    //NSLog(@"keyboardWillHide %@",[n description]);
//    [self updateKeyboardProperties:n];
//}

//- (void)updateKeyboardProperties:(NSNotification*)n
//{
//    NSNumber *d = [[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    if (d!=nil && [d isKindOfClass:[NSNumber class]])
//        keyboardAnimationDuration = [d floatValue];
//    d = [[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    if (d!=nil && [d isKindOfClass:[NSNumber class]])
//        keyboardAnimationCurve = [d integerValue];
//    NSValue *v = [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//        if ([v isKindOfClass:[NSValue class]])
//        {
//            CGRect r = [v CGRectValue];
//            r = [self.window convertRect:r toView:self];
//            keyboardHeight = r.size.height;
//        }
//}



@end
