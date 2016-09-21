//
//  commentsOnFeedViewController.h
//  Lively
//
//  Created by Brahmasys on 24/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface commentsOnFeedViewController : UIViewController
{
    IBOutlet AsyncImageView *profile_img,*thumb_img;
    IBOutlet UITableView *tablev;
    IBOutlet UITextView *message_box;
    IBOutlet UILabel *topLabel,*lblName,*lblCaption,*lblLocation,*lblTime;
    IBOutlet UIScrollView *scrv,*innerScrv;;
}
- (IBAction)send_action:(id)sender;
- (IBAction)cancel_action:(id)sender;
@end
