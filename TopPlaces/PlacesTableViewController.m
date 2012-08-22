//
//  PlacesTableViewController.m
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"

@interface PlacesTableViewController () 

@property (nonatomic, strong) NSArray *places;

@end

@implementation PlacesTableViewController

@synthesize places = _places;

- (NSArray *)places {
    if (!_places) {
        NSArray *array = [FlickrFetcher topPlaces];
        array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"_content" ascending:TRUE]]];
        self.places = array;
    }
    return _places;
}

- (void)setPlaces:(NSArray *)places {
    if (places != _places) {
        _places = places;
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToPhotoList"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [segue.destinationViewController setLocationReference:[self.places objectAtIndex:indexPath.row]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *location = [[self.places objectAtIndex:indexPath.row] objectForKey:@"_content"];
    NSArray *locationArray = [location componentsSeparatedByString:@", "];
    cell.textLabel.text = [locationArray objectAtIndex:0];
    if (locationArray.count > 1) cell.detailTextLabel.text = [locationArray objectAtIndex:1];
    for (int i = 2; i < locationArray.count; i++) {
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@", %@", [locationArray objectAtIndex:i]];
    }
    
    return cell;
}

@end
