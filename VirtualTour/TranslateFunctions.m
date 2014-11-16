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
        return 1.0f;
    } else if (theta < -1/slope) {
        return 0.0f;
    } else {
        return (slope*theta + intercept);
    }
}


+(CGFloat) getDy:(CGFloat)theta slope:(CGFloat)slope withIntercept:(CGFloat)intercept {
//    NSLog(@"%1.2f\t %1.2f\t %1.2f",theta,slope,intercept);
    if (theta > -1/(2*slope)) {
        return 0.0f;
    } else if (theta < 1/(2*slope)) {
        return 1.0f;
    } else {
        return (slope*theta + intercept);
    }
}


+(CGFloat) kalmanFilterPitch:(CGFloat) measurement {
    static CGFloat estimatedX = 0.0f;
    static CGFloat estimatedError = 1.0f;
    static CGFloat error;
    static CGFloat correctedX;
    static CGFloat kalmanGain;
    const CGFloat kKF = 25.0f;
    
    kalmanGain = estimatedError/(estimatedError + kKF);
    correctedX = estimatedX + kalmanGain *(measurement -estimatedX);
    error = estimatedError*(1-kalmanGain);
    estimatedX = correctedX;
    
    return correctedX;
}

+(CGFloat) kalmanFilterRoll:(CGFloat) measurement {
    static CGFloat estimatedX = 0.0f;
    static CGFloat estimatedError = 1.0f;
    static CGFloat error;
    static CGFloat correctedX;
    static CGFloat kalmanGain;
    const CGFloat kKF = 25.0f;
    
    kalmanGain = estimatedError/(estimatedError + kKF);
    correctedX = estimatedX + kalmanGain *(measurement -estimatedX);
    error = estimatedError*(1-kalmanGain);
    estimatedX = correctedX;
    
    return correctedX;
}

+(CGFloat) kalmanFilterYaw:(CGFloat) measurement {
    static CGFloat estimatedX = 0.0f;
    static CGFloat estimatedError = 1.0f;
    static CGFloat error;
    static CGFloat correctedX;
    static CGFloat kalmanGain;
    const CGFloat kKF = 25.0f;
    
    kalmanGain = estimatedError/(estimatedError + kKF);
    correctedX = estimatedX + kalmanGain *(measurement -estimatedX);
    error = estimatedError*(1-kalmanGain);
    estimatedX = correctedX;
    
    return correctedX;
}



@end
