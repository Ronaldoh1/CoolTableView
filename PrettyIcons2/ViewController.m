//
//  ViewController.m
//  PrettyIcons2
//
//  Created by Ronald Hernandez on 6/22/15.
//  Copyright (c) 2015 Wahoo. All rights reserved.
//

#import "ViewController.h"
#import "Icon.h"
#import "IconSet.h"


//step 1 - ciclude the delegate and date source

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *iconSets;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //we neeed to get the sets to display in table view

    self.iconSets = [IconSet iconSets];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//we need to implement the two delegate methods that will allow us to work with the different sections in table view.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.iconSets.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    IconSet *set = self.iconSets[section];
    return set.name;
}

//step 2. conform the class to the delegate and data source protocols.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    IconSet *set = self.iconSets[section];

    return set.icons.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //create the cell based on prototype.

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    IconSet *set = self.iconSets[indexPath.section];

    Icon *icon = set.icons[indexPath.row];

    //fill in the cell details.


    cell.textLabel.text = icon.title;
    cell.detailTextLabel.text = icon.subtitle;
    cell.imageView.image = icon.image;




    return cell;
}


@end
