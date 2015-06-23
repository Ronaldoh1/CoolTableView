//
//  Icon.m
//  WinterIcons
//
//  Created by Main Account on 2/10/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "Icon.h"

@implementation Icon

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName {
  if ((self = [super init])) {
    _title = title;
    _subtitle = subtitle;
    _image = [UIImage imageNamed:imageName];
    _rating = RatingTypeUnrated;
  }
  return self;
}

@end