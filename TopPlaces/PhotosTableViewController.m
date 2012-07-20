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

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSMutableDictionary *photoCache;

- (BOOL)photo:(NSDictionary *)reference isContainedInArray:(NSArray *)array;

@end

@implementation PhotosTableViewController

@synthesize locationReference = _locationReference;
@synthesize photos = _photos;
@synthesize photoCache = _photoCache;

#define RECENTLY_VIEWED_KEY @"PhotosTableViewController.RecentlyViewed"

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.locationReference) self.photos = [[NSUserDefaults standardUserDefaults] objectForKey:RECENTLY_VIEWED_KEY];
}

#define MAX_FLICKR_RESULTS 50

- (void)setLocationReference:(NSDictionary *)locationReference {
    if (locationReference != _locationReference) {
        _locationReference = locationReference;
        self.photos = [FlickrFetcher photosInPlace:self.locationReference maxResults:MAX_FLICKR_RESULTS];
    }
}

- (void)setPhotos:(NSArray *)photos {
    if (photos != _photos) {
        _photos = photos;
        [self.tableView reloadData];
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
        NSDictionary *photoReference = [self.photos objectAtIndex:indexPath.row];
        [segue.destinationViewController setPhotoReference:photoReference];
        UITableViewCell *cell = sender;
        [segue.destinationViewController navigationItem].title = cell.textLabel.text;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photoInformation = [self.photos objectAtIndex:indexPath.row];
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

- (UIImage *)photoWithReference:(NSDictionary *)photoReference {
    return [self.photoCache objectForKey:photoReference];
}

@end
