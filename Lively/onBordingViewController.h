//
//  onBordingViewController.h
//  Lively
//
//  Created by Brahmasys on 23/03/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface onBordingViewController : UIViewController
{
    IBOutlet UIScrollView *scrv;
    IBOutlet UIButton *donebtn;
    IBOutlet UIImageView *dot1,*dot2,*dot3,*dot4,*dot5,*imgLogo;
    IBOutlet UIView *view1,*view2,*view3,*view4;
}
- (IBAction)next_action:(id)sender;
- (IBAction)back_action:(id)sender;
- (IBAction)done_action:(id)sender;
@end
