//
//  UIImage+OpenCV.h
//  
//
//  Created by Louis Tran on 11/11/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (OpenCV)


+ (cv::Mat)cvMatWithImage:(UIImage *)image;
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;


@end
