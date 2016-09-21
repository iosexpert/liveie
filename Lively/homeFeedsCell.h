//
//  homeFeedsCell.h
//  Lively
//
//  Created by Brahmasys on 18/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AVPlayerDemoPlaybackView.h"
#import "STTweetLabel.h"
@interface homeFeedsCell : UITableViewCell
{
    
    
}
@property(weak , nonatomic) IBOutlet UIImageView *activity;

@property(weak , nonatomic) IBOutlet UIView *headerView;
@property(weak , nonatomic) IBOutlet UIView *fotterView;


@property(weak , nonatomic) IBOutlet AVPlayerDemoPlaybackView *videoView;
@property(weak , nonatomic) IBOutlet AsyncImageView *videoImage;

@property(weak , nonatomic) IBOutlet UIView *sidev;

@property(weak , nonatomic) IBOutlet AsyncImageView *profileImage;
@property(weak , nonatomic) IBOutlet UILabel *name;
@property(weak , nonatomic) IBOutlet UIButton *city;
@property(weak , nonatomic) IBOutlet UILabel *time;
@property(weak , nonatomic) IBOutlet STTweetLabel *profiledescription;
@property(weak , nonatomic) IBOutlet UIButton *userprofileButton;


@property(weak , nonatomic) IBOutlet UIButton *commentButton;
@property(weak , nonatomic) IBOutlet UIButton *commentCount;

@property(weak , nonatomic) IBOutlet UIButton *viewLabel;

@property(weak , nonatomic) IBOutlet UIButton *replyCountButton;
@property(weak , nonatomic) IBOutlet UIButton *replyButton;

@property(weak , nonatomic) IBOutlet UIButton *likeButton;
@property(weak , nonatomic) IBOutlet UIButton *likeCountBtn;

@property(weak , nonatomic) IBOutlet UIButton *optionBtn;

@end
