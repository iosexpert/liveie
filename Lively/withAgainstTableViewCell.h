//
//  withAgainstTableViewCell.h
//  
//
//  Created by Brahmasys on 04/12/15.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "STTweetLabel.h"
#import "AVPlayerDemoPlaybackView.h"
@interface withAgainstTableViewCell : UITableViewCell




@property(weak , nonatomic) IBOutlet AsyncImageView *profileImage;
@property(weak , nonatomic) IBOutlet UILabel *name;
@property(weak , nonatomic) IBOutlet UILabel *city;
@property(weak , nonatomic) IBOutlet UILabel *time;
@property(weak , nonatomic) IBOutlet STTweetLabel *profiledescription;
@property(weak , nonatomic) IBOutlet UILabel *likeLabel;
@property(weak , nonatomic) IBOutlet UIButton *postDetailButton;
@property(weak , nonatomic) IBOutlet AVPlayerDemoPlaybackView *videoView;
@property(weak , nonatomic) IBOutlet UIImageView *videoImagefilter;

@property(weak , nonatomic) IBOutlet AsyncImageView *videoImage;

@end
