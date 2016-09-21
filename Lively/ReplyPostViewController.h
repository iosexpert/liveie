//
//  ReplyPostViewController.h
//  Lively
//
//  Created by azadhada on 28/07/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentTableViewCell.h"
#import "AsyncImageView.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerDemoPlaybackView.h"
#import "VideoPlayerViewController.h"
#import "STTweetLabel.h"
#import "ReplyPostTableViewCell.h"
#import "homeFeedsCell.h"
#import "postFirstCellTableViewCell.h"
@interface ReplyPostViewController : UIViewController<UIActionSheetDelegate>
{
    IBOutlet UIButton *cancelbtn;
    IBOutlet ReplyPostTableViewCell *celll;
    IBOutlet homeFeedsCell *Homecelll;
    IBOutlet commentTableViewCell *cell;
    postFirstCellTableViewCell *cellll;
    IBOutlet UITableView *tablev;
    
    
    NSString *st;
    
    
    IBOutlet UIView *viewOptions;
    
    int downloadVideoCount,count,downloadImageCount;
    
    int indexreply;
    
    
    int indexOptions;
    int indexPost;
    
    
}
-(IBAction)back_Button:(id)sender;
@end
