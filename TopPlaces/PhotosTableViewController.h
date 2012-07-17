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


/*

 When an instance of PhotosTableViewController appears, it is either pushed onto the navigation controller by the PlacesTableViewController (which sets the public locationReference property, which in turn sets the photoList property after fetching the results from Flickr) or it is selected from the tab bar.
  
*/