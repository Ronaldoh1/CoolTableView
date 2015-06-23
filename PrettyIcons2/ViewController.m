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
@property (strong, nonatomic) NSArray *icons;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *iconSet = [IconSet iconSets];
    IconSet *set = (IconSet *)iconSet[0];
    self.icons = set.icons ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//step 2. conform the class to the delegate and data source protocols.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.icons.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //create the cell based on prototype.

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    Icon *icon = self.icons[indexPath.row];

    //fill in the cell details.


    cell.textLabel.text = icon.title;
    cell.detailTextLabel.text = icon.subtitle;
    cell.imageView.image = icon.image;




    return cell;
}


@end
