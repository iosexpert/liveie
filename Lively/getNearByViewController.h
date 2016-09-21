//
//  getNearByViewController.h
//  
//
//  Created by Brahmasys on 28/01/16.
//
//

#import <UIKit/UIKit.h>
#import "homeFeedsCell.h"

#import "MachineCollectionCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AVPlayerDemoPlaybackView.h"
@interface getNearByViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet homeFeedsCell *celll;
    IBOutlet UITableView *collectionV;
    
    IBOutlet UIButton *cancelbtn;
    int indexPost;

    IBOutlet UICollectionView *collection_obj;
    IBOutlet UIScrollView *scrv;
    IBOutlet UIButton *gridListbtn;
    IBOutlet UIScrollView *scrolv;
    IBOutlet UIScrollView *nearByscrolv;
    IBOutlet UIScrollView *collectionscrolv;
    IBOutlet UILabel *lblTop;
    IBOutlet UIView *viewOptions;
    int indexOptions;
    IBOutlet UIView *navigationView;

    
}
@property (strong, nonatomic)    NSMutableArray *postArr;
@property (strong, nonatomic) NSString *strTop;
@property (nonatomic, assign) CGFloat lastContentOffset;

-(IBAction)backButton:(id)sender;
-(IBAction)listGridButton:(id)sender;
@end
