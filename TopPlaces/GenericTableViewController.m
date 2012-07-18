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

@property (nonatomic, readonly) NSArray *topPlaces;
@property (nonatomic, readonly) NSArray *recentlyViewed;

@end

@implementation GenericTableViewController

@synthesize tableViewDataSource = _tableViewDataSource;
@synthesize topPlaces = _topPlaces;
@synthesize recentlyViewed = _recentlyViewed;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tabBarController.delegate = self;
}

- (NSArray *)topPlaces {
    NSArray *array = [FlickrFetcher topPlaces];
    array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"_content" ascending:TRUE]]];
    return array;
}

- (NSArray *)recentlyViewed {
    return [[NSUserDefaults standardUserDefaults] objectForKey:RECENTLY_VIEWED_KEY];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([[viewController.childViewControllers lastObject] isKindOfClass:[PlacesTableViewController class]]) {
        self.tableViewDataSource = self.topPlaces;
    } else if ([[viewController.childViewControllers lastObject] isKindOfClass:[PhotosTableViewController class]]) {
        self.tableViewDataSource = self.recentlyViewed;
    }
}

- (NSArray *)tableViewDataSource {
    if (!_tableViewDataSource) {
        self.tableViewDataSource = self.topPlaces;
    }
    return _tableViewDataSource;
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
