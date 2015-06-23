//
//  IconSet.m
//  WinterIcons
//
//  Created by Main Account on 2/10/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "IconSet.h"
#import "Icon.h"

@implementation IconSet

- (instancetype)initWithName:(NSString *)name icons:(NSMutableArray *)icons {
  if ((self = [super init])) {
    _name = name;
    _icons = icons;
  }
  return self;
}

+ (IconSet *)winterSet {

  NSMutableArray *icons = [NSMutableArray array];
  [icons addObject:[[Icon alloc] initWithTitle:@"Ornament" subtitle:@"Hang on your tree" imageName:@"icons_winter_01.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Candy Cane" subtitle:@"Mmm, tasty" imageName:@"icons_winter_02.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Snowman" subtitle:@"A very happy soul" imageName:@"icons_winter_03.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Penguin" subtitle:@"Mario's friend" imageName:@"icons_winter_04.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Santa Hat" subtitle:@"Found it in the chimney" imageName:@"icons_winter_05.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Gift" subtitle:@"Under the tree" imageName:@"icons_winter_06.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Gingerbread Man" subtitle:@"Lives in a yummy house" imageName:@"icons_winter_07.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Christmas Tree" subtitle:@"Smells good" imageName:@"icons_winter_08.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Snowflake" subtitle:@"Unique and beautiful" imageName:@"icons_winter_09.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Reindeer" subtitle:@"A very shiny nose" imageName:@"icons_winter_10.png"]];
  
  return [[IconSet alloc] initWithName:@"Winter" icons:icons];

}

+ (IconSet *)summerSet {

  NSMutableArray *icons = [NSMutableArray array];
  
  [icons addObject:[[Icon alloc] initWithTitle:@"Sun" subtitle:@"A beautiful day" imageName:@"summericons_100px_01.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Beach Ball" subtitle:@"Fun in the sand" imageName:@"summericons_100px_02.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Swim Trunks" subtitle:@"Time to go swimming" imageName:@"summericons_100px_03.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Bikini" subtitle:@"Bow-chicka-bow-wow" imageName:@"summericons_100px_04.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Sand Bucket and Shovel" subtitle:@"A castle in the sand" imageName:@"summericons_100px_05.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Surfboard" subtitle:@"Catch a wave" imageName:@"summericons_100px_06.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Strawberry Dacquari" subtitle:@"Great way to relax" imageName:@"summericons_100px_07.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Sunglasses" subtitle:@"I wear them at night" imageName:@"summericons_100px_08.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Flip Flops" subtitle:@"Sand between your toes" imageName:@"summericons_100px_09.png"]];
  [icons addObject:[[Icon alloc] initWithTitle:@"Ice Cream" subtitle:@"A summer treat" imageName:@"summericons_100px_10.png"]];
  
  return [[IconSet alloc] initWithName:@"Summer" icons:icons];
}

+ (NSMutableArray *)iconSets {
  return [@[[self winterSet], [self summerSet]] mutableCopy];
}

@end
