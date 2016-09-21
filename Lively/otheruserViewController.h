//
//  otheruserViewController.h
//  
//
//  Created by Brahmasys on 08/12/15.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "STTweetLabel.h"
#import "homeFeedsCell.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "AVPlayerDemoPlaybackView.h"
#import "VideoPlayerViewController.h"

@interface otheruserViewController : UIViewController<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UIButton *cancelbtn,*btnFollow,*btnFollowing;
    IBOutlet homeFeedsCell *celll;
    int indexPost;
    
    IBOutlet AsyncImageView *cover_img,*imgCoverTop,*imgProfileTop;
    IBOutlet AsyncImageView *cover_img1,*imgBlack;

    IBOutlet AsyncImageView *profile_img;
    IBOutlet UIScrollView *mainScrlv;
    
    IBOutlet UIScrollView *profileScrlv;
    
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    
    IBOutlet UITableView *tablev;
    
    IBOutlet UILabel *name_lbl,*lblNameTop;
    IBOutlet UILabel *username_lbl;
    IBOutlet UILabel *following_lbl;
    IBOutlet UILabel *follower_lbl;
    
    IBOutlet UIImageView *noVideoImage;

    
    IBOutlet UIButton *posts_Btn;
    IBOutlet UIButton *liked_Btn;
    
    
    IBOutlet UILabel *aboutUser;

    IBOutlet UIView *viewOptions;
     IBOutlet UIButton *folow_Btn;
    
    int indexOptions;
    
    IBOutlet UILabel *postCount_lbl;
    IBOutlet UILabel *followedCount_lbl;

}
-(IBAction)fllowing_Button:(id)sender;
-(IBAction)follower_Button:(id)sender;
-(IBAction)likes_Button:(id)sender;
-(IBAction)profile_likes_Button:(id)sender;
-(IBAction)followUser_Button:(id)sender;
-(IBAction)reportUser_Button:(id)sender;



-(IBAction)posts_Button:(id)sender;
-(IBAction)liked_Button:(id)sender;
@end
