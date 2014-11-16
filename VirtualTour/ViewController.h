//
//  ViewController.h
//  VirtualTour
//
//  Created by Louis Tran on 11/10/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanoramaStitcher.h"

@class VTRImageDebugView;

@interface ViewController : UIViewController <PanoramaStitcherProtocol>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIView *preview;
@property (strong, nonatomic) IBOutlet VTRImageDebugView *debugView;

@property (strong, nonatomic) IBOutlet UIView *tapToStartView;
@property (weak, nonatomic) IBOutlet UIView *movingDot;

@end

