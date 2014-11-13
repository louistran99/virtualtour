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
#import "UIImage+Resize.h"
#import "UIImage+FixRotation.h"

#define radiansToDegrees(x) (180/M_PI)*x

static double const kVTrotationThreshold = (25.0 * M_PI / 180);


@interface ViewController () <SCRecorderDelegate> {
    dispatch_queue_t _processingQueue;
    SCRecorder *_recorder;
    

    // for animation
    UIView *_flashView;

    
    // motion related ivars
    CMMotionManager *_motionManager;
    CADisplayLink *_timer;
    
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
    [self setUpCoreMotionPulling];
    
    [self setUpDisplayLinkTimer];
    
    [self performSelector:@selector(updateReference) withObject:nil afterDelay:3.0];
    
}

-(void) viewDidDisappear:(BOOL)animated  {
    [super viewDidDisappear:animated];
    [self stopMotionUpdate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) updateReference {
    if (_referenceAttitude == nil) {
        _referenceAttitude = _motionManager.deviceMotion.attitude;
        [self.debugView.referenceYaw setText:[NSString stringWithFormat:@"%1.2f",radiansToDegrees(_referenceAttitude.yaw)]];
    } else {
        _referenceAttitude = _motionManager.deviceMotion.attitude;
        [self.debugView.referenceYaw setText:[NSString stringWithFormat:@"%1.2f",radiansToDegrees(_referenceAttitude.yaw)]];
    }
}

-(void) setUpDisplayLinkTimer {
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMotion)];
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


-(void) stopMotionUpdate {
    [_timer invalidate];
    [self teardownCoreMotion];
}

-(void) startStitching:(UIGestureRecognizer*) gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        [self.currentAttitude multiplyByInverseOfAttitude:self.referenceAttitude];
        [self.debugView.pitchLabel setText:[NSString stringWithFormat:@"%f",radiansToDegrees(self.currentAttitude.pitch)]];
        [self.debugView.rollLabel setText:[NSString stringWithFormat:@"%f",radiansToDegrees(self.currentAttitude.roll)]];
        [self.debugView.yawLabel setText:[NSString stringWithFormat:@"%1.3f",radiansToDegrees(self.currentAttitude.yaw)]];
        
        [_timer invalidate];
//        [_activityIndicatorView startAnimating];
//        dispatch_async(_processingQueue, ^{
//            PanoramaStitcher *sticher = [[PanoramaStitcher alloc] init];
//            sticher.delegate = self;
//            [sticher process];
//        });
    }
}



#pragma mark core motion

-(void) teardownCoreMotion {
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
}

-(void) setUpCoreMotionPulling {
    _motionManager = [[CMMotionManager alloc] init];
    if (_motionManager) {
        _motionManager.deviceMotionUpdateInterval = 1.0f / 10.0f;
        if ([CMMotionManager availableAttitudeReferenceFrames] & CMAttitudeReferenceFrameXArbitraryCorrectedZVertical) {
            [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
        } else if ([CMMotionManager availableAttitudeReferenceFrames] & CMAttitudeReferenceFrameXArbitraryZVertical) {
            [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
        }
        [_motionManager startDeviceMotionUpdates];
    }
}

-(void) updateMotion {
    self.currentAttitude = _motionManager.deviceMotion.attitude;
    if (self.referenceAttitude) {
        [self.currentAttitude multiplyByInverseOfAttitude:self.referenceAttitude];
    }
    
    if (sin(self.currentAttitude.roll) < -sin(kVTrotationThreshold)) {
        [self updateReference];
        [self takePicture:nil];
    }
//    NSLog(@"angle threshold:%1.2f \t current angle:%1.2f",sinf(kVTrotationThreshold),sin(self.currentAttitude.roll));
    [self.debugView.pitchLabel setText:[NSString stringWithFormat:@"%f",radiansToDegrees(self.currentAttitude.pitch)]];
    [self.debugView.rollLabel setText:[NSString stringWithFormat:@"%f",radiansToDegrees(self.currentAttitude.roll)]];
    [self.debugView.yawLabel setText:[NSString stringWithFormat:@"%1.3f",radiansToDegrees(self.currentAttitude.yaw)]];
    
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

- (void) takePicture:(id)sender {
    
    __block NSMutableArray *_images = [[NSMutableArray alloc] init];
    [_recorder capturePhoto:^(NSError *error, UIImage *image) {
        if (!error) {
            if (image) {
                CGFloat scale = 1024.0/image.size.height;
                CGSize newSize = CGSizeMake(scale*image.size.width, scale*image.size.height);
                
                image = [image fixOrientation];
                image = [image resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
                
                _imageView.image = image;
                _imageView.alpha = 1.0f;
                _imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                NSLog(@"w:%1.0f\t h:%1.0f",[image size].width, [image size].height);
            }
        }
    }];
}

#pragma mark KVO
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"capturingStillImage"]) {
        BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if ( isCapturingStillImage ) {
            // do flash bulb like animation
            _flashView = [[UIView alloc] initWithFrame:[_recorder.previewView frame]];
            [_flashView setBackgroundColor:[UIColor blackColor]];
            [_flashView setAlpha:0.f];
            [[[self view] window] addSubview:_flashView];
            
            [UIView animateWithDuration:.4f
                             animations:^{
                                 [_flashView setAlpha:1.f];
                             }
             ];
        }
        else {
            [UIView animateWithDuration:.4f
                             animations:^{
                                 [_flashView setAlpha:0.f];
                             }
                             completion:^(BOOL finished){
                                 [_flashView removeFromSuperview];
                                 _flashView = nil;
                             }
             ];
        }
    }
}


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
