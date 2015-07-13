//
//  RatingTableViewController.m
//  PrettyIcons2
//
//  Created by Ronald Hernandez on 7/13/15.
//  Copyright (c) 2015 Wahoo. All rights reserved.
//

#import "RatingTableViewController.h"
#import "Icon.h"

@interface RatingTableViewController ()

@end

@implementation RatingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


//loop through all the cells
- (void)refresh{

    for (int i = 0; i < NumRatingTypes; i++){

        UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType = (int)self.icon.rating == i?
        UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self refresh];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //update the rating

    self.icon.rating = indexPath.row;
    [self refresh];
}


@end
