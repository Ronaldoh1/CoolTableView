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

    //to add the edit button at the top simply add the one that's already bilt in.

    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //we neeed to get the sets to display in table view

    self.iconSets = [IconSet iconSets ];

    //enable selection during edit mode.

    self.tableView.allowsSelectionDuringEditing =YES;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//in willSelectRowAtIndexPath - this will return the indexPath only it's the last item in the section and it's in editing mode. It will not allow the user to select other cells. This is basically so that if the user taps on the last cell (to add a new icon) no matter where the user taps, the table view will know that the user is trying to add a new item

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    IconSet *set = self.iconSets[indexPath.section];

    //here we're basically saying that if the user taps on a cell that corresponds to an item in the set, we do not return the index path.
    if ([self isEditing] && indexPath.row < set.icons.count ) {
        return nil;


        //if it's not one of the items in the set, then that means this is the extra cell that the user can tap to add a new cell. So for this we return the indexPath.
    } else {

        return indexPath;
    }

}

//We also need to prevent the tapping on the additional cell to trigger a segue. We can check for this in the should prepare for segue.
//here in shouldPerformSegueWithIdentifier, we check if the identifier is equal to the identifier set have set on storyboard and also check if it's editing mode ...if it is then we do not want to perform the segue. Else we should perform the segue as always.
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{

    if ([identifier isEqualToString:@"goToDetail"] && [self isEditing]){
        return NO;
    }else{
        return YES;
    }

}

//didSelectRowAtIndexPath delegate method needs to be overriden. If you want to know which row was selected. We can remove the high light here.

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //here we remove the cell highlight when you come back from detail vc.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    //we check the icon set
    IconSet *set = self.iconSets[indexPath.section];

    //here we're in editing mode and we're beyond the number of icons - so here we're already showing the extra cell.
    if (indexPath.row >= set.icons.count && [self isEditing]) {
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
    }




}

//we need to implement the two delegate methods that will allow us to work with the different sections in table view.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.iconSets.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    IconSet *set = self.iconSets[section];
    return set.name;
}

//in order to be able to delete an item from the table view you need to implement the following method and checkfor the diting style.
//also this method is used to insert new rows to table.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //delete the item from the data model.
        IconSet *set = self.iconSets[indexPath.section];
        [set.icons removeObjectAtIndex:indexPath.row];

        //we need to remove it from the tableview
        //using reloadData is the dumb way of doing it - it is not good for the user's perspective.
        //[self.tableView reloadData];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        //if the user tap add icon - you need to actually update the data model and the tableview itself.
    } else if (editingStyle == UITableViewCellEditingStyleInsert){
        IconSet *set = self.iconSets[indexPath.section];
        Icon *newIcon = [[Icon alloc] initWithTitle:@"New Icon" subtitle:@"" imageName:nil];
        [set.icons addObject:newIcon];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}

//step 2. conform the class to the delegate and data source protocols.
//we need to know if we're in editing mode.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //adjustment lets us know if we need an aditional row - if we're in editing mode. If we're not in editing mode, then it just returns the number of rows without the adjustment.

    int adjustment = [self isEditing] ? 1 : 0 ;

    IconSet *set = self.iconSets[section];

    return set.icons.count + adjustment;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //create the cell based on prototype.

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    IconSet *set = self.iconSets[indexPath.section];

    //Configure the Cell

    //here we need to see if the current number of rows are greater than the number of icons to display..and if it's editing mode then we want to display add icon to let the user know that he can tap to add another icon...else the tableview is not in editing mode which means we can just return the number of icons.
    if(indexPath.row >= set.icons.count && [self isEditing]){
        cell.textLabel.text = @"Add Icon";
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
    }else{

          Icon *icon = set.icons[indexPath.row];
        cell.textLabel.text = icon.title;
        cell.detailTextLabel.text = icon.subtitle;
        cell.imageView.image = icon.image;
    }



    return cell;
}

//To let the tableView know that you went to edit mode and that it needs to update its self...you must overide setediting methethod...to tell the tableView everything you want to change.

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];

    if (editing) {

        //first we need to loop through all the sections.One insert for every section. This handles the case when we enter editing mode.
        [self.tableView beginUpdates];
        for (int i = 0; i < _iconSets.count; i++) {
            IconSet *set = _iconSets[i];
            //notify the tableview that we're trying to insert a new row.
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:set.icons.count inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];
    }else {
        //first we need to loop through all the sections.We delete one row at a time.  This handles the case when we enter editing mode.
        [self.tableView beginUpdates];
        for (int i = 0; i < _iconSets.count; i++) {
            IconSet *set = _iconSets[i];
            //notify the tableview that we're trying to insert a new row.
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:set.icons.count inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];
    }
}

//To add the green button to the left of the cell for the user to tap. or red button for the user to delete, we must implement the following method.

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    IconSet *set = self.iconSets[indexPath.section];

    if (indexPath.row >= set.icons.count) {

        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}
@end
