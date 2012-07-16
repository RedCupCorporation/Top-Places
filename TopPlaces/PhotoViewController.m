//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController ()

@property (nonatomic, strong) UIImage *photo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewController

@synthesize photoReference = _photoReference;
@synthesize photo = _photo;
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;

- (void)setPhotoReference:(NSDictionary *)photoReference {
    if (photoReference != _photoReference) {
        _photoReference = photoReference;
        NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photoReference format:FlickrPhotoFormatOriginal];
        self.photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
    }
}

- (void)setPhoto:(UIImage *)photo {
    if (photo != _photo) {
        _photo = photo;
        self.imageView.image = self.photo;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.photo;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
