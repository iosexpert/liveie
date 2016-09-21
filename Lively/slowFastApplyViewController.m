//
//  slowFastApplyViewController.m
//  Lively
//
//  Created by Brahmasys on 15/03/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "slowFastApplyViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "uploadVideoViewController.h"
#import "withOrAgainstPostViewController.h"
@interface slowFastApplyViewController ()
{
    NSMutableArray *filterArr;
    UITextField *captionTextField;
    NSTimer *aTimer,*playvideoTimer ;
    AVPlayer *player;
    AVPlayerLayer *avPlayerLayer;
    int count;
    int startTime,endTime;
    NSTimer *tttt;
    
    NSTimer *tm;
    
}
@end

@implementation slowFastApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    screenName=@"upload";

    count=0;
    filterrArr=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"fastmo.png"],[UIImage imageNamed:@"slowmo.png"], nil];
    
    
   tm= [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(onTick:)
                                   userInfo:nil
                                    repeats:NO];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onTick:(NSTimer *)timer {
    
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:vPath] options:nil];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:player];
    avPlayerLayer.frame=CGRectMake(0, 0, videoView.frame.size.width,videoView.frame.size.height);
    [videoView.layer addSublayer:avPlayerLayer];
    videoView.userInteractionEnabled=false;
    avPlayerLayer.backgroundColor=[UIColor clearColor].CGColor;
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
    avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    [player play];
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    if(scrv.contentOffset.x==0)
    {
        player.rate=1.0;
    }
    if(scrv.contentOffset.x==self.view.frame.size.width)
    {
        player.rate=2.0;
    }
    if(scrv.contentOffset.x==self.view.frame.size.width*2)
    {
        player.rate=.5;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }
    [self addFiltersOnScroll];
}
-(void)addFiltersOnScroll
{
    int xx=scrv.frame.size.width;
    for(int i=0;i<filterrArr.count;i++)
    {
        
        UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake(xx, 0, scrv.frame.size.width, scrv.frame.size.height)];
        imgv.image=filterrArr[i];
        imgv.contentMode=UIViewContentModeScaleToFill;
        imgv.alpha=0.3;
        [scrv addSubview:imgv];
        xx=xx+scrv.frame.size.width;
        
    }
    scrv.contentSize=CGSizeMake(xx, scrv.frame.size.height);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrv.contentOffset.x==self.view.frame.size.width)
    {
        player.rate=2.0;
    }
    if(scrv.contentOffset.x==self.view.frame.size.width*2)
    {
        player.rate=.5;
    }
    if(scrv.contentOffset.x==0)
    {
        player.rate=1.0;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView
{
}
-(IBAction)backButton:(id)sender
{
    goUpload=0;
    [player pause];

    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)doneButton:(id)sender
{
    [player pause];
    [videoView removeFromSuperview];
    
    NSString *str =[NSString stringWithFormat:@"%d",(int)(scrv.contentOffset.x/self.view.frame.size.width)];
    vFilters = str;
    goUpload=1;
    if(shareOrReply==0)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        [self.navigationController popViewControllerAnimated:NO];
    }
//    if(shareOrReply==0)
//    {
//    uploadVideoViewController *mvc;
//    if(iphone4)
//    {
//        mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController@4" bundle:nil];
//    }
//    else if(iphone5)
//    {
//        mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController" bundle:nil];
//    }
//    else if(iphone6)
//    {
//        mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController@6" bundle:nil];
//    }
//    else if(iphone6p)
//    {
//        mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController@6p" bundle:nil];
//    }
//    else
//    {
//        mvc=[[uploadVideoViewController alloc]initWithNibName:@"uploadVideoViewController@ipad" bundle:nil];
//    }
//    [self.navigationController pushViewController:mvc animated:YES];
//    }
//    else
//    {
//        withOrAgainstPostViewController *mvc;
//        if(iphone4)
//        {
//            mvc=[[withOrAgainstPostViewController alloc]initWithNibName:@"withOrAgainstPostViewController@4" bundle:nil];
//        }
//        else if(iphone5)
//        {
//            mvc=[[withOrAgainstPostViewController alloc]initWithNibName:@"withOrAgainstPostViewController" bundle:nil];
//        }
//        else if(iphone6)
//        {
//            mvc=[[withOrAgainstPostViewController alloc]initWithNibName:@"withOrAgainstPostViewController@6" bundle:nil];
//        }
//        else if(iphone6p)
//        {
//            mvc=[[withOrAgainstPostViewController alloc]initWithNibName:@"withOrAgainstPostViewController@6p" bundle:nil];
//        }
//        else
//        {
//            mvc=[[withOrAgainstPostViewController alloc]initWithNibName:@"withOrAgainstPostViewController@ipad" bundle:nil];
//        }
//        [self.navigationController pushViewController:mvc animated:YES];
//    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [tm invalidate];
    [player pause];
}
@end
