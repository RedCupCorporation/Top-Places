//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

@interface PhotosTableViewController () <PhotoViewControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *photoCache;

- (BOOL)photo:(NSDictionary *)reference isContainedInArray:(NSArray *)array;

@end

@implementation PhotosTableViewController

@synthesize locationReference = _locationReference;
@synthesize photoCache = _photoCache;

#define MAX_FLICKR_RESULTS 50

- (void)setLocationReference:(NSDictionary *)locationReference {
    if (locationReference != _locationReference) {
        _locationReference = locationReference;
        self.tableViewDataSource = [FlickrFetcher photosInPlace:self.locationReference maxResults:MAX_FLICKR_RESULTS];
    }
}

- (NSMutableDictionary *)photoCache {
    if (!_photoCache) self.photoCache = [NSMutableDictionary dictionary];
    return _photoCache;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToPhotoView"]) {
        [segue.destinationViewController setDelegate:self];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *photoReference = [self.tableViewDataSource objectAtIndex:indexPath.row];
        UIImage *photo = [self.photoCache objectForKey:photoReference];
        if (photo) {    // Set photo explicitly if contained in cache
            [segue.destinationViewController setPhoto:photo];
        } else {
            [segue.destinationViewController setPhotoReference:photoReference];
        }
        UITableViewCell *cell = sender;
        [segue.destinationViewController navigationItem].title = cell.textLabel.text;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photoInformation = [self.tableViewDataSource objectAtIndex:indexPath.row];
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

#define MAX_RECENT_PHOTOS 20

#warning Crash: view photo, switch tabs, switch back, back to photoTableViewController, all photos say Unknown

- (void)photoViewController:(PhotoViewController *)sender viewedPhoto:(UIImage *)photo withReference:(NSDictionary *)photoReference {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentlyViewed = [[defaults objectForKey:RECENTLY_VIEWED_KEY] mutableCopy];
    if (!recentlyViewed) recentlyViewed = [NSMutableArray array];
    
    // If it's already in array, remove from array and add at index 0
    // If count exceeds max, remove last object and add at index 0
    // Add to photo cache no matter what since duplicates aren't possible
    
    if ([self photo:photoReference isContainedInArray:[recentlyViewed copy]]) [recentlyViewed removeObject:photoReference];
    if (recentlyViewed.count >= MAX_RECENT_PHOTOS) [recentlyViewed removeLastObject];
    [recentlyViewed insertObject:photoReference atIndex:0];
    [self.photoCache setObject:photo forKey:photoReference];
    
    [defaults setObject:recentlyViewed forKey:RECENTLY_VIEWED_KEY];
    [defaults synchronize];
}

- (BOOL)photo:(NSDictionary *)reference isContainedInArray:(NSArray *)array {
    NSString *photoID = [reference objectForKey:@"id"];
    for (NSDictionary *dict in array) {
        if ([photoID isEqualToString:[dict objectForKey:@"id"]]) return TRUE;
    }
    return FALSE;
}

@end
