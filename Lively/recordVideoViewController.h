//
//  recordVideoViewController.h
//  
//
//  Created by Brahmasys on 04/12/15.
//
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"

@interface recordVideoViewController : UIViewController<SCRecorderDelegate, UIImagePickerControllerDelegate>
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
@end
