//
//  ImageGenerator.m
//  VirtualTour
//
//  Created by Louis Tran on 11/11/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "ImageGenerator.h"

@implementation ImageGenerator




-(instancetype) initWithTestData {
    self = [super init];
    if (self) {
    
        NSArray *files = @[@"IMG_0177.jpg",@"IMG_0177.jpg"];
        _images = [[NSMutableArray alloc] initWithCapacity:files.count];
        
        
        NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
        
        
        for (NSString *file in files) {
            NSLog(@"%@",[mainBundlePath stringByAppendingPathComponent:file]);
        }
    }
    return self;
}



@end
