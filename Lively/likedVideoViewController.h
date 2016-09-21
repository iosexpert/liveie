//
//  likedVideoViewController.h
//  Lively
//
//  Created by Brahmasys on 14/04/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTweetLabel.h"
#import "homeFeedsCell.h"

#import <MediaPlayer/MediaPlayer.h>
#import "AVPlayerDemoPlaybackView.h"
@interface likedVideoViewController : UIViewController
{
    IBOutlet homeFeedsCell *celll;
    IBOutlet UITableView *collectionV;

     UIView *viewOptions,*viewOptions1;
    int indexOptions;
    int indexPost;
    IBOutlet UIView *navigationView;

    
}
@property (nonatomic, assign) CGFloat lastContentOffset;

@end
