//
//  ImageGenerator.h
//  VirtualTour
//
//  Created by Louis Tran on 11/11/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageGenerator : NSObject

@property (nonatomic,strong) NSMutableArray *images;


-(instancetype) initWithTestData;

@end
