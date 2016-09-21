//
//  editCommentViewController.h
//  Lively
//
//  Created by Brahmasys on 10/05/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editCommentViewController : UIViewController
{
    IBOutlet UITextView *message_box;

}
- (IBAction)send_action:(id)sender;
- (IBAction)cancel_action:(id)sender;
@end
