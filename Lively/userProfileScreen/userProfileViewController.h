//
//  userProfileViewController.h
//  Lively
//
//  Created by Brahmasys on 18/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "withAgainstTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerDemoPlaybackView.h"
#import "VideoPlayerViewController.h"
#import "homeFeedsCell.h"

@interface userProfileViewController : UIViewController<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    
    int indexOptions;
    IBOutlet homeFeedsCell *celll;
    int indexPost;
    IBOutlet UIImageView *imgNoPost;
    IBOutlet UIButton *cancelbtn,*btnFollow,*btnFollowing;

    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;

    IBOutlet UIScrollView *profileScrlv;

    
    IBOutlet AsyncImageView *cover_img,*imgCoverTop,*imgBlack;
    IBOutlet AsyncImageView *cover_img1;
    IBOutlet AsyncImageView *profile_img,*imgProfileTop;
    IBOutlet UIScrollView *mainScrlv;
    IBOutlet UITableView *tablev;
    
    IBOutlet UILabel *name_lbl,*lblNameTop;
    IBOutlet UILabel *username_lbl;
    IBOutlet UILabel *following_lbl;
    IBOutlet UILabel *follower_lbl;
    IBOutlet UIButton *posts_Btn;
    IBOutlet UIButton *liked_Btn;
    //IBOutlet withAgainstTableViewCell *cell;

    IBOutlet UILabel *aboutUser;
    UIView *viewOptions;
    
    UIView *viewOptions1;

    
    
    
    
    
    IBOutlet UILabel *postCount_lbl;
    IBOutlet UILabel *followedCount_lbl;
}
-(IBAction)fllowing_Button:(id)sender;
-(IBAction)follower_Button:(id)sender;
-(IBAction)likes_Button:(id)sender;


-(IBAction)posts_Button:(id)sender;
-(IBAction)liked_Button:(id)sender;

@end
