//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *photo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)initializeContent;
- (void)setZoomScale;

@end

@implementation PhotoViewController

@synthesize photoReference = _photoReference;
@synthesize photo = _photo;
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize delegate = _delegate;

- (void)setPhotoReference:(NSDictionary *)photoReference {
    if (photoReference != _photoReference) {
        _photoReference = photoReference;
        UIImage *photo = [self.delegate photoWithReference:photoReference];
        if (photo) {
            self.photo = photo;
        } else {
            NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photoReference format:FlickrPhotoFormatLarge];
            self.photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
        }
        [self.delegate photoViewController:self viewedPhoto:self.photo withReference:self.photoReference];
    }
}

- (void)setPhoto:(UIImage *)photo {
    if (photo != _photo) {
        _photo = photo;
        self.imageView.image = self.photo;
    }
}

- (void)initializeContent {
    // self.scrollView.delegate is set in the storyboard
    self.imageView.image = self.photo;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (void)setZoomScale {
    CGFloat scrollViewAspectRatio = self.scrollView.bounds.size.width / self.scrollView.bounds.size.height;
    CGFloat photoAspectRatio = self.photo.size.width / self.photo.size.height;
    BOOL lockHeight = photoAspectRatio > scrollViewAspectRatio;
    if (lockHeight) {
        self.scrollView.contentOffset = CGPointMake((self.photo.size.width - self.scrollView.bounds.size.width) / 2, 0);
        self.scrollView.zoomScale = self.scrollView.bounds.size.height / self.photo.size.height;
        self.scrollView.minimumZoomScale = self.scrollView.bounds.size.width / self.photo.size.width;
    } else {
        self.scrollView.contentOffset = CGPointMake(0, (self.photo.size.height - self.scrollView.bounds.size.height) / 2);
        self.scrollView.zoomScale = self.scrollView.bounds.size.width / self.photo.size.width;
        self.scrollView.minimumZoomScale = self.scrollView.bounds.size.height / self.photo.size.height;
    }
    self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale * 25;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat extraHeight = scrollView.bounds.size.height - scrollView.contentSize.height;
    CGFloat extraWidth = scrollView.bounds.size.width - scrollView.contentSize.width;
    scrollView.contentInset = UIEdgeInsetsMake(extraHeight > 0 ? extraHeight / 2 : 0, extraWidth > 0 ? extraWidth / 2 : 0, 0, 0);
}

- (void)viewWillLayoutSubviews {
    self.scrollView.zoomScale = 1;
    [self initializeContent];
    [self setZoomScale];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
