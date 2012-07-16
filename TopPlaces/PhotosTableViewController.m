//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"

@interface PhotosTableViewController ()

@property (nonatomic, strong) NSArray *photoList;

@end

@implementation PhotosTableViewController

@synthesize locationReference = _locationReference;
@synthesize photoList = _photoList;

- (NSArray *)photoList {
    if (!_photoList) {
        self.photoList = [FlickrFetcher photosInPlace:self.locationReference maxResults:50];
    }
    return _photoList;
}

- (void)setPhotoList:(NSArray *)photoList {
    if (photoList != _photoList) {
        _photoList = photoList;
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Left this method in here in case I want to implement sections later
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photoInformation = [self.photoList objectAtIndex:indexPath.row];
    cell.textLabel.text = [photoInformation objectForKey:@"title"];
    cell.detailTextLabel.text = [photoInformation valueForKeyPath:@"description._content"];
    if (cell.textLabel.text.length == 0) {
        if (cell.detailTextLabel.text.length == 0) {
            cell.textLabel.text = @"Unknown";
        } else {
            cell.textLabel.text = cell.detailTextLabel.text;
        }
    }
    
    return cell;
}

@end
