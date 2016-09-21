//
//  getNearByViewController.m
//
//
//  Created by Brahmasys on 28/01/16.
//
//
#import "postOfHashTagView.h"
#import "APIViewController.h"
#import "LoaderViewController.h"

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


#import "otheruserViewController.h"
#import "likeViewController.h"
#import "directViewController.h"


#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "commentsOnFeedViewController.h"
#import "reSharePostViewController.h"
#import "AppDelegate.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerDemoPlaybackView.h"
#import "VideoPlayerViewController.h"

#import "getNearByViewController.h"

#import "recordVideoViewController.h"

#import "directVideoViewController.h"

@class AVPlayer;
@class AVPlayerDemoPlaybackView;

#import "getNearByViewController.h"
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
@interface getNearByViewController ()
@property (readwrite, retain) AVPlayer* mPlayer;
@property (nonatomic, retain) VideoPlayerViewController *myPlayerViewController;
@end

@implementation getNearByViewController
{
    int play,list;
    homeFeedsCell *cellToActivate;
    homeFeedsCell *cellToDeactivate;
    
    int currentplayingVideo;
    
    NSMutableArray *posts;
    UIImageView *heartanimation;
    
    NSMutableDictionary *playableDict;
    NSTimer *videoCheckTimer;
    int screenSide;
    BOOL stopLoader;
    int apicall;
    int cellToLoad;

    NSMutableArray *arrSearch;
    
    APIViewController *api_obj;
    
    UIView *fullView;
    AVPlayerLayer *avPlayerLayer;
    AVPlayer *player;
    AVPlayer *playerr;
    UIImageView *filterView;
    int duration;
    int currentTime;
    NSTimer *aTimer ;
    NSArray *foooooo;
    NSMutableArray *filterArr;
    
    UISearchBar *searchBaar;
    UITableView *tablev;
    
    BOOL isScrolling;
    UIImageView *fimage;
    UIImageView *im;
    int downloadVideoCount,count,downloadImageCount;
    
    NSIndexPath *currentindex;
    NSURLSessionDownloadTask *downloadTask ;
    int feedID;
    
    UIActivityIndicatorView *indicator;
    NSString *min,*max;
    
    int playingVideo;
    
}
@synthesize postArr,strTop;

- (void)viewDidLayoutSubviews
{
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    tabFrame.size.height = 40;
    tabFrame.origin.y = self.view.frame.size.height - 40;
    self.tabBarController.tabBar.frame= tabFrame;
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    
    self.mPlayer.volume=0.0;
    [self.mPlayer pause];
    [player pause];
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    [super viewDidLoad];
    screenSide=0;
    [self createOptionPopUp];
    playableDict = [NSMutableDictionary new];

    
    
    
    collection_obj.frame=CGRectMake(0, 60, collection_obj.frame.size.width,  collection_obj.frame.size.height);
    searchBaar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, 44)];
    searchBaar.delegate = self;
    for (UIView *subview in searchBaar.subviews)
    {
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)])
        {
            [(UITextField *)subview setClearButtonMode:UITextFieldViewModeWhileEditing];
        }
    }
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor darkGrayColor]];
    
    searchBaar.barTintColor = [UIColor clearColor];
    searchBaar.backgroundImage = [UIImage new];
    UIImageView *imgSearchBack=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbor"]];
    imgSearchBack.frame = CGRectMake(20, 15, self.view.frame.size.width-40, 34);
    
    [collectionscrolv addSubview:imgSearchBack];
    [collectionscrolv addSubview:searchBaar];
    [collectionscrolv setContentOffset:CGPointMake(0, 60) animated:YES];
    
    
    
    cancelbtn.layer.cornerRadius=5.0;
    
    [gridListbtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    
    
    if(iphone5||iphone4)
        [collection_obj registerNib:[UINib nibWithNibName:@"MachineCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    else if(iphone6)
        [collection_obj registerNib:[UINib nibWithNibName:@"MachineCollectionCell@6" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    else if(iphone6p)
        [collection_obj registerNib:[UINib nibWithNibName:@"MachineCollectionCell@6p" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    
    [self getNearBy];
    
    
    
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];

    
    NSLog(@"%@",strTop);
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)getNearBy
{
    
    NSString *st=[NSString stringWithFormat:@"%@/%@/%@/%@",userid,strTop,@"0",@"12"];
    //        api_obj=[[APIViewController alloc]init];
    //        [api_obj getNearByPost:@selector(getNearByPostResult:) tempTarget:self :st];
    
    lblTop.text=@"NEAR BY";
    
    
    postArr=[NSMutableArray new];
    NSString *completeURL = [NSString stringWithFormat:@"%@/Post.svc/GetNearbyPost/%@",appUrl,st];
    
    NSLog(@"url %@",completeURL);
    NSURL *url = [[NSURL alloc] initWithString:completeURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            
            NSError *e;
            NSMutableDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            [self getNearByPostResult:JSON];
            // [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        // [self getNearByPostResult:JSON];
        [self getNearByPostResult:nil];
        
    }];
    
    [operation start];
}
-(void)getShowMoreData
{
    if(apicall==1)
    {
        NSString *st=[NSString stringWithFormat:@"%@/%@/%@/%@",userid,strTop,min,max];
        api_obj=[[APIViewController alloc]init];
        [api_obj getNearByPost:@selector(getShowMoreDataResult:) tempTarget:self :st];
        apicall=0;
    }
}
-(void)getShowMoreDataResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if([[[dict_Response objectForKey:@"response"]valueForKey:@"status" ] integerValue]==200)
        {
            
            
            [indicator removeFromSuperview];
            for(int i=0;i<[[dict_Response valueForKey:@"nearby_post"] count];i++)
            {
                [postArr addObject:[dict_Response valueForKey:@"nearby_post"][i]];
                [ posts  addObject:[dict_Response valueForKey:@"nearby_post"][i]];
            }
            downloadVideoCount=(int)postArr.count;
            downloadImageCount=(int)postArr.count;
            [self btnImagesClick:0];
            apicall=1;
            CGRect f1 = collection_obj.frame;
            f1.size.height = posts.count*100;
            collection_obj.frame =f1;
            
            //[self btnImagesClick1:0];
            [collectionV reloadData];
            
            [collection_obj reloadData];
            
            if([[dict_Response valueForKey:@"nearby_post"] count]==0)
            {
                stopLoader=YES;
                [indicator removeFromSuperview];
                UIFont * myFont = [UIFont fontWithName:@"Arial" size:12];
                CGRect labelFrame = CGRectMake (0, collection_obj.contentSize.height+collection_obj.frame.origin.y,self.view.frame.size.width, 20);
                UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
                [label setFont:myFont];
                label.lineBreakMode=NSLineBreakByWordWrapping;
                label.numberOfLines=5;
                label.textAlignment=NSTextAlignmentCenter;
                label.textColor=[UIColor grayColor];
                label.backgroundColor=[UIColor clearColor];
                [label setText:[NSString stringWithFormat:@"%@",@"No More Videos"]];
                [collectionscrolv addSubview:label];
                collection_obj.backgroundColor=[UIColor clearColor];
            }
            else
            {
                for(int i=(int)postArr.count-1;i>=0;i--)
                {
                    apicall=1;
                    NSString *str=[postArr[i] valueForKey:@"url"];
                    NSString *userid = [postArr[i] valueForKey:@"userid"];
                    NSArray* foo = [str componentsSeparatedByString: @"/"];
                    NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                    NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
                    NSURL *URLl = [NSURL fileURLWithPath:dataPath];
                    [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
                    
                    //==========Checking if path already exist for video files==================
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
                    
                    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
                    
                    if(fileExists && asset.playable)
                    {
                        [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:postArr[i]]]];
                    }
                    else
                        [playableDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:postArr[i]]]];
                    
                }

            }
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }

    
    play=1;
    screenName=@"nearby";
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTableOnNotification) name:@"nearby" object:nil];
    screencount=5;
    duration=0;
    currentTime=0;
    self.mPlayer.volume=0.0;
    self.navigationController.navigationBarHidden=YES;
    stopLoader=false;
    
    if(goToPostAfterComment==1)
    {
        goToPostAfterComment=0;
        if([[postAfterComment valueForKey:@"post_type"]isEqualToString:@"public"]||[[postAfterComment valueForKey:@"post_type"]isEqualToString:@"reshare"])
        {
            selectedFeed=[postAfterComment mutableCopy];
            
        }
        else
        {
            selectedFeed=[postAfterComment mutableCopy];
            [selectedFeed setValue:[selectedFeed valueForKey:@"parent_id"] forKey:@"postid"];
        }
        reSharePostViewController *mvc;
        if(iphone4)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }
    if(screenSide==0)
    {
        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
        [gridListbtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        gridListbtn.tag=0;
    }
    else
    {
        if(postArr.count>0)
        {
            [scrv setContentOffset:CGPointMake(self.view.frame.size.width+1, 0) animated:YES];
            [gridListbtn setImage:[UIImage imageNamed:@"thumbnial"] forState:UIControlStateNormal];
            gridListbtn.tag=1;
            [self scrollTableOnNotification];
        }
    }

}

-(void)getNearByPostResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    
    
    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        if([[[dict_Response objectForKey:@"response"]valueForKey:@"status" ] integerValue]==200)
        {
            
            posts = [[dict_Response objectForKey:@"nearby_post"]mutableCopy];;
            //postImages
            
            
            postArr=[NSMutableArray new];
            postArr=[[dict_Response valueForKey:@"nearby_post"]mutableCopy];
            //[tablev reloadData];
            downloadVideoCount=(int)postArr.count;
            downloadImageCount=(int)postArr.count;
            [self btnImagesClick:0];
            
            CGRect f1 = collection_obj.frame;
            f1.size.height = posts.count*100;
            collection_obj.frame =f1;
            apicall=1;
            [indicator removeFromSuperview];
            
            [collectionV reloadData];
            [collection_obj reloadData];
            for(int i=(int)postArr.count-1;i>=0;i--)
            {
                apicall=1;
                NSString *str=[postArr[i] valueForKey:@"url"];
                NSString *userid = [postArr[i] valueForKey:@"userid"];
                NSArray* foo = [str componentsSeparatedByString: @"/"];
                NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
                NSURL *URLl = [NSURL fileURLWithPath:dataPath];
                [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
                
                //==========Checking if path already exist for video files==================
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
                
                AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
                
                if(fileExists && asset.playable)
                {
                    [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:postArr[i]]]];
                }
                else
                    [playableDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:postArr[i]]]];
                
            }

            
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    collection_obj.scrollEnabled=false;
    
    return posts.count;
    
}


- (MachineCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MachineCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    for (UILabel *b in cell.subviews)
    {
        
        if(b.tag==98)
            [b removeFromSuperview];
    }
    
    NSDictionary *dict=[[posts objectAtIndex:indexPath.row]mutableCopy];
    cell.ImgView.layer.cornerRadius=cell.ImgView.frame.size.width/2;
    [cell.ImgView.layer setMasksToBounds:YES];
    
    
    if([[dict valueForKey:@"thumb_small"] isEqualToString:@""])
        cell.ImgView.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
    else
        cell.ImgView.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb_small"]]];
    
//    cell.ImgView.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",appUrl,[dict valueForKey:@"thumb"]]];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:11];
    CGRect labelFrame = CGRectMake (0, cell.ImgView.frame.size.height+12,cell.frame.size.width, 35);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.tag=98;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=2;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor grayColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:[dict objectForKey:@"caption"]];
    [cell addSubview:label];
    
    if(indexPath.row==posts.count-1)
    {
        CGRect f = collection_obj.frame;
        f.size.height = collection_obj.contentSize.height+100;
        collection_obj.frame =f;
        if(f.size.height<=self.view.frame.size.height+20)
            collectionscrolv.contentSize=CGSizeMake(300, self.view.frame.size.height+10);
        else
            collectionscrolv.contentSize=CGSizeMake(300, collection_obj.contentSize.height+120);
        collection_obj.scrollEnabled=false;
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // LOG_SELECTOR_ENTRY();
    
    selectedFeed=[posts objectAtIndex:indexPath.row];
    reSharePostViewController *mvc;
    if(iphone4)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
}
-(IBAction)listGridButton:(id)sender;
{
    [searchBaar resignFirstResponder];

    
    //[tablev removeFromSuperview];
    if(postArr.count>0)
    {
    if(gridListbtn.tag==1)
    {
        list=0;
        [cellToActivate.videoView.player pause];
        [cellToDeactivate.videoView.player pause];
        cellToDeactivate.videoView.player=nil;
        cellToActivate.videoView.player=nil;
        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
        [gridListbtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        gridListbtn.tag=0;
        self.mPlayer.volume=0.0;
        [self.mPlayer pause];
        [player pause];
    }
    else
    {
        list=1;
        [scrv setContentOffset:CGPointMake(self.view.frame.size.width+1, 0) animated:YES];
        [gridListbtn setImage:[UIImage imageNamed:@"thumbnial"] forState:UIControlStateNormal];
        gridListbtn.tag=1;
        [self scrollTableOnNotification];

    }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if(play == 1)
    {
        if(list == 1)
        {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [cellToActivate.videoView.player seekToTime:kCMTimeZero];
    [cellToActivate.videoView.player play];
    
    
    NSMutableDictionary *dict=postArr[currentplayingVideo];
    if([[dict valueForKey:@"filter"]integerValue]==0)
    {
        cellToActivate.videoView.player.rate=1.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
    {
        cellToActivate.videoView.player.rate=2.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==2)
    {
        cellToActivate.videoView.player.rate=0.5;
    }
    
    if([[dict valueForKey:@"filter"]integerValue]==0)
    {
        player.rate=1.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
    {
        player.rate=2.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==2)
    {
        player.rate=0.5;
    }
    
    
    //[self getDataFromDataBAse];
    UIButton *v;
    if(fullView==nil )
    {
        v = (UIButton *)[collectionV viewWithTag:4000+currentplayingVideo];
        if([[v titleForState:UIControlStateNormal] isEqualToString:@"1K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"2K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"3K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"4K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"5K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"6K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"7K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"8K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"9K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"10K+"])
        {
            
        }
        else
        {
            [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal]intValue]+1] forState:UIControlStateNormal];
        }
        api_obj=[[APIViewController alloc]init];
        [api_obj markviewresd:@selector(markviewresdResult:) tempTarget:self :[dict valueForKey:@"postid"]];
        [[postArr objectAtIndex:currentplayingVideo] setValue:[v titleForState:UIControlStateNormal] forKey:@"views"];
    }
    }
    }
}


-(void)resharePost:(UIButton*)btn
{
    
    selectedFeed=[postArr objectAtIndex:btn.tag];
    reSharePostViewController *mvc;
    if(iphone4)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
    
    
}
-(void)closeFullView:(UIButton*)btn
{
    duration=0;
    currentTime=0;
    player.volume=0.0;;
    [player pause];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    fullView = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellToLoad];
    [collectionV scrollToRowAtIndexPath:indexPath
                       atScrollPosition:UITableViewScrollPositionMiddle
                               animated:YES];

    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    
}

-(void)btnImagesClick:(UIButton*)sender
{
    
    downloadVideoCount=downloadVideoCount-1;
    if(downloadVideoCount>=0)
    {
        NSMutableDictionary *downloadVideoDict = [postArr objectAtIndex:downloadVideoCount];
        [self downloadstoryvideos:downloadVideoDict];
        
    }
}
//Download StoryVideos
-(void)downloadstoryvideos:(NSMutableDictionary*)dictTemp
{
    
    
    
    
    NSString *str=[dictTemp valueForKey:@"url"];
    NSURL *URL=[[NSURL alloc] initWithString:str];
    
    
    NSString *userid = [dictTemp valueForKey:@"userid"];
    
    if(![str isEqualToString:@""])
    {
        NSArray* foo = [str componentsSeparatedByString: @"/"];
        NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
        NSURL *URLl = [NSURL fileURLWithPath:dataPath];
        [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        
        
        //==========Checking if path already exist for video files==================
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
        
        AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
        
        if(fileExists && asset.playable)
        {
            
            [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:dictTemp]]];
            [self btnImagesClick:0];
            
        }
        else
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:dataPath append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:dictTemp]]];
                [self btnImagesClick:0];
                
                NSLog(@"Successfully downloaded file to %@", dataPath);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
            [operation start];
        }
        
    }
    else
    {
        
        
        [self btnImagesClick:0 ];
    }
}




- (void)userprofileButton_action:(UIButton*)sender
{
    friendID=[[postArr objectAtIndex:sender.tag]valueForKey:@"userid"];
    
    if([friendID isEqualToString:userid])
    {
        self.tabBarController.selectedIndex=4;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"UserSelected"
         object:self];
    }
    else
    {
        otheruserViewController *mvc;
        if(iphone4)
        {
            mvc=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }
}
- (void)comment_action:(UIButton*)sender
{
    commentFeed=[postArr objectAtIndex:sender.tag];
    
    commentsOnFeedViewController *mvc;
    if(iphone4)
    {
        mvc=[[commentsOnFeedViewController alloc]initWithNibName:@"commentsOnFeedViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[commentsOnFeedViewController alloc]initWithNibName:@"commentsOnFeedViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[commentsOnFeedViewController alloc]initWithNibName:@"commentsOnFeedViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[commentsOnFeedViewController alloc]initWithNibName:@"commentsOnFeedViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[commentsOnFeedViewController alloc]initWithNibName:@"commentsOnFeedViewController@ipad" bundle:nil];
    }
    [self presentViewController:mvc animated:YES completion:nil];
    
    //[self.navigationController pushViewController:mvc animated:YES];
}
-(void)reShareButton_action:(UIButton*)sender
{
    
    selectedFeed=[postArr objectAtIndex:sender.tag];
    recordVideoViewController *mvc;
    if(iphone4)
    {
        mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController@6" bundle:nil];
    }
    
    else if(iphone6p)
    {
        mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController@6P" bundle:nil];
    }
    
    else
    {
        mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
    
}
- (void)like_action:(UIButton*)sender
{
    
    sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width-5, sender.frame.size.height-5);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width+5, sender.frame.size.height+5);
    [UIView commitAnimations];
    
    NSString *st;
    
    
    selectedFeed=[postArr objectAtIndex:sender.tag-900];
    
    
    if([UIImagePNGRepresentation([sender imageForState:UIControlStateNormal] )isEqualToData: UIImagePNGRepresentation([UIImage imageNamed:@"like_filled"])])
    {
        
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [[postArr objectAtIndex:sender.tag-900] setValue:@"0" forKey:@"like_status"];
        UIButton *v = (UIButton *)[collectionV viewWithTag:6700+sender.tag-900];
        st=@"false";
        [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]-1] forState:UIControlStateNormal];
    }
    else
    {
        st=@"true";
        [sender setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateNormal];
        
        [[postArr objectAtIndex:sender.tag-900] setValue:@"1" forKey:@"like_status"];
        UIButton *v = (UIButton *)[collectionV viewWithTag:6700+sender.tag-900];
        [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]+1] forState:UIControlStateNormal];
        
        
    }
    
    
    api_obj=[[APIViewController alloc]init];
    [api_obj likeOnFeed:@selector(getlikeresult1:) tempTarget:self :[selectedFeed objectForKey:@"postid"] :st];
    
    
    
    
}
-(void)markviewresdResult:(NSDictionary*)dict_Response
{
}

-(void)getlikeresult1:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else
    {
        if([[dict_Response  valueForKey:@"status"]integerValue]==200 )
        {
            
            // [self viewDidLoad];
        }
        else
        {
            
        }
    }
}

-(void)btnImagesClick1:(UIButton*)sender
{
    
    downloadImageCount=downloadImageCount-1;
    if(downloadImageCount>=0)
    {
        NSMutableDictionary *downloadVideoDict = [postArr objectAtIndex:downloadImageCount];
        [self downloadstoryimages:downloadVideoDict];
        
    }
}
//Download StoryVideos
-(void)downloadstoryimages:(NSMutableDictionary*)dictTemp
{
    
    
    
    
    NSString *str=[dictTemp valueForKey:@"thumb"];
    NSString *strTemp = str;
    NSString *profileURL = [appUrl stringByAppendingPathComponent:strTemp];
    NSURL *URL=[[NSURL alloc] initWithString:profileURL];
    
    
    NSString *userid = [dictTemp valueForKey:@"userid"];
    
    if(![str isEqualToString:@""])
    {
        NSArray* foo = [profileURL componentsSeparatedByString: @"IMG"];
        NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".png"]];
        NSURL *URLl = [NSURL fileURLWithPath:dataPath];
        [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        
        
        //==========Checking if path already exist for video files==================
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
        
        
        if(fileExists)
        {
            
            [self btnImagesClick1:0];
            
        }
        else
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:dataPath append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self btnImagesClick1:0];
                NSLog(@"Successfully downloaded file to %@", dataPath);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
            [operation start];
        }
        
    }
    else
    {
        
        
        [self btnImagesClick1:0 ];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    play=0;
    screenSide=scrv.contentOffset.x;
    [cellToActivate.videoView.player pause];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
    cellToActivate.videoView.player=nil;
    [cellToDeactivate.activity stopAnimating];
    cellToDeactivate.activity.hidden=YES;
    [cellToActivate.activity stopAnimating];
    cellToActivate.activity.hidden=YES;
    [videoCheckTimer invalidate];

    
    self.mPlayer.volume=0.0;
    [self.mPlayer pause];
    playerr.volume=0.0;
    [playerr pause];
    [player pause];
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    player=nil;
    self.mPlayer=nil;
    playerr=nil;
    [fullView removeFromSuperview];
    //[scrolv removeFromSuperview];
    
}
-(void)playFullScreenVideo:(UIButton*)sender
{
    [cellToActivate.videoView.player pause];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
    cellToActivate.videoView.player=nil;
    
    selectedFeed=[postArr[sender.tag]mutableCopy];
    
    fullView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    fullView.backgroundColor=[UIColor blackColor];
    
    NSMutableDictionary *dict=[selectedFeed mutableCopy];
    NSString *str=[dict valueForKey:@"url"];
    NSString *userid = [dict valueForKey:@"userid"];
    NSArray* foo = [str componentsSeparatedByString: @"/"];
    NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:player];
    avPlayerLayer.frame=CGRectMake(0, 0, fullView.frame.size.width,fullView.frame.size.height);
    [fullView.layer addSublayer:avPlayerLayer];
    avPlayerLayer.backgroundColor=[UIColor clearColor].CGColor;
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    player.volume=1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
    avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
    if(play == 1)
    {
        if(list == 1)
        {
    [player play];
        }
    }
    if([[dict valueForKey:@"filter"]integerValue]==0)
    {
        player.rate=1.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
    {
        player.rate=2.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==2)
    {
        player.rate=0.5;
    }
    
    [self.mPlayer setVolume:0];
    
    
    UIView *btnNext = [[UIView alloc]initWithFrame:self.view.frame];
    btnNext.backgroundColor=[UIColor clearColor];
    btnNext.userInteractionEnabled=true;
    
    btnNext.frame = self.view.frame;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    
    
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    // Adding the swipe gesture on image view
    [btnNext addGestureRecognizer:swipeLeft];
    [btnNext addGestureRecognizer:swipeRight];
    [btnNext addGestureRecognizer:swipeUp];
    [btnNext addGestureRecognizer:swipeDown];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleDoubleTap:)];
    
    
    
    [doubleTap setDelaysTouchesBegan : YES];
    [doubleTap setNumberOfTapsRequired : 2];
    [btnNext addGestureRecognizer : doubleTap];
    
    [fullView addSubview:btnNext];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(closeFullView1:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
    button.frame = CGRectMake(fullView.frame.size.width-60, 20, 60, 40.0);
    [fullView addSubview:button];
    
    
    
    
    UIView *viewBack=[[UIView alloc]init];
    [viewBack setBackgroundColor:[UIColor whiteColor]];
    [viewBack setFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    [viewBack setAlpha:0.8];
    [fullView addSubview:viewBack];
    
    AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,2, 50, 50)];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.layer.cornerRadius=25;
    img.layer.masksToBounds = YES;
    [img.layer setMasksToBounds:YES];
    img.backgroundColor=[UIColor grayColor];
    img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[selectedFeed valueForKey:@"user_pic"]]];
    [viewBack addSubview:img];
    
    
    UILabel *timelbl;
    timelbl = [[UILabel alloc] initWithFrame:CGRectMake (viewBack.frame.size.width-30,10, 40, 20)];
    [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
    timelbl.textColor=[UIColor purpleColor];
    timelbl.backgroundColor=[UIColor clearColor];
    NSString *st= [AppDelegate HourCalculation:[selectedFeed valueForKey:@"time"]];
    [timelbl setText:st];
    [viewBack addSubview:timelbl];
    
    
    UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userProfileButton setTitle:@"" forState:UIControlStateNormal];
    [userProfileButton addTarget:self action:@selector(userprofileButton_action:) forControlEvents:UIControlEventTouchUpInside];
    userProfileButton.tag=sender.tag;
    userProfileButton.frame = CGRectMake(8,8, 60, 60);
    [viewBack addSubview:userProfileButton];
    
    
    
    
    CGSize stringsize = [[NSString stringWithFormat:@"%@,",[selectedFeed valueForKey:@"username"]]sizeWithFont:[UIFont systemFontOfSize:15]];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (73, 5, stringsize.width+20, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor purpleColor];
    
    label.backgroundColor=[UIColor clearColor];
    [label setText:[NSString stringWithFormat:@"%@,",[selectedFeed valueForKey:@"username"]]];
    [viewBack addSubview:label];
    
    
    
    CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, self.view.frame.size.width-120-stringsize.width, 25);
    
    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
    [location addTarget:self action:@selector(openNearByScreen:) forControlEvents:UIControlEventTouchUpInside];
    location.tag=sender.tag;
    location.frame =labelFrameee;
    location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    location.titleLabel.font=[UIFont fontWithName:@"Arial" size:13];
    [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    location.backgroundColor=[UIColor clearColor];
    [location setTitle:[selectedFeed valueForKey:@"location"] forState:UIControlStateNormal];
    [viewBack addSubview:location];
    
    
    
    
    
    UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:13];
    CGRect labelFrame1 = CGRectMake (73,25, 250, 35);
    STTweetLabel *labell = [[STTweetLabel alloc] initWithFrame:labelFrame1];
    [labell setFont:myFont1];
    label.numberOfLines=2;
    labell.lineBreakMode=NSLineBreakByWordWrapping;
    labell.textColor=[UIColor grayColor];
    labell.backgroundColor=[UIColor clearColor];
    [labell setText:[selectedFeed valueForKey:@"caption"]];
    
    
    [viewBack addSubview:labell];
    
    
    UIButton *postDetailbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postDetailbutton addTarget:self action:@selector(postdetailaction:) forControlEvents:UIControlEventTouchUpInside];
    postDetailbutton.tag=sender.tag;
    [postDetailbutton setTitle:@"" forState:UIControlStateNormal];
    postDetailbutton.frame = CGRectMake(73,25, 250, 35);
    [viewBack addSubview:postDetailbutton];
    
    
    
    
    
    
    [self.view addSubview:fullView];
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }
    
    
}
-(void)closeFullView1:(UIButton*)btn
{
    player.volume=0.0;;
    [player pause];
    duration=0;
    currentTime=0;
    [filterView removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    fullView = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellToLoad];
    [collectionV scrollToRowAtIndexPath:indexPath
                       atScrollPosition:UITableViewScrollPositionMiddle
                               animated:YES];

    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    
}
-(void)aTimee
{
    
    if(duration==foooooo.count)
    {
        duration=0;
    }
    else
    {
        if(foooooo.count>duration)
        {
            NSArray *st=[[foooooo objectAtIndex:duration]componentsSeparatedByString:@"!"];
            if(currentTime == [st[1] integerValue])
            {
                if([st[0] integerValue]==4)
                {
                    player.rate = 1.0f;
                    
                }
                else if([st[0] integerValue]==5)
                {
                    player.rate = 0.1f;
                }
                else
                {
                    filterView.image=[UIImage imageNamed:filterArr[[st[0] intValue]]];
                    player.rate =0.5f;
                }
                
                
            }
        }
        
        if(duration==foooooo.count-1)
            duration=0;
    }
    duration++;
    currentTime++;
}
-(IBAction)shareDirectLink:(id)sender
{
    
    directViewController *mvc;
    if(iphone4)
    {
        mvc=[[directViewController alloc]initWithNibName:@"directViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[directViewController alloc]initWithNibName:@"directViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[directViewController alloc]initWithNibName:@"directViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[directViewController alloc]initWithNibName:@"directViewController@6P" bundle:nil];
    }
    else
    {
        mvc=[[directViewController alloc]initWithNibName:@"directViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
}

-(void)Likes:(UIButton*)sender
{
    NSMutableDictionary *dict=[postArr objectAtIndex:sender.tag-6700];
    
    
    likeViewController *mvc;
    if(iphone4)
    {
        mvc=[[likeViewController alloc]initWithNibName:@"likeViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[likeViewController alloc]initWithNibName:@"likeViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[likeViewController alloc]initWithNibName:@"likeViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[likeViewController alloc]initWithNibName:@"likeViewController@6P" bundle:nil];
    }
    else
    {
        mvc=[[likeViewController alloc]initWithNibName:@"likeViewController@ipad" bundle:nil];
    }
    mvc.strPostId=[dict valueForKey:@"postid"];
    [self.navigationController pushViewController:mvc animated:YES];
    
}


#pragma mark Options
- (void)Options:(UIButton*)sender
{
    if(viewOptions.tag==0)
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,self.view.frame.size.height-viewOptions.frame.size.height-53, viewOptions.frame.size.width, viewOptions.frame.size.height)];
        viewOptions.tag=1;
        indexOptions=(int)[sender tag];
        [tablev removeFromSuperview];
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        
        [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
        [tablev removeFromSuperview];
        
        viewOptions.tag=0;
        [UIView commitAnimations];
        
    }
    
}
-(IBAction)Report:(id)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        api_obj=[[APIViewController alloc]init];
        [api_obj ReportSpamPost:@selector(ReportSpamPostResult:) tempTarget:self :[dict valueForKey:@"postid"]];
    }
}
-(void)ReportSpamPostResult:(NSMutableDictionary*)dict
{
    NSLog(@"ReportSpamPostResult :%@",dict);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Successfully reported as Spam" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self viewWillAppear:YES];
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
}
-(IBAction)ReShare:(id)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        if([[dict valueForKey:@"userid"]isEqualToString:userid])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"You can't Reliveie this post" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else
        {
        api_obj=[[APIViewController alloc]init];
        [api_obj ReShare:@selector(ReShareResult:) tempTarget:self :[dict valueForKey:@"postid"]];
        }
    }
}
-(void)ReShareResult:(NSMutableDictionary*)dict
{
    NSLog(@"ReShareResult :%@",dict);
    [self viewWillAppear:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Reliveie is Successfull" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
}

-(IBAction)HidePost:(id)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        api_obj=[[APIViewController alloc]init];
        [api_obj HidePost:@selector(HidePostResult:) tempTarget:self :[dict valueForKey:@"postid"]];
    }
}
-(void)HidePostResult:(NSMutableDictionary*)dict
{
    NSLog(@"HidePostResult :%@",dict);
    [videoCheckTimer invalidate];

[self getNearBy];    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
}
-(IBAction)shareLink:(UIButton*)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        selectedFeed=[dict mutableCopy];
        directVideoViewController *mvc;
        if(iphone4)
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController@6P" bundle:nil];
        }
        else
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }
    [self cancelClick:0];
    
}
-(IBAction)cancelClick:(id)sender
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
    
    
}
-(IBAction)copyLink:(UIButton*)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]];
        
        
    }
    [self cancelClick:0];
    
}

-(void)showDataAfterApi
{
    
    for(int i=0;i<posts.count;i++)
    {
        
        int x = 0,y;
        if(iphone5 || iphone4)
            x=10;
        else if(iphone6)
            x=19;
        else if (iphone6p)
            x=29;
        
        
        y=10;
        for(int i=0;i<posts.count;i++)
        {
            NSMutableDictionary *dict=posts[i];
            AsyncImageView *img1;
            
            if(iphone5 || iphone4)
            {
                if(i%3==0 && i!=0)
                {
                    y=y+110;
                    x=10;
                }
                
                img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, y, 70, 70)];
                img1.layer.cornerRadius=35;
                img1.contentMode = UIViewContentModeScaleAspectFill;
                [img1.layer setMasksToBounds:YES];
                img1.backgroundColor=[UIColor clearColor];
                img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
                [nearByscrolv addSubview:img1];
                
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self action:@selector(openNearBy:)forControlEvents:UIControlEventTouchUpInside];
                [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
                //[button setTitle:[dict valueForKey:@"hashtag"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                button.tag=i;
                button.frame =CGRectMake  (x-10, y+5, 90,80);
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -64, 0.0)];
                [nearByscrolv addSubview:button];
                
                x=x+110;
            }
            else if(iphone6)
            {
                if(i%3==0 && i!=0)
                {
                    y=y+120;
                    x=19;
                }
                
                img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, y, 100, 100)];
                img1.layer.cornerRadius=50;
                img1.contentMode = UIViewContentModeScaleAspectFill;
                [img1.layer setMasksToBounds:YES];
                img1.backgroundColor=[UIColor clearColor];
                img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
                [nearByscrolv addSubview:img1];
                
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self action:@selector(openNearBy:)forControlEvents:UIControlEventTouchUpInside];
                [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
                //[button setTitle:[dict valueForKey:@"hashtag"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                button.tag=i;
                button.frame =CGRectMake  (x-10, y+15, 110,95);
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -90, 0.0)];
                [nearByscrolv addSubview:button];
                
                x=x+119;
                
            }
            else if (iphone6p)
            {
                if(i%3==0 && i!=0)
                {
                    y=y+120;
                    x=28;
                }
                
                img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, y, 100, 100)];
                img1.layer.cornerRadius=50;
                img1.contentMode = UIViewContentModeScaleAspectFill;
                [img1.layer setMasksToBounds:YES];
                img1.backgroundColor=[UIColor clearColor];
                img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
                [nearByscrolv addSubview:img1];
                
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self action:@selector(openNearBy:)forControlEvents:UIControlEventTouchUpInside];
                [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
                //[button setTitle:[dict valueForKey:@"hashtag"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                button.tag=i;
                button.frame =CGRectMake  (x-10, y+15, 110,95);
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -90, 0.0)];
                [nearByscrolv addSubview:button];
                
                x=x+128;
                
            }
        }
        nearByscrolv.contentSize=CGSizeMake(self.view.frame.size.width, y+200);
    }
    
}

-(void)openNearBy:(UIButton*)btn
{
    selectedFeed=[posts objectAtIndex:btn.tag];
    reSharePostViewController *mvc;
    if(iphone4)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)postdetailaction:(UIButton*)btn
{
    [self.mPlayer setVolume:0];
    selectedFeed=[postArr objectAtIndex:btn.tag];
    reSharePostViewController *mvc;
    if(iphone4)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
    
    
}

- (void)handleDoubleTap:(UIGestureRecognizer *)indexPath {
    //do your stuff for a single tap
    NSLog(@"double tap");
    
    
    
    NSString *st;
    heartanimation=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40,self.view.frame.size.height/2-40, 80,80)];
    
    
    if([[selectedFeed valueForKey:@"like_status"]boolValue])
    {
        st=@"false";
        api_obj=[[APIViewController alloc]init];
        [api_obj likeOnFeed:@selector(getlikeresult1:) tempTarget:self :[selectedFeed objectForKey:@"postid"] :st];
        
    }
    else
    {
        st=@"true";
        heartanimation.image=[UIImage imageNamed:@"Heartshape.png"];
        
        api_obj=[[APIViewController alloc]init];
        [api_obj likeOnFeed:@selector(getlikeresult1:) tempTarget:self :[selectedFeed objectForKey:@"postid"] :st];
        
    }
    
    
    
    
    
    
    [fullView addSubview:heartanimation];
    
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.9f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [heartanimation setFrame:CGRectMake(0,self.view.frame.size.height/2-160, 320, 320)];
    heartanimation.alpha=0.0;
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeHeart) userInfo:nil repeats:NO];
    
    
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        [player pause];
        duration=0;
        currentTime=0;
        [filterView removeFromSuperview];
        [avPlayerLayer removeFromSuperlayer];
        [fullView removeFromSuperview];
        player=nil;
        avPlayerLayer=nil;
        fullView=nil;
        
        pushback=0;
        recordVideoViewController *mvc;
        if(iphone4)
        {
            mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController@6P" bundle:nil];
        }
        else
        {
            mvc=[[recordVideoViewController alloc]initWithNibName:@"recordVideoViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
        [player pause];
        [self closeFullView:0];
        
        directVideoViewController *mvc;
        if(iphone4)
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController@6P" bundle:nil];
        }
        
        else
        {
            mvc=[[directVideoViewController alloc]initWithNibName:@"directVideoViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:NO];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"up Swipe");
        
        if([[selectedFeed valueForKey:@"post_type"]isEqualToString:@"public"]||[[selectedFeed valueForKey:@"post_type"]isEqualToString:@"reshare"])
        {
            
        }
        else
        {
            [selectedFeed setValue:[selectedFeed valueForKey:@"parent_id"] forKey:@"postid"];
        }
        reSharePostViewController *mvc;
        if(iphone4)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
        
        
        
        
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(closeFullView:) userInfo:nil repeats:NO];
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        [fullView setFrame:CGRectMake(0,fullView.frame.size.height, fullView.frame.size.width, fullView.frame.size.height)];
        fullView.alpha=0.3;
        [UIView commitAnimations];
        
        
        //
        NSLog(@"down Swipe");
    }
    
}
-(void)removeHeart
{
    [heartanimation removeFromSuperview];
}
-(void)openNearByScreen:(UIButton*)but
{
    
    getNearByViewController *mvc;
    
    if(iphone4)
    {
        mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController@6P" bundle:nil];
    }
    else
    {
        mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController@ipad" bundle:nil];
    }
    NSMutableDictionary *dict=postArr[but.tag];
    mvc.strTop=[NSString stringWithFormat:@"%f/%f",[[dict valueForKey:@"points"][0]floatValue],[[dict valueForKey:@"points"][1]floatValue]];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)createOptionPopUp
{
    NSArray *buttonArray = [[NSArray alloc]initWithObjects:@"Reliveie",@"Follow Post",@"Direct Share",@"Copy Link",@"Hide Post",@"Report",@"Cancel", nil];
    viewOptions=[[UIView alloc]initWithFrame:CGRectMake(0, 790, self.view.frame.size.width, 320)];
    viewOptions.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    int y=10;
    for(int i=0;i<buttonArray.count;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(optionPopupMethod:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(20.0, y, self.view.frame.size.width-40, 30);
        [viewOptions addSubview:button];
        if(i==buttonArray.count-1)
        {
            button.frame = CGRectMake(20.0, y+10, self.view.frame.size.width-40, 30);
            button.layer.cornerRadius=5.0;
            button.backgroundColor=[UIColor colorWithRed:113/255.0 green:43/255.0 blue:141/255.0 alpha:1.0];
            
        }
        if(i!=0)
        {
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, y-5, self.view.frame.size.width, 1)];
            view.backgroundColor=[UIColor whiteColor];
            [viewOptions addSubview:view];
        }
        
        
        y=y+40;
    }
    
    
    [self.view addSubview:viewOptions];
}
-(void)optionPopupMethod:(UIButton*)btn
{
    viewOptions.tag=1;
    if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Cancel"])
    {
        [self cancelClick:0];
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Reliveie"])
    {
        [self ReShare:0];
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Follow Post"])
    {
        [self followPost:0];
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Direct Share"])
    {
        [self shareDirectLink:0];
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Copy Link"])
    {
        [self copyLink:0];
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Hide Post"])
    {
        [self HidePost:0];
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Report"])
    {
        [self Report:0];
    }
    
}
-(IBAction)followPost:(id)sender
{
    if(viewOptions.tag==1)
    {
        api_obj=[[APIViewController alloc]init];
        [api_obj HidePost:@selector(followPostResult:) tempTarget:self :[selectedFeed valueForKey:@"postid"]];
        
    }
}
-(void)followPostResult:(NSMutableDictionary*)dict
{
    NSLog(@"HidePostResult :%@",dict);
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:[dict valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];;
    viewOptions.tag=0;
    [UIView commitAnimations];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText  isEqual: @""])
    {
        api_obj=[[APIViewController alloc]init];
        [api_obj GetSearchNearby:@selector(searchresult:) tempTarget:self :searchText];
        
        
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBaar.showsCancelButton=NO;
    [searchBaar resignFirstResponder];
    [tablev removeFromSuperview];
    [searchBaar resignFirstResponder];
    searchBaar.text=@"";
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBaar.showsCancelButton=NO;
    [searchBaar resignFirstResponder];
    [tablev removeFromSuperview];
    [searchBaar resignFirstResponder];
    searchBaar.text=@"";
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBaar.showsCancelButton=YES;
    searchBaar.returnKeyType=UIReturnKeyDone;

    tablev = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBaar.frame.origin.y+45+65, self.view.frame.size.width, self.view.frame.size.height-330) style:UITableViewStylePlain];
    [tablev setDataSource:self];
    [tablev setDelegate:self];
    tablev.tag=43;
    [tablev setShowsVerticalScrollIndicator:NO];
    tablev.translatesAutoresizingMaskIntoConstraints = NO;
    tablev.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tablev];
    
    return YES;
}
-(void)searchresult:(NSMutableArray*)arr_Response
{
    if(arr_Response.count>0)
    {
        arrSearch=[arr_Response mutableCopy];
        [tablev reloadData];
    }
}






-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [collectionV visibleCells];
    
    for (UITableView *cell in visibleCells) {
        if (!cellToActivate) {
            cellToActivate = (homeFeedsCell *)cell;
        } else {
            // cellToActive is always the top most cell
            homeFeedsCell *cell1 = cellToActivate;
            NSIndexPath *cell1_indexPath = [collectionV indexPathForCell:cell1];
            CGRect cell1_frame = [collectionV cellForRowAtIndexPath:cell1_indexPath].frame;
            
            homeFeedsCell *cell2 = (homeFeedsCell *)cell;
            NSIndexPath *cell2_indexPath = [collectionV indexPathForCell:cell2];
            CGRect cell2_frame = [collectionV cellForRowAtIndexPath:cell2_indexPath].frame;
            
            // Cell frames in controller frames
            CGRect cell1_frameInSuperview = [collectionV convertRect:cell1_frame toView:[collectionV superview]];
            CGRect cell2_frameInSuperview = [collectionV convertRect:cell2_frame toView:[collectionV superview]];
            
            // Calculate which cell has the most real estate on screen
            CGFloat cell1_visibleAmount = cell1_frameInSuperview.size.height - ABS(cell1_frameInSuperview.origin.y);
            CGFloat cell2_visibleAmount = cell2_frameInSuperview.size.height - ABS(cell2_frameInSuperview.origin.y);
            
            if (cell1_visibleAmount > cell2_visibleAmount) {
                cellToActivate = cell1;
                cellToDeactivate = cell2;
            } else {
                cellToActivate = cell2;
                cellToDeactivate = cell1;
            }
        }
    }
    
    
    currentplayingVideo=(int)cellToActivate.videoView.tag;
    cellToLoad=currentplayingVideo;

    if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
    {
        
        
        NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
        
        NSString *useridd = [dict valueForKey:@"userid"];
        NSString *str=[dict valueForKey:@"url"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            
            NSArray* foo = [str componentsSeparatedByString: @"/"];
            NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
            NSURL *URLl = [NSURL fileURLWithPath:dataPath];
            [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
            
            //==========Checking if path already exist for video files==================
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
            
            AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
            
            if(fileExists && asset.playable)
            {
                [cellToActivate.activity stopAnimating];
                cellToActivate.activity.hidden=YES;
                dispatch_sync(dispatch_get_main_queue(), ^(void) {
                    if(play == 1)
                    {
                        if(list == 1)
                        {
                    playerr =[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                    
                    // Assign image back on the main thread
                    [cellToActivate.videoView setPlayer:playerr];
                    [cellToActivate.videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                    if([[dict valueForKey:@"filter"]integerValue]==0)
                    {
                        playerr.rate=1.0;
                    }
                    if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
                    {
                        playerr.rate=2.0;
                    }
                    if([[dict valueForKey:@"filter"]integerValue]==2)
                    {
                        playerr.rate=0.5;
                    }
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(playerItemDidReachEnd:)
                                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                                               object:[playerr currentItem]];
                        }
                    }
                });
                
            }
           
            
            
        });
        
    }
    else
    {
        NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
        [self downloadVideoOnStop:dict];
        cellToActivate.activity.hidden=false;
        [cellToActivate.activity startAnimating];
        [videoCheckTimer invalidate];
        videoCheckTimer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(VideoPlayTimerComplete:) userInfo:nil repeats:YES];
        
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.tag==9999)
    {
        float scrollViewHeight = collectionscrolv.frame.size.height;
        float scrollContentSizeHeight = collectionscrolv.contentSize.height;
        float scrollOffset = collectionscrolv.contentOffset.y;
        
        if (scrollOffset == 0)
        {
            // then we are at the top
        }
        else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
        {
            if(!stopLoader)
            {
                [indicator removeFromSuperview];
                indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                indicator.frame = CGRectMake(self.view.frame.size.width/2-20, scrollContentSizeHeight-60, 40.0, 40.0);
                [collectionscrolv addSubview:indicator];
                [indicator bringSubviewToFront:scrolv];
                [indicator startAnimating];
                
                min=[NSString stringWithFormat:@"%d",(int)postArr.count];
                max=[NSString stringWithFormat:@"%d",12];
                apicall=1;
            }
            
            if(apicall==1)
            {
                [self getShowMoreData];
            }
            
        }
    }
    if(scrv.contentOffset.x==self.view.frame.size.width+1)
    {
        if(!decelerate)
        {
//            NSArray *visibleCells = [collectionV visibleCells];
//            
//            for (UITableView *cell in visibleCells) {
//                if (!cellToActivate) {
//                    cellToActivate = (homeFeedsCell *)cell;
//                } else {
//                    // cellToActive is always the top most cell
//                    homeFeedsCell *cell1 = cellToActivate;
//                    NSIndexPath *cell1_indexPath = [collectionV indexPathForCell:cell1];
//                    CGRect cell1_frame = [collectionV cellForRowAtIndexPath:cell1_indexPath].frame;
//                    
//                    homeFeedsCell *cell2 = (homeFeedsCell *)cell;
//                    NSIndexPath *cell2_indexPath = [collectionV indexPathForCell:cell2];
//                    CGRect cell2_frame = [collectionV cellForRowAtIndexPath:cell2_indexPath].frame;
//                    
//                    // Cell frames in controller frames
//                    CGRect cell1_frameInSuperview = [collectionV convertRect:cell1_frame toView:[collectionV superview]];
//                    CGRect cell2_frameInSuperview = [collectionV convertRect:cell2_frame toView:[collectionV superview]];
//                    
//                    // Calculate which cell has the most real estate on screen
//                    CGFloat cell1_visibleAmount = cell1_frameInSuperview.size.height - ABS(cell1_frameInSuperview.origin.y);
//                    CGFloat cell2_visibleAmount = cell2_frameInSuperview.size.height - ABS(cell2_frameInSuperview.origin.y);
//                    
//                    if (cell1_visibleAmount > cell2_visibleAmount) {
//                        cellToActivate = cell1;
//                        cellToDeactivate = cell2;
//                    } else {
//                        cellToActivate = cell2;
//                        cellToDeactivate = cell1;
//                    }
//                }
//            }
            
            
            currentplayingVideo=(int)cellToActivate.videoView.tag;
            cellToLoad=currentplayingVideo;

            if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
            {
                
                
                NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
                
                NSString *useridd = [dict valueForKey:@"userid"];
                NSString *str=[dict valueForKey:@"url"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    
                    NSArray* foo = [str componentsSeparatedByString: @"/"];
                    NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                    NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
                    NSURL *URLl = [NSURL fileURLWithPath:dataPath];
                    [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
                    
                    //==========Checking if path already exist for video files==================
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
                    
                    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
                    
                    if(fileExists && asset.playable)
                    {
                        [cellToActivate.activity stopAnimating];
                        cellToActivate.activity.hidden=YES;
                        dispatch_sync(dispatch_get_main_queue(), ^(void) {
                            if(play == 1)
                            {
                                if(list == 1)
                                {
                            playerr =[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                            
                            // Assign image back on the main thread
                            [cellToActivate.videoView setPlayer:playerr];
                            [cellToActivate.videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                            if([[dict valueForKey:@"filter"]integerValue]==0)
                            {
                                playerr.rate=1.0;
                            }
                            if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
                            {
                                playerr.rate=2.0;
                            }
                            if([[dict valueForKey:@"filter"]integerValue]==2)
                            {
                                playerr.rate=0.5;
                            }
                            
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                     selector:@selector(playerItemDidReachEnd:)
                                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                                       object:[playerr currentItem]];
                                }}
                        });
                        
                    }
                    
                });
                
            }
            else
            {
                NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
                [self downloadVideoOnStop:dict];
                cellToActivate.activity.hidden=false;
                [cellToActivate.activity startAnimating];
                [videoCheckTimer invalidate];
                videoCheckTimer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(VideoPlayTimerComplete:) userInfo:nil repeats:YES];
                
            }
            
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView.tag==9999)
    {
        float scrollViewHeight = collectionscrolv.frame.size.height;
        float scrollContentSizeHeight = collectionscrolv.contentSize.height;
        float scrollOffset = collectionscrolv.contentOffset.y;
        
        if (scrollOffset == 0)
        {
            // then we are at the top
        }
        else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
        {
            if(!stopLoader)
            {
                [indicator removeFromSuperview];
                indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                indicator.frame = CGRectMake(self.view.frame.size.width/2-20, scrollContentSizeHeight-60, 40.0, 40.0);
                [collectionscrolv addSubview:indicator];
                [indicator bringSubviewToFront:scrolv];
                [indicator startAnimating];
                
                min=[NSString stringWithFormat:@"%d",(int)postArr.count];
                max=[NSString stringWithFormat:@"%d",12];
                apicall=1;
            }
            
            if(apicall==1)
            {
                [self getShowMoreData];
            }
            
        }
    }
    
//    NSArray *visibleCells = [collectionV visibleCells];
//    
//    for (UITableView *cell in visibleCells) {
//        if (!cellToActivate) {
//            cellToActivate = (homeFeedsCell *)cell;
//        } else {
//            // cellToActive is always the top most cell
//            homeFeedsCell *cell1 = cellToActivate;
//            NSIndexPath *cell1_indexPath = [collectionV indexPathForCell:cell1];
//            CGRect cell1_frame = [collectionV cellForRowAtIndexPath:cell1_indexPath].frame;
//            
//            homeFeedsCell *cell2 = (homeFeedsCell *)cell;
//            NSIndexPath *cell2_indexPath = [collectionV indexPathForCell:cell2];
//            CGRect cell2_frame = [collectionV cellForRowAtIndexPath:cell2_indexPath].frame;
//            
//            // Cell frames in controller frames
//            CGRect cell1_frameInSuperview = [collectionV convertRect:cell1_frame toView:[collectionV superview]];
//            CGRect cell2_frameInSuperview = [collectionV convertRect:cell2_frame toView:[collectionV superview]];
//            
//            // Calculate which cell has the most real estate on screen
//            CGFloat cell1_visibleAmount = cell1_frameInSuperview.size.height - ABS(cell1_frameInSuperview.origin.y);
//            CGFloat cell2_visibleAmount = cell2_frameInSuperview.size.height - ABS(cell2_frameInSuperview.origin.y);
//            
//            if (cell1_visibleAmount > cell2_visibleAmount) {
//                cellToActivate = cell1;
//                cellToDeactivate = cell2;
//            } else {
//                cellToActivate = cell2;
//                cellToDeactivate = cell1;
//            }
//        }
//    }
    NSLog(@"%f",scrv.contentOffset.x);
    if(scrv.contentOffset.x==self.view.frame.size.width+1)
    {
        currentplayingVideo=(int)cellToActivate.videoView.tag;
        cellToLoad=currentplayingVideo;

        
        if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
        {
            
            
            NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
            
            NSString *useridd = [dict valueForKey:@"userid"];
            NSString *str=[dict valueForKey:@"url"];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                
                NSArray* foo = [str componentsSeparatedByString: @"/"];
                NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
                NSURL *URLl = [NSURL fileURLWithPath:dataPath];
                [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
                
                //==========Checking if path already exist for video files==================
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
                
                AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
                
                if(fileExists && asset.playable)
                {
                    [cellToActivate.activity stopAnimating];
                    cellToActivate.activity.hidden=YES;
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        if(play == 1)
                        {
                            if(list == 1)
                            {
                        playerr =[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                        
                        // Assign image back on the main thread
                        [cellToActivate.videoView setPlayer:playerr];
                        [cellToActivate.videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                        if([[dict valueForKey:@"filter"]integerValue]==0)
                        {
                            playerr.rate=1.0;
                        }
                        if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
                        {
                            playerr.rate=2.0;
                        }
                        if([[dict valueForKey:@"filter"]integerValue]==2)
                        {
                            playerr.rate=0.5;
                        }
                        
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(playerItemDidReachEnd:)
                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                   object:[playerr currentItem]];
                            }}
                    });
                    
                }
                
                
                
            });
            
        }
        else
        {
            NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
            [self downloadVideoOnStop:dict];
            cellToActivate.activity.hidden=false;
            [cellToActivate.activity startAnimating];
            [videoCheckTimer invalidate];
            videoCheckTimer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(VideoPlayTimerComplete:) userInfo:nil repeats:YES];
            
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    //    if(scrollView.contentOffset.y>0 && scrv.contentOffset.x>=320)
    //    {
    //
    //        if (self.lastContentOffset > scrollView.contentOffset.y)
    //        {
    //            CGRect f = scrv.frame;
    //            if(f.origin.y!=64)
    //            {
    //                f.origin.y = f.origin.y+4;
    //                f.size.height=f.size.height-4;
    //
    //            }
    //            scrv.frame =f;
    //
    //
    //        }
    //        else if (self.lastContentOffset < scrollView.contentOffset.y)
    //        {
    //            CGRect f = scrv.frame;
    //            if(f.origin.y!=20)
    //            {
    //                f.origin.y = f.origin.y-4;
    //                f.size.height=f.size.height+4;
    //            }
    //            scrv.frame =f;
    //
    //        }
    //        self.lastContentOffset = scrollView.contentOffset.y;
    
    //  }
    
    
    
    NSArray *visibleCells = [collectionV visibleCells];
    for (UITableView *cell in visibleCells) {
        if (!cellToActivate) {
            cellToActivate = (homeFeedsCell *)cell;
        } else {
            // cellToActive is always the top most cell
            homeFeedsCell *cell1 = cellToActivate;
            NSIndexPath *cell1_indexPath = [collectionV indexPathForCell:cell1];
            CGRect cell1_frame = [collectionV cellForRowAtIndexPath:cell1_indexPath].frame;
            
            homeFeedsCell *cell2 = (homeFeedsCell *)cell;
            NSIndexPath *cell2_indexPath = [collectionV indexPathForCell:cell2];
            CGRect cell2_frame = [collectionV cellForRowAtIndexPath:cell2_indexPath].frame;
            
            // Cell frames in controller frames
            CGRect cell1_frameInSuperview = [collectionV convertRect:cell1_frame toView:[collectionV superview]];
            CGRect cell2_frameInSuperview = [collectionV convertRect:cell2_frame toView:[collectionV superview]];
            
            // Calculate which cell has the most real estate on screen
            CGFloat cell1_visibleAmount = cell1_frameInSuperview.size.height - ABS(cell1_frameInSuperview.origin.y);
            CGFloat cell2_visibleAmount = cell2_frameInSuperview.size.height - ABS(cell2_frameInSuperview.origin.y);
            
            if (cell1_visibleAmount > cell2_visibleAmount) {
                cellToActivate = cell1;
                cellToDeactivate = cell2;
            } else {
                cellToActivate = cell2;
                cellToDeactivate = cell1;
            }
        }
    }
    cellToLoad=(int)cellToActivate.tag;
    [cellToActivate.videoView.player pause];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
    cellToActivate.videoView.player=nil;
    [cellToDeactivate.activity stopAnimating];
    cellToDeactivate.activity.hidden=YES;
    [cellToActivate.activity stopAnimating];
    cellToActivate.activity.hidden=YES;
    [videoCheckTimer invalidate];

    
    
    
}
#pragma mark Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag==43)
        return 1;
    else
    {
        if(postArr.count==0)
            return 0;
        return postArr.count+1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==43)
        return arrSearch.count;
    else
    {
        if(postArr.count==section)
            return 0;
        else
        return 1;
    }
    }
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,80)];
    if(section==postArr.count)
    {
        if(!stopLoader)
        {
            indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.frame = CGRectMake(self.view.frame.size.width/2-20, 30, 40.0, 40.0);
            [view addSubview:indicator];
            [indicator bringSubviewToFront:scrolv];
            [indicator startAnimating];
            min=[NSString stringWithFormat:@"%d",(int)postArr.count];
            max=[NSString stringWithFormat:@"%d",10];
            [self getShowMoreData];
            
        }
        else{
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:12];
            CGRect labelFrame = CGRectMake (0, 40,self.view.frame.size.width, 20);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor grayColor];
            label.backgroundColor=[UIColor clearColor];
            [label setText:[NSString stringWithFormat:@"%@",@"No More Videos"]];
            [view addSubview:label];
            
        }
        
        
        return view;
    }

    NSMutableDictionary *dict=[postArr[section] mutableCopy];
    AsyncImageView *img;
    if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        img=[[AsyncImageView alloc]initWithFrame:CGRectMake(4,4, 50, 50)];
    }
    else
    {
        img=[[AsyncImageView alloc]initWithFrame:CGRectMake(4,29, 50, 50)];
        
    }
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.layer.cornerRadius=25;
    img.layer.masksToBounds = YES;
    [img.layer setMasksToBounds:YES];
    img.backgroundColor=[UIColor whiteColor];
    img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"user_pic"]]];
    [view addSubview:img];
    
    
    
    
    
    UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userProfileButton addTarget:self action:@selector(userprofileButton_action:) forControlEvents:UIControlEventTouchUpInside];
    userProfileButton.tag=section;
    [userProfileButton setTitle:@"" forState:UIControlStateNormal];
    if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""])
    {
        userProfileButton.frame = CGRectMake(4,4, 50, 50);
    }
    else
    {
        userProfileButton.frame = CGRectMake(4,29, 50, 50);
    }
    [view addSubview:userProfileButton];
    
    
    if(![[dict valueForKey:@"action_text"] isEqual:[NSNull null]] && ![[dict valueForKey:@"action_text"] isEqualToString:@""] )
    {
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:12];
        CGRect labelFrame = CGRectMake (0, 5,self.view.frame.size.width, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
        [label setText:[NSString stringWithFormat:@"%@",[dict valueForKey:@"action_text"]]];
        [view addSubview:label];
        
    }
    
    
    UIFont * myFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
    CGRect labelFrame;
    if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        labelFrame= CGRectMake (65,4, self.view.frame.size.width, 20);
    }
    else
    {
        labelFrame= CGRectMake (65,29, self.view.frame.size.width, 20);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor purpleColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:[NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]]];
    [view addSubview:label];
    CGSize constrainedSize1 = CGSizeMake(self.view.frame.size.width-70  , 9999);
    NSDictionary *attributesDictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:@"Arial" size:12], NSFontAttributeName,
                                           nil];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"location"] attributes:attributesDictionary1];
    CGRect requiredHeight1 = [string1 boundingRectWithSize:constrainedSize1 options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    int z=requiredHeight1.size.height+4;
    
    
    UILabel *locationlbl;
    if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        locationlbl = [[UILabel alloc] initWithFrame:CGRectMake (65,22,self.view.frame.size.width-70, z)];
    }
    else
    {
        locationlbl = [[UILabel alloc] initWithFrame:CGRectMake (65,47,self.view.frame.size.width-74, z)];
    }
    [locationlbl setFont:[UIFont fontWithName:@"Arial" size:12]];
    locationlbl.textColor=[UIColor grayColor];
    locationlbl.lineBreakMode=NSLineBreakByWordWrapping;
    locationlbl.numberOfLines=15;
    locationlbl.backgroundColor=[UIColor clearColor];
    [locationlbl setText:[dict valueForKey:@"location"]];
    [view addSubview:locationlbl];
    
    
    
    CGRect labelFrameee;
    labelFrameee = CGRectMake (0,0,locationlbl.frame.size.width, locationlbl.frame.size.height);
    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
    location.tag=section;
    location.frame =labelFrameee;
    location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    location.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    location.backgroundColor=[UIColor clearColor];
    location.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [location setTitle:@"" forState:UIControlStateNormal];
    if(![[dict valueForKey:@"location"] isEqualToString:@""])
    {
        [location addTarget:self action:@selector(openNearByScreen:) forControlEvents:UIControlEventTouchUpInside];
    }
    [locationlbl addSubview:location];
    
    
    UILabel *timelbl;
    if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        timelbl = [[UILabel alloc] initWithFrame:CGRectMake (self.view.frame.size.width-30,4, 30, 20)];
    }
    else
    {
        timelbl = [[UILabel alloc] initWithFrame:CGRectMake (self.view.frame.size.width-30, 4+25, 30, 20)];
    }
    [timelbl setFont:[UIFont fontWithName:@"Arial" size:12]];
    timelbl.textColor=[UIColor purpleColor];
    timelbl.backgroundColor=[UIColor clearColor];
    NSString *st1= [AppDelegate HourCalculation:[dict valueForKey:@"time"]];
    [timelbl setText:st1];
    [view addSubview:timelbl];
    
    
    
    UIFont * myFont1 ;
    myFont1 = [UIFont fontWithName:@"HelveticaNeue" size:12];
    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-70  , 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          myFont1, NSFontAttributeName,
                                          nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"caption"] attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    
    CGRect labelFrame1;
    labelFrame1= CGRectMake (65, locationlbl.frame.origin.y+locationlbl.frame.size.height+3, self.view.frame.size.width-70, requiredHeight.size.height+2);
    STTweetLabel *labell = [[STTweetLabel alloc] initWithFrame:labelFrame1];
    labell.textColor=[UIColor grayColor];
    [labell setFont:myFont1];
    labell.lineBreakMode=NSLineBreakByWordWrapping;
    labell.numberOfLines=15;
    labell.backgroundColor=[UIColor clearColor];
    [labell setText:[dict valueForKey:@"caption"]];
    
    [view addSubview:labell];
    
    
    UIButton *postDetailbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postDetailbutton addTarget:self action:@selector(postdetailaction:) forControlEvents:UIControlEventTouchUpInside];
    postDetailbutton.tag=section;
    [postDetailbutton setTitle:@"" forState:UIControlStateNormal];
    
    postDetailbutton.frame = labelFrame1;
    [view addSubview:postDetailbutton];
    
    
    
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==postArr.count)
    {
        return 100;
    }
    if(postArr.count==0)
    {
        return 0;
    }

    int h=0;
    NSMutableDictionary *dict=[postArr[section] mutableCopy];
    UIFont * myFont1 ;
    myFont1 = [UIFont fontWithName:@"HelveticaNeue" size:12];
    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-70  , 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: myFont1, NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"caption"] attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    
    if(![[dict valueForKey:@"action_text"] isEqual:[NSNull null]] && ![[dict valueForKey:@"action_text"] isEqualToString:@""] )
        h=h+25;
    CGSize constrainedSize1 = CGSizeMake(self.view.frame.size.width-74  , 9999);
    NSDictionary *attributesDictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:@"Arial" size:12], NSFontAttributeName,
                                           nil];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"location"] attributes:attributesDictionary1];
    CGRect requiredHeight1 = [string1 boundingRectWithSize:constrainedSize1 options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    int z=0;
    if(iphone5)
    {
        if(requiredHeight1.size.height<38)
            z=requiredHeight1.size.height-12;
        else
            z=requiredHeight1.size.height-18;
    }

    if(tableView.tag==43)
        return 0;
    else
        return 50+requiredHeight.size.height+h+z;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==43)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        NSMutableDictionary *dict=  arrSearch[indexPath.row];
        
        
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame = CGRectMake (20, 10, 230, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[dict objectForKey:@"caption"]];
        [cell addSubview:label];
        
        //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
        
        
    }
    else{
        static NSString *simpleTableIdentifier = @"Fish";
        celll = (homeFeedsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (celll == nil)
        { NSArray *nib;
            if(iphone6)
                nib = [[NSBundle mainBundle] loadNibNamed:@"homeFeedsCell@6" owner:self options:nil];
            else if(iphone6p)
                nib = [[NSBundle mainBundle] loadNibNamed:@"homeFeedsCell@6p" owner:self options:nil];
            else if(iphone5||iphone4)
                nib = [[NSBundle mainBundle] loadNibNamed:@"homeFeedsCell" owner:self options:nil];
            
            celll = [nib objectAtIndex:0];
            
            
        }
        NSMutableDictionary *dict=[postArr[indexPath.section] mutableCopy];
        
        celll.activity.animationImages = [[NSArray alloc] initWithObjects:
                                          [UIImage imageNamed:@"1 (1).png"],
                                          [UIImage imageNamed:@"1 (2).png"],
                                          [UIImage imageNamed:@"1 (3).png"],
                                          [UIImage imageNamed:@"1 (4).png"],
                                          [UIImage imageNamed:@"1 (5).png"],
                                          [UIImage imageNamed:@"1 (6).png"],
                                          [UIImage imageNamed:@"1 (7).png"],
                                          [UIImage imageNamed:@"1 (8).png"],
                                          [UIImage imageNamed:@"1 (9).png"],
                                          [UIImage imageNamed:@"1 (10).png"],
                                          [UIImage imageNamed:@"1 (11).png"],
                                          [UIImage imageNamed:@"1 (12).png"],
                                          [UIImage imageNamed:@"1 (13).png"],
                                          [UIImage imageNamed:@"1 (14).png"],
                                          [UIImage imageNamed:@"1 (15).png"],
                                          [UIImage imageNamed:@"1 (16).png"],
                                          [UIImage imageNamed:@"1 (17).png"],
                                          [UIImage imageNamed:@"1 (18).png"],
                                          [UIImage imageNamed:@"1 (19).png"],
                                          [UIImage imageNamed:@"1 (20).png"],
                                          [UIImage imageNamed:@"1 (21).png"],
                                          [UIImage imageNamed:@"1 (22).png"],
                                          [UIImage imageNamed:@"1 (23).png"],
                                          [UIImage imageNamed:@"1 (24).png"],
                                          [UIImage imageNamed:@"1 (25).png"],
                                          [UIImage imageNamed:@"1 (26).png"],
                                          [UIImage imageNamed:@"1 (27).png"],
                                          [UIImage imageNamed:@"1 (28).png"],
                                          [UIImage imageNamed:@"1 (29).png"],
                                          [UIImage imageNamed:@"1 (30).png"],
                                          nil];
        [celll.activity startAnimating];
        celll.activity.tag=indexPath.section;
        celll.activity.hidden=YES;
        
        celll.name.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]];
        
        
        
        celll.videoView.tag=indexPath.section;
        
        
        celll.videoImage.contentMode = UIViewContentModeScaleAspectFill;
        [celll.videoImage.layer setMasksToBounds:YES];
        celll.videoImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
        
        
        [celll.likeCountBtn setTitle:[NSString stringWithFormat:@"%@",[dict valueForKey:@"likes"]] forState:UIControlStateNormal];
        celll.likeCountBtn.tag=6700+indexPath.section;
        [celll.likeCountBtn addTarget:self action:@selector(Likes:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [celll.likeButton addTarget:self action:@selector(like_action:) forControlEvents:UIControlEventTouchUpInside];
        celll.likeButton.tag=indexPath.section+900;
        if([[dict valueForKey:@"like_status"]integerValue]==1)
        {
            [celll.likeButton setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateNormal];
        }
        else
        {
            [celll.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        }
        
        
        
        
        [celll.commentCount setTitle:[NSString stringWithFormat:@"%@",[dict valueForKey:@"comments"]] forState:UIControlStateNormal];
        
        
        [celll.commentButton addTarget:self action:@selector(comment_action:) forControlEvents:UIControlEventTouchUpInside];
        celll.commentButton.tag=indexPath.section;
        
        
        celll.viewLabel.tag=4000+indexPath.section;
        [celll.viewLabel setTitle:[NSString stringWithFormat:@"%d",[[dict valueForKey:@"views"]intValue] ] forState:UIControlStateNormal];
        
        
        
        [celll.replyCountButton setTitle:[NSString stringWithFormat:@"%d",[[dict valueForKey:@"reply_count"]intValue] ] forState:UIControlStateNormal];
        
        
        
        
        
        [celll.replyButton addTarget:self action:@selector(reShareButton_action:) forControlEvents:UIControlEventTouchUpInside];
        celll.replyButton.tag=indexPath.section;
        
        
        
        [celll.optionBtn addTarget:self action:@selector(Options:) forControlEvents:UIControlEventTouchUpInside];
        celll.optionBtn.tag=indexPath.section;
        
        
        
        UIButton *fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullScreen addTarget:self action:@selector(playFullScreenVideo1:) forControlEvents:UIControlEventTouchUpInside];
        fullScreen.tag=indexPath.section;
        fullScreen.backgroundColor=[UIColor clearColor];
        fullScreen.frame = CGRectMake(0, 0, self.view.frame.size.width-52, self.view.frame.size.width);
        [celll.fotterView addSubview:fullScreen];
        
        
        
        
        
        
        if([[celll.likeCountBtn titleForState:UIControlStateNormal]integerValue]==0)
            [celll.likeCountBtn setTitle:@"" forState:UIControlStateNormal];
        if([[celll.commentCount titleForState:UIControlStateNormal]integerValue]==0)
            [celll.commentCount setTitle:@"" forState:UIControlStateNormal];
        if([[celll.viewLabel titleForState:UIControlStateNormal]integerValue]==0)
            [celll.viewLabel setTitle:@"" forState:UIControlStateNormal];
        if([[celll.viewLabel titleForState:UIControlStateNormal]integerValue]>1000)
        {
            int k= (int) [[celll.viewLabel titleForState:UIControlStateNormal]integerValue]/1000;
            [celll.viewLabel setTitle:[NSString stringWithFormat:@"%dK+",k] forState:UIControlStateNormal];
            
        }
        if([[celll.replyCountButton titleForState:UIControlStateNormal]integerValue]==0)
            [celll.replyCountButton setTitle:@"" forState:UIControlStateNormal];
        
        
        
        
        return celll;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==43)
    {
        searchBaar.showsCancelButton=NO;
        [searchBaar resignFirstResponder];
        [tablev removeFromSuperview];
        [searchBaar resignFirstResponder];
        searchBaar.text=@"";
        
        [cellToActivate.videoView.player pause];
        [cellToDeactivate.videoView.player pause];
        cellToDeactivate.videoView.player=nil;
        cellToActivate.videoView.player=nil;
        
        
        selectedFeed=arrSearch[indexPath.row];
        reSharePostViewController *mvc;
        if(iphone4)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==43)
    {
        return 40;
    }
    else
    {
        if(indexPath.section==postArr.count)
        {
            return 0;
        }

        int h;
        if(iphone5||iphone4)
            h=320;
        else if(iphone6)
            h=375;
        else
            h=414;
        return h;
        
    }
}
-(void)playFullScreenVideo1:(UIButton*)sender
{
    [cellToActivate.videoView.player pause];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
    cellToActivate.videoView.player=nil;
    
    [self.mPlayer pause];
    NSDictionary *dictTemp=postArr[sender.tag];
    cellToLoad=(int)sender.tag;

    NSString *str=[dictTemp valueForKey:@"url"];
    NSString *userid = [dictTemp valueForKey:@"userid"];
    if(![str isEqualToString:@""])
    {
        NSArray* foo = [str componentsSeparatedByString: @"/"];
        NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
        NSURL *URLl = [NSURL fileURLWithPath:dataPath];
        [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        
        
        //==========Checking if path already exist for video files==================
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
        
        if(fileExists)
        {
            
            
            [filterView removeFromSuperview];
            [avPlayerLayer removeFromSuperlayer];
            [fullView removeFromSuperview];
            indexPost=(int)[sender tag];
            selectedFeed=[postArr[sender.tag]mutableCopy];
            
            
            
            fullView=nil;
            fullView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            fullView.backgroundColor=[UIColor blackColor];
            
            selectedFeed=[postArr[sender.tag]mutableCopy];
            NSMutableDictionary *dict=[selectedFeed mutableCopy];
            NSString *str=[dict valueForKey:@"url"];
            NSString *userid = [dict valueForKey:@"userid"];
            NSArray* foo = [str componentsSeparatedByString: @"/"];
            NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
            
            AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
            AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
            player = [AVPlayer playerWithPlayerItem:playerItem];
            avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:player];
            avPlayerLayer.frame=CGRectMake(0, 0, fullView.frame.size.width,fullView.frame.size.height);
            [fullView.layer addSublayer:avPlayerLayer];
            avPlayerLayer.backgroundColor=[UIColor clearColor].CGColor;
            player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            player.volume=1.0;
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[player currentItem]];
            avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
            if(play == 1)
            {
                if(list == 1)
                {
            [player play];
                }
            }
            [self.mPlayer setVolume:0];
            
            player.volume=1.0;
            if([[dict valueForKey:@"filter"]integerValue]==0)
            {
                player.rate=1.0;
            }
            if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
            {
                player.rate=2.0;
            }
            if([[dict valueForKey:@"filter"]integerValue]==2)
            {
                player.rate=0.5;
            }
            
            
            
            
            UIView *btnNext = [[UIView alloc]initWithFrame:self.view.frame];
            btnNext.backgroundColor=[UIColor clearColor];
            btnNext.userInteractionEnabled=true;
            if(indexPost<postArr.count-1)
                btnNext.tag=indexPost+1;
            else
                btnNext.tag=0;
            btnNext.frame = self.view.frame;
            [fullView addSubview:btnNext];
            UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(handleLongPress:)];
            longPress.minimumPressDuration = 0.4;
            [btnNext addGestureRecognizer:longPress];
            
            // Setting the swipe direction.
            [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
            [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
            [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
            [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
            
            // Adding the swipe gesture on image view
            [btnNext addGestureRecognizer:swipeLeft];
            [btnNext addGestureRecognizer:swipeRight];
            [btnNext addGestureRecognizer:swipeUp];
            [btnNext addGestureRecognizer:swipeDown];
            
            UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleDoubleTap:)];
            
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleSingleTap:)];
            
            [singleTap requireGestureRecognizerToFail : doubleTap];
            [doubleTap setDelaysTouchesBegan : YES];
            [singleTap setDelaysTouchesBegan : YES];
            [doubleTap setNumberOfTapsRequired : 2];
            [singleTap setNumberOfTapsRequired : 1];
            [btnNext addGestureRecognizer : doubleTap];
            [btnNext addGestureRecognizer : singleTap];
            
            
            //            UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [btnNext addTarget:self
            //                        action:@selector(playFullScreenVideo1:)
            //              forControlEvents:UIControlEventTouchUpInside];
            //            [btnNext setTitle:@"" forState:UIControlStateNormal];
            //            if(indexPost<postArr.count-1)
            //                btnNext.tag=indexPost+1;
            //            else
            //                btnNext.tag=0;
            //            btnNext.frame = self.view.frame;
            //            [fullView addSubview:btnNext];
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(closeFullView1:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
            button.frame = CGRectMake(fullView.frame.size.width-60, 20, 60, 40.0);
            [fullView addSubview:button];
            
            
            UIView *viewBack=[[UIView alloc]init];
            [viewBack setBackgroundColor:[UIColor whiteColor]];
            [viewBack setFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
            [viewBack setAlpha:0.8];
            [fullView addSubview:viewBack];
            
            AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,2, 50, 50)];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.layer.cornerRadius=25;
            img.layer.masksToBounds = YES;
            [img.layer setMasksToBounds:YES];
            img.backgroundColor=[UIColor grayColor];
            img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[selectedFeed valueForKey:@"user_pic"]]];
            [viewBack addSubview:img];
            
            UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [userProfileButton setTitle:@"" forState:UIControlStateNormal];
            [userProfileButton addTarget:self action:@selector(userprofileButton_action:) forControlEvents:UIControlEventTouchUpInside];
            userProfileButton.tag=sender.tag;
            userProfileButton.frame = CGRectMake(8,8, 60, 60);
            [viewBack addSubview:userProfileButton];
            
            UILabel *timelbl;
            timelbl = [[UILabel alloc] initWithFrame:CGRectMake (viewBack.frame.size.width-30,10, 40, 20)];
            [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            timelbl.textColor=[UIColor purpleColor];
            timelbl.backgroundColor=[UIColor clearColor];
            NSString *st= [AppDelegate HourCalculation:[dict valueForKey:@"time"]];
            [timelbl setText:st];
            [viewBack addSubview:timelbl];
            
            
            CGSize stringsize = [[NSString stringWithFormat:@"%@,",[selectedFeed valueForKey:@"username"]]sizeWithFont:[UIFont systemFontOfSize:15]];
            
            
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
            CGRect labelFrame = CGRectMake (73, 5, stringsize.width+20, 25);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textColor=[UIColor purpleColor];
            
            label.backgroundColor=[UIColor clearColor];
            [label setText:[NSString stringWithFormat:@"%@,",[selectedFeed valueForKey:@"username"]]];
            [viewBack addSubview:label];
            
            
            
            CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, self.view.frame.size.width-120-stringsize.width, 25);
            
            
            
            UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
            [location addTarget:self action:@selector(openNearByScreen:) forControlEvents:UIControlEventTouchUpInside];
            location.tag=sender.tag;
            location.frame =labelFrameee;
            location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            location.titleLabel.font=[UIFont fontWithName:@"Arial" size:13];
            [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            location.backgroundColor=[UIColor clearColor];
            [location setTitle:[selectedFeed valueForKey:@"location"] forState:UIControlStateNormal];
            [viewBack addSubview:location];
            
            
            
            
            
            //            UIButton *postDetailbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            //
            //            [postDetailbutton setTitle:@"" forState:UIControlStateNormal];
            //            postDetailbutton.frame = CGRectMake(65,480, 320-65, 25);
            //            [fullView addSubview:postDetailbutton];
            
            
            
            UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:13];
            CGRect labelFrame1 = CGRectMake (73,25, 250, 35);
            STTweetLabel *labell = [[STTweetLabel alloc] initWithFrame:labelFrame1];
            [labell setFont:myFont1];
            label.numberOfLines=2;
            labell.lineBreakMode=NSLineBreakByWordWrapping;
            labell.textColor=[UIColor grayColor];
            labell.backgroundColor=[UIColor clearColor];
            [labell setText:[selectedFeed valueForKey:@"caption"]];
            
            
            [viewBack addSubview:labell];
            
            
            UIButton *postDetailbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [postDetailbutton addTarget:self action:@selector(postdetailaction:) forControlEvents:UIControlEventTouchUpInside];
            postDetailbutton.tag=sender.tag;
            [postDetailbutton setTitle:@"" forState:UIControlStateNormal];
            postDetailbutton.frame = CGRectMake(73,25, 250, 35);
            [viewBack addSubview:postDetailbutton];
            
            
            
            
            
            
            
            
            
            
            [self.view addSubview:fullView];
            
            
            UITabBarController *bar = [self tabBarController];
            if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
                //iOS 7 - hide by property
                NSLog(@"iOS 7");
                [self setExtendedLayoutIncludesOpaqueBars:YES];
                bar.tabBar.hidden = YES;
            }
            
        }
    }
    
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    if(UIGestureRecognizerStateBegan == gesture.state) {
        // Called on start of gesture, do work here
        NSMutableDictionary *dict=[postArr objectAtIndex:indexPost];
        if([[dict valueForKey:@"userid"]isEqualToString:userid])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"You can't Reliveie this post" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else
        {
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"HomeEntries" inManagedObjectContext:context];
            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
            [request11 setEntity:entityDesc1];
            
            NSPredicate *pred1 ;
            pred1 =[NSPredicate predicateWithFormat:@"(post_Id = %@ && isReshare = 1)",[dict valueForKey:@"postid"]];
            [request11 setPredicate:pred1];
            NSError *error;
            NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
            if(objects11.count>0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Already Reposted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            else
            {
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context =[appDelegate managedObjectContext];
                NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"HomeEntries" inManagedObjectContext:context];
                NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                [request11 setEntity:entityDesc1];
                NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(post_Id = %@)",[dict valueForKey:@"postid"]];
                [request11 setPredicate:pred1];
                NSError *error;
                NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
                for (NSManagedObject *obj in objects11) {
                    
                    [obj setValue:[NSNumber numberWithInt:1] forKey:@"isReshare"];
                    
                    
                    [context save:&error];
                    
                }
                
                
                
                
                
                api_obj=[[APIViewController alloc]init];
                [api_obj ReShare:@selector(ReShareResult:) tempTarget:self :[dict valueForKey:@"postid"]];
            }
            
        }
        
    }
    
    if(UIGestureRecognizerStateChanged == gesture.state) {
        // Do repeated work here (repeats continuously) while finger is down
        
        UITabBarController *bar = [self tabBarController];
        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
            //iOS 7 - hide by property
            NSLog(@"iOS 7");
            [self setExtendedLayoutIncludesOpaqueBars:YES];
            bar.tabBar.hidden = YES;
        }
        
    }
    
    if(UIGestureRecognizerStateEnded == gesture.state) {
        // Do end work here when finger is lifted
        UITabBarController *bar = [self tabBarController];
        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
            //iOS 7 - hide by property
            NSLog(@"iOS 7");
            [self setExtendedLayoutIncludesOpaqueBars:YES];
            bar.tabBar.hidden = YES;
        }
        
    }
}
- (void)handleSingleTap:(UIGestureRecognizer *)indexPath {
    //do your stuff for a double tap
    [player pause];
    NSLog(@"single tap");
    if(indexPost<postArr.count-1)
        indexPost=  indexPost+1;
    else
        indexPost=0;
    
    
    [filterView removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    
    
    fullView=nil;
    fullView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    fullView.backgroundColor=[UIColor blackColor];
    
    selectedFeed=[postArr[indexPost]mutableCopy];
    NSMutableDictionary *dict=[selectedFeed mutableCopy];
    NSString *str=[dict valueForKey:@"url"];
    NSString *userid = [dict valueForKey:@"userid"];
    NSArray* foo = [str componentsSeparatedByString: @"/"];
    NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:player];
    avPlayerLayer.frame=CGRectMake(0, 0, fullView.frame.size.width,fullView.frame.size.height);
    [fullView.layer addSublayer:avPlayerLayer];
    avPlayerLayer.backgroundColor=[UIColor clearColor].CGColor;
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    player.volume=1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
    avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
    if(play == 1)
    {
        if(list == 1)
        {
    [player play];
        }
    }
    [self.mPlayer setVolume:0];
    
    player.volume=1.0;
    
    if([[dict valueForKey:@"filter"]integerValue]==0)
    {
        player.rate=1.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
    {
        player.rate=2.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==2)
    {
        player.rate=.5;
    }
    
    
    
    UIView *btnNext = [[UIView alloc]initWithFrame:self.view.frame];
    btnNext.backgroundColor=[UIColor clearColor];
    btnNext.userInteractionEnabled=true;
    if(indexPost<postArr.count-1)
        btnNext.tag=indexPost+1;
    else
        btnNext.tag=0;
    btnNext.frame = self.view.frame;
    [fullView addSubview:btnNext];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.4;
    [btnNext addGestureRecognizer:longPress];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    // Adding the swipe gesture on image view
    [btnNext addGestureRecognizer:swipeLeft];
    [btnNext addGestureRecognizer:swipeRight];
    [btnNext addGestureRecognizer:swipeUp];
    [btnNext addGestureRecognizer:swipeDown];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleDoubleTap:)];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleSingleTap:)];
    
    [singleTap requireGestureRecognizerToFail : doubleTap];
    [doubleTap setDelaysTouchesBegan : YES];
    [singleTap setDelaysTouchesBegan : YES];
    [doubleTap setNumberOfTapsRequired : 2];
    [singleTap setNumberOfTapsRequired : 1];
    [btnNext addGestureRecognizer : doubleTap];
    [btnNext addGestureRecognizer : singleTap];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(closeFullView1:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
    button.frame = CGRectMake(fullView.frame.size.width-60, 20, 60, 40.0);
    [fullView addSubview:button];
    
    
    UIView *viewBack=[[UIView alloc]init];
    [viewBack setBackgroundColor:[UIColor whiteColor]];
    [viewBack setFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    [viewBack setAlpha:0.8];
    [fullView addSubview:viewBack];
    
    AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,2, 50, 50)];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.layer.cornerRadius=25;
    img.layer.masksToBounds = YES;
    [img.layer setMasksToBounds:YES];
    img.backgroundColor=[UIColor grayColor];
    img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[selectedFeed valueForKey:@"user_pic"]]];
    [viewBack addSubview:img];
    
    UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userProfileButton setTitle:@"" forState:UIControlStateNormal];
    userProfileButton.frame = CGRectMake(8,8, 60, 60);
    [viewBack addSubview:userProfileButton];
    
    
    
    
    CGSize stringsize = [[NSString stringWithFormat:@"%@,",[selectedFeed valueForKey:@"username"]]sizeWithFont:[UIFont systemFontOfSize:15]];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (73, 5, stringsize.width+20, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor purpleColor];
    
    label.backgroundColor=[UIColor clearColor];
    [label setText:[NSString stringWithFormat:@"%@,",[selectedFeed valueForKey:@"username"]]];
    [viewBack addSubview:label];
    
    
    
    
    CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, self.view.frame.size.width-120-stringsize.width, 25);
    
    
    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
    [location addTarget:self action:@selector(openNearByScreen:) forControlEvents:UIControlEventTouchUpInside];
    location.frame =labelFrameee;
    location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    location.titleLabel.font=[UIFont fontWithName:@"Arial" size:13];
    [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    location.backgroundColor=[UIColor clearColor];
    [location setTitle:[selectedFeed valueForKey:@"location"] forState:UIControlStateNormal];
    [viewBack addSubview:location];
    
    //            UIButton *postDetailbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //
    //            [postDetailbutton setTitle:@"" forState:UIControlStateNormal];
    //            postDetailbutton.frame = CGRectMake(65,480, 320-65, 25);
    //            [fullView addSubview:postDetailbutton];
    
    UILabel *timelbl;
    timelbl = [[UILabel alloc] initWithFrame:CGRectMake (viewBack.frame.size.width-30,10, 40, 20)];
    [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
    timelbl.textColor=[UIColor purpleColor];
    timelbl.backgroundColor=[UIColor clearColor];
    NSString *st= [AppDelegate HourCalculation:[dict valueForKey:@"time"]];
    [timelbl setText:st];
    [viewBack addSubview:timelbl];
    
    UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:13];
    CGRect labelFrame1 = CGRectMake (73,25, 250, 35);
    STTweetLabel *labell = [[STTweetLabel alloc] initWithFrame:labelFrame1];
    [labell setFont:myFont1];
    label.numberOfLines=2;
    labell.lineBreakMode=NSLineBreakByWordWrapping;
    labell.textColor=[UIColor grayColor];
    labell.backgroundColor=[UIColor clearColor];
    [labell setText:[selectedFeed valueForKey:@"caption"]];
    
    
    [viewBack addSubview:labell];
    
    
    [self.view addSubview:fullView];
    
    
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }
    
}
-(void)downloadVideoOnStop:(NSMutableDictionary*)dictTemp
{
if(dictTemp)
{
    NSString *str=[dictTemp valueForKey:@"url"];
    NSURL *URL=[[NSURL alloc] initWithString:str];
    
    
    NSString *userid = [dictTemp valueForKey:@"userid"];
    
    if(![str isEqualToString:@""])
    {
        NSArray* foo = [str componentsSeparatedByString: @"/"];
        NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
        NSURL *URLl = [NSURL fileURLWithPath:dataPath];
        [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        
        //==========Checking if path already exist for video files==================
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
        
        AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:dataPath] options:nil];
        
        if(fileExists && asset.playable)
        {
            [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:dictTemp]]];
        }
        else
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:dataPath append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:dictTemp]]];
                NSLog(@"Successfully downloaded file to %@",dataPath);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
            }];
            
            [operation start];
        }
        
    }
    else
    {
    }
}
}
-(void)VideoPlayTimerComplete:(NSTimer *)timer
{
    
    if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
    {
        NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
        NSString *useridd = [dict valueForKey:@"userid"];
        NSString *str=[dict valueForKey:@"url"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            
            NSArray* foo = [str componentsSeparatedByString: @"/"];
            NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
            NSURL *URLl = [NSURL fileURLWithPath:dataPath];
            [URLl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                if(play == 1)
                {
                    if(list == 1)
                    {
                playerr =[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                
                // Assign image back on the main thread
                [cellToActivate.videoView setPlayer:playerr];
                [cellToActivate.videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                if([[dict valueForKey:@"filter"]integerValue]==0)
                {
                    playerr.rate=1.0;
                }
                if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
                {
                    playerr.rate=2.0;
                }
                if([[dict valueForKey:@"filter"]integerValue]==2)
                {
                    playerr.rate=0.5;
                }
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:[playerr currentItem]];
                    }}
            });
            
            
            
        });
        [cellToActivate.videoView.player play];
        [cellToActivate.activity stopAnimating];
        cellToActivate.activity.hidden=YES;
        [videoCheckTimer invalidate];
    }
}
-(void)scrollTableOnNotification
{
    [collectionV setContentOffset:CGPointMake(0,collectionV.contentOffset.y+0.1) animated:YES];

//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellToLoad];
//    [collectionV scrollToRowAtIndexPath:indexPath
//                       atScrollPosition:UITableViewScrollPositionMiddle
//                               animated:YES];
}
@end

