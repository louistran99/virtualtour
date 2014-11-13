//
//  ViewController.m
//  VirtualTour
//
//  Created by Louis Tran on 11/10/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"
#import "PanoramaStitcher.h"
#import "ResultVC.h"
#import "SCRecorder.h"
#import "VTRImageDebugView.h"

#import "NSString+Extras.h"

#define radiansToDegrees(x) (180/M_PI)*x

static CGFloat const kVTrotationThreshold = 25.0 * 2* M_PI / 180;


@interface ViewController () <SCRecorderDelegate> {
    dispatch_queue_t _processingQueue;
    SCRecorder *_recorder;
    
    // motion related ivars
    CMMotionManager *_motionManager;
    CGFloat _referenceYaw;
    CGFloat _currentYaw;
}

@property (nonatomic,strong) CMAttitude *referenceAttitude;
@property (nonatomic,readwrite) CMAttitude *currentAttitude;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startStitching:)];
    [self.view addGestureRecognizer:tapGesture];
    
    // create background queue
    _processingQueue = dispatch_queue_create("com.opencv.queue", NULL);
    
    //
    [self setupSCRecorder];
    
    // set up core motion
    [self setupCoreMotion];
    
}

-(void) viewDidDisappear:(BOOL)animated  {
    [super viewDidDisappear:animated];
    [self teardownCoreMotion];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) updateReferenceYaw:(CGFloat) yaw {
    _referenceYaw = yaw;
    [self.debugView.referenceYaw setText:[NSString stringWithFormat:@"%1.2f",radiansToDegrees(_referenceYaw)]];
}


-(void) updateReference:(CMAttitude*) attitude {
    _referenceAttitude = attitude;

}


-(void) startStitching:(UIGestureRecognizer*) gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        _referenceAttitude = _motionManager.deviceMotion.attitude;
        [self.debugView.referenceYaw setText:[NSString stringWithFormat:@"%1.2f",radiansToDegrees(_referenceAttitude.yaw)]];
//        [_activityIndicatorView startAnimating];
//        dispatch_async(_processingQueue, ^{
//            PanoramaStitcher *sticher = [[PanoramaStitcher alloc] init];
//            sticher.delegate = self;
//            [sticher process];
//        });
        
    }
}

#pragma mark set up core motion
-(void) setupCoreMotion {
    _motionManager = [[CMMotionManager alloc] init];
    if (_motionManager) {
        _motionManager.deviceMotionUpdateInterval = 1.0f / 10.0f;
        if ([CMMotionManager availableAttitudeReferenceFrames] & CMAttitudeReferenceFrameXArbitraryZVertical) {
            [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
        }
        
        ViewController * __weak weakSelf = self;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
            } else {
                CMQuaternion quat = motion.attitude.quaternion;
                float myRoll = radiansToDegrees(atan2(2*(quat.y*quat.w - quat.x*quat.z), 1 - 2*quat.y*quat.y - 2*quat.z*quat.z)) ;
                float myPitch = radiansToDegrees(atan2(2*(quat.x*quat.w + quat.y*quat.z), 1 - 2*quat.x*quat.x - 2*quat.z*quat.z));
                float myYaw = radiansToDegrees(asin(2*quat.x*quat.y + 2*quat.w*quat.z));
                
                // kalman filtering
                static float q = 0.1;   // process noise
                static float r = 0.1;   // sensor noise
                static float p = 0.1;   // estimated error
                static float k = 0.5;   // kalman filter gain
                
                float x = myYaw;
                p = p + q;
                k = p / (p + r);
                x = x + k*(myYaw - x);
                p = (1 - k)*p;
                myYaw = x;
                [weakSelf.debugView.pitchLabel setText:[NSString stringWithFormat:@"%f",myPitch]];
                [weakSelf.debugView.rollLabel setText:[NSString stringWithFormat:@"%f",myRoll]];
                [weakSelf.debugView.yawLabel setText:[NSString stringWithFormat:@"%1.3f",myYaw]];
                
                
                if (weakSelf.referenceAttitude == nil) {
                    weakSelf.referenceAttitude = motion.attitude;
                    [self updateReference:motion.attitude];
                }
                
            }
        }];
//        [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
//            if (error) {
//                NSLog(@"%@",[error description]);
//            } else {
//                [weakSelf.debugView.pitchLabel setText:[NSString stringWithFormat:@"%f",motion.attitude.pitch]];
//                [weakSelf.debugView.rollLabel setText:[NSString stringWithFormat:@"%f",motion.attitude.roll]];
//                [weakSelf.debugView.yawLabel setText:[NSString stringWithFormat:@"%f",motion.attitude.yaw]];
//            }
//        }];
    }
}

-(void) teardownCoreMotion {
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
}


#pragma mark set up video
-(void) setupSCRecorder {
    _recorder = [SCRecorder recorder];
    _recorder.sessionPreset = AVCaptureSessionPresetPhoto;// AVCaptureSessionPreset1280x720;
    _recorder.audioEnabled = NO;
//    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = NO;
    _recorder.photoEnabled = YES;               // enable capturing still photo
    _recorder.previewView = _preview;
    //    NSLog(@"setupSCRecorder -- width:%1.1f\t height :%1.1f",_preview.frame.size.width,_preview.frame.size.height);
    
    [_recorder openSession:^(NSError *sessionError, NSError *audioError, NSError *videoError, NSError *photoError) {
        NSLog(@"==== Opened session ====");
        NSLog(@"Session error: %@", sessionError.description);
        NSLog(@"Audio error : %@", audioError.description);
        NSLog(@"Video error: %@", videoError.description);
        NSLog(@"Photo error: %@", photoError.description);
        NSLog(@"Preview Layer: %@",[_recorder.previewLayer description]);
        NSLog(@"=======================");
        [_recorder startRunningSession];
        [self setupRecordingSession];
        [self setUpStillCapture];
    }];
}

-(void) setupRecordingSession {
    if (_recorder.photoOutput) {
        [_recorder.photoOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void) setUpStillCapture {
    NSArray *pixelFormats = [_recorder.photoOutput availableImageDataCVPixelFormatTypes];
    for (NSString *format in pixelFormats) {
        NSLog(@"%@",format);
    }
}

#pragma mark tear down video


#pragma take picture





#pragma mark PanoramaStitcherProtocol
-(void) PanoramaStitchingDidFinish:(UIImage *)panorama {

    dispatch_async(dispatch_get_main_queue(), ^{
        [_activityIndicatorView stopAnimating];
        _imageView.image = panorama;
        _imageView.alpha = 1.0f;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    });

    
}

@end
