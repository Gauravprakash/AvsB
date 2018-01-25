//
//  BlockedusersListing.m
//  AvsB
//
//  Created by Techwin Labs 28 Dec on 19/09/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "BlockedusersListing.h"
@interface BlockedusersListing (){
CommonMethods *m_commonMethods;
BlockedCell *cell;
}
@end
@implementation BlockedusersListing

#pragma mark : view Controller life Cycle

-(void)viewDidLoad {
[super viewDidLoad];
m_commonMethods = [CommonMethods sharedInstance];
[self registerTableData];
self.m_blockListingArray =[[NSArray alloc]init];
}
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
    
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (IBAction)m_backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark : TableView Datasource method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"blockData";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[BlockedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    tableView.separatorColor=[UIColor clearColor];
    UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    cell.m_unblock.tag=indexPath.row;
    [cell.m_unblock setBackgroundColor:[UIColor whiteColor]];
    [cell.m_unblock.layer setCornerRadius:5.0f];
    [cell.m_unblock.layer setBorderWidth:1.0f];
    [cell.m_unblock.layer setBorderColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0].CGColor];
    [cell.contentView addSubview:separatorView];
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)registerTableData{
    UINib*nib=[UINib nibWithNibName:@"BlockedCell" bundle:nil];
    [self.m_blockTable registerNib:nib forCellReuseIdentifier:@"blockData"];
    self.m_blockTable.dataSource=self;
    self.m_blockTable.delegate=self;
}

    
@end
