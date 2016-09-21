//
//  notificationPostScreen.h
//  Lively
//
//  Created by Brahmasys on 30/05/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "homeFeedsCell.h"
#import "commentTableViewCell.h"
#import "AsyncImageView.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerDemoPlaybackView.h"
#import "VideoPlayerViewController.h"
#import "STTweetLabel.h"

@interface notificationPostScreen : UIViewController
{
    IBOutlet UIButton *cancelbtn;
    IBOutlet homeFeedsCell *celll;
    IBOutlet commentTableViewCell *cell;
    IBOutlet UITableView *tablev;
    
    
    NSString *st;
    
    
    IBOutlet UIView *viewOptions;
    
    int downloadVideoCount,count,downloadImageCount;
    
    int indexreply;
    
    
    int indexOptions;
    int indexPost;
    
    IBOutlet UIScrollView *scrolv;
    
}
-(IBAction)back_Button:(id)sender;
@end
