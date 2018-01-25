//
//  FollowersProfile.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 04/07/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "FollowersProfile.h"

@implementation FollowersProfile{
     FollowersProfileCell *cell;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self registerNibFile];
    self.m_followersList = [NSArray arrayWithObjects:@"Cristopher-drops",@"Emily steppens", @"Cristina186",@"Bethanny Dior",@"Rawan Seherbatsky",@"Patrice-plussize",@"Emily steppens", @"Cristina186",@"Bethanny Dior",@"Rawan Seherbatsky",@"Patrice-plussize",@"Cristopher-drops", nil];
    self.m_followersImage =[NSArray arrayWithObjects: @"imgg1",@"imgg2",@"imgg3",@"imgg4",@"imgg1",@"imgg2",@"imgg3",@"imgg4",@"imgg1",@"imgg2",@"imgg3",@"imgg4",nil];
    }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.m_followButton.layer.cornerRadius=5.0f;
    self.m_followButton.clipsToBounds=YES;
    [self.m_followButton.layer setBorderWidth:1.0f];
    [self.m_followButton setBackgroundColor:[UIColor whiteColor]];
    [self.m_profile_name setText:@"liadia SaysSo"];
    [self.m_profile_name setFont:[UIFont fontWithName:@"Proxima Nova-Bold" size:16.0]];
    [self.m_followButton.layer setBorderColor:[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0].CGColor];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
  }
#pragma mark : TableView Datasource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.m_followersList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"reuseData";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[FollowersProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.m_profileName.textColor=[UIColor colorWithRed:0/255.0 green:114/255.0 blue:215/255.0 alpha:1.0];
    tableView.separatorColor=[UIColor clearColor];
    UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    cell.m_buttonFolllow.tag=indexPath.row;
    [cell.contentView addSubview:separatorView];
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [CommonMethods setImageCorner:cell.m_imageFollowers];
    cell.m_profileName.text =[NSString stringWithFormat:@"%@",[self.m_followersList objectAtIndex:indexPath.row]];
    cell.m_imageFollowers.image = [UIImage imageNamed:[self.m_followersImage objectAtIndex:indexPath.row]];
    [cell.m_buttonFolllow setTitle:@"Following" forState:UIControlStateNormal];
    [cell.m_buttonFolllow setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0]
                               forState:UIControlStateNormal];
    [cell.m_buttonFolllow setBackgroundColor:[UIColor whiteColor]];
    [cell.m_buttonFolllow.layer setCornerRadius:5.0f];
    [cell.m_buttonFolllow.layer setBorderWidth:1.0f];
    [cell.m_buttonFolllow.layer setBorderColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0].CGColor];
    if(indexPath.row%2!=0){
        [cell.m_buttonFolllow setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.m_buttonFolllow setBackgroundColor:[UIColor colorWithRed:0/255.0 green:131/255.0 blue:217/255.0 alpha:1.0]];
        [cell.m_buttonFolllow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.m_buttonFolllow.layer setBorderWidth:0.0f];
        [cell.m_buttonFolllow.layer setBorderColor:[UIColor clearColor].CGColor];
    }
return cell;
}

- (IBAction)m_back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)registerNibFile{
    UINib*nib=[UINib nibWithNibName:@"FollowersProfileCell" bundle:nil];
    [self.m_tableView registerNib:nib forCellReuseIdentifier:@"reuseData"];
    self.m_tableView.dataSource=self;
    self.m_tableView.delegate=self;
}

@end
