//
//  PanoramaStitcher.h
//  VirtualTour
//
//  Created by Louis Tran on 11/11/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#ifndef VirtualTour_PanoramaStitcher_h
#define VirtualTour_PanoramaStitcher_h


#import <Foundation/Foundation.h> 

@protocol PanoramaStitcherProtocol <NSObject>
-(void) PanoramaStitchingDidFinish:(UIImage*) panorama;
@end



@interface PanoramaStitcher : NSObject
@property (weak) id <PanoramaStitcherProtocol> delegate;
-(void) process;

@end



#endif
