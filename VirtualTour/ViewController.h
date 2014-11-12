//
//  ViewController.h
//  VirtualTour
//
//  Created by Louis Tran on 11/10/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanoramaStitcher.h"

@interface ViewController : UIViewController <PanoramaStitcherProtocol>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end

