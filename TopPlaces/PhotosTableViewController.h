//
//  PhotosTableViewController.h
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericTableViewController.h"

@interface PhotosTableViewController : GenericTableViewController

@property (nonatomic, strong) NSDictionary *locationReference; // for Flickr API

@end
