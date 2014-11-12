//
//  ViewController.m
//  VirtualTour
//
//  Created by Louis Tran on 11/10/14.
//  Copyright (c) 2014 Louis Tran. All rights reserved.
//

#import "ViewController.h"
#import "PanoramaStitcher.h"
#import "ResultVC.h"
#import "SCRecorder.h"

@interface ViewController () <SCRecorderDelegate> {
    dispatch_queue_t _processingQueue;
    SCRecorder *_recorder;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startStitching:)];
    [self.view addGestureRecognizer:tapGesture];
    
    // create background queue
    _processingQueue = dispatch_queue_create("com.opencv.queue", NULL);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) startStitching:(UIGestureRecognizer*) gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        
        [_activityIndicatorView startAnimating];
        dispatch_async(_processingQueue, ^{
            PanoramaStitcher *sticher = [[PanoramaStitcher alloc] init];
            sticher.delegate = self;
            [sticher process];
        });
        
    }
}

#pragma mark set up video
-(void) setupSCRecorder {
    _recorder = [SCRecorder recorder];
    _recorder.sessionPreset = AVCaptureSessionPresetPhoto;// AVCaptureSessionPreset1280x720;
    _recorder.audioEnabled = NO;
    _recorder.delegate = self;
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
