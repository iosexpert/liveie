//
//  recordDirectViewController.m
//  Lively
//
//  Created by Brahmasys on 19/03/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "recordDirectViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SCTouchDetector.h"
#import "SCRecorderViewController.h"
#import "SCVideoPlayerViewController.h"
#import "SCImageDisplayerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCSessionListViewController.h"
#import "SCRecordSessionManager.h"
#import "uploadVideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kVideoPreset AVCaptureSessionPresetHigh



@interface recordDirectViewController ()
{
    SCRecorder *_recorder;
    UIImage *_photo;
    SCRecordSession *_recordSession;
    UIImageView *_ghostImageView;
    
    NSArray *animationArray;
    int animationCount;
    int seconds;
    
    NSTimer *timer,*timer1;
    int next;

}

@property (strong, nonatomic) SCRecorderToolsView *focusView;



@end

@implementation recordDirectViewController
#pragma mark - UIViewController

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#endif

#pragma mark - Left cycle

- (void)dealloc {
    _recorder.previewView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    shareOrReply=0;
    
    directOrSimple=1;
    animationView.transform=CGAffineTransformMakeRotation(M_PI);
    screenName=@"upload";

    self.timeRecordedLabel.hidden=YES;
    vFilters=@"";
    
    animationArray=[[NSArray alloc]initWithObjects:@"1_00001.png",@"1_00002.png",@"1_00003.png",@"1_00004.png",@"1_00005.png",@"1_00006.png",@"1_00007.png",@"1_00008.png",@"1_00009.png",@"1_00010.png",@"1_00011.png",@"1_00012.png",@"1_00013.png",@"1_00014.png",@"1_00015.png",@"1_00016.png",@"1_00017.png",@"1_00018.png",@"1_00019.png",@"1_00020.png",@"1_00021.png",@"1_00022.png",@"1_00023.png",@"1_00024.png",@"1_00025.png",@"1_00026.png",@"1_00027.png",@"1_00028.png",@"1_00029.png",@"1_00030.png",@"1_00031.png",@"1_00032.png",@"1_00033.png",@"1_00034.png",@"1_00035.png",@"1_00037.png",@"1_00038.png",@"1_00039.png",@"1_00040.png",@"1_00041.png",@"1_00042.png",@"1_00043.png",@"1_00044.png",@"1_00045.png",@"1_00046.png",@"1_00047.png",@"1_00048.png",@"1_00049.png",@"1_00050.png",@"1_00051.png",@"1_00052.png",@"1_00053.png",@"1_00054.png",@"1_00055.png",@"1_00056.png",@"1_00057.png",@"1_00058.png",@"1_00059.png",@"1_00060.png",@"1_00061.png",@"1_00062.png",@"1_00063.png",@"1_00064.png",@"1_00065.png",@"1_00066.png",@"1_00067.png",@"1_00068.png",@"1_00069.png",@"1_00070.png",@"1_00071.png",@"1_00072.png",@"1_00073.png",@"1_00074.png",@"1_00075.png",@"1_00076.png",@"1_00077.png",@"1_00078.png",@"1_00079.png",@"1_00080.png",@"1_00081.png",@"1_00082.png",@"1_00083.png",@"1_00084.png",@"1_00085.png",@"1_00086.png",@"1_00087.png",@"1_00088.png",@"1_00089.png",@"1_00090.png",@"1_00091.png",@"1_00092.png",@"1_00093.png",@"1_00094.png",@"1_00095.png",@"1_00096.png",@"1_00097.png",@"1_00098.png",@"1_00099.png",@"1_00100.png",@"1_00101.png",@"1_00102.png",@"1_00103.png",@"1_00104.png",@"1_00105.png",@"1_00106.png",@"1_00107.png",@"1_00108.png",@"1_00109.png",@"1_00110.png",@"1_00111.png",@"1_00112.png",@"1_00113.png",@"1_00114.png",@"1_00115.png",@"1_00116.png",@"1_00117.png",@"1_00118.png",@"1_00119.png",@"1_00120.png",@"1_00121.png",@"1_00122.png",@"1_00123.png",@"1_00124.png",@"1_00125.png",@"1_00126.png",@"1_00127.png",@"1_00128.png",@"1_00129.png",@"1_00130.png",@"1_00131.png",@"1_00132.png",@"1_00133.png",@"1_00134.png",@"1_00135.png",@"1_00136.png",@"1_00137.png",@"1_00138.png",@"1_00139.png",@"1_00140.png",@"1_00141.png",@"1_00142.png",@"1_00143.png",@"1_00144.png",@"1_00145.png",@"1_00146.png",@"1_00147.png",@"1_00148.png",@"1_00149.png",@"1_00150.png",@"1_00151.png",@"1_00152.png",@"1_00153.png",@"1_00154.png",@"1_00155.png",@"1_00156.png",@"1_00157.png",@"1_00158.png",@"1_00159.png",@"1_00160.png",@"1_00161.png",@"1_00162.png",@"1_00163.png",@"1_00164.png",@"1_00165.png",@"1_00167.png",@"1_00168.png",@"1_00169.png",@"1_00170.png", nil];

    
    
    
    _ghostImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _ghostImageView.contentMode = UIViewContentModeScaleAspectFill;
    _ghostImageView.alpha = 0.2;
    _ghostImageView.userInteractionEnabled = NO;
    _ghostImageView.hidden = YES;
    
    [self.view insertSubview:_ghostImageView aboveSubview:self.previewView];
    
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    //    _recorder.maxRecordDuration = CMTimeMake(10, 1);
    //    _recorder.fastRecordMethodEnabled = YES;
    
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    UIView *previewView = self.previewView;
    _recorder.previewView = previewView;
    
    [self.retakeButton addTarget:self action:@selector(handleRetakeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton addTarget:self action:@selector(handleStopButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.reverseCamera addTarget:self action:@selector(handleReverseCameraTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.recordView addGestureRecognizer:[[SCTouchDetector alloc] initWithTarget:self action:@selector(handleTouchDetected:)]];
    self.loadingView.hidden = YES;
    
    self.focusView = [[SCRecorderToolsView alloc] initWithFrame:previewView.bounds];
    self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    self.focusView.insideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    
    _recorder.initializeSessionLazily = NO;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    NSLog(@"Skipped video buffer");
}

- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
    NSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
    NSLog(@"Reconfigured video input: %@", videoInputError);
    if(videoInputError != nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera Services Disabled!"
                                                            message:@"Liveie does not have access to your camera. To enable access, Tap Settings and turn on Camera."
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"Cancel", nil];
        alertView.tag = 100;
        [alertView show];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    seconds=0;
    
    if(goUpload==1)
    {
        goUpload=0;
        
                   uploadVideoViewController *mvc;
            if(iphone4)
            {
                mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController@6p" bundle:nil];
            }
            else
            {
                mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController@ipad" bundle:nil];
            }
            [self.navigationController pushViewController:mvc animated:YES];
        }

    
    
    [self prepareSession];
    next=0;

    if(videoUploaded)
    {
        [self.tabBarController setSelectedIndex:0];
    }
    
    animationView.image=[UIImage imageNamed:@""];
    
    self.navigationController.navigationBarHidden = YES;
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }
    
    [self handleRetakeButtonTapped:0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }
    
    
    [_recorder startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer1 invalidate];
    [timer invalidate];
    [_recorder stopRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Handle

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*) message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alertView.tag=6;
    [alertView show];
}
//Home Button or Back Button Action
-(IBAction)backButton:(id)sender
{
    
    [self backBUtton:sender];
    
}
- (void)showVideo {
    
    shareOrReply=1;
    SCVideoPlayerViewController *mvc;
    if(iphone4)
    {
        mvc=[[SCVideoPlayerViewController alloc]initWithNibName:@"SCVideoPlayerViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[SCVideoPlayerViewController alloc]initWithNibName:@"SCVideoPlayerViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[SCVideoPlayerViewController alloc]initWithNibName:@"SCVideoPlayerViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[SCVideoPlayerViewController alloc]initWithNibName:@"SCVideoPlayerViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[SCVideoPlayerViewController alloc]initWithNibName:@"SCVideoPlayerViewController@ipad" bundle:nil];
    }
    mvc.recordSession = _recordSession;
    [self.navigationController pushViewController:mvc animated:YES];
    //[self performSegueWithIdentifier:@"Video" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[SCVideoPlayerViewController class]]) {
        SCVideoPlayerViewController *videoPlayer = segue.destinationViewController;
        videoPlayer.recordSession = _recordSession;
    } else if ([segue.destinationViewController isKindOfClass:[SCImageDisplayerViewController class]]) {
        SCImageDisplayerViewController *imageDisplayer = segue.destinationViewController;
        imageDisplayer.photo = _photo;
        _photo = nil;
    } else if ([segue.destinationViewController isKindOfClass:[SCSessionListViewController class]]) {
        SCSessionListViewController *sessionListVC = segue.destinationViewController;
        
        sessionListVC.recorder = _recorder;
    }
}

- (void)showPhoto:(UIImage *)photo {
    _photo = photo;
    [self performSegueWithIdentifier:@"Photo" sender:self];
}

- (void) handleReverseCameraTapped:(id)sender {
    [_recorder switchCaptureDevices];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *url = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    SCRecordSessionSegment *segment = [SCRecordSessionSegment segmentWithURL:url info:nil];
    
    [_recorder.session addSegment:segment];
    _recordSession = [SCRecordSession recordSession];
    [_recordSession addSegment:segment];
    
    [self showVideo];
}
- (void) handleStopButtonTapped:(id)sender {
    if(next==1)
    {
        [_recorder pause:^{
            [self saveAndShowSession:_recorder.session];
        }];
    }

}

- (void)saveAndShowSession:(SCRecordSession *)recordSession {
    [[SCRecordSessionManager sharedInstance] saveRecordSession:recordSession];
    
    _recordSession = recordSession;
    [self showVideo];
}

- (void)handleRetakeButtonTapped:(id)sender {
    SCRecordSession *recordSession = _recorder.session;
    
    if (recordSession != nil) {
        _recorder.session = nil;
        
        // If the recordSession was saved, we don't want to completely destroy it
        if ([[SCRecordSessionManager sharedInstance] isSaved:recordSession]) {
            [recordSession endSegmentWithInfo:nil completionHandler:nil];
        } else {
            [recordSession cancelSession:nil];
        }
    }
    
    [self prepareSession];
}

- (IBAction)switchCameraMode:(id)sender {
    if ([_recorder.captureSessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordView.alpha = 1.0;
            self.retakeButton.alpha = 1.0;
            self.stopButton.alpha = 1.0;
        } completion:^(BOOL finished) {
            _recorder.captureSessionPreset = kVideoPreset;
            [self.flashModeButton setTitle:@"Flash : Off" forState:UIControlStateNormal];
            _recorder.flashMode = SCFlashModeOff;
        }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.recordView.alpha = 0.0;
            self.retakeButton.alpha = 0.0;
            self.stopButton.alpha = 0.0;
        } completion:^(BOOL finished) {
            _recorder.captureSessionPreset = AVCaptureSessionPresetPhoto;
            [self.flashModeButton setTitle:@"Flash : Auto" forState:UIControlStateNormal];
            _recorder.flashMode = SCFlashModeAuto;
        }];
    }
}

- (IBAction)switchFlash:(id)sender {
    NSString *flashModeString = nil;
    if ([_recorder.captureSessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        switch (_recorder.flashMode) {
            case SCFlashModeAuto:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeOn;
                break;
            case SCFlashModeOn:
                flashModeString = @"Flash : Light";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Auto";
                _recorder.flashMode = SCFlashModeAuto;
                break;
            default:
                break;
        }
    } else {
        switch (_recorder.flashMode) {
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }
    
    [self.flashModeButton setTitle:flashModeString forState:UIControlStateNormal];
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        
        _recorder.session = session;
    }
    
    [self updateTimeRecordedLabel];
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }
    
}

- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
    NSLog(@"didCompleteSession:");
    [self saveAndShowSession:recordSession];
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized audio in record session");
    } else {
        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized video in record session");
    } else {
        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Began record segment: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
}

- (void)updateTimeRecordedLabel {
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.session != nil) {
        currentTime = _recorder.session.duration;
    }
    
    self.timeRecordedLabel.text = [NSString stringWithFormat:@"%.0f", CMTimeGetSeconds(currentTime)];
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    [self updateTimeRecordedLabel];
}

- (void)handleTouchDetected:(SCTouchDetector*)touchDetector {
    if([self.timeRecordedLabel.text intValue]==10)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Video" message:@"Maximum Limit Completed" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        alert.tag=6;
        [alert show];
    }
    else
    {
        if (touchDetector.state == UIGestureRecognizerStateBegan) {
            _ghostImageView.hidden = YES;
            
            if(seconds==10)
            {
                [timer1 invalidate];
            }
            else
            {
                timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(SaveVideo) userInfo:nil repeats:YES ];
                [_recorder record];
                timer1=[NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(updateline) userInfo:nil repeats:YES ];
            }
        } else if (touchDetector.state == UIGestureRecognizerStateEnded) {
            [_recorder pause];
            [timer1 invalidate];
            [timer invalidate];
            
            
        }
    }
    next=1;

}
-(void)updateline
{
    if(animationCount<167)
        animationCount++;
    animationView.image=[UIImage imageNamed:animationArray[animationCount]];
}
-(void)SaveVideo
{
    
    seconds+=1;
    videoLegth= seconds;
    if (seconds==10)
    {
        [_recorder pause];
        [timer invalidate];
        
    }
    
}- (IBAction)backBUtton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)capturePhoto:(id)sender {
    [_recorder capturePhoto:^(NSError *error, UIImage *image) {
        if (image != nil) {
            [self showPhoto:image];
        } else {
            [self showAlertViewWithTitle:@"Failed to capture photo" message:error.localizedDescription];
        }
    }];
}



- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)closeCameraTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==100)
    {
    
    if(buttonIndex == 0)//Settings button pressed
    {
        
        //This will opne particular app location settings
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
    else if(buttonIndex == 1)//Cancel button pressed.
    {
        //TODO for cancel
    }
    }
    
}
@end
