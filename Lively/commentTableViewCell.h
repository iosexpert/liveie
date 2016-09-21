//
//  commentTableViewCell.h
//  Lively
//
//  Created by Brahmasys on 17/05/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTweetLabel.h"
#import "AsyncImageView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AVPlayerDemoPlaybackView.h"
@interface commentTableViewCell : UITableViewCell


@property(weak , nonatomic) IBOutlet AVPlayerDemoPlaybackView *videoView;

@property(weak , nonatomic) IBOutlet UIView *headerView;
@property(weak , nonatomic) IBOutlet UIView *fotterView;

@property(weak , nonatomic) IBOutlet UILabel *name;
@property(weak , nonatomic) IBOutlet UILabel *time;
@property(weak , nonatomic) IBOutlet STTweetLabel *profiledescription;
@property(weak , nonatomic) IBOutlet UIButton *userprofileButton;
@property(weak , nonatomic) IBOutlet AsyncImageView *profileImage;


@property(weak , nonatomic) IBOutlet UIButton *commentButton;
@property(weak , nonatomic) IBOutlet UIButton *likeButton;
@property(weak , nonatomic) IBOutlet UIButton *optionButton;


@end
