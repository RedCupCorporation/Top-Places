//
//  GenericTableViewController.h
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericTableViewController : UITableViewController <UITabBarControllerDelegate>

#define RECENTLY_VIEWED_KEY @"PhotosTableViewController.RecentlyViewed"

@property (nonatomic, strong) NSArray *tableViewDataSource;

@end
