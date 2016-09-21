//
//  postOfHashTagView.h
//  
//
//  Created by Brahmasys on 07/12/15.
//
//

#import <UIKit/UIKit.h>
#import "MachineCollectionCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AVPlayerDemoPlaybackView.h"
#import "homeFeedsCell.h"

@interface postOfHashTagView : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    IBOutlet UIButton *cancelbtn;
    int indexPost;

    IBOutlet homeFeedsCell *celll;
    IBOutlet UITableView *collectionV;
     IBOutlet UICollectionView *collection_obj;
    IBOutlet UIScrollView *scrv;
    IBOutlet UIButton *gridListbtn;
    IBOutlet UIScrollView *scrolv;
    IBOutlet UILabel *lblTop;
    IBOutlet UIView *viewOptions,*viewOptions1;
    int indexOptions;
    IBOutlet UIScrollView *hashtagScroll;


}
@property (strong, nonatomic)    NSMutableArray *postArr;
@property (strong, nonatomic) NSString *strTop;

-(IBAction)backButton:(id)sender;
-(IBAction)listGridButton:(id)sender;
@end
