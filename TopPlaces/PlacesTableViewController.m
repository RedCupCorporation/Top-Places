//
//  PlacesTableViewController.m
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrFetcher.h"

@implementation PlacesTableViewController

@synthesize topPlaces = _topPlaces;

- (NSArray *)topPlaces {
    if (!_topPlaces) {
        self.topPlaces = [FlickrFetcher topPlaces];
        NSLog(@"%@", self.topPlaces.description);
    }
    return _topPlaces;
}

- (void)setTopPlaces:(NSArray *)topPlaces {
    if (topPlaces != _topPlaces) {
        _topPlaces = topPlaces;
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Left this method in here in case I want to implement sections later
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *location = [[self.topPlaces objectAtIndex:indexPath.row] objectForKey:@"_content"];
    NSArray *locationArray = [location componentsSeparatedByString:@", "];
    cell.textLabel.text = [locationArray objectAtIndex:0];
    if (locationArray.count > 1) cell.detailTextLabel.text = [locationArray objectAtIndex:1];
    for (int i = 2; i < locationArray.count; i++) {
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@", %@", [locationArray objectAtIndex:i]];
    }
    
    return cell;
}

@end
