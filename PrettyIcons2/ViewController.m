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
#import "IconCell.h"
#import "DetailViewController.h"
#import "EditViewController.h"


//step 1 - ciclude the delegate and date source

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>
@property (strong, nonatomic) NSArray *iconSets;
@property NSMutableArray *filteredIcons;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayViewController;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //to add the edit button at the top simply add the one that's already bilt in.

    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //we neeed to get the sets to display in table view

    self.iconSets = [IconSet iconSets ];

    //enable selection during edit mode.

    self.tableView.allowsSelectionDuringEditing =YES;



     //Add the gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];

    //add the long press recognizer to the table view.
    [self.tableView addGestureRecognizer:longPress];


    //initialize the array

    self.filteredIcons = [NSMutableArray new];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//****************Long Press Recognizer/////////
//this is the method that will be called every time the user performs a long press.
-(IBAction)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress{

    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];

    //get the current state of the gesture.

    UIGestureRecognizerState state = longPress.state;
    static UIView *snapShot = nil;
    static NSIndexPath *sourceIndexPath = nil;

    switch (state) {
        case UIGestureRecognizerStateBegan: {
            //check to see if we have an indexPath to make sure the user hasn't long pressed in an area that doesn't have an indexPath.

            //if we do have an indexPath, then set the source indexpath to the indexpath that's recognized by the gesture recognizer above.

            if (indexPath) {
                sourceIndexPath = indexPath;

                //get the cell to be moved.
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];


                snapShot = [self customSnapshotFromView:cell];

                __block CGPoint center = cell.center;
                snapShot.center = cell.center;
                snapShot.alpha = 0;


                [self.tableView addSubview:snapShot];
                [UIView animateWithDuration:0.25 animations:^{

                    center.y = location.y;
                    snapShot.center = center;
                    snapShot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapShot.alpha = 0.98;


                    cell.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.alpha = 0;
                    cell.detailTextLabel.alpha = 0;
                    cell.imageView.alpha = 0;


                }];
            }
        }
            break;

        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapShot.center;
            center.y = location.y;
            snapShot.center = center;

            IconSet *destSet = [self.iconSets objectAtIndex:indexPath.section];
            if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.row < destSet.icons.count) {



                IconSet *sourceSet = self.iconSets[sourceIndexPath.section];
                IconSet *destSet = self.iconSets[indexPath.section];

                Icon *iconToMove = sourceSet.icons[sourceIndexPath.row];

                //need to check if the source set = destination set. if they are the same we are basically moving the icon to a different stop in the same array.
                if (sourceSet == destSet) {

                    //use the exchange object at index method to change places of each item within the same array.
                    [destSet.icons exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];


                } else{
                    //else if the source set and destination sets are not the same, then we need to add the icon to the destination set and then remove it from the destination set.

                    //1. We need to add our icon to our destination set.
                    [destSet.icons insertObject:iconToMove atIndex:indexPath.row];
                    
                    //2. we need to remove it from our source set.
                    [sourceSet.icons removeObjectAtIndex:sourceIndexPath.row];
                    
                    
                    
                    
                }

                //tell the table that you're moving the item from source indexPath to indexPath.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                sourceIndexPath = indexPath;
                
            }

        }
            break;

        default:{

            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{

                snapShot.transform = CGAffineTransformMakeScale(1.0, 1.0);
                snapShot.alpha = 0.00;


                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.alpha = 1;
                cell.detailTextLabel.alpha = 1;
                cell.imageView.alpha = 1;
            }completion:^(BOOL finished) {
                [snapShot removeFromSuperview];
                snapShot = nil;
            }];
        }
            break;
    }


}

//helper method to get a costum snap shot//
-(UIView *)customSnapshotFromView:(UIView *)inputView{

    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;


    return snapshot;

}
//*******************Moving Rows*************************
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{

    //if the current indexpath is greater than the count of icons available, that means this is the add icon cell which should not be allowed to move. So we need to check if the current IndexPath is great and if it's in editing mode and return NO; Else return Yes and allow cells to be able to move.
    IconSet *set = self.iconSets[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
        return NO;
    }else{
        return YES;
    }
}

//Here you get two indexPaths - the source and the destination.
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    IconSet *sourceSet = self.iconSets[sourceIndexPath.section];
    IconSet *destSet = self.iconSets[destinationIndexPath.section];

    Icon *iconToMove = sourceSet.icons[sourceIndexPath.row];

    //need to check if the source set = destination set. if they are the same we are basically moving the icon to a different stop in the same array.
    if (sourceSet == destSet) {

        //use the exchange object at index method to change places of each item within the same array.
        [destSet.icons exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];


    } else{
        //else if the source set and destination sets are not the same, then we need to add the icon to the destination set and then remove it from the destination set.

        //1. We need to add our icon to our destination set.
        [destSet.icons insertObject:iconToMove atIndex:destinationIndexPath.row];

        //2. we need to remove it from our source set.
        [sourceSet.icons removeObjectAtIndex:sourceIndexPath.row];




    }


}

//This method will check to seee if the indexPath to move the item if not return a different index path. Check if the proposed destination indexpath and to see if the user is trying to put it below the ADD button.
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{


    //get the set for the seciton selected.
    IconSet *set = self.iconSets[proposedDestinationIndexPath.section];

    //check if the user is trying to place the cell beyond/below the add button. if the user tries, simply return the closes indexPath
    if (proposedDestinationIndexPath.row >= set.icons.count) {

        return [NSIndexPath indexPathForRow:set.icons.count -1 inSection:proposedDestinationIndexPath.section];


    }

    //else its ok let the user place the cell at the desired destination.
    return proposedDestinationIndexPath;


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

    if (tableView == self.searchDisplayViewController.searchResultsTableView) {
        return 1;

    }else{
    return self.iconSets.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{


    if (tableView == self.searchDisplayViewController.searchResultsTableView) {
        return nil;
    }else{
        IconSet *set = self.iconSets[section];
        return set.name;
    }


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

    if (tableView == self.searchDisplayViewController.searchResultsTableView) {
        return  self.filteredIcons.count;
    }else{



    int adjustment = [self isEditing] ? 1 : 0 ;

    IconSet *set = self.iconSets[section];

    return set.icons.count + adjustment;

    }

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //create the cell based on prototype.


    //Configure the Cell

    //here we need to see if the current number of rows are greater than the number of icons to display..and if it's editing mode then we want to display add icon to let the user know that he can tap to add another icon...else the tableview is not in editing mode which means we can just return the number of icons.
    if (tableView == self.searchDisplayViewController.searchResultsTableView) {

          IconCell *iconCell  = [self.tableView dequeueReusableCellWithIdentifier:@"customCell"];


        Icon *icon = self.filteredIcons[indexPath.row];
        iconCell.titleLabel.text = icon.title;
        iconCell.subTitleLabel.text = icon.subtitle;
        iconCell.iconCellImage.image = icon.image;
        if (icon.rating == RatingTypeAwesome) {
            iconCell.favoriteImageView.image = [UIImage imageNamed:@"star_sel.png"];
        } else {
            iconCell.favoriteImageView.image = [UIImage imageNamed:@"star_uns.png"];
        }
        return iconCell;
    }else{


    // Create the cell (based on prototype)
    UITableViewCell *cell = nil;

    // Configure the cell
    IconSet *set = self.iconSets[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewRowCell" forIndexPath:indexPath];

        cell.textLabel.text = @"Add Icon";
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        IconCell *iconCell = (IconCell *)cell;

        Icon *icon = set.icons[indexPath.row];
        iconCell.titleLabel.text = icon.title;
        iconCell.subTitleLabel.text = icon.subtitle;
        iconCell.iconCellImage.image = icon.image;
        if (icon.rating == RatingTypeAwesome) {
            iconCell.favoriteImageView.image = [UIImage imageNamed:@"star_sel.png"];
        } else {
            iconCell.favoriteImageView.image = [UIImage imageNamed:@"star_uns.png"];
        }
    }

         return cell;
    }
    





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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    IconSet *set = self.iconSets[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
        return 40;
    }else{
        return 80;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"goToDetail"]) {

        //get a pointer to the destination view controller.
        DetailViewController *destVC = (DetailViewController *)segue.destinationViewController;

        //get the indexpath for selected cell.
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        //lookup the incon that was selected.First you have to check the section/set and then the icon.

        IconSet *set = self.iconSets[indexPath.section];

        Icon *icon = set.icons[indexPath.row];


        destVC.icon = icon;


    } else if ([segue.identifier isEqualToString:@"goToEdit"]) {

        //get a pointer to the destination view controller.
        EditViewController *destVC = (EditViewController *)segue.destinationViewController;

        //get the indexpath for selected cell.
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        //lookup the incon that was selected.First you have to check the section/set and then the icon.

        IconSet *set = self.iconSets[indexPath.section];

        Icon *icon = set.icons[indexPath.row];
        
        
        destVC.icon = icon;
        
        
    }


}

#pragma mark - Filtereing 

-(void)filterIcons:(NSArray *)icons forSearchText:(NSString *)searchText{

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@", searchText];
    [self.filteredIcons addObjectsFromArray:[icons filteredArrayUsingPredicate:predicate]];

}

- (void)filteredContentForSearchText:(NSString *)searchText scopeIndex:(NSInteger)scopeIndex{

    //remove all icons
    [self.filteredIcons removeAllObjects];

    if (scopeIndex == 0 || scopeIndex == 1) {
        IconSet *winterSet = (IconSet *)self.iconSets[0];
        [self filterIcons:winterSet.icons forSearchText:searchText];

    }
    if (scopeIndex == 0 || scopeIndex == 12) {
        IconSet *summerSet = (IconSet *)self.iconSets[1];
        [self filterIcons:summerSet.icons forSearchText:searchText];

    }
}

#pragma mark - Search Contol Display Delegate Methods.

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{

    [self filteredContentForSearchText:searchString scopeIndex:self.searchDisplayViewController.searchBar.selectedScopeButtonIndex];

    return YES;


}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{

    [self filteredContentForSearchText:self.searchDisplayViewController.searchBar.text scopeIndex:searchOption];

    return YES;



}
@end
