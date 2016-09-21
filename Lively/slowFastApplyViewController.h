//
//  slowFastApplyViewController.h
//  Lively
//
//  Created by Brahmasys on 15/03/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface slowFastApplyViewController : UIViewController
{
    IBOutlet UIScrollView *scrv;
    IBOutlet UIView *videoView;
    IBOutlet UILabel *lblTime;
}
-(IBAction)backButton:(id)sender;
-(IBAction)doneButton:(id)sender;
@end
