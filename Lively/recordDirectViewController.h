//
//  recordDirectViewController.h
//  Lively
//
//  Created by Brahmasys on 19/03/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"

@interface recordDirectViewController : UIViewController<SCRecorderDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *recordBtn;
    IBOutlet UIImageView *animationView;
}
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *timeRecordedLabel;
@property (weak, nonatomic) IBOutlet UIView *downBar;
@property (weak, nonatomic) IBOutlet UIButton *reverseCamera;
@property (weak, nonatomic) IBOutlet UIButton *flashModeButton;

- (IBAction)switchFlash:(id)sender;
- (IBAction)backBUtton:(id)sender;
@end
