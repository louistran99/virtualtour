//
//  ViewController.m
//  VirtualTour
//
//  Created by Louis Tran on 11/10/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "ViewController.h"
#import "PanoramaStitcher.h"
#import "ImageGenerator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startStitching:)];
    [self.view addGestureRecognizer:tapGesture];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) startStitching:(UIGestureRecognizer*) gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        PanoramaStitcher *sticher = [[PanoramaStitcher alloc] init];
        [sticher process];
    }
}


@end
