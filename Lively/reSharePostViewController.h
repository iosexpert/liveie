//
//  reSharePostViewController.h
//  
//
//  Created by Brahmasys on 27/11/15.
//
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
#import "postFirstCellTableViewCell.h"

@interface reSharePostViewController : UIViewController<UIActionSheetDelegate>
{
    IBOutlet UIButton *cancelbtn;
    IBOutlet homeFeedsCell *celll;
    IBOutlet commentTableViewCell *cell;
    postFirstCellTableViewCell *cellll;
    IBOutlet UITableView *tablev;
    

    NSString *st;
    
 
    IBOutlet UIView *viewOptions,*viewOptions1;

       int downloadVideoCount,count,downloadImageCount;
  
    int indexreply;
    
    
    int indexOptions;
    int indexPost;
    

}
@property (strong, nonatomic) NSString *strComment;
-(IBAction)back_Button:(id)sender;
@end
