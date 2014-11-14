//
//  PanoramaSticher.m
//  VirtualTour
//
//  Created by Louis Tran on 11/10/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "PanoramaStitcher.h"
#import "UIImage+OpenCV.h"

using namespace cv;


@interface PanoramaStitcher () {


}
@end



@implementation PanoramaStitcher

-(instancetype) init {
    self = [super init];
    if (self) {
    
        
    }
    return self;
}


-(void) process {
    vector<Mat> vImg;
    Mat rImg;
    
    if (_images == nil) {
        _images = [self testFiles];
        for (NSString *file in _images) {
            const char *filename = [file UTF8String];
            vImg.push_back(imread(filename));
        }
    } else {
        for (UIImage *image in _images) {
            Mat imageToProcess = [image CVMat3];//- (cv::Mat)CVMat3
            vImg.push_back(imageToProcess);
        }
//        for (int i=0; i<_files.count; i++) {
//            NSString *file = [_files objectAtIndex:i];
//            const char *filename = [file UTF8String];
//            vImg.push_back(imread(filename));
//        }
    
    }
    
    
    Stitcher stitcher = Stitcher::createDefault();
    stitcher.stitch(vImg, rImg);
    
    UIImage *outputImage = [UIImage imageWithCVMat:rImg];

    if ([self.delegate respondsToSelector:@selector(PanoramaStitchingDidFinish:)]) {
        [self.delegate PanoramaStitchingDidFinish:outputImage];
    }
}


-(NSMutableArray*) testFiles {
    NSArray *files = @[@"/IMG_0177.jpg",@"/IMG_0178.jpg"];
    NSMutableArray *fullPath = [[NSMutableArray alloc] initWithCapacity:files.count];
    
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    
    for (NSString *file in files) {
        [fullPath addObject:[mainBundlePath stringByAppendingString:file]];
    }

    return fullPath;
}





@end

