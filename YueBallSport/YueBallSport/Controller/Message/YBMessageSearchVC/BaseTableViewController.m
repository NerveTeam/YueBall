//
//  BaseTableViewController.m
//  UISearchController&UISearchDisplayController
//
//  Created by zml on 15/12/2.
//  Copyright © 2015年 zml@lanmaq.com. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DemoModel.h"
#import "DemoCell.h"

#import "UIImageView+WebCache.h"
NSString *const kCellIdentifier = @"CellID";
NSString *const kTableCellNibName = @"DemoCell";

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 60.0;
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(DemoCell *)cell forModel:(DemoModel *)model
{
    cell.friendNameLabel.text = model.friendName;
    cell.friendIdLabel.text        = model.friendId;
//    cell.rightImageView.image = //[UIImage imageWithData:model.imageData];
//    cell.groupHeadIcon.image = //[UIImage imageWithData:model.imageData];
    
    [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.headIcon] placeholderImage:[UIImage imageNamed:@"1"]];
    [cell.groupHeadIcon sd_setImageWithURL:[NSURL URLWithString:model.chatIcon] placeholderImage:[UIImage imageNamed:@"1"]];
    
    
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } els/Users/zml/Desktop/UISearchController&UISearchDisplayController/UISearchController&UISearchDisplayController/BaseTableViewController.me if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
