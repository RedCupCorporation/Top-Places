//
//  PhotoViewController.h
//  TopPlaces
//
//  Created by Colin Regan on 7/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoViewController;
@protocol PhotoViewControllerDelegate

@optional
- (void)photoViewController:(PhotoViewController *)sender viewedPhoto:(UIImage *)photo withReference:(NSDictionary *)photoReference;
- (UIImage *)photoWithReference:(NSDictionary *)photoReference;

@end

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) NSDictionary *photoReference;
@property (nonatomic, weak) id <PhotoViewControllerDelegate> delegate;

@end
