//
//  circleView.m
//  VirtualTour
//
//  Created by Louis Tran on 11/16/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "circleView.h"

@implementation circleView


-(instancetype) init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) setRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5);
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 0.0f, 1.0f);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, _radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
}

@end
