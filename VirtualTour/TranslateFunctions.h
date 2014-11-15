//
//  TranslateFunctions.h
//  VirtualTour
//
//  Created by Louis Tran on 11/14/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslateFunctions : NSObject

+(CGFloat) getDx:(CGFloat)theta slope:(CGFloat) slope withIntercept:(CGFloat) intercept;
+(CGFloat) getDy:(CGFloat)theta slope:(CGFloat)slope withIntercept:(CGFloat)intercept;


@end
