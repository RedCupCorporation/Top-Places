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

@end

@implementation GenericTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tabBarController.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //NSLog(@"selected tab: %@", [viewController.childViewControllers lastObject]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
