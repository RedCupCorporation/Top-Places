//
//  GenericTableViewController.m
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericTableViewController.h"
#import "PlacesTableViewController.h"
#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"

@interface GenericTableViewController ()

@property (nonatomic, strong) NSArray *tableViewDataSource;

@end

@implementation GenericTableViewController

@synthesize tableViewDataSource = _tableViewDataSource;

- (void)viewDidLoad {
    self.tabBarController.delegate = self;
}

#define RECENTLY_VIEWED_KEY @"PhotosTableViewController.RecentlyViewed"

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[PlacesTableViewController class]]) {
        NSArray *topPlaces = [FlickrFetcher topPlaces];
        topPlaces = [topPlaces sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"_content" ascending:TRUE]]];
        self.tableViewDataSource = topPlaces;
    } else if ([viewController isKindOfClass:[PhotosTableViewController class]]) {
        self.tableViewDataSource = [[NSUserDefaults standardUserDefaults] objectForKey:RECENTLY_VIEWED_KEY];
    }
}

- (void)setTableViewDataSource:(NSArray *)tableViewDataSource {
    if (tableViewDataSource != _tableViewDataSource) {
        _tableViewDataSource = tableViewDataSource;
        [self.tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
