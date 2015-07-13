//
//  EditViewController.m
//  PrettyIcons2
//
//  Created by Ronald Hernandez on 6/26/15.
//  Copyright (c) 2015 Wahoo. All rights reserved.
//

#import "EditViewController.h"
#import "Icon.h"
#import "DetailViewController.h"
@interface EditViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate   >
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *subTitleTextField;

@property (weak, nonatomic) IBOutlet UITextField *ratingTextField;
@end

@implementation EditViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.iconImage.image = self.icon.image;
    self.titleTextField.text = self.icon.title;
    self.subTitleTextField.text = self.icon.subtitle;
    self.ratingTextField.text = [Icon ratingToString:self.icon.rating];



}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];

    self.icon.image =  self.iconImage.image ;
    self.icon.title =     self.titleTextField.text;
    self.icon.subtitle = self.subTitleTextField.text;

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;


}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return indexPath;
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //deselect the cell.

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    //present the UIImagePicker

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:nil];



}

//need to implement the image picker.
//here you can also take an image.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.icon.image = image;
    self.iconImage.image = image;

    [self dismissViewControllerAnimated:YES completion:nil];




}

//add accessory views

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqual:@"goToDetail"]){

        DetailViewController *destinationVC = (DetailViewController *)segue.destinationViewController;
        destinationVC.icon = self.icon;



    }


}


@end
