//
//  DetailViewController.m
//  PrettyIcons2
//
//  Created by Ronald Hernandez on 6/26/15.
//  Copyright (c) 2015 Wahoo. All rights reserved.
//

#import "DetailViewController.h"
#import "Icon.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

    self.imageView.image = self.icon.image;

    
}


@end
