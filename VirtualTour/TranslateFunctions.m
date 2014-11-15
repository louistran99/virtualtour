//
//  TranslateFunctions.m
//  VirtualTour
//
//  Created by Louis Tran on 11/14/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "TranslateFunctions.h"

@implementation TranslateFunctions

+(CGFloat) getDx:(CGFloat)theta slope:(CGFloat)slope withIntercept:(CGFloat)intercept {
    if (theta > 0.0f) {
        return 0.0f;
    } else if (theta < 1/slope) {
        return 1.0f;
    } else {
        return (slope*theta + intercept);
    }
}


+(CGFloat) getDy:(CGFloat)theta slope:(CGFloat)slope withIntercept:(CGFloat)intercept {
    NSLog(@"%1.2f\t %1.2f\t %1.2f",theta,slope,intercept);
    if (theta > -1/(2*slope)) {
        return 0.0f;
    } else if (theta < 1/(2*slope)) {
        return 1.0f;
    } else {
        return (slope*theta + intercept);
    }
}



@end
