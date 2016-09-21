//
//  directPostViewController.m
//  Lively
//
//  Created by Vinay Sharma on 22/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "directPostViewController.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "APIViewController.h"
#import "LoaderViewController.h"

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
#import "postOfHashTagView.h"

#import "recordVideoViewController.h"

#import "getNearByViewController.h"
#import "AGPushNoteView.h"


@class AVPlayer;
@class AVPlayerDemoPlaybackView;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;

@interface directPostViewController ()
{
    NSTimer *aTimer ;
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
    NSArray *foooooo;
    int play;
    int currentTime;

}
@property (readwrite, retain) AVPlayer* mPlayer;
@property (nonatomic, retain) VideoPlayerViewController *myPlayerViewController;
@end



@implementation directPostViewController
@synthesize strOtherUserId;

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
    currentTime=0;
    screencount=4;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }

    
    play=1;
    [super viewWillAppear:animated];
    screencount=4;
    duration=0;
    currentTime=0;
    self.mPlayer.volume=0.0;
    self.navigationController.navigationBarHidden=YES;
    screenName=@"directinner";

    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetDirectPost/%@/%@/0/500",WEBURL1,userid,friendID];
    
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
    
    
    
    //
}
-(void)viewWillDisappear:(BOOL)animated
{
    play=0;
}
-(IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
            postArr=[NSMutableArray new];
            postArr=[[dict_Response valueForKey:@"posts"]mutableCopy];
            //[tablev reloadData];
            downloadVideoCount=(int)postArr.count;
            downloadImageCount=(int)postArr.count;
            [self btnImagesClick:0];
            //[self btnImagesClick1:0];
            
            
            [self addDataOnScrollView];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    isScrolling = NO;
    
    
    [self.mPlayer pause];
    int c=postArr.count-roundf((scrolv.contentSize.height-scrolv.contentOffset.y)/(scrolv.contentSize.height/postArr.count));
    //NSLog(@"heighttttttttt %f",postArr.count-roundf((scrolv.contentSize.height-scrolv.contentOffset.y)/(scrolv.contentSize.height/postArr.count)));
    AVPlayerDemoPlaybackView *v = (AVPlayerDemoPlaybackView *)[scrolv viewWithTag:c+1];
    
    
    
    NSMutableDictionary *dict=postArr[c];
    selectedFeed=[dict mutableCopy];
    NSString *useridd = [dict valueForKey:@"userid"];
    NSString *str=[dict valueForKey:@"url"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        //cell.videoView.hidden=NO;
        NSArray* foo = [str componentsSeparatedByString: @"/"];
        NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(play == 1)
            {
            self.mPlayer=[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
            
            [v setPlayer:self.mPlayer];
            [v setVideoFillMode:AVLayerVideoGravityResizeAspect];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[self.mPlayer currentItem]];
            if(screencount==4)
            [self.mPlayer play];
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
            }
            
        });
        [self.mPlayer setVolume:0];
    });
    
    if (!isScrolling) {
        if([[dict valueForKey:@"view_status"]integerValue]==0)
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj markviewresd:@selector(markviewresdResult:) tempTarget:self :[dict valueForKey:@"postid"]];
        }
    }
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    NSLog(@"Did end dragging%d",decelerate);
    if(!decelerate)
    {
        [self.mPlayer pause];
        int c=postArr.count-roundf((scrolv.contentSize.height-scrolv.contentOffset.y)/(scrolv.contentSize.height/postArr.count));
        NSLog(@"heighttttttttt %f",postArr.count-roundf((scrolv.contentSize.height-scrolv.contentOffset.y)/(scrolv.contentSize.height/postArr.count)));
        AVPlayerDemoPlaybackView *v = (AVPlayerDemoPlaybackView *)[scrolv viewWithTag:c+1];
        
        
        
        NSMutableDictionary *dict=postArr[c];
        selectedFeed=[dict mutableCopy];
        NSString *useridd = [dict valueForKey:@"userid"];
        NSString *str=[dict valueForKey:@"url"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            //cell.videoView.hidden=NO;
            NSArray* foo = [str componentsSeparatedByString: @"/"];
            NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(play == 1)
                {
                self.mPlayer=[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                
                [v setPlayer:self.mPlayer];
                [v setVideoFillMode:AVLayerVideoGravityResizeAspect];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:[self.mPlayer currentItem]];
                if(screencount==4)
                [self.mPlayer play];
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
                }
                //v.transform=CGAffineTransformMakeRotation(M_PI / 2);
            });
            [self.mPlayer setVolume:0];
        });
        
        if([[dict valueForKey:@"view_status"]integerValue]==0)
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj markviewresd:@selector(markviewresdResult:) tempTarget:self :[dict valueForKey:@"postid"]];
        }
        
        
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView
{
    isScrolling = YES;
    [aTimer invalidate];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [aTimer invalidate];
    [self.mPlayer pause];
    [player pause];
    isScrolling = YES;
    
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if(play == 1)
    {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    duration=0;
    currentTime=0;
    [self.mPlayer seekToTime:kCMTimeZero];
    if(screencount==4)
    [self.mPlayer play];
    if(fullView)
    {
        if([[selectedFeed valueForKey:@"filter"]integerValue]==0)
        {
            player.rate=1.0;
        }
        if([[selectedFeed valueForKey:@"filter"]integerValue]==1 || [[selectedFeed valueForKey:@"filter"]integerValue]==320)
        {
            player.rate=2.0;
        }
        if([[selectedFeed valueForKey:@"filter"]integerValue]==2)
        {
            player.rate=0.5;
        }


    }
    if([[selectedFeed valueForKey:@"filter"]integerValue]==0)
    {
        self.mPlayer.rate=1.0;
    }
    if([[selectedFeed valueForKey:@"filter"]integerValue]==1 || [[selectedFeed valueForKey:@"filter"]integerValue]==320)
    {
        self.mPlayer.rate=2.0;
    }
    if([[selectedFeed valueForKey:@"filter"]integerValue]==2)
    {
        self.mPlayer.rate=0.5;
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
        
        if(fileExists)
        {
            
            [self btnImagesClick:0];
            
        }
        else
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:dataPath append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    //[self.navigationController pushViewController:mvc animated:YES];
    [self presentViewController:mvc animated:YES completion:nil];

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
    [self.navigationController pushViewController:mvc animated:YES];
    
}
- (void)like_action:(UIButton*)sender
{
    sender.imageView.frame = CGRectMake(sender.frame.origin.x+1, sender.frame.origin.y+1, sender.frame.size.width-2, sender.frame.size.height-2);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.imageView.frame = CGRectMake(sender.frame.origin.x-1, sender.frame.origin.y-1, sender.frame.size.width+2, sender.frame.size.height+2);
    [UIView commitAnimations];
    
    NSString *st;
    if([UIImagePNGRepresentation([sender imageForState:UIControlStateNormal] )isEqualToData: UIImagePNGRepresentation([UIImage imageNamed:@"like__filled"])])
    {
        st=@"false";
    }
    else
    {
        st=@"true";
    }
    
    selectedFeed=[postArr objectAtIndex:sender.tag];
    
    
    api_obj=[[APIViewController alloc]init];
    [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[selectedFeed objectForKey:@"postid"] :st];
    [LoaderViewController show:self.view animated:YES];
    
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

-(void)viewDidDisappear:(BOOL)animated
{
    self.mPlayer.volume=0.0;
    [self.mPlayer pause];
    [player pause];
    player.volume=0.0;
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    
    screencount=0;
    
    
}
-(void)playFullScreenVideo:(UIButton*)sender
{
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
    if(play == 1)
    {
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    player.volume=1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
    avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
    
    [player play];
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

    
    UIView *btnNext = [[UIView alloc]initWithFrame:self.view.frame];
    btnNext.backgroundColor=[UIColor clearColor];
    btnNext.userInteractionEnabled=true;
     btnNext.frame = self.view.frame;
    [fullView addSubview:btnNext];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [btnNext addGestureRecognizer:swipeDown];

    
    
    UIView *viewBack=[[UIView alloc]init];
    [viewBack setBackgroundColor:[UIColor whiteColor]];
    [viewBack setFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    [viewBack setAlpha:0.8];
    [fullView addSubview:viewBack];
    
    AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,8, 50, 50)];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.layer.cornerRadius=25;
    img.layer.masksToBounds = YES;
    [img.layer setMasksToBounds:YES];
    img.backgroundColor=[UIColor grayColor];
    img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[selectedFeed valueForKey:@"user_pic"]]];
    [viewBack addSubview:img];
    
    UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userProfileButton setTitle:@"" forState:UIControlStateNormal];
    userProfileButton.frame = CGRectMake(8,8, 50, 50);
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
    
    //CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, stringsize.width, 25);
    
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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(closeFullView1:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
    button.frame = CGRectMake(fullView.frame.size.width-60, 20, 60, 40.0);
    [fullView addSubview:button];
    
    
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
-(IBAction)Direct:(id)sender
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
        mvc=[[directViewController alloc]initWithNibName:@"directViewController@" bundle:nil];
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
-(IBAction)Likes:(id)sender
{
    NSMutableDictionary *dict=[postArr objectAtIndex:[sender tag]];
    
    
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
-(void)addDataOnScrollView
{
    for (UIView *subview in scrolv.subviews) {
        [subview removeFromSuperview];
    }
    
   // NSArray* reversedArray = [[postArr reverseObjectEnumerator] allObjects];
    //postArr=[reversedArray mutableCopy];
    int y=0;
    for(int i=0;i<postArr.count;i++)
    {
        NSMutableDictionary *dict=postArr[i];
        AsyncImageView *img;
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        {
            img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8, y+8, 60, 60)];
        }
        else
        {
            img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8, y+8+20, 60, 60)];
            
        }
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.cornerRadius=30;
        img.layer.masksToBounds = YES;
        [img.layer setMasksToBounds:YES];
        img.backgroundColor=[UIColor whiteColor];
        img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"user_pic"]]];
        [scrolv addSubview:img];
        
        
        
        
        
        UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [userProfileButton addTarget:self action:@selector(userprofileButton_action:) forControlEvents:UIControlEventTouchUpInside];
        userProfileButton.tag=i;
        [userProfileButton setTitle:@"" forState:UIControlStateNormal];
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""])
        {
            userProfileButton.frame = CGRectMake(8, y+8, 60, 60);
        }
        else
        {
            userProfileButton.frame = CGRectMake(8, y+8+20, 60, 60);
        }
        [scrolv addSubview:userProfileButton];
        
        
        
        
        
        if(![[dict valueForKey:@"action_text"] isEqual:[NSNull null]] && ![[dict valueForKey:@"action_text"] isEqualToString:@""] && ![[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        {
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:12];
            CGRect labelFrame = CGRectMake (0, y,self.view.frame.size.width, 20);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor grayColor];
            label.backgroundColor=[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
            [label setText:[NSString stringWithFormat:@"%@",[dict valueForKey:@"action_text"]]];
            [scrolv addSubview:label];
            
        }
        
        
        
        
        
        CGSize stringsize = [[NSString stringWithFormat:@"%@ ,",[dict valueForKey:@"username"]]sizeWithFont:[UIFont systemFontOfSize:15]];
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:17];
        CGRect labelFrame;
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        {
            labelFrame= CGRectMake (73, y+6, stringsize.width+20, 25);
        }
        else
        {
            labelFrame= CGRectMake (73, y+6+20, stringsize.width+20, 25);
        }
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor purpleColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"username"]]];
        [scrolv addSubview:label];
        
        
        CGRect labelFrameee;
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        {
            labelFrameee = CGRectMake (73+stringsize.width+5, y+8,self.view.frame.size.width-120-stringsize.width, 25);
        }
        else
        {
            labelFrameee = CGRectMake (73+stringsize.width+5, y+8+20,self.view.frame.size.width-120-stringsize.width, 25);
        }
        

        
        UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
        [location addTarget:self action:@selector(openNearByScreen:) forControlEvents:UIControlEventTouchUpInside];
        location.tag=i;
        location.frame =labelFrameee;
        location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        location.titleLabel.font=[UIFont fontWithName:@"Arial" size:13];
        [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        location.backgroundColor=[UIColor clearColor];
        [location setTitle:[dict valueForKey:@"location"] forState:UIControlStateNormal];
        [scrolv addSubview:location];
        
        
        
        UILabel *timelbl;
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        {
            timelbl = [[UILabel alloc] initWithFrame:CGRectMake (scrolv.frame.size.width-33, y+10, 40, 20)];
        }
        else
        {
            timelbl = [[UILabel alloc] initWithFrame:CGRectMake (scrolv.frame.size.width-30, y+10+20, 40, 20)];
        }
        [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
        timelbl.textColor=[UIColor purpleColor];
        timelbl.backgroundColor=[UIColor clearColor];
        NSString *st1= [AppDelegate HourCalculation:[dict valueForKey:@"time"]];
        [timelbl setText:st1];
        [scrolv addSubview:timelbl];
        
        
        
        
        
        UIFont * myFont1 ;
        myFont1 = [UIFont fontWithName:@"HelveticaNeue" size:12];
        NSString * myText =[[dict objectForKey:@"caption"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
        CGFloat constrainedSize1     = self.view.frame.size.width-90;
        CGSize textSize = [myText sizeWithFont: myFont1 constrainedToSize:CGSizeMake(constrainedSize1, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        //        CGSize constraintSize;
        //        constraintSize.height = MAXFLOAT;
        //        constraintSize.width = self.view.frame.size.width-90;
        //        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        //                                              [UIFont fontWithName:@"HelveticaNeue" size:12], NSFontAttributeName,
        //                                              nil];
        //        CGRect frame = [myText boundingRectWithSize:constraintSize
        //                                            options:NSStringDrawingUsesLineFragmentOrigin
        //                                         attributes:attributesDictionary
        //                                            context:nil];
        //
        //        CGSize stringSize = frame.size;
        //
        //        CGSize expectedLabelSize = [myText sizeWithFont:myFont1
        //                                          constrainedToSize:constraintSize
        //                                              lineBreakMode:NSLineBreakByWordWrapping];
        //
        //
        
        CGRect labelFrame1;
        labelFrame1= CGRectMake (73, location.frame.origin.y+location.frame.size.height, self.view.frame.size.width-85, textSize.height+30);
        
        
        
        
        
        
        STTweetLabel *labell = [[STTweetLabel alloc] initWithFrame:labelFrame1];
        labell.textColor=[UIColor grayColor];
        [labell setFont:myFont1];
        labell.lineBreakMode=NSLineBreakByWordWrapping;
        labell.numberOfLines=15;
        labell.backgroundColor=[UIColor clearColor];
        [labell setText:[dict valueForKey:@"caption"]];
        labell.detectionBlock = ^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
            
            selectedHashTag=[NSString stringWithFormat:@"%@%@", string, (protocol != nil) ? [NSString stringWithFormat:@" *%@*", protocol] : @""];
            if([selectedHashTag hasPrefix:@"@"])
            {
                
            }
            else
            {
                postOfHashTagView *mvc;
                if(iphone4)
                {
                    mvc=[[postOfHashTagView alloc]initWithNibName:@"postOfHashTagView@4" bundle:nil];
                }
                else if(iphone5)
                {
                    mvc=[[postOfHashTagView alloc]initWithNibName:@"postOfHashTagView" bundle:nil];
                }
                else if(iphone6)
                {
                    mvc=[[postOfHashTagView alloc]initWithNibName:@"postOfHashTagView@5" bundle:nil];
                }
                
                else if(iphone6p)
                {
                    mvc=[[postOfHashTagView alloc]initWithNibName:@"postOfHashTagView@6P" bundle:nil];
                }
                
                else
                {
                    mvc=[[postOfHashTagView alloc]initWithNibName:@"postOfHashTagView@ipad" bundle:nil];
                }
                [self.navigationController pushViewController:mvc animated:YES];
            }
            
        };
        
        [scrolv addSubview:labell];
        
        
        y=labell.frame.size.height+labell.frame.origin.y+10;

        
        
        UIButton *postDetailbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [postDetailbutton addTarget:self action:@selector(resharePost:) forControlEvents:UIControlEventTouchUpInside];
        postDetailbutton.tag=i;
        [postDetailbutton setTitle:@"" forState:UIControlStateNormal];
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""])
        {
            postDetailbutton.frame = CGRectMake(65, y+5, 320-65, textSize.height+15);
        }
        else
        {
            postDetailbutton.frame = CGRectMake(65, y+5+20, 320-65, textSize.height+15);
        }
        //[scrolv addSubview:postDetailbutton];
        
        y=labell.frame.size.height+labell.frame.origin.y+10;

        

        UIView *viewSep=[[UIView alloc]init];
        
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""])
        {
            [viewSep setFrame:CGRectMake(0,y+400,self.view.frame.size.width,1)];
        }
        else
        {
            [viewSep setFrame:CGRectMake(0,y+400+20,self.view.frame.size.width,1)];
            
        }
        [viewSep setAlpha:0.2];
        [viewSep setBackgroundColor:[UIColor lightGrayColor]];
        //[scrolv addSubview:viewSep];

        
        AsyncImageView *img1;
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        {
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.width)];
        }
        else
        {
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.width)];
        }

        img1.contentMode = UIViewContentModeScaleAspectFill;
        [img1.layer setMasksToBounds:YES];
        img1.backgroundColor=[UIColor whiteColor];
        // img1.imageURL=[NSURL fileURLWithPath:dataPathh];
        img1.tag=8000+i;
        img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
        [scrolv addSubview:img1];
        
        
        
        
        
        AVPlayerDemoPlaybackView *playerView;
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""])
        {
            playerView=[[AVPlayerDemoPlaybackView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.width)];
        }
        else
        {
            playerView=[[AVPlayerDemoPlaybackView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.width)];
        }
        playerView.tag=i+1;
        
    
        
        [scrolv addSubview:playerView];
        
        
        
        
        
        
        UIButton *fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullScreen addTarget:self action:@selector(playFullScreenVideo1:) forControlEvents:UIControlEventTouchUpInside];
        fullScreen.tag=i;
        fullScreen.backgroundColor=[UIColor clearColor];
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""])
        {
            fullScreen.frame = CGRectMake(0, y, self.view.frame.size.width-52, self.view.frame.size.width);
        }
        else
        {
            fullScreen.frame = CGRectMake(0, y+20, self.view.frame.size.width-52, self.view.frame.size.width);
            
        }
        [scrolv addSubview:fullScreen];
        
        
        
        if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""])
        {
            y=y+self.view.frame.size.width;
            
        }
        else
        {
            y=y+5+self.view.frame.size.width;
            
        }
        
    }
    
    
    if(y<self.view.frame.size.height)
        scrolv.contentSize=CGSizeMake(self.view.frame.size.width,self.view.frame.size.height +100);
    else
        scrolv.contentSize=CGSizeMake(self.view.frame.size.width, y+50);
    
    
    
    
    [LoaderViewController remove:self.view animated:YES];
    if(!fullView)
    {
        UITabBarController *bar = [self tabBarController];
        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
            //iOS 7 - hide by property
            NSLog(@"iOS 7");
            [self setExtendedLayoutIncludesOpaqueBars:YES];
            bar.tabBar.hidden = NO;
            
            
        }
    }
    
    
    if(postArr.count>0)
    {
        [self.mPlayer pause];
        int c=postArr.count-roundf((scrolv.contentSize.height-scrolv.contentOffset.y)/(scrolv.contentSize.height/postArr.count));
        AVPlayerDemoPlaybackView *v = (AVPlayerDemoPlaybackView *)[scrolv viewWithTag:c+1];
        
        
        
        NSMutableDictionary *dict1=postArr[c];
        selectedFeed=[dict1 mutableCopy];
        NSString *useridd = [dict1 valueForKey:@"userid"];
        NSString *str=[dict1 valueForKey:@"url"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            
            //cell.videoView.hidden=NO;
            NSArray* foo = [str componentsSeparatedByString: @"/"];
            NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:useridd]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self.mPlayer setVolume:0];
                if(play == 1)
                {
                self.mPlayer=[AVPlayer playerWithURL:[NSURL fileURLWithPath:dataPath]];
                
                [v setPlayer:self.mPlayer];
                [v setVideoFillMode:AVLayerVideoGravityResizeAspect];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:[self.mPlayer currentItem]];
                if(screencount==4)
                [self.mPlayer play];
                if([[dict1 valueForKey:@"filter"]integerValue]==0)
                {
                    self.mPlayer.rate=1.0;
                }
                if([[dict1 valueForKey:@"filter"]integerValue]==1 || [[dict1 valueForKey:@"filter"]integerValue]==320)
                {
                    self.mPlayer.rate=2.0;
                }
                if([[dict1 valueForKey:@"filter"]integerValue]==2)
                {
                    self.mPlayer.rate=0.5;
                }
            }
                
            });
            [self.mPlayer setVolume:0];
        });
        
        
    }
    
    
}
-(void)playFullScreenVideo1:(UIButton*)sender
{
    NSDictionary *dictTemp=postArr[sender.tag];
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
            selectedFeed=[postArr[sender.tag]mutableCopy];
            
            
            
            fullView=nil;
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
            
            UIView *btnNext = [[UIView alloc]initWithFrame:self.view.frame];
            btnNext.backgroundColor=[UIColor clearColor];
            btnNext.userInteractionEnabled=true;
            btnNext.frame = self.view.frame;
            [fullView addSubview:btnNext];
            UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
            [btnNext addGestureRecognizer:swipeDown];
            if(play == 1)
            {
            
            avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
            [player play];
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
            
            player.volume=1.0;
            
            
            
            
            
            
            
            
            
            
            
            
            UIView *viewBack=[[UIView alloc]init];
            [viewBack setBackgroundColor:[UIColor whiteColor]];
            [viewBack setFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
            [viewBack setAlpha:0.5];
            [fullView addSubview:viewBack];
            
            
            UILabel *timelbl;
            timelbl = [[UILabel alloc] initWithFrame:CGRectMake (viewBack.frame.size.width-30,10, 40, 20)];
            [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            timelbl.textColor=[UIColor purpleColor];
            timelbl.backgroundColor=[UIColor clearColor];
            NSString *st= [AppDelegate HourCalculation:[selectedFeed valueForKey:@"time"]];
            [timelbl setText:st];
            [viewBack addSubview:timelbl];
            
            
            
            AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(4,4, 50, 50)];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.layer.cornerRadius=25;
            img.layer.masksToBounds = YES;
            [img.layer setMasksToBounds:YES];
            img.backgroundColor=[UIColor grayColor];
            img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[selectedFeed valueForKey:@"user_pic"]]];
            [viewBack addSubview:img];
            
            UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [userProfileButton setTitle:@"" forState:UIControlStateNormal];
            userProfileButton.frame = CGRectMake(4,4, 50, 50);
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
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(closeFullView1:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
            button.frame = CGRectMake(fullView.frame.size.width-60, 20, 60, 40.0);
            [fullView addSubview:button];

            
            
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

-(void)openNearByScreen:(UIButton*)but
{
    
    [player pause];
    [filterView removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    player=nil;
    avPlayerLayer=nil;
    fullView=nil;
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

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    [player pause];
    [self.mPlayer pause];
    player.volume=0.0;
    self.mPlayer.volume=0.0;

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


@end