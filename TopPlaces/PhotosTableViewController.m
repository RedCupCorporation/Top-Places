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

@property (nonatomic, strong) NSArray *photoList;
@property (nonatomic, strong) NSMutableDictionary *photoCache;

- (BOOL)photo:(NSDictionary *)reference isContainedInArray:(NSArray *)array;

@end

@implementation PhotosTableViewController

@synthesize locationReference = _locationReference;
@synthesize photoList = _photoList;
@synthesize photoCache = _photoCache;

#define MAX_FLICKR_RESULTS 50

- (void)setLocationReference:(NSDictionary *)locationReference {
    if (locationReference != _locationReference) {
        _locationReference = locationReference;
        self.photoList = [FlickrFetcher photosInPlace:self.locationReference maxResults:MAX_FLICKR_RESULTS];
    }
}

- (void)setPhotoList:(NSArray *)photoList {
    if (photoList != _photoList) {
        _photoList = photoList;
        //[self.tableView reloadData];
    }
}

- (NSMutableDictionary *)photoCache {
    if (!_photoCache) self.photoCache = [NSMutableDictionary dictionary];
    return _photoCache;
}

#define RECENTLY_VIEWED_KEY @"PhotosTableViewController.RecentlyViewed"

- (NSArray *)photoList {
    if (self.tabBarController.selectedIndex == 1) self.photoList = [[NSUserDefaults standardUserDefaults] objectForKey:RECENTLY_VIEWED_KEY];
    return _photoList;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#warning Still must fix bug that leaves the last recently viewed photo out after the user selects a new photo

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToPhotoView"]) {
        [segue.destinationViewController setDelegate:self];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *photoReference = [self.photoList objectAtIndex:indexPath.row];
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
    NSLog(@"recently viewed: %@", recentlyViewed);
    NSLog(@"photo cache: %@", self.photoCache);
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
