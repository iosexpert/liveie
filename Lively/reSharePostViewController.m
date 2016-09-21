//
//  reSharePostViewController.m
//
//
//  Created by Brahmasys on 27/11/15.
//
//

#import "reSharePostViewController.h"


#import "AppDelegate.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "otheruserViewController.h"
#import "commentsOnFeedViewController.h"
#import "reSharePostViewController.h"
#import "postOfHashTagView.h"
#import "recordVideoViewController.h"
#import "directVideoViewController.h"
#import "likeViewController.h"
#import "getNearByViewController.h"
#import "editCommentViewController.h"
#import "AGPushNoteView.h"
#import "ReplyPostViewController.h"

@class AVPlayer;
@class AVPlayerDemoPlaybackView;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;

@interface reSharePostViewController ()
{
    int play;
    int cellToLoad;
    int options;
    APIViewController *api_obj;
    int apiCall;
    homeFeedsCell *cellToActivate;
    homeFeedsCell *cellToDeactivate;
    NSMutableDictionary *playableDict;
    NSTimer *videoCheckTimer;

    UIImageView *heartanimation;
    
    int selectbtn;
    
    UIView *fullView;
    AVPlayerLayer *avPlayerLayer;
    AVPlayer *player;
    UIImageView *filterView;
    int duration;
    int currentTime;
    NSArray *foooooo;
    NSTimer *aTimer ;
    NSMutableArray *filterArr;
    
    int currentplayingVideo;
    
    NSMutableArray *withPostArr,*againstPostArr,*imgArr,*storyArray;
    int with,playvideocount,counterCount;
    BOOL isScrolling;
    
    
    NSDictionary *videoPlayDict;
    
    int orignOfY;
    
    
    NSMutableArray *offsetArray;
    
    NSMutableArray *videoArray;
    
}

@property (readwrite, retain) AVPlayer* mPlayer;
@property (nonatomic, retain) VideoPlayerViewController *myPlayerViewController;

@end

@implementation reSharePostViewController


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
-(void)getPostData
{
    NSString *urls;
    apiCall=0;
    if([_strComment  isEqual: @"true"])
    {
        urls=[NSString stringWithFormat:@"%@/%@/%@/%@",userid,[selectedFeed objectForKey:@"parent_postid"],@"0",@"50"];

    }
    else
    {
    urls=[NSString stringWithFormat:@"%@/%@/%@/%@",userid,[selectedFeed objectForKey:@"postid"],@"0",@"50"];
    }
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetUserPostWithReply/%@",WEBURL1,urls];
    
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
            [LoaderViewController remove:self.view animated:YES];

            [self getWithAndagaistResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [LoaderViewController remove:self.view animated:YES];

        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getWithAndagaistResult:nil];
        
    }];

    [operation start];
  
}
- (void)viewDidLoad {
    

    [self createOptionPopUp];
    
    [super viewDidLoad];
    
    
    with=1;
    currentTime=0;
    
    cancelbtn.layer.cornerRadius=5.0;
    [LoaderViewController show:self.view animated:YES];
    [self getPostData];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if(goToPostAfterComment == 2)
    {
        goToPostAfterComment=0;
        selectedFeed1=[postAfterComment mutableCopy];
        [selectedFeed1 setValue:@"" forKey:@"parent_id"];
        
        
        ReplyPostViewController *mvc;
        if(iphone4)
        {
            mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }
    
    [self getPostData];

   
    screenName=@"post";
    screencount=3;
    
    if(withPostArr.count>0)
    pushback=0;
    
    selectbtn=0;
    
    
}


-(void)getWithAndagaistResult:(NSDictionary *)dict_Response
{
     play = 1;
    apiCall =1;
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {

        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];

    }
    else
    {
        if([[[dict_Response objectForKey:@"response"]valueForKey:@"status" ] integerValue]==200)
        {

            playableDict = [NSMutableDictionary new];
            withPostArr=[NSMutableArray new];
            withPostArr=[[dict_Response valueForKey:@"reply"]mutableCopy];
            //selectedFeed=[[dict_Response valueForKey:@"post"]mutableCopy];
            
            downloadVideoCount=(int)withPostArr.count;
            [self btnImagesClick:0];
            
            for(int i=0;i<withPostArr.count;i++)
            {
                NSDictionary *dict=[withPostArr[i] mutableCopy];
                if(![[dict valueForKey:@"post_type"]isEqualToString:@"comments"])
                {
                NSString *str=[withPostArr[i] valueForKey:@"url"];
                NSString *userid = [withPostArr[i] valueForKey:@"userid"];
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
                    [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",i]];
                    
                }
                else
                    [playableDict setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
                }
            }

            [tablev reloadData];
            [tablev setContentOffset:CGPointMake(0,tablev.contentOffset.y+0.1) animated:YES];

            
            videoArray=[NSMutableArray new];
            storyArray=[NSMutableArray new];
            
            for(int i=(int)withPostArr.count-1;i>=0;i--)
            {
                NSDictionary *dict=[withPostArr[i] mutableCopy];
                if(![[dict valueForKey:@"post_type"]isEqualToString:@"comments"])
                {
                    [storyArray addObject:dict];
                    [videoArray addObject:dict];
                    
                    
                }
            }
            
            
        }
    }
    CGPoint point = tablev.contentOffset;
    point.y = 0;
    tablev.contentOffset = point;
}

-(void)btnImagesClick:(UIButton*)sender
{
    
    downloadVideoCount=downloadVideoCount-1;
    if(downloadVideoCount>=0)
    {
        NSMutableDictionary *downloadVideoDict = [withPostArr objectAtIndex:downloadVideoCount];
        [self downloadstoryvideos:downloadVideoDict];
        
    }
}
//Download StoryVideos
-(void)downloadstoryvideos:(NSMutableDictionary*)dictTemp
{
    
    
    
    
    NSString *str=[dictTemp valueForKey:@"url"];
    if(str.length>0)
    {
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
        [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%lu",(unsigned long)[withPostArr indexOfObject:dictTemp]]];
            
            [self btnImagesClick:0];
            
        }
        else
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:dataPath append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%lu",(unsigned long)[withPostArr indexOfObject:dictTemp]]];
                [self btnImagesClick:0];
                NSLog(@"Successfully downloaded file to %@", dataPath);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self btnImagesClick:0];
            }];
            
            [operation start];
        }
        
    }
    else
    {
        
        
        [self btnImagesClick:0 ];
    }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back_Button:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userprofileButton_action:(UIButton*)sender
{
    
        friendID=[withPostArr[sender.tag] valueForKey:@"userid"];
    
    if([friendID isEqualToString:userid])
    {
        self.tabBarController.selectedIndex=4;
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

- (void)edit_action:(UIButton*)btn
{
    commentFeed=[[withPostArr objectAtIndex:btn.tag ] mutableCopy];
    
    if([[selectedFeed valueForKey:@"userid"] isEqualToString:userid] && [[commentFeed valueForKey:@"userid"]isEqualToString:userid])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit",@"Delete", nil];
        [sheet showInView:self.view];
        [sheet setTag:2];
    }
    else if([[selectedFeed valueForKey:@"userid"] isEqualToString:userid] && ![[commentFeed valueForKey:@"userid"]isEqualToString:userid])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
        [sheet showInView:self.view];
        [sheet setTag:3];
    }
    else if([[commentFeed valueForKey:@"userid"]isEqualToString:userid])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit",@"Delete", nil];
        [sheet showInView:self.view];
        [sheet setTag:4];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report Spam", nil];
        [sheet showInView:self.view];
        [sheet setTag:5];
    }
    
    
}

- (void)comment_action:(UIButton*)sender
{
    commentFeed=[[withPostArr objectAtIndex:sender.tag] mutableCopy];


    if([[commentFeed  valueForKey:@"post_type"] isEqualToString:@"reply"])
    {
        goToPostAfterComment=2;
        [commentFeed  setValue:@"000000000000000000000000" forKey:@"parent_id"];
        [commentFeed  setValue:@"public" forKey:@"post_type"];
        [commentFeed  setValue:@"" forKey:@"action_text"];

    }

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
    
}
-(void)reShareButton_action:(UIButton*)sender
{
    reply=@"1";
    pushback=0;
    selectedFeed1=[withPostArr objectAtIndex:sender.tag];
screen=@"post";
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
- (void)likeActionOfComments:(UIButton*)sender
{
    sender.imageView.frame = CGRectMake(sender.frame.origin.x+1, sender.frame.origin.y+1, sender.frame.size.width-2, sender.frame.size.height-2);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.imageView.frame = CGRectMake(sender.frame.origin.x-1, sender.frame.origin.y-1, sender.frame.size.width+2, sender.frame.size.height+2);
    [UIView commitAnimations];
    
    
    NSMutableDictionary *dict=withPostArr[sender.tag-7000];
    if([[dict valueForKey:@"like_status"]intValue]==1)
    {
       // st=@"false";
        [[withPostArr objectAtIndex:sender.tag-7000]setObject:@"0" forKey:@"like_status"];
        [sender setImage:[UIImage imageNamed:@"likeG"] forState:UIControlStateNormal];
        
        //;
    }
    else
    {
        //st=@"true";
        [[withPostArr objectAtIndex:sender.tag-7000]setObject:@"1" forKey:@"like_status"];
        [sender setImage:[UIImage imageNamed:@"like__filled"] forState:UIControlStateNormal];
        
    }
    
    api_obj=[[APIViewController alloc]init];
    [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[dict objectForKey:@"postid"] :st];
    
    
}
- (void)likeActionOfReply:(UIButton*)sender
{
    
    sender.imageView.frame = CGRectMake(sender.frame.origin.x+1, sender.frame.origin.y+1, sender.frame.size.width-2, sender.frame.size.height-2);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.imageView.frame = CGRectMake(sender.frame.origin.x-1, sender.frame.origin.y-1, sender.frame.size.width+2, sender.frame.size.height+2);
    [UIView commitAnimations];
    
    
    NSMutableDictionary *dict;
    
  
    dict=withPostArr[sender.tag-7000];
    if([[dict valueForKey:@"like_status"]intValue]==1)
    {
        st=@"false";
        
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        UIButton *v = (UIButton *)[tablev viewWithTag:6700+(sender.tag-7000)];
        [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]-1] forState:UIControlStateNormal];
      
        [[withPostArr objectAtIndex:sender.tag-7000] setValue:[NSNumber numberWithInt:0] forKey:@"like_status"];
        if([[v titleForState:UIControlStateNormal ]intValue]==0)
            [v setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        st=@"true";
      
        [[withPostArr objectAtIndex:sender.tag-7000] setValue:[NSNumber numberWithInt:1] forKey:@"like_status"];
        [sender setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateNormal];
        UIButton *v = (UIButton *)[tablev viewWithTag:6700+(sender.tag-7000)];
        [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]+1] forState:UIControlStateNormal];
        if([[v titleForState:UIControlStateNormal ]intValue]==0)
            [v setTitle:@"" forState:UIControlStateNormal];
    }
    api_obj=[[APIViewController alloc]init];
    [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[dict objectForKey:@"postid"] :st];
    
    
}
-(void)getlikeresult:(NSDictionary*)dict_Response
{
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];

    }
    
    else
    {
        if([[dict_Response  valueForKey:@"status"]integerValue]==200 )
        {
           // [likeCount setTitle:[NSString stringWithFormat:@"%d",[[dict_Response valueForKey:@"message"] intValue]] forState:UIControlStateNormal];
        }
        else
        {
            
        }
    }
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        if(fullView)
            bar.tabBar.hidden = YES;
        
        
    }
    
    
}

-(void)closeFullView:(UIButton*)btn
{

    [player pause];
    duration=0;
    currentTime=0;
    [filterView removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    player=nil;
    avPlayerLayer=nil;
    fullView=nil;
   
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellToLoad];
    [tablev scrollToRowAtIndexPath:indexPath
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
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if(play == 1)
    {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [cellToActivate.videoView.player seekToTime:kCMTimeZero];
    [cellToActivate.videoView.player play];
    
    NSMutableDictionary *dict;
  
   dict=withPostArr[currentplayingVideo];
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
    if(fullView==nil)
    {
        v = (UIButton *)[tablev viewWithTag:5600+currentplayingVideo];
        if([[v titleForState:UIControlStateNormal] isEqualToString:@"1K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"2K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"3K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"4K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"5K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"6K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"7K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"8K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"9K+"] || [[v titleForState:UIControlStateNormal] isEqualToString:@"10K+"])
        {
            
        }
        else
        {
            NSLog(@"%@",[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal]intValue]+1]);
            [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal]intValue]+1] forState:UIControlStateNormal];
        }
        api_obj=[[APIViewController alloc]init];
        [api_obj markviewresd:@selector(markviewresdResult:) tempTarget:self :[dict valueForKey:@"postid"]];
      
            [[withPostArr objectAtIndex:currentplayingVideo] setValue:[v titleForState:UIControlStateNormal] forKey:@"views"];
        
    }

    }
}

-(void)markviewresdResult:(NSDictionary*)dict_Response
{
}




- (void)playerItemDidReach:(NSNotification *)notification {
    if(play == 1)
    {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    if(screencount==3)
        [self.mPlayer play];
    
    if([[videoPlayDict valueForKey:@"filter"]integerValue]==0)
    {
        self.mPlayer.rate=1.0;
    }
    if([[videoPlayDict valueForKey:@"filter"]integerValue]==1 || [[videoPlayDict valueForKey:@"filter"]integerValue]==320)
    {
        self.mPlayer.rate=2.0;
    }
    if([[videoPlayDict valueForKey:@"filter"]integerValue]==2)
    {
        self.mPlayer.rate=0.5;
    }
    
    if([[videoPlayDict valueForKey:@"filter"]integerValue]==0)
    {
        player.rate=1.0;
    }
    if([[videoPlayDict valueForKey:@"filter"]integerValue]==1 || [[videoPlayDict valueForKey:@"filter"]integerValue]==320)
    {
        player.rate=2.0;
    }
    if([[videoPlayDict valueForKey:@"filter"]integerValue]==2)
    {
        player.rate=0.5;
    }
    
    
    
    UIButton *button = (UIButton *)[self.view viewWithTag:5600+counterCount];
    [button setTitle:[NSString stringWithFormat:@"%d",[[button titleForState:UIControlStateNormal]intValue]+1] forState:UIControlStateNormal];
    
    
    api_obj=[[APIViewController alloc]init];
    [api_obj markviewresd:@selector(markviewresdResult:) tempTarget:self :[videoPlayDict valueForKey:@"postid"]];
     [[withPostArr objectAtIndex:counterCount] setValue:[button titleForState:UIControlStateNormal] forKey:@"views"];
    }
    
}
-(void)Likes:(UIButton*)sender
{
    NSMutableDictionary *dict;
 
        dict=[withPostArr objectAtIndex:sender.tag-6700];

    
    
    
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



-(void)resharePost:(UIButton*)btn
{
    [self.mPlayer setVolume:0];
    selectedFeed=[withPostArr objectAtIndex:btn.tag];
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
//        selectedFeed=[videoPlayDict mutableCopy];
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
        
        selectedFeed=[videoPlayDict mutableCopy];;
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
        
        if([[videoPlayDict valueForKey:@"post_type"]isEqualToString:@"public"]||[[videoPlayDict valueForKey:@"post_type"]isEqualToString:@"reshare"])
        {
            selectedFeed=[videoPlayDict mutableCopy];
            
        }
        else
        {
            selectedFeed=[videoPlayDict mutableCopy];
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
        
      [tablev setContentOffset:CGPointMake(0,tablev.contentOffset.y+0.1) animated:YES];

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
    
    
    
    
    heartanimation=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40,self.view.frame.size.height/2-40, 80,80)];
    
    
    if([[videoPlayDict valueForKey:@"like_status"]boolValue])
    {
        st=@"false";
        heartanimation.image=[UIImage imageNamed:@"WhiteHeart.png"];
        api_obj=[[APIViewController alloc]init];
        [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[videoPlayDict objectForKey:@"postid"] :st];
    }
    else
    {
        st=@"true";
        heartanimation.image=[UIImage imageNamed:@"Heartshape.png"];
        api_obj=[[APIViewController alloc]init];
        [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[videoPlayDict objectForKey:@"postid"] :st];
        
        //[sender setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateNormal];
    }
    
    
    
    
    
    
    
    heartanimation.layer.zPosition=100;
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
    [self playerItemDidReachEndnext:0];
}

-(void)playFirstFullscreen:(UIButton*)sender
{
    [cellToActivate.videoView.player pause];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
    cellToActivate.videoView.player=nil;

    
    NSDictionary *dictTemp;
    
    dictTemp=storyArray[0];
    videoPlayDict=[dictTemp mutableCopy];
    cellToLoad=0;

    
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
            
            //selectedFeed=[withPostArr[sender.tag]mutableCopy];
            
            
            
            fullView=nil;
            fullView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            fullView.backgroundColor=[UIColor blackColor];
            
            
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
                                                     selector:@selector(playerItemDidReachEnddddddddd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[player currentItem]];
            
            
            avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
            if(play == 1)
            {
            [player play];
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==0)
            {
                player.rate=1.0;
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==1 || [[videoPlayDict valueForKey:@"filter"]integerValue]==320)
            {
                player.rate=2.0;
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==2)
            {
                player.rate=0.5;
            }
            
            
            [self.mPlayer setVolume:0];
            
            player.volume=1.0;
            
            
            
            UIView *btnNext = [[UIView alloc]initWithFrame:self.view.frame];
            btnNext.backgroundColor=[UIColor clearColor];
            btnNext.userInteractionEnabled=true;
            btnNext.tag=2345;
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
            
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleSingleTap:)];
            
            [singleTap requireGestureRecognizerToFail : doubleTap];
            [doubleTap setDelaysTouchesBegan : YES];
            [singleTap setDelaysTouchesBegan : YES];
            [doubleTap setNumberOfTapsRequired : 2];
            [singleTap setNumberOfTapsRequired : 1];
            [btnNext addGestureRecognizer : doubleTap];
            [btnNext addGestureRecognizer : singleTap];
            
            [fullView addSubview:btnNext];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(closeFullView:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
            ;
            button.frame = CGRectMake(fullView.frame.size.width-60, 20, 60, 40.0);
            [fullView addSubview:button];
            
            
            UIView *viewBack=[[UIView alloc]init];
            [viewBack setBackgroundColor:[UIColor whiteColor]];
            [viewBack setFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
            [viewBack setAlpha:0.8];
            
            
            AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,4, 50, 50)];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.layer.cornerRadius=25;
            img.layer.masksToBounds = YES;
            [img.layer setMasksToBounds:YES];
            img.backgroundColor=[UIColor grayColor];
            img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[videoPlayDict valueForKey:@"user_pic"]]];
            [viewBack addSubview:img];
            
            UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [userProfileButton setTitle:@"" forState:UIControlStateNormal];
            userProfileButton.frame = CGRectMake(8,4, 50, 50);
            [viewBack addSubview:userProfileButton];
            
            
            
            
            CGSize stringsize = [[NSString stringWithFormat:@"%@,",[videoPlayDict valueForKey:@"username"]]sizeWithFont:[UIFont systemFontOfSize:15]];
            
            
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
            CGRect labelFrame = CGRectMake (73, 5, stringsize.width+20, 25);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textColor=[UIColor purpleColor];
            
            label.backgroundColor=[UIColor clearColor];
            [label setText:[NSString stringWithFormat:@"%@,",[videoPlayDict valueForKey:@"username"]]];
            [viewBack addSubview:label];
            
            UILabel *timelbl;
            timelbl = [[UILabel alloc] initWithFrame:CGRectMake (viewBack.frame.size.width-30,10, 40, 20)];
            [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            timelbl.textColor=[UIColor purpleColor];
            timelbl.backgroundColor=[UIColor clearColor];
            NSString *stt= [AppDelegate HourCalculation:[videoPlayDict valueForKey:@"time"]];
            [timelbl setText:stt];
            [viewBack addSubview:timelbl];
            
            CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, self.view.frame.size.width-120-stringsize.width, 25);            UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
            [location addTarget:self action:@selector(openNearByScreenn:) forControlEvents:UIControlEventTouchUpInside];
            location.tag=0;
            location.frame =labelFrameee;
            location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            location.titleLabel.font=[UIFont fontWithName:@"Arial" size:13];
            [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            location.backgroundColor=[UIColor clearColor];
            [location setTitle:[videoPlayDict valueForKey:@"location"] forState:UIControlStateNormal];
            [viewBack addSubview:location];
            
    
            
            
            UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:13];
            CGRect labelFrame1 = CGRectMake (73,25, 250, 35);
            STTweetLabel *labell = [[STTweetLabel alloc] initWithFrame:labelFrame1];
            [labell setFont:myFont1];
            label.numberOfLines=2;
            labell.lineBreakMode=NSLineBreakByWordWrapping;
            labell.textColor=[UIColor grayColor];
            labell.backgroundColor=[UIColor clearColor];
            [labell setText:[videoPlayDict valueForKey:@"caption"]];
            
            
            [viewBack addSubview:labell];
            [fullView addSubview:viewBack];
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
- (void)playerItemDidReachEnddddddddd:(NSNotification *)notification {
    if(storyArray.count==1)
        [self playFirstFullscreen:0];
    else
        [self playerItemDidReachEndnext:0];
}
-(void)playvideoInFullScreen:(UIButton*)btn
{
    [cellToActivate.videoView.player pause];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
    cellToActivate.videoView.player=nil;

    
    NSDictionary *dictTemp;
    NSDictionary *dict=withPostArr[btn.tag];
    cellToLoad=(int)btn.tag;

    videoPlayDict=[dict mutableCopy];
    for(int i=0;i<storyArray.count;i++)
    {
        NSDictionary *dictt=storyArray[i];
        if([[dict valueForKey:@"postid"]isEqualToString:[dictt valueForKey:@"postid"]])
        {
            dictTemp=[dictt mutableCopy];
            playvideocount=i;
        }
    }
    
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
            
            //selectedFeed=[withPostArr[sender.tag]mutableCopy];
            
            
            
            fullView=nil;
            fullView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            fullView.backgroundColor=[UIColor blackColor];
            
            
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
                                                     selector:@selector(playerItemDidReachEndnext:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[player currentItem]];
            
            
            avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
            if(play == 1)
            {
            [player play];
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==0)
            {
                player.rate=1.0;
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==1 || [[videoPlayDict valueForKey:@"filter"]integerValue]==320)
            {
                player.rate=2.0;
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==2)
            {
                player.rate=0.5;
            }
            
            [self.mPlayer setVolume:0];
            
            player.volume=1.0;
            
            
            
            UIView *btnNext = [[UIView alloc]initWithFrame:self.view.frame];
            btnNext.backgroundColor=[UIColor clearColor];
            btnNext.userInteractionEnabled=true;
            btnNext.tag=playvideocount;
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
            
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleSingleTap:)];
            
            [singleTap requireGestureRecognizerToFail : doubleTap];
            [doubleTap setDelaysTouchesBegan : YES];
            [singleTap setDelaysTouchesBegan : YES];
            [doubleTap setNumberOfTapsRequired : 2];
            [singleTap setNumberOfTapsRequired : 1];
            [btnNext addGestureRecognizer : doubleTap];
            [btnNext addGestureRecognizer : singleTap];
            
            [fullView addSubview:btnNext];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(closeFullView:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
            
            button.frame = CGRectMake(fullView.frame.size.width-60, 20, 60, 40.0);
            [fullView addSubview:button];
            
            
            UIView *viewBack=[[UIView alloc]init];
            [viewBack setBackgroundColor:[UIColor whiteColor]];
            [viewBack setFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
            [viewBack setAlpha:0.8];
            [fullView addSubview:viewBack];
            
            UILabel *timelbl;
            timelbl = [[UILabel alloc] initWithFrame:CGRectMake (viewBack.frame.size.width-30,10, 40, 20)];
            [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            timelbl.textColor=[UIColor purpleColor];
            timelbl.backgroundColor=[UIColor clearColor];
            NSString *stt= [AppDelegate HourCalculation:[videoPlayDict valueForKey:@"time"]];
            [timelbl setText:stt];
            [viewBack addSubview:timelbl];
            
            AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,4, 50, 50)];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.layer.cornerRadius=25;
            img.layer.masksToBounds = YES;
            [img.layer setMasksToBounds:YES];
            img.backgroundColor=[UIColor grayColor];
            img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[videoPlayDict valueForKey:@"user_pic"]]];
            [viewBack addSubview:img];
            
            UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [userProfileButton setTitle:@"" forState:UIControlStateNormal];
            userProfileButton.frame = CGRectMake(8,8, 50, 50);
            [viewBack addSubview:userProfileButton];
            
            
            
            
            CGSize stringsize = [[NSString stringWithFormat:@"%@,",[videoPlayDict valueForKey:@"username"]]sizeWithFont:[UIFont systemFontOfSize:15]];
            
            
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
            CGRect labelFrame = CGRectMake (73, 5, stringsize.width+20, 25);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textColor=[UIColor purpleColor];
            
            label.backgroundColor=[UIColor clearColor];
            [label setText:[NSString stringWithFormat:@"%@,",[videoPlayDict valueForKey:@"username"]]];
            [viewBack addSubview:label];
            
            
            
            CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, self.view.frame.size.width-120-stringsize.width, 25);            UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
            [location addTarget:self action:@selector(openNearByScreenFromFullScreen:) forControlEvents:UIControlEventTouchUpInside];
            location.frame =labelFrameee;
            location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            location.titleLabel.font=[UIFont fontWithName:@"Arial" size:13];
            [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            location.backgroundColor=[UIColor clearColor];
            [location setTitle:[videoPlayDict valueForKey:@"location"] forState:UIControlStateNormal];
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
            [labell setText:[videoPlayDict valueForKey:@"caption"]];
            
            
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
    }
    
}
-(void)playerItemDidReachEndnext:(UIButton*)sender
{
    playvideocount++;
    
    if(playvideocount>=storyArray.count)
        playvideocount=0;
    
    NSDictionary *dictTemp=storyArray[playvideocount];
    videoPlayDict=[dictTemp mutableCopy];
    
    
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
            
            //selectedFeed=[withPostArr[sender.tag]mutableCopy];
            
            
            
            fullView=nil;
            fullView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            fullView.backgroundColor=[UIColor blackColor];
            
            
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
                                                     selector:@selector(playerItemDidReachEndnext:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[player currentItem]];
            
            
            avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
            if(play == 1)
            {
            [player play];
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==0)
            {
                player.rate=1.0;
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==1 || [[videoPlayDict valueForKey:@"filter"]integerValue]==320)
            {
                player.rate=2.0;
            }
            if([[videoPlayDict valueForKey:@"filter"]integerValue]==2)
            {
                player.rate=0.5;
            }
            
            [self.mPlayer setVolume:0];
            
            player.volume=1.0;
            
            
            
            UIView *btnNext = [[UIView alloc]initWithFrame:self.view.frame];
            btnNext.backgroundColor=[UIColor clearColor];
            btnNext.userInteractionEnabled=true;
            btnNext.tag=playvideocount;
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
            
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleSingleTap:)];
            
            [singleTap requireGestureRecognizerToFail : doubleTap];
            [doubleTap setDelaysTouchesBegan : YES];
            [singleTap setDelaysTouchesBegan : YES];
            [doubleTap setNumberOfTapsRequired : 2];
            [singleTap setNumberOfTapsRequired : 1];
            [btnNext addGestureRecognizer : doubleTap];
            [btnNext addGestureRecognizer : singleTap];
            
            [fullView addSubview:btnNext];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(closeFullView:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
            
            button.frame = CGRectMake(fullView.frame.size.width-60, 20, 60, 40.0);
            [fullView addSubview:button];
            
            
            UIView *viewBack=[[UIView alloc]init];
            [viewBack setBackgroundColor:[UIColor whiteColor]];
            [viewBack setFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
            [viewBack setAlpha:0.8];
            [fullView addSubview:viewBack];
            
            UILabel *timelbl;
            timelbl = [[UILabel alloc] initWithFrame:CGRectMake (viewBack.frame.size.width-30,10, 40, 20)];
            [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
            timelbl.textColor=[UIColor purpleColor];
            timelbl.backgroundColor=[UIColor clearColor];
            NSString *stt= [AppDelegate HourCalculation:[videoPlayDict valueForKey:@"time"]];
            [timelbl setText:stt];
            [viewBack addSubview:timelbl];
            
            
            AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,8, 50, 50)];
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.layer.cornerRadius=25;
            img.layer.masksToBounds = YES;
            [img.layer setMasksToBounds:YES];
            img.backgroundColor=[UIColor grayColor];
            img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[videoPlayDict valueForKey:@"user_pic"]]];
            [viewBack addSubview:img];
            
            UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [userProfileButton setTitle:@"" forState:UIControlStateNormal];
            userProfileButton.frame = CGRectMake(8,2, 50, 50);
            [viewBack addSubview:userProfileButton];
            
            
            
            
            CGSize stringsize = [[NSString stringWithFormat:@"%@,",[videoPlayDict valueForKey:@"username"]]sizeWithFont:[UIFont systemFontOfSize:15]];
            
            
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
            CGRect labelFrame = CGRectMake (73, 5, stringsize.width+20, 25);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textColor=[UIColor purpleColor];
            
            label.backgroundColor=[UIColor clearColor];
            [label setText:[NSString stringWithFormat:@"%@,",[videoPlayDict valueForKey:@"username"]]];
            [viewBack addSubview:label];
            
            
            
            CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, self.view.frame.size.width-120-stringsize.width, 25);            UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
            [location addTarget:self action:@selector(openNearByScreenFromFullScreen:) forControlEvents:UIControlEventTouchUpInside];
            location.tag=playvideocount;
            location.frame =labelFrameee;
            location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            location.titleLabel.font=[UIFont fontWithName:@"Arial" size:13];
            [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            location.backgroundColor=[UIColor clearColor];
            [location setTitle:[videoPlayDict valueForKey:@"location"] forState:UIControlStateNormal];
            [viewBack addSubview:location];

            
            
            UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:13];
            CGRect labelFrame1 = CGRectMake (73,25, 250, 35);
            STTweetLabel *labell = [[STTweetLabel alloc] initWithFrame:labelFrame1];
            [labell setFont:myFont1];
            label.numberOfLines=2;
            labell.lineBreakMode=NSLineBreakByWordWrapping;
            labell.textColor=[UIColor grayColor];
            labell.backgroundColor=[UIColor clearColor];
            [labell setText:[videoPlayDict valueForKey:@"caption"]];
            
            
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
    
    NSMutableDictionary *dict=[withPostArr[but.tag] mutableCopy];
    
    mvc.strTop=[NSString stringWithFormat:@"%f/%f",[[dict valueForKey:@"points"][0]floatValue],[[dict valueForKey:@"points"][1]floatValue]];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)openNearByScreen1:(UIButton*)but
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
    NSMutableDictionary *dict=[videoPlayDict mutableCopy] ;
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
#pragma mark Options
- (void)Options:(UIButton*)sender
{
    selectbtn=(int)sender.tag;
    NSDictionary *dict;
    dict=[withPostArr objectAtIndex:sender.tag];
    if([[dict valueForKey:@"post_follow_status"] boolValue] == 0)
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

-(void)Report:(UIButton*)sender
{
   
        NSDictionary *dict;
    
            dict=[withPostArr objectAtIndex:selectbtn];
        
        api_obj=[[APIViewController alloc]init];
        [api_obj ReportSpamPost:@selector(ReportSpamPostResult:) tempTarget:self :[dict valueForKey:@"postid"]];
    
}
-(void)ReportSpamPostResult:(NSMutableDictionary*)dict
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"ReportSpamPostResult :%@",dict);
    [self viewWillAppear:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Successfully reported as Spam" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,790, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];;
    viewOptions1.tag=0;
    [UIView commitAnimations];
    
}
-(void)ReShare:(UIButton*)sender
{
            NSDictionary *dict;
   
            dict=[withPostArr objectAtIndex:selectbtn];
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
    
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,790, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];;
    viewOptions1.tag=0;
    [UIView commitAnimations];
}
-(void)copyLink:(UIButton*)sender
{
  
        NSDictionary *dict;
    
            dict=[withPostArr objectAtIndex:selectbtn];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"link copied" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,790, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];;
    viewOptions1.tag=0;
    [UIView commitAnimations];
    
}
-(void)shareDirectLink:(UIButton*)sender
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
        NSMutableDictionary *dict;
   
            dict=[withPostArr objectAtIndex:selectbtn];
        
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
-(void)shareLink:(UIButton*)sender
{
    
        NSMutableDictionary *dict;//=[postArr objectAtIndex:indexOptions];
    
            dict=[withPostArr objectAtIndex:selectbtn];
        NSURL *textToShare =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]]];
        
        
        NSString *Text=@"LIVELY";
        
        NSArray *itemsToShare = @[Text,textToShare,];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = nil ;//or whichever you don't need
        [self presentViewController:activityVC animated:YES completion:nil];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,790, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];;
    viewOptions1.tag=0;
    [UIView commitAnimations];
}
-(void)HidePost:(id)sender
{
    
        NSMutableDictionary *dict;//=[postArr objectAtIndex:indexOptions];
    
            dict=[withPostArr objectAtIndex:selectbtn];
        api_obj=[[APIViewController alloc]init];
        [api_obj HidePost:@selector(HidePostResult:) tempTarget:self :[dict valueForKey:@"postid"]];
    
}
-(void)HidePostResult:(NSMutableDictionary*)dict
{
    [videoCheckTimer invalidate];
    NSLog(@"HidePostResult :%@",dict);
    [self viewWillAppear:YES];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,790, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];;
    viewOptions1.tag=0;
    [UIView commitAnimations];
}
-(void)cancelClick:(id)sender
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions1 setFrame:CGRectMake(viewOptions1.frame.origin.x,790, viewOptions1.frame.size.width, viewOptions1.frame.size.height)];;
    viewOptions1.tag=0;
    [UIView commitAnimations];
    
    
}

-(void)followPost:(id)sender
{
    if(options==1)
    {
        NSMutableDictionary *dict=[withPostArr objectAtIndex:selectbtn];
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
        NSMutableDictionary *dict=[withPostArr objectAtIndex:selectbtn];
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
    [self getPostData];

    
}
#pragma mark Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    if (actionSheet.tag == 2){
        if (buttonIndex==0) {//edit
            
            editCommentViewController *mvc;
            if(iphone4)
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController@6p" bundle:nil];
            }
            else
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController@ipad" bundle:nil];
            }
            [self presentViewController:mvc animated:YES completion:nil];
        }
        else if (buttonIndex==1) {//delete
            [LoaderViewController show:self.view animated:YES];
            
            NSString *urlString=[NSString stringWithFormat:@"%@/DeletePostComment/%@/%@",WEBURL1,userid,[commentFeed valueForKey:@"postid"]];
            
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
                    
                    [self getDeleteResult:JSON];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error: %@",  operation.responseString);
                
                NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
                
                if (errStr==Nil) {
                    errStr=@"Server not reachable";
                }
                
                [self getDeleteResult:nil];
                
            }];
            
            [operation start];
            
        }
        
        
    }
    else if (actionSheet.tag == 3){
        if (buttonIndex==0) {//delete
            
            [LoaderViewController show:self.view animated:YES];
            
            NSString *urlString=[NSString stringWithFormat:@"%@/DeletePostComment/%@/%@",WEBURL1,userid,[commentFeed valueForKey:@"postid"]];
            
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
                    
                    [self getDeleteResult:JSON];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error: %@",  operation.responseString);
                
                NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
                
                if (errStr==Nil) {
                    errStr=@"Server not reachable";
                }
                
                [self getDeleteResult:nil];
                
            }];
            
            [operation start];
            
        }
        
        
    }
    else if (actionSheet.tag == 4){
        if (buttonIndex==0) {//edit
            editCommentViewController *mvc;
            if(iphone4)
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController@6p" bundle:nil];
            }
            else
            {
                mvc=[[editCommentViewController alloc]initWithNibName:@"editCommentViewController@ipad" bundle:nil];
            }
            [self presentViewController:mvc animated:YES completion:nil];
            
        }
        else if (buttonIndex==1) {//delete
            
            [LoaderViewController show:self.view animated:YES];
            
            NSString *urlString=[NSString stringWithFormat:@"%@/DeletePostComment/%@/%@",WEBURL1,userid,[commentFeed valueForKey:@"postid"]];
            
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
                    
                    [self getDeleteResult:JSON];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error: %@",  operation.responseString);
                
                NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
                
                if (errStr==Nil) {
                    errStr=@"Server not reachable";
                }
                
                [self getDeleteResult:nil];
                
            }];
            
            [operation start];
            
        }
        
        
        
        
    }
    else if (actionSheet.tag == 5){
        if (buttonIndex==0) {//spam
            
            [LoaderViewController show:self.view animated:YES];
            
            api_obj=[[APIViewController alloc]init];
            [api_obj ReportSpamPost:@selector(ReportSpamPostResult:) tempTarget:self :[commentFeed valueForKey:@"postid"]];
        }
        
        
        
    }
    
}

-(void)getDeleteResult:(NSDictionary*)dict
{
    [LoaderViewController remove:self.view animated:YES];

    NSString *urls=[NSString stringWithFormat:@"%@/%@/%@/%@",userid,[selectedFeed objectForKey:@"postid"],@"0",@"50"];
    
    api_obj=[[APIViewController alloc]init];
    [api_obj getWithAndagaist:@selector(getWithAndagaistResult:) tempTarget:self :urls];
    
}
#pragma mark Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return withPostArr.count+1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==withPostArr.count)
    {
        return 0;
    }
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,80)];
    
    if(section == withPostArr.count)
    {
        
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:12];
            CGRect labelFrame = CGRectMake (0, 40,self.view.frame.size.width, 20);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor grayColor];
            label.backgroundColor=[UIColor clearColor];
            [label setText:[NSString stringWithFormat:@"%@",@"No More Comments or Reply"]];
            [view addSubview:label];
        
        
    }
    else
    {
    NSMutableDictionary *dict;

        dict=[withPostArr[section] mutableCopy];

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


    
    
    [view setBackgroundColor:[UIColor whiteColor]];
    }//your background color...
    return view;
}
-(void)postdetailaction:(UIButton*)btn
{
    [self.mPlayer setVolume:0];
    if([[[withPostArr objectAtIndex:btn.tag]valueForKey:@"post_type"]isEqualToString:@"public"]||[[[withPostArr objectAtIndex:btn.tag]valueForKey:@"post_type"]isEqualToString:@"reply"])
    {
        selectedFeed1=[withPostArr objectAtIndex:btn.tag];
        [selectedFeed1 setValue:@"" forKey:@"parent_id"];
    
  
    ReplyPostViewController *mvc;
    if(iphone4)
    {
        mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[ReplyPostViewController alloc]initWithNibName:@"ReplyPostViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
    
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==withPostArr.count)
    {
        return 100;
        
    }
    int h=0;
    
    NSMutableDictionary *dict;
  
        dict=[withPostArr[section] mutableCopy];
    
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
    if(section==0 || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        return 0;
    else
    return 50+requiredHeight.size.height+h+z;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,80)];
    NSMutableDictionary *dict;
  
        dict=[withPostArr[section] mutableCopy];

    
    AsyncImageView *img;
    if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        img=[[AsyncImageView alloc]initWithFrame:CGRectMake(4,4, 50, 50)];
    }
    else
    {
        img=[[AsyncImageView alloc]initWithFrame:CGRectMake(4,24, 50, 50)];
        
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
        userProfileButton.frame = CGRectMake(4,24, 50, 50);
    }
    [view addSubview:userProfileButton];
    
    
        
    
    UIFont * myFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
    CGRect labelFrame;
      labelFrame= CGRectMake (65,4, self.view.frame.size.width, 20);
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
    int z=0;
    if(requiredHeight1.size.height<14)
        z=15;
    else
        z=26;
    
    CGRect labelFrameee;
    if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""])
    {
        labelFrameee = CGRectMake (65,22,self.view.frame.size.width-74, z);
    }
    else
    {
        labelFrameee = CGRectMake (65,42,self.view.frame.size.width-74, z);
    }
    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
    location.tag=section;
    location.frame =labelFrameee;
    location.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    location.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    location.backgroundColor=[UIColor clearColor];
    location.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [location setTitle:[dict valueForKey:@"location"] forState:UIControlStateNormal];
    if(![[dict valueForKey:@"location"] isEqualToString:@""])
    {
        [location addTarget:self action:@selector(openNearByScreenn:) forControlEvents:UIControlEventTouchUpInside];
    }
    [view addSubview:location];
    
    
    
    UILabel *timelbl;
    if([[dict valueForKey:@"action_text"] isEqual:[NSNull null]] || [[dict valueForKey:@"action_text"] isEqualToString:@""] || [[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        timelbl = [[UILabel alloc] initWithFrame:CGRectMake (self.view.frame.size.width-30,4, 30, 20)];
    }
    else
    {
        timelbl = [[UILabel alloc] initWithFrame:CGRectMake (self.view.frame.size.width-30, 4+20, 30, 20)];
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
    labelFrame1= CGRectMake (65, location.frame.origin.y+location.frame.size.height+3, self.view.frame.size.width-70, requiredHeight.size.height+2);
    STTweetLabel *labell = [[STTweetLabel alloc] initWithFrame:labelFrame1];
    labell.textColor=[UIColor grayColor];
    [labell setFont:myFont1];
    labell.lineBreakMode=NSLineBreakByWordWrapping;
    labell.numberOfLines=15;
    labell.backgroundColor=[UIColor clearColor];
    [labell setText:[dict valueForKey:@"caption"]];
    
    [view addSubview:labell];
    
    
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
                mvc=[[postOfHashTagView alloc]initWithNibName:@"postOfHashTagView@6" bundle:nil];
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
    
    
    
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section== withPostArr.count)
        return 0;
    int h=0;
    NSMutableDictionary *dict;
  
        dict=[withPostArr[section] mutableCopy];

    UIFont * myFont1 ;
    myFont1 = [UIFont fontWithName:@"HelveticaNeue" size:12];
    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-70  , 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: myFont1, NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"caption"] attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    
    
    if(section==0)
        return 50+requiredHeight.size.height+h+5;
    else
        return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    
    NSMutableDictionary *dict;
  
        dict=[withPostArr[indexPath.section] mutableCopy];
    
    if([[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        static NSString *simpleTableIdentifier = @"Fish";
        cell = (commentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if(iphone6)
                nib = [[NSBundle mainBundle] loadNibNamed:@"commentTableViewCell@6" owner:self options:nil];
            else if(iphone6p)
                nib = [[NSBundle mainBundle] loadNibNamed:@"commentTableViewCell@6p" owner:self options:nil];
            else if(iphone5||iphone4)
                nib = [[NSBundle mainBundle] loadNibNamed:@"commentTableViewCell" owner:self options:nil];
            
            cell = [nib objectAtIndex:0];
        }
        
        
        cell.profileImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"user_pic"]]];
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
        cell.profileImage.clipsToBounds =YES;
        
        NSString *st1= [AppDelegate HourCalculation:[dict valueForKey:@"time"]];
        cell.time.text=st1;
        
        [cell.userprofileButton addTarget:self action:@selector(userprofileButton_action:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.profiledescription.text=[dict valueForKey:@"caption"];
        
        cell.name.text=[dict valueForKey:@"username"];
        cell.likeButton.tag=7000+indexPath.section;
        if([[dict valueForKey:@"like_status"]boolValue])
            [cell.likeButton setImage:[UIImage imageNamed:@"like__filled"] forState:UIControlStateNormal];
        else
            [cell.likeButton setImage:[UIImage imageNamed:@"likeG"] forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeActionOfComments:)forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.commentButton addTarget:self action:@selector(comment_action:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentButton.tag=indexPath.section;
        
        [cell.optionButton addTarget:self action:@selector(edit_action:) forControlEvents:UIControlEventTouchUpInside];
        cell.optionButton.tag=indexPath.section;
        
        [cell.userprofileButton addTarget:self action:@selector(userprofileButton_action:) forControlEvents:UIControlEventTouchUpInside];
        cell.userprofileButton.tag=indexPath.section;
        
        
        
        
        UIView *viewSep=[[UIView alloc]init];
        [viewSep setFrame:CGRectMake(0,0,self.view.frame.size.width,1)];
        [viewSep setAlpha:0.2];
        [viewSep setBackgroundColor:[UIColor lightGrayColor]];
        [cell addSubview:viewSep];
        cell.tag=indexPath.section;
        return  cell;
    }
    else
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
        
        celll.activity.hidden=YES;
        
        celll.videoView.tag=5000+indexPath.section;
        
        
        celll.videoImage.contentMode = UIViewContentModeScaleAspectFill;
        [celll.videoImage.layer setMasksToBounds:YES];
        celll.videoImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
        
        
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

        
        celll.profiledescription.detectionBlock = ^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
            
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
                    mvc=[[postOfHashTagView alloc]initWithNibName:@"postOfHashTagView@6" bundle:nil];
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
        
        
    
        [celll.likeCountBtn setTitle:[NSString stringWithFormat:@"%@",[dict valueForKey:@"likes"]] forState:UIControlStateNormal];
        celll.likeCountBtn.tag=6700+indexPath.section;
        [celll.likeCountBtn addTarget:self action:@selector(Likes:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [celll.likeButton addTarget:self action:@selector(likeActionOfReply:) forControlEvents:UIControlEventTouchUpInside];
        celll.likeButton.tag=indexPath.section+7000;
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
        
        
        celll.viewLabel.tag=5600+indexPath.section;
        [celll.viewLabel setTitle:[NSString stringWithFormat:@"%d",[[dict valueForKey:@"views"]intValue] ] forState:UIControlStateNormal];
        
        
        
        [celll.replyCountButton setTitle:[NSString stringWithFormat:@"%d",[[dict valueForKey:@"reply_count"]intValue] ] forState:UIControlStateNormal];
        
        
        
        
        
        [celll.replyButton addTarget:self action:@selector(reShareButton_action:) forControlEvents:UIControlEventTouchUpInside];
        celll.replyButton.tag=indexPath.section;
        
        
        [celll.optionBtn addTarget:self action:@selector(Options:) forControlEvents:UIControlEventTouchUpInside];
        celll.optionBtn.tag=indexPath.section;
        
        
        
        UIButton *fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    
            [fullScreen addTarget:self action:@selector(playvideoInFullScreen:) forControlEvents:UIControlEventTouchUpInside];
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
        
        
        UIView *viewSep=[[UIView alloc]init];
        [viewSep setFrame:CGRectMake(0,0,self.view.frame.size.width,1)];
        [viewSep setAlpha:0.2];
        [viewSep setBackgroundColor:[UIColor lightGrayColor]];
        [celll addSubview:viewSep];
        celll.tag=indexPath.section;
        

        return celll;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict;
 
        dict=[withPostArr[indexPath.section] mutableCopy];
    
    
   
        
    int h;
    if(iphone5||iphone4)
        h=320;
    else if(iphone6)
        h=375;
    else
        h=414;
    
    if([[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        h=98;
        CGSize constrainedSize = CGSizeMake(cell.profiledescription.frame.size.width  , 9999);
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: cell.profiledescription.font, NSFontAttributeName,nil];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"caption"] attributes:attributesDictionary];
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        if(requiredHeight.size.height>30)
            h=h+requiredHeight.size.height-10;
      
    }
    return h;

}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
        NSArray *visibleCells = [tablev visibleCells];
        
        for (UITableView *cell in visibleCells) {
            if (!cellToActivate) {
                cellToActivate = (homeFeedsCell *)cell;
            } else {
                // cellToActive is always the top most cell
                homeFeedsCell *cell1 = cellToActivate;
                NSIndexPath *cell1_indexPath = [tablev indexPathForCell:cell1];
                CGRect cell1_frame = [tablev cellForRowAtIndexPath:cell1_indexPath].frame;
                
                homeFeedsCell *cell2 = (homeFeedsCell *)cell;
                NSIndexPath *cell2_indexPath = [tablev indexPathForCell:cell2];
                CGRect cell2_frame = [tablev cellForRowAtIndexPath:cell2_indexPath].frame;
                
                // Cell frames in controller frames
                CGRect cell1_frameInSuperview = [tablev convertRect:cell1_frame toView:[tablev superview]];
                CGRect cell2_frameInSuperview = [tablev convertRect:cell2_frame toView:[tablev superview]];
                
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
        NSDictionary *dict;
    
            currentplayingVideo=(int)cellToActivate.tag-5000;
    cellToLoad=currentplayingVideo;

            dict=[withPostArr[cellToActivate.tag] mutableCopy];
    
        if([[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        {
            [cellToDeactivate.videoView.player pause];
            cellToDeactivate.videoView.player=nil;
        }
        else
        {
            currentplayingVideo=(int)cellToActivate.videoView.tag-5000;
            cellToLoad=currentplayingVideo;

            if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
            {
                
                
                NSMutableDictionary *dict=[withPostArr[currentplayingVideo] mutableCopy];
                
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
                        
                    }
                });

        }
            else
            {
                NSMutableDictionary *dict=[withPostArr[currentplayingVideo] mutableCopy];
                [self downloadVideoOnStop:dict];
                cellToActivate.activity.hidden=false;
                [cellToActivate.activity startAnimating];
                [videoCheckTimer invalidate];
                videoCheckTimer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(VideoPlayTimerComplete:) userInfo:nil repeats:YES];
                
            }

        
    }
}
-(void)VideoPlayTimerComplete:(NSTimer *)timer
{
    
    if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
    {
        NSMutableDictionary *dict=[withPostArr[currentplayingVideo] mutableCopy];
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
//Download StoryVideos
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
            [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[withPostArr indexOfObject:dictTemp]]];
        }
        else
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:dataPath append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [playableDict setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",(int)[withPostArr indexOfObject:dictTemp]]];
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

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    
    if(!decelerate)
    {
//        NSArray *visibleCells = [tablev visibleCells];
//        
//        for (UITableView *cell in visibleCells) {
//            if (!cellToActivate) {
//                cellToActivate = (homeFeedsCell *)cell;
//            } else {
//                // cellToActive is always the top most cell
//                homeFeedsCell *cell1 = cellToActivate;
//                NSIndexPath *cell1_indexPath = [tablev indexPathForCell:cell1];
//                CGRect cell1_frame = [tablev cellForRowAtIndexPath:cell1_indexPath].frame;
//                
//                homeFeedsCell *cell2 = (homeFeedsCell *)cell;
//                NSIndexPath *cell2_indexPath = [tablev indexPathForCell:cell2];
//                CGRect cell2_frame = [tablev cellForRowAtIndexPath:cell2_indexPath].frame;
//                
//                // Cell frames in controller frames
//                CGRect cell1_frameInSuperview = [tablev convertRect:cell1_frame toView:[tablev superview]];
//                CGRect cell2_frameInSuperview = [tablev convertRect:cell2_frame toView:[tablev superview]];
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
        NSDictionary *dict;
      
            currentplayingVideo=(int)cellToActivate.tag-5000;
        cellToLoad=currentplayingVideo;

            dict=[withPostArr[cellToActivate.tag] mutableCopy];
        
        if([[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
        {
            [cellToDeactivate.videoView.player pause];
            cellToDeactivate.videoView.player=nil;
        }
        else
        {
            currentplayingVideo=(int)cellToActivate.videoView.tag-5000;
            cellToLoad=currentplayingVideo;

            if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
            {
                
                
                NSMutableDictionary *dict=[withPostArr[currentplayingVideo] mutableCopy];
                
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
                        
                    }

                });
                
            }
            else
            {
                NSMutableDictionary *dict=[withPostArr[currentplayingVideo] mutableCopy];
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
    NSArray *visibleCells = [tablev visibleCells];
    
//    for (UITableView *cell in visibleCells) {
//        if (!cellToActivate) {
//            cellToActivate = (homeFeedsCell *)cell;
//        } else {
//            // cellToActive is always the top most cell
//            homeFeedsCell *cell1 = cellToActivate;
//            NSIndexPath *cell1_indexPath = [tablev indexPathForCell:cell1];
//            CGRect cell1_frame = [tablev cellForRowAtIndexPath:cell1_indexPath].frame;
//            
//            homeFeedsCell *cell2 = (homeFeedsCell *)cell;
//            NSIndexPath *cell2_indexPath = [tablev indexPathForCell:cell2];
//            CGRect cell2_frame = [tablev cellForRowAtIndexPath:cell2_indexPath].frame;
//            
//            // Cell frames in controller frames
//            CGRect cell1_frameInSuperview = [tablev convertRect:cell1_frame toView:[tablev superview]];
//            CGRect cell2_frameInSuperview = [tablev convertRect:cell2_frame toView:[tablev superview]];
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
    NSDictionary *dict;

        currentplayingVideo=(int)cellToActivate.tag-5000;
    cellToLoad=currentplayingVideo;

        dict=[withPostArr[cellToActivate.tag] mutableCopy];
        videoPlayDict=[withPostArr[cellToActivate.tag] mutableCopy];
    
    if([[dict valueForKey:@"post_type"] isEqualToString:@"comments"])
    {
        [cellToDeactivate.videoView.player pause];
        cellToDeactivate.videoView.player=nil;
    }
    else
    {
        currentplayingVideo=(int)cellToActivate.videoView.tag-5000;
        cellToLoad=currentplayingVideo;

        if([[playableDict valueForKey:[NSString stringWithFormat:@"%d",currentplayingVideo]]isEqualToString:@"YES"])
        {
            
            
            NSMutableDictionary *dict=[withPostArr[currentplayingVideo] mutableCopy];
            
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
                    
                }
                
            });
            
        }
        else
        {
            NSMutableDictionary *dict=[withPostArr[currentplayingVideo] mutableCopy];
            [self downloadVideoOnStop:dict];
            cellToActivate.activity.hidden=false;
            [cellToActivate.activity startAnimating];
            [videoCheckTimer invalidate];
            videoCheckTimer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(VideoPlayTimerComplete:) userInfo:nil repeats:YES];
            
        }
        
        
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if(scrollView.contentOffset.y<-50)
    {
if(apiCall==1)
{
        [self getPostData];
}
    }
    NSArray *visibleCells = [tablev visibleCells];
    for (UITableView *cell in visibleCells) {
        if (!cellToActivate) {
            cellToActivate = (homeFeedsCell *)cell;
        } else {
            // cellToActive is always the top most cell
            homeFeedsCell *cell1 = cellToActivate;
            NSIndexPath *cell1_indexPath = [tablev indexPathForCell:cell1];
            CGRect cell1_frame = [tablev cellForRowAtIndexPath:cell1_indexPath].frame;
            
            homeFeedsCell *cell2 = (homeFeedsCell *)cell;
            NSIndexPath *cell2_indexPath = [tablev indexPathForCell:cell2];
            CGRect cell2_frame = [tablev cellForRowAtIndexPath:cell2_indexPath].frame;
            
            // Cell frames in controller frames
            CGRect cell1_frameInSuperview = [tablev convertRect:cell1_frame toView:[tablev superview]];
            CGRect cell2_frameInSuperview = [tablev convertRect:cell2_frame toView:[tablev superview]];
            
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
    [videoCheckTimer invalidate];
}
-(void)openNearByScreenn:(UIButton*)but
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
    NSMutableDictionary *dict;

     dict=[withPostArr[but.tag] mutableCopy];
    
    mvc.strTop=[NSString stringWithFormat:@"%f/%f",[[dict valueForKey:@"points"][0]floatValue],[[dict valueForKey:@"points"][1]floatValue]];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)openNearByScreenFromFullScreen:(UIButton*)but
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
    
    
    mvc.strTop=[NSString stringWithFormat:@"%f/%f",[[videoPlayDict valueForKey:@"points"][0]floatValue],[[videoPlayDict valueForKey:@"points"][1]floatValue]];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    play=0;
    [cellToActivate.videoView.player pause];
    [cellToDeactivate.videoView.player pause];
    cellToDeactivate.videoView.player=nil;
    cellToActivate.videoView.player=nil;
    [videoCheckTimer invalidate];
    [self.mPlayer pause];
    self.mPlayer.volume=0.0;
    self.mPlayer=nil;

    player.volume=0.0;
    [player pause];
    player=nil;
    [fullView removeFromSuperview];
    fullView=nil;
    
    screencount=0;
    [aTimer invalidate];
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    
    
    
    api_obj=nil;
    
    
}
-(void)scrollTableOnNotification
{
    [tablev setContentOffset:CGPointMake(0,tablev.contentOffset.y+0.1) animated:YES];

//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellToLoad];
//    [tablev scrollToRowAtIndexPath:indexPath
//                       atScrollPosition:UITableViewScrollPositionMiddle
//                               animated:YES];
}
@end
