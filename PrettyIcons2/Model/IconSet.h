//
//  IconSet.h
//  WinterIcons
//
//  Created by Main Account on 2/10/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconSet : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *icons;

+ (NSMutableArray *)iconSets;
- (instancetype)initWithName:(NSString *)name icons:(NSMutableArray *)icons;

@end
