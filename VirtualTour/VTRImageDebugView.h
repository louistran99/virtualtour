//
//  VTRImageDebugView.h
//  VirtualTour
//
//  Created by Louis Tran on 11/12/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTRImageDebugView : UIView

@property (nonatomic) IBOutlet UILabel *pitchLabel;
@property (nonatomic,strong) IBOutlet UILabel *yawLabel;
@property (nonatomic) IBOutlet UILabel *rollLabel;
@property (nonatomic,strong) IBOutlet UILabel *referenceYaw;


@end
