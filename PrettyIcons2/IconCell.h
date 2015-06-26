//
//  iconCell.h
//  PrettyIcons2
//
//  Created by Ronald Hernandez on 6/26/15.
//  Copyright (c) 2015 Wahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconCellImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end
