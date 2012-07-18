//
//  PlacesTableViewController.m
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosTableViewController.h"

@interface PlacesTableViewController () 

@end

@implementation PlacesTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToPhotoList"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [segue.destinationViewController setLocationReference:[self.tableViewDataSource objectAtIndex:indexPath.row]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *location = [[self.tableViewDataSource objectAtIndex:indexPath.row] objectForKey:@"_content"];
    NSArray *locationArray = [location componentsSeparatedByString:@", "];
    cell.textLabel.text = [locationArray objectAtIndex:0];
    if (locationArray.count > 1) cell.detailTextLabel.text = [locationArray objectAtIndex:1];
    for (int i = 2; i < locationArray.count; i++) {
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@", %@", [locationArray objectAtIndex:i]];
    }
    
    return cell;
}

@end
