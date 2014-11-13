//
//  UIImage+Scale.h
//  VirtualTour
//
//  Created by Louis Tran on 11/13/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;

@end
