//
//  likedVideoViewController.m
//  Lively
//
//  Created by Brahmasys on 14/04/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "likedVideoViewController.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AVPlayerDemoPlaybackView.h"
#import "VideoPlayerViewController.h"

#import "otheruserViewController.h"
#import "likeViewController.h"
#import "directViewController.h"
#import "reSharePostViewController.h"


#import "AppDelegate.h"


#import "recordVideoViewController.h"
#import "directVideoViewController.h"
#import "getNearByViewController.h"
#import "commentsOnFeedViewController.h"
#import "AGPushNoteView.h"
@interface likedVideoViewController ()


@property (readwrite, retain) AVPlayer* mPlayer;
@property (nonatomic, retain) VideoPlayerViewController *myPlayerViewController;
@end

@class AVPlayer;
@class AVPlayerDemoPlaybackView;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;


@implementation likedVideoViewController
{
    int play,options;
    NSMutableDictionary *playableDict;
    NSTimer *videoCheckTimer;
    
    homeFeedsCell *cellToActivate;
    homeFeedsCell *cellToDeactivate;
    
    int cellToLoad;

    NSTimer *aTimer,*indiTimer ;
    BOOL isScrolling;
    UIView *fullView;
    NSMutableArray *postArr;
    AVPlayer *player;
    APIViewController *api_obj;
    
    int duration;
    NSMutableArray *filterArr;
    UIImageView *filterView,*fimage;
    UIImageView *im;
    int downloadVideoCount,count,downloadImageCount;
    
    NSIndexPath *currentindex;
    NSURLSessionDownloadTask *downloadTask ;
    int feedID;
    AVPlayerLayer *avPlayerLayer;
    
    int currentTime;
    UIImageView *imgv;
    
    int currentplayingVideo;
    
    UIImageView *heartanimation;
    UILabel *Notification_count_lbl;
    UIActivityIndicatorView *indicator;
    NSString *min,*max;
    int changeview;
    
    BOOL stopLoader;
    
    NSMutableArray *videoArray;
    int apicall;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    playableDict = [NSMutableDictionary new];

    changeview=40;
    [self createOptionPopUp];
    
    currentTime=0;

    [self GetLikedVideos];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)GetLikedVideos
{
    NSString *d;
    
    
    
   
        d=@"10";
    
    
    
    NSString *urls=[NSString stringWithFormat:@"%@/%@/%@",userid,@"0",d];
    NSString *urlString=[NSString stringWithFormat:@"%@/GetPostLikedByUser/%@",WEBURL1,urls];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
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
            
            [self getAllVideosResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getAllVideosResult:nil];
        
    }];
    
    [operation start];
 
}
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getShowMoreData
{
    if(apicall==1)
    {
        apicall=0;
        NSString *urls=[NSString stringWithFormat:@"%@/%@/%@",userid,min,max];
        
        //GetPostLikedByUser
        
        
        NSString *urlString=[NSString stringWithFormat:@"%@/GetPostLikedByUser/%@",WEBURL1,urls];
        
        NSLog(@"url %@",urlString);
        NSURL *url = [[NSURL alloc] initWithString:urlString];
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
                
                [self getShowMoreDataResult:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self getShowMoreDataResult:nil];
            
        }];
        
        [operation start];

        
        
        
//        api_obj=[[APIViewController alloc]init];
//        [api_obj getAllVideos:@selector(getShowMoreDataResult:) tempTarget:self :url];
    }
}
-(void)getShowMoreDataResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        if([[[dict_Response objectForKey:@"response"]valueForKey:@"status" ] integerValue]==200)
        {
            if(self.tabBarController.selectedIndex==4)
            {
                if([[dict_Response valueForKey:@"userpost"] count]>0)
                {
                    for(int i=0;i<[[dict_Response valueForKey:@"userpost"] count];i++)
                    {
                        [postArr addObject:[dict_Response valueForKey:@"userpost"][i]];
                    }
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

                    if([[dict_Response valueForKey:@"userpost"] count])
                    {
                        downloadVideoCount=(int)postArr.count;
                        for(int i=postArr.count-1;i>=0;i--)
                        {
                            [videoArray addObject:[postArr objectAtIndex:i]];
                        }
                        downloadImageCount=0;
                        [self btnImagesClick:0];
                        [collectionV reloadData];
                        
    
                    }
                    
                    else
                    {
                    }
                }
                else
                {
                    stopLoader=YES;
                    [collectionV reloadData];

                }
            }
            
            //
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    


    
    play=1;
    
    [super viewWillAppear:animated];
    stopLoader=false;
    screencount=111;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTableOnNotification) name:@"liked" object:nil];
    screenName=@"liked";

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

    videoUploaded=false;
    duration=0;
    changeview=0;
    currentTime=0;
    self.mPlayer.volume=0.0;
    self.navigationController.navigationBarHidden=YES;
    
    
    if(postArr.count>0)
       [self scrollTableOnNotification];
    
    
//    NSString *url=[NSString stringWithFormat:@"%@/%@/%@",userid,@"0",d];
//    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getAllVideos:@selector(getAllVideosResult:) tempTarget:self :url];
    
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    
    
    
    //
}



-(void)getAllVideosResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        if([[[dict_Response objectForKey:@"response"]valueForKey:@"status" ] integerValue]==200)
        {
            if(self.tabBarController.selectedIndex==4)
            {
                postArr=[NSMutableArray new];
                videoArray=[NSMutableArray new];
                postArr=[[dict_Response valueForKey:@"userpost"]mutableCopy];
                //[tablev reloadData];
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

                for(int i=(int)postArr.count-1;i>=0;i--)
                {
                    [videoArray addObject:[postArr objectAtIndex:i]];
                }
                downloadVideoCount=(int)postArr.count;
                downloadImageCount=0;
                //[self btnImagesClick1:0];
                [self btnImagesClick:0];
                
                [collectionV reloadData];
                if(postArr.count>0)
                    [collectionV setContentOffset:CGPointMake(0,collectionV.contentOffset.y+0.5) animated:YES];
                if(postArr.count==0)
                {
                }
                
            }
            
        }
    }
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {

    if(play == 1)
    {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [cellToActivate.videoView.player seekToTime:kCMTimeZero];
    [cellToActivate.videoView.player play];
    
    NSMutableDictionary *dict=postArr[currentplayingVideo];
    if([[dict valueForKey:@"filter"]integerValue]==0)
    {
        self.mPlayer.rate=1.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==1 || [[dict valueForKey:@"filter"]integerValue]==320)
    {
        self.mPlayer.rate=2.0;
    }
    if([[dict valueForKey:@"filter"]integerValue]==2)
    {
        self.mPlayer.rate=0.5;
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
    
    if(fullView==nil && changeview==0)
    {
        UIButton *v = (UIButton *)[collectionV viewWithTag:4000+currentplayingVideo];
        if([[v titleForState:UIControlStateNormal] isEqualToString:@"1K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"2K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"3K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"4K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"5K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"6K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"7K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"8K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"9K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"10K+"])
        {
            
        }
        else
        {
            [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal]intValue]+1] forState:UIControlStateNormal];
        }
        api_obj=[[APIViewController alloc]init];
        [api_obj markviewresd:@selector(markviewresdResult:) tempTarget:self :[dict valueForKey:@"postid"]];
    }
    }
}

-(void)postdetailaction:(UIButton*)btn
{
    [self.mPlayer setVolume:0];
    if([[[postArr objectAtIndex:btn.tag]valueForKey:@"post_type"]isEqualToString:@"public"]||[[[postArr objectAtIndex:btn.tag]valueForKey:@"post_type"]isEqualToString:@"reshare"])
    {
        selectedFeed=[postArr objectAtIndex:btn.tag];
        
    }
    else
    {
        selectedFeed=[postArr objectAtIndex:btn.tag];
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
-(void)closeFullView:(UIButton*)btn
{
    duration=0;
    currentTime=0;
    player.volume=0.0;;
    [player pause];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellToLoad];
    [collectionV scrollToRowAtIndexPath:indexPath
                       atScrollPosition:UITableViewScrollPositionMiddle
                               animated:YES];

    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }
    
}

-(void)btnImagesClick:(UIButton*)sender
{
    
    downloadVideoCount=downloadVideoCount-1;
    if(downloadVideoCount>=0)
    {
        NSMutableDictionary *downloadVideoDict = [videoArray objectAtIndex:downloadVideoCount];
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
                [self btnImagesClick:0];
                NSLog(@"Successfully downloaded file to %@",dataPath);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[postArr indexOfObject:dictTemp]]];
                [self btnImagesClick:0];
                
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
        [self back_Button:0];
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
    
    sender.imageView.frame = CGRectMake(sender.frame.origin.x+1, sender.frame.origin.y+1, sender.frame.size.width-2, sender.frame.size.height-2);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.imageView.frame = CGRectMake(sender.frame.origin.x-1, sender.frame.origin.y-1, sender.frame.size.width+2, sender.frame.size.height+2);
    [UIView commitAnimations];
    
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
    sender.imageView.frame = CGRectMake(sender.frame.origin.x+1, sender.frame.origin.y+1, sender.frame.size.width-2, sender.frame.size.height-2);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.imageView.frame = CGRectMake(sender.frame.origin.x-1, sender.frame.origin.y-1, sender.frame.size.width+2, sender.frame.size.height+2);
    [UIView commitAnimations];
    
    
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
    [self.navigationController pushViewController:mvc animated:NO];
    
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
    [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[selectedFeed objectForKey:@"postid"] :st];
    
    
    
    
}
- (void)Options:(UIButton*)sender
{
    selectedFeed=[postArr objectAtIndex:sender.tag];
    if([[selectedFeed valueForKey:@"post_follow_status"] boolValue] == 0)
    {
        options=1;
        if(viewOptions.tag==0)
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,self.view.frame.size.height-viewOptions.frame.size.height-43, viewOptions.frame.size.width, viewOptions.frame.size.height)];
            viewOptions.tag=1;
            indexOptions=(int)[sender tag];
            
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
            viewOptions.tag=0;
            [UIView commitAnimations];
            
        }
    }
    else
    {
        options=2;
        if(viewOptions1.tag==0)
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,self.view.frame.size.height-viewOptions1.frame.size.height-43, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];
            viewOptions1.tag=1;
            indexOptions=(int)[sender tag];
            
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,790, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];
            viewOptions1.tag=0;
            [UIView commitAnimations];
            
        }
        
    }
    
}
-(IBAction)Report:(id)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        if([[dict valueForKey:@"userid"]isEqualToString:userid])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"You can't Report your post" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj ReportSpamPost:@selector(ReportSpamPostResult:) tempTarget:self :[dict valueForKey:@"postid"]];
        }
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
            
            
            
            
            
            
       // }
        
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
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
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
-(IBAction)shareDirectLink:(UIButton*)sender
{
    if(viewOptions.tag==1)
    {
        ///NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        
        selectedFeed=[postArr objectAtIndex:indexOptions];
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
        
        
        //        NSURL *textToShare =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]]];
        //
        //
        //        NSString *Text=@"LIVELY";
        //
        //        NSArray *itemsToShare = @[Text,textToShare,];
        //
        //        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        //        activityVC.excludedActivityTypes = nil ;//or whichever you don't need
        //        [self presentViewController:activityVC animated:YES completion:nil];
    }
    [self cancelClick:0];
    
}
-(IBAction)copyLink:(UIButton*)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"link copied" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [self cancelClick:0];
    
}
-(void)HidePostResult:(NSMutableDictionary*)dict
{
    NSLog(@"HidePostResult :%@",dict);
    [self viewWillAppear:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Post hide Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [videoCheckTimer invalidate];

    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];;
    viewOptions.tag=0;
    [UIView commitAnimations];
}
-(IBAction)cancelClick:(id)sender
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];;
    viewOptions.tag=0;
    [UIView commitAnimations];
    
    
}
-(void)markviewresdResult:(NSDictionary*)dict_Response
{
}

-(void)getlikeresult:(NSDictionary*)dict_Response
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
            
            
            
           
        }
        else
        {
            
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    play=0;
    [cellToActivate.videoView.player pause];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
    cellToActivate.videoView.player=nil;
    
    screencount=0;
    [self.mPlayer pause];
    [fullView removeFromSuperview];
    [self.mPlayer setVolume:0];
    [indiTimer invalidate];
    [aTimer invalidate];
    [player pause];
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    
    changeview=1;
    
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
            [player play];
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
-(void)closeFullView1:(UIButton*)btn
{
    
    // [self.mPlayer setVolume:1];
    
    player.volume=0.0;;
    [player pause];
    duration=0;
    currentTime=0;
    
    [filterView removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    avPlayerLayer=nil;
    fullView=nil;
    player=nil;
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
    [collectionV setContentOffset:CGPointMake(0,collectionV.contentOffset.y+0.1) animated:YES];

}
-(void)closeFullViewOnswipe:(UIButton*)btn
{
    
    // [self.mPlayer setVolume:1];
    
    player.volume=0.0;;
    [player pause];
    duration=0;
    currentTime=0;
    
    [filterView removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    avPlayerLayer=nil;
    fullView=nil;
    player=nil;
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    [collectionV setContentOffset:CGPointMake(0,collectionV.contentOffset.y+0.1) animated:YES];

    //[self getDataFromDataBAse];
}

-(void)Likes:(UIButton*)sender
{
    int x = (int)[sender tag];
    NSMutableDictionary *dict=[postArr objectAtIndex:x - 6700];
    
    
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

-(IBAction)back_Button:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    [player pause];
    [self.mPlayer pause];
    player.volume=0.0;
    self.mPlayer.volume=0.0;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        [self.mPlayer pause];
        [player pause];
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
        
        selectedFeed=[postArr objectAtIndex:indexPost];
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
        [self closeFullViewOnswipe:0];
        
        selectedFeed=[postArr objectAtIndex:indexPost];
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
        if([[[postArr objectAtIndex:indexPost]valueForKey:@"post_type"]isEqualToString:@"public"]||[[[postArr objectAtIndex:indexPost]valueForKey:@"post_type"]isEqualToString:@"reshare"])
        {
            selectedFeed=[postArr objectAtIndex:indexPost];
            
        }
        else
        {
            selectedFeed=[postArr objectAtIndex:indexPost];
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
        
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(closeFullView1:) userInfo:nil repeats:NO];
        
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
- (void)handleDoubleTap:(UIGestureRecognizer *)indexPath {
    //do your stuff for a single tap
    NSLog(@"double tap");
    
    
    
    selectedFeed=[postArr objectAtIndex:indexPost];
    
    heartanimation=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40,self.view.frame.size.height/2-40, 80,80)];
    
    NSString *st;
    // Check Id Exist Or Not
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"HomeEntries" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    
    NSPredicate *pred1 ;
    pred1 =[NSPredicate predicateWithFormat:@"(post_Id = %@)",[selectedFeed objectForKey:@"postid"]];
    
    [request11 setPredicate:pred1];
    NSError *error;
    NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
    for (NSManagedObject *obj in objects11) {
        
        if([[obj valueForKey:@"likestatus"]boolValue])
        {
            //            [obj setValue:[NSNumber numberWithInt:0] forKey:@"likestatus"];
            //            [obj setValue:[NSNumber numberWithInt:[[obj valueForKey:@"likeCount"] intValue]-1] forKey:@"likeCount"];
            //            st=@"false";
            //            heartanimation.image=[UIImage imageNamed:@"WhiteHeart.png"];
            
            
            //[sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        }
        else
        {
            st=@"true";
            [obj setValue:[NSNumber numberWithInt:1] forKey:@"likestatus"];
            [obj setValue:[NSNumber numberWithInt:[[obj valueForKey:@"likeCount"] intValue]+1] forKey:@"likeCount"];
            heartanimation.image=[UIImage imageNamed:@"Heartshape.png"];
            [context save:&error];
            api_obj=[[APIViewController alloc]init];
            [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[selectedFeed objectForKey:@"postid"] :st];
            //[sender setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateNormal];
        }
        
        
        ;
        
    }
    //[self getDataFromDataBAse];
    
    
    
    
    [fullView addSubview:heartanimation];
    
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.9f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [heartanimation setFrame:CGRectMake(0,self.view.frame.size.height/2-160, 320, 320)];
    heartanimation.alpha=0.0;
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeHeart) userInfo:nil repeats:NO];
    
    
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
    [player play];
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
    
    AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,2, 50,50)];
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
    
    
    
CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, self.view.frame.size.width-120-stringsize.width, 25);    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    NSArray *buttonArray1 = [[NSArray alloc]initWithObjects:@"Reliveie",@"Unfollow Post",@"Direct Share",@"Copy Link",@"Hide Post",@"Report",@"Cancel", nil];
    viewOptions1=[[UIView alloc]initWithFrame:CGRectMake(0, 790, self.view.frame.size.width, 320)];
    viewOptions1.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    int y1=10;
    for(int i=0;i<buttonArray1.count;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(optionPopupMethod:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:buttonArray1[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(20.0, y1, self.view.frame.size.width-40, 30);
        [viewOptions1 addSubview:button];
        if(i==buttonArray1.count-1)
        {
            button.frame = CGRectMake(20.0, y1+10, self.view.frame.size.width-40, 30);
            button.layer.cornerRadius=5.0;
            button.backgroundColor=[UIColor colorWithRed:113/255.0 green:43/255.0 blue:141/255.0 alpha:1.0];
            
        }
        if(i!=0)
        {
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, y1-5, self.view.frame.size.width, 1)];
            view.backgroundColor=[UIColor whiteColor];
            [viewOptions1 addSubview:view];
        }
        
        
        y1=y1+40;
    }
    
    
    [self.view addSubview:viewOptions1];
    
    
    
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
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Unfollow Post"])
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
    if(options==1)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        if([[dict valueForKey:@"userid"] isEqual:userid])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Liveie" message:@"Cannot follow his own post" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj followUser:@selector(followPostResult:) tempTarget:self :[dict valueForKey:@"postid"] : @"true"];
        }
        
    }
    else if(options==2)
    {
        NSMutableDictionary *dict=[postArr objectAtIndex:indexOptions];
        if([[dict valueForKey:@"userid"] isEqual:userid])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Liveie" message:@"Cannot follow his own post" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj followUser:@selector(followPostResult:) tempTarget:self :[dict valueForKey:@"postid"] : @"false"];
        }
        
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
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,790, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];;
    viewOptions1.tag=0;
    [UIView commitAnimations];
    [self GetLikedVideos];
    
    
}
#pragma mark Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(postArr.count==0)
    {
        [collectionV setHidden:YES];
        return 0;
    }
    else
    {
        [collectionV setHidden:NO];
    return postArr.count+1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==postArr.count || postArr.count==0)
    {
        return 0;
    }

        return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,80)];
    if(section == postArr.count)
    {
        
        if(!stopLoader)
        {
            indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.frame = CGRectMake(self.view.frame.size.width/2-20, 30, 40.0, 40.0);
            [view addSubview:indicator];
            [indicator bringSubviewToFront:tableView];
            [indicator startAnimating];
            
            
            
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
        
    }
    else
    {

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
        
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(section==postArr.count)
    {
        return 100;
        
    }
    
    int h=0;
    NSMutableDictionary *dict=[postArr[section] mutableCopy];
    UIFont * myFont1 ;
    myFont1 = [UIFont fontWithName:@"HelveticaNeue" size:12];
    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-70  , 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: myFont1, NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"caption"] attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
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

    
    if(![[dict valueForKey:@"action_text"] isEqual:[NSNull null]] && ![[dict valueForKey:@"action_text"] isEqualToString:@""] )
        h=h+25;
    
    return 50+requiredHeight.size.height+h+z;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    
    if(indexPath.section==postArr.count-1)
    {
        if(stopLoader)
        {
            
        }
        else
        {
        apicall=1;
        min=[NSString stringWithFormat:@"%lu",(unsigned long)postArr.count];
        max=[NSString stringWithFormat:@"10"];
        [self getShowMoreData];
        }
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

    
    
    
        celll.videoView.tag=indexPath.section;
        
        
        celll.videoImage.contentMode = UIViewContentModeScaleAspectFill;
        [celll.videoImage.layer setMasksToBounds:YES];
        celll.videoImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
        
        
        celll.profileImage.layer.cornerRadius=25;
        celll.profileImage.imageURL=[NSURL URLWithString: [NSString stringWithFormat:@"%@",[dict valueForKey:@"user_pic"]] ];
        
        [celll.city setTitle:[dict valueForKey:@"location"] forState:UIControlStateNormal];
        celll.selectionStyle = UITableViewCellSelectionStyleNone;
        celll.city.tag=indexPath.section;
        [celll.city addTarget:self action:@selector(openNearByScreen:) forControlEvents:UIControlEventTouchUpInside];
        
        celll.city.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==43)
    {
        return 40;
    }
    else
    {
        int h;
        if(iphone5||iphone4)
            h=320;
        else if(iphone6)
            h=375;
        else
            h=414;
        if(indexPath.section==postArr.count)
        {
            h=0;
        }
        return h;

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
    // NSLog(@"%ld",(long)cellToActivate.videoView.tag);
    currentplayingVideo=(int)cellToActivate.videoView.tag;
    cellToLoad=currentplayingVideo;
    NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];

    if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
    {
    
    NSString *useridd = [dict valueForKey:@"userid"];
    NSString *str=[dict valueForKey:@"url"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSArray* foo = [str componentsSeparatedByString: @"/"];
        NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
        AVPlayer *playerr =[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            
            if(play == 1)
            {
            
            // Assign image back on the main thread
            [cellToActivate.videoView setPlayer:playerr];
            [cellToActivate.videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            [playerr play];
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
            });
    });
    
    
    [cellToActivate.videoView.player play];
    }

else
{
    
    [self downloadVideoOnStop:dict];
    cellToActivate.activity.hidden=false;
    [cellToActivate.activity startAnimating];
    [videoCheckTimer invalidate];
    videoCheckTimer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(VideoPlayTimerComplete:) userInfo:nil repeats:YES];
    
}


}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(postArr.count>0)
    {
    if(!decelerate)
    {
//        NSArray *visibleCells = [collectionV visibleCells];
//        
//        for (UITableView *cell in visibleCells) {
//            if (!cellToActivate) {
//                cellToActivate = (homeFeedsCell *)cell;
//            } else {
//                // cellToActive is always the top most cell
//                homeFeedsCell *cell1 = cellToActivate;
//                NSIndexPath *cell1_indexPath = [collectionV indexPathForCell:cell1];
//                CGRect cell1_frame = [collectionV cellForRowAtIndexPath:cell1_indexPath].frame;
//                
//                homeFeedsCell *cell2 = (homeFeedsCell *)cell;
//                NSIndexPath *cell2_indexPath = [collectionV indexPathForCell:cell2];
//                CGRect cell2_frame = [collectionV cellForRowAtIndexPath:cell2_indexPath].frame;
//                
//                // Cell frames in controller frames
//                CGRect cell1_frameInSuperview = [collectionV convertRect:cell1_frame toView:[collectionV superview]];
//                CGRect cell2_frameInSuperview = [collectionV convertRect:cell2_frame toView:[collectionV superview]];
//                
//                // Calculate which cell has the most real estate on screen
//                CGFloat cell1_visibleAmount = cell1_frameInSuperview.size.height - ABS(cell1_frameInSuperview.origin.y);
//                CGFloat cell2_visibleAmount = cell2_frameInSuperview.size.height - ABS(cell2_frameInSuperview.origin.y);
//                
//                if (cell1_visibleAmount > cell2_visibleAmount) {
//                    cellToActivate = cell1;
//                    cellToDeactivate = cell2;
//                } else {
//                    cellToActivate = cell2;
//                    cellToDeactivate = cell1;
//                }
//            }
//        }
        // NSLog(@"%ld",(long)cellToActivate.videoView.tag);
        currentplayingVideo=(int)cellToActivate.videoView.tag;
        cellToLoad=currentplayingVideo;

        NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
        
        if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
        {
            
            NSString *useridd = [dict valueForKey:@"userid"];
            NSString *str=[dict valueForKey:@"url"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                NSArray* foo = [str componentsSeparatedByString: @"/"];
                NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
                AVPlayer *playerr =[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                dispatch_sync(dispatch_get_main_queue(), ^(void) {
                    // Assign image back on the main thread
                    [cellToActivate.videoView setPlayer:playerr];
                    [cellToActivate.videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                    [playerr play];
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
                                                               object:[playerr currentItem]];        });
            });
            
            if(play == 1)
            {
            [cellToActivate.videoView.player play];
            }
        }
        
        else
        {
            
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
    if(postArr.count>0)
    {

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
    
    currentplayingVideo=(int)cellToActivate.videoView.tag;
        cellToLoad=currentplayingVideo;

        NSMutableDictionary *dict=[postArr[currentplayingVideo] mutableCopy];
        
        if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
        {
            
            NSString *useridd = [dict valueForKey:@"userid"];
            NSString *str=[dict valueForKey:@"url"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                NSArray* foo = [str componentsSeparatedByString: @"/"];
                NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
                AVPlayer *playerr =[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                dispatch_sync(dispatch_get_main_queue(), ^(void) {
                    
                    if(play == 1)
                    {
                    
                    // Assign image back on the main thread
                    [cellToActivate.videoView setPlayer:playerr];
                    [cellToActivate.videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                    [playerr play];
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
                    
                    });
            });
            
            if(play == 1)
            {
            [cellToActivate.videoView.player play];
            }
        }
        
        else
        {
            
            [self downloadVideoOnStop:dict];
            cellToActivate.activity.hidden=false;
            [cellToActivate.activity startAnimating];
            [videoCheckTimer invalidate];
            videoCheckTimer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(VideoPlayTimerComplete:) userInfo:nil repeats:YES];
            
        }

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(postArr.count>0)
    {

    
    if(scrollView.contentOffset.y>0)
    {
        
        if (self.lastContentOffset > scrollView.contentOffset.y)
        {
            CGRect f = collectionV.frame;
            if(f.origin.y!=64)
            {
                f.origin.y = f.origin.y+4;
                f.size.height=f.size.height-4;
                
            }
            collectionV.frame =f;
            
            
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y)
        {
            CGRect f = collectionV.frame;
            if(f.origin.y!=20)
            {
                f.origin.y = f.origin.y-4;
                f.size.height=f.size.height+4;
            }
            collectionV.frame =f;
            
        }
        self.lastContentOffset = scrollView.contentOffset.y;
    }

    
    
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
    [cellToActivate.videoView.player play];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
        [videoCheckTimer invalidate];

    
    
    
    }
}
-(void)downloadVideoOnStop:(NSMutableDictionary*)dictTemp
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
                AVPlayer *playerr =[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                
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
            });
            
            
            
        });
        if(play == 1)
        {
        [cellToActivate.videoView.player play];
        }
        [cellToActivate.activity stopAnimating];
        cellToActivate.activity.hidden=YES;
        [videoCheckTimer invalidate];
    }
}
-(void)scrollTableOnNotification
{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellToLoad];
//    [collectionV scrollToRowAtIndexPath:indexPath
//                       atScrollPosition:UITableViewScrollPositionMiddle
//                               animated:YES];
    [collectionV setContentOffset:CGPointMake(0,collectionV.contentOffset.y+0.1) animated:YES];

}
@end
