//
//  otheruserViewController.m
//
//
//  Created by Brahmasys on 08/12/15.
//
//

#import "otheruserViewController.h"
#import "userfollowerView.h"
#import "userfollowingView.h"
#import "AppDelegate.h"

#import "postOfHashTagView.h"
#import "APIViewController.h"
#import "LoaderViewController.h"

#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "recordVideoViewController.h"
#import "commentsOnFeedViewController.h"
#import "directVideoViewController.h"
#import "reSharePostViewController.h"
#import "getNearByViewController.h"
#import "AGPushNoteView.h"
#import "likeViewController.h"


@class AVPlayer;
@class AVPlayerDemoPlaybackView;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;

@interface otheruserViewController ()
{
    
    NSString *isPrivate;
    int play;
    UIImageView *heartanimation;
    int totalHeight;
    UIActivityIndicatorView *indicator;
    NSMutableArray *videoArray;

    int imgclick,selectedIndexx;
    NSString *min,*max;

    BOOL stopLoader;

    APIViewController *api_obj;
    
    NSMutableArray *postsArr,*likedArr;
    NSString *usernameforshow;

    UIView *fullView;
    AVPlayerLayer *avPlayerLayer;
    AVPlayer *player;
    UIImageView *filterView;
    int duration;
    int currentTime;
    NSTimer *aTimer ;
    NSArray *foooooo;
    NSMutableArray *filterArr;
    int downloadVideoCount,downloadVideoCount1;
    BOOL isScrolling;
    
    CGRect cachedImageViewSize;
    int playingVideo;
    int apicall;
    int selectedbtn;
}

@property (readwrite, retain) AVPlayer* mPlayer;
@property (nonatomic, retain) VideoPlayerViewController *myPlayerViewController;

@end

@implementation otheruserViewController

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
    [super viewDidLoad];
    
    cachedImageViewSize = cover_img.frame;
    //    [mainScrlv sendSubviewToBack:profileScrlv];
    [mainScrlv sendSubviewToBack:cover_img];
    [mainScrlv sendSubviewToBack:imgBlack];
    
    [LoaderViewController show:self.view animated:YES];
    NSString *urlString=[NSString stringWithFormat:@"%@/GetUserProfile/%@/%@/%@/%@",WEBURL,userid,friendID,@"0",@"10"];
    
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
            
            [self getProfileInfoResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getProfileInfoResult:nil];
        
    }];
    
    [operation start];

}
-(void)viewWillAppear:(BOOL)animated
{
    play=1;
    api_obj=[[APIViewController alloc]init];
    [api_obj getProfileInfo:@selector(getProfileInfoResult1:) tempTarget:self : friendID];
    
    
    screenName=@"otherprofile";
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTableOnNotification) name:@"otherprofile" object:nil];
    totalHeight=0;
    if(postsArr.count>0)
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(scrollTableOnNotification) userInfo:nil repeats:NO];
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

    
    [self createOptionPopUp];
    
    cancelbtn.layer.cornerRadius=5.0;
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    
    [posts_Btn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    [liked_Btn setImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Segment Action
-(IBAction)posts_Button:(id)sender
{
    if(postsArr.count == 0)
    {
        [tablev setHidden:YES];
    }
    else
    {
        [tablev setHidden:NO];
    }

    totalHeight=0;
    CGRect f = tablev.frame;
    f.size.height = 700*postsArr.count;
    tablev.frame =f;
    mainScrlv.contentSize=CGSizeMake(300, tablev.frame.size.height);

    [self.mPlayer pause];
    [player pause];
    selectedbtn=0;
    postCount_lbl.textColor=[UIColor whiteColor];
    followedCount_lbl.textColor=[UIColor whiteColor];
    [posts_Btn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    [liked_Btn setImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
    
    [tablev reloadData];
}
-(IBAction)liked_Button:(id)sender
{
    if(likedArr.count == 0)
    {
        [tablev setHidden:YES];
    }
    else
    {
        [tablev setHidden:NO];
    }

    totalHeight=0;
    CGRect f = tablev.frame;
    f.size.height = 700*likedArr.count;
    tablev.frame =f;
    mainScrlv.contentSize=CGSizeMake(300, tablev.frame.size.height);

    [self.mPlayer pause];
    [player pause];
    selectedbtn=1;
    postCount_lbl.textColor=[UIColor whiteColor];
    followedCount_lbl.textColor=[UIColor whiteColor];
    [tablev reloadData];
    [posts_Btn setImage:[UIImage imageNamed:@"posted"] forState:UIControlStateNormal];
    [liked_Btn setImage:[UIImage imageNamed:@"Likedb"] forState:UIControlStateNormal];
}

-(void)getProfileInfoResult1:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    apicall=1;
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        mainScrlv.contentSize=CGSizeMake(300, 735);
        if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){
            usernameforshow=[[dict_Response objectForKey:@"userdetails"] objectForKey:@"username"];
            
            
            name_lbl.text=[[dict_Response objectForKey:@"userdetails"] objectForKey:@"username"];
            btnFollow.titleLabel.text=[NSString stringWithFormat:@"%@ Followers",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"followers"] ];
            btnFollowing.titleLabel.text=[NSString stringWithFormat:@"%@ Following",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"followings"] ];

        }
    }
}
-(void)getProfileInfoResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    apicall=1;
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        mainScrlv.contentSize=CGSizeMake(300, 735);
        if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){
            usernameforshow=[[dict_Response objectForKey:@"userdetails"] objectForKey:@"username"];
            
            
            name_lbl.text=[[dict_Response objectForKey:@"userdetails"] objectForKey:@"username"];
            btnFollow.titleLabel.text=[NSString stringWithFormat:@"%@ Followers",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"followers"] ];
            btnFollowing.titleLabel.text=[NSString stringWithFormat:@"%@ Following",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"followings"] ];
            profile_img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"profile_pic"]]];
            profile_img.layer.cornerRadius=35;
            
            cover_img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"wall_image"]]];
            cover_img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"wall_image"]]];
            if([[[dict_Response objectForKey:@"userdetails"] objectForKey:@"wall_image"] isEqualToString:@""])
            {
                cover_img.image=[UIImage imageNamed:@"coverimage.png"];
                cover_img1.image=[UIImage imageNamed:@"coverimage.png"];
            }
            
            
            if([[[dict_Response objectForKey:@"userdetails"] objectForKey:@"isPrivate"]boolValue]==true)
            {
                isPrivate = @"true";
                UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-200, self.view.frame.size.width, 40)];
                [lbl setText:@"Videos are Private"];
                [lbl setTextAlignment:NSTextAlignmentCenter];
                [self.view addSubview:lbl];
                noVideoImage.hidden=YES;
                
            }
            else
            {
                isPrivate = @"false";
            }
            postsArr=[[[dict_Response objectForKey:@"userdetails"] objectForKey:@"posts"]mutableCopy];
            likedArr=[[[dict_Response objectForKey:@"userdetails"] objectForKey:@"liked"]mutableCopy];
            
            
            downloadVideoCount=(int)postsArr.count;
            downloadVideoCount1=(int)likedArr.count;
            videoArray=[NSMutableArray new];
            
            downloadVideoCount=(int)postsArr.count;
            for(int i=0;i<(int)postsArr.count;i++)
            {
                [videoArray addObject:[postsArr objectAtIndex:i]];
            }
            [self btnImagesClick:0];
            [self btnImagesClick1:0];
            
            
            aboutUser.text=[NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"about"]];
            username_lbl.text=[NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"username"]];
            username_lbl.text=[username_lbl.text uppercaseString];
            
            if(![aboutUser.text isEqualToString:@""])
            {
                
                profileScrlv.contentSize=CGSizeMake(self.view.frame.size.width*2, 100);
                
            }
            
            
            
            
            NSLog(@"%@,%@",[dict_Response objectForKey:@"name"],[NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"wall_image"]]);
            
            
            
            
            if([[[dict_Response objectForKey:@"userdetails"] objectForKey:@"isfollowing"] isEqual:@"approved"])
            {
                [folow_Btn setImage:[UIImage imageNamed:@"followingbtn"] forState:UIControlStateNormal];
                [folow_Btn setUserInteractionEnabled:YES];
                
                folow_Btn.tag=0;
            }
            else if([[[dict_Response objectForKey:@"userdetails"] objectForKey:@"isfollowing"] isEqual:@"na"])
            {
                [folow_Btn setImage:[UIImage imageNamed:@"followbtna"] forState:UIControlStateNormal];
                [folow_Btn setUserInteractionEnabled:YES];
                
                folow_Btn.tag=1;
                
            }
            else
            {
                [folow_Btn setImage:[UIImage imageNamed:@"requested"] forState:UIControlStateNormal];
                [folow_Btn setUserInteractionEnabled:NO];
                folow_Btn.tag=2;
            }
            
            
            
            
            if([[[dict_Response objectForKey:@"userdetails"] objectForKey:@"post_count"] intValue]>0)
                postCount_lbl.text=[NSString stringWithFormat:@"(%@)",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"post_count"]];
            
            if([[[dict_Response objectForKey:@"userdetails"] objectForKey:@"post_followed_count"] intValue]>0)
                followedCount_lbl.text=[NSString stringWithFormat:@"(%@)",[[dict_Response objectForKey:@"userdetails"] objectForKey:@"post_followed_count"]];
            
            
            if(selectedbtn==1)
            {
                CGRect f = tablev.frame;
                f.size.height = likedArr.count*700;
                tablev.frame =f;
                postCount_lbl.textColor=[UIColor whiteColor];
                followedCount_lbl.textColor=[UIColor whiteColor];
                [posts_Btn setImage:[UIImage imageNamed:@"posted"] forState:UIControlStateNormal];
                [liked_Btn setImage:[UIImage imageNamed:@"Likedb"] forState:UIControlStateNormal];
            }
            else
            {
                CGRect f = tablev.frame;
                f.size.height = postsArr.count*700;
                tablev.frame =f;
                selectedbtn=0;
                postCount_lbl.textColor=[UIColor whiteColor];
                followedCount_lbl.textColor=[UIColor whiteColor];
                [posts_Btn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
                [liked_Btn setImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
            }
            
            
            [tablev reloadData];
        }
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
-(void)btnImagesClick1:(UIButton*)sender
{
    
    downloadVideoCount1=downloadVideoCount1-1;
    if(downloadVideoCount1>=0)
    {
        NSMutableDictionary *downloadVideoDict = [likedArr objectAtIndex:downloadVideoCount1];
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






-(IBAction)fllowing_Button:(id)sender
{
    followingID=friendID;
    userfollowingView *mvc;
    if(iphone4)
    {
        mvc=[[userfollowingView alloc]initWithNibName:@"userfollowingView@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[userfollowingView alloc]initWithNibName:@"userfollowingView" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[userfollowingView alloc]initWithNibName:@"userfollowingView@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[userfollowingView alloc]initWithNibName:@"userfollowingView@6P" bundle:nil];
    }
    else
    {
        mvc=[[userfollowingView alloc]initWithNibName:@"userfollowingView@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
}
-(IBAction)follower_Button:(id)sender
{
    followingID=friendID;
    userfollowerView *mvc;
    if(iphone4)
    {
        mvc=[[userfollowerView alloc]initWithNibName:@"userfollowerView@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[userfollowerView alloc]initWithNibName:@"userfollowerView" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[userfollowerView alloc]initWithNibName:@"userfollowerView@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[userfollowerView alloc]initWithNibName:@"userfollowerView@6P" bundle:nil];
    }
    else
    {
        mvc=[[userfollowerView alloc]initWithNibName:@"userfollowerView@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
}

-(IBAction)likes_Button:(id)sender
{
    
}
#pragma mark Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(selectedbtn==0)
    {
        if(postsArr.count==0)
            return 0;
        return postsArr.count+1;
        
    }
    else
    {
        if(likedArr.count==0)
            return 0;
        return likedArr.count+1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,80)];
    int k=0;
    if(selectedbtn==0)
    {
        k=postsArr.count;
    }
    else
    {
        k=likedArr.count;
    }
    
    if(section == k)
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
            CGRect labelFrame = CGRectMake (0, 70,self.view.frame.size.width, 20);
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
        
        NSMutableDictionary *dict;
        if(selectedbtn==0)
            dict=postsArr[section];
        else
            dict=likedArr[section];
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
            CGRect labelFrame = CGRectMake (0, 0,self.view.frame.size.width, 20);
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
        
        
    }
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int k=0;
    if(selectedbtn==0)
    {
        k=postsArr.count;
    }
    else
    {
        k=likedArr.count;
    }
    
    if(section==k)
    {
        return 160;
        
    }
    
    int h=0;
    NSMutableDictionary *dict;
    if(selectedbtn==0)
        dict=postsArr[section];
    else
        dict=likedArr[section];
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
    totalHeight=totalHeight+50+requiredHeight.size.height+h;
    return 50+requiredHeight.size.height+h+z;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int k=0;
    if(selectedbtn==0)
    {
        k=postsArr.count;
    }
    else
    {
        k=likedArr.count;
    }
    
    if(section==k)
        return 0;
    
    return 1;
    
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
    NSMutableDictionary *dict;
    if(selectedbtn==0)
    {
        dict=postsArr[indexPath.section];
        //        if(indexPath.section==postsArr.count-1)
        //        {
        //            apicall=1;
        //            min=[NSString stringWithFormat:@"%lu",(unsigned long)postsArr.count];
        //            max=[NSString stringWithFormat:@"10"];
        //            [self GetUserPost];
        //        }
        
    }
    else
    {
        dict=likedArr[indexPath.section];
        //        if(indexPath.section==likedArr.count-1)
        //        {
        //            apicall=1;
        //            min=[NSString stringWithFormat:@"%lu",(unsigned long)likedArr.count];
        //            max=[NSString stringWithFormat:@"10"];
        //            [self GetFollowPost];
        //        }
        
    }
    celll.activity.hidden=YES;
    
    celll.name.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]];
    
    
    
    celll.videoView.tag=indexPath.section+3000;
    
    
    celll.videoImage.contentMode = UIViewContentModeScaleAspectFill;
    [celll.videoImage.layer setMasksToBounds:YES];
    celll.videoImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
    
    
    
    celll.likeCountBtn.tag=6700+indexPath.section;
    [celll.likeCountBtn addTarget:self action:@selector(Likes:) forControlEvents:UIControlEventTouchUpInside];
    if([[dict valueForKey:@"likes"] integerValue] != 0)
    {
        
        [celll.likeCountBtn setTitle:[NSString stringWithFormat:@"%@",[dict valueForKey:@"likes"]] forState:UIControlStateNormal];
        
    }
    
    [celll.likeButton addTarget:self action:@selector(like_action:) forControlEvents:UIControlEventTouchUpInside];
    celll.likeButton.tag=indexPath.section;
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
    
    
    
    //totalHeight=totalHeight+celll.frame.size.width;
    if(selectedbtn==0)
    {
        if(indexPath.section==postsArr.count-1)
        {
            CGRect f = tablev.frame;
            f.size.height = [tablev contentSize].height;
            tablev.frame =f;
            mainScrlv.contentSize=CGSizeMake(300, f.size.height+f.origin.y);
        }
    }
    else{
        if(indexPath.section==likedArr.count-1)
        {
            CGRect f = tablev.frame;
            f.size.height = [tablev contentSize].height;//totalHeight+(likedArr.count*self.view.frame.size.width)-150;
            tablev.frame =f;
            mainScrlv.contentSize=CGSizeMake(300, f.size.height+f.origin.y);
        }
    }
    
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    int h;
    if(iphone5||iphone4)
        h=320;
    else if(iphone6)
        h=375;
    else
        h=414;
    return h;
    
    
}

-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)followUser_Button:(id)sender
{
    NSString *st=@"true";
    if(folow_Btn.tag==1)
    {
        st=@"true";
        [folow_Btn setImage:[UIImage imageNamed:@"followingbtn"] forState:UIControlStateNormal];
        folow_Btn.tag=0;
    }
    else
    {
           st=@"false";
        [folow_Btn setImage:[UIImage imageNamed:@"followbtna"] forState:UIControlStateNormal];
        folow_Btn.tag=1;
    }
    
    
    
      
    
    
    api_obj=[[APIViewController alloc]init];
    [api_obj follow_user:@selector(follow_userResult:) tempTarget:self : friendID :st];
    
}
-(void)follow_userResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    
    
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        if([[dict_Response valueForKey:@"status"] integerValue]==200){
            
            api_obj=[[APIViewController alloc]init];
            [api_obj getProfileInfo:@selector(getProfileInfoResult:) tempTarget:self : friendID];
        }
    }
}
-(void)playFullScreenVideo:(id)sender
{
    [self.mPlayer pause];
    self.mPlayer.volume=0.0;
    
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
        [player play];
    }
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
    
    
    currentTime=0;
    
    
    filterView=[[UIImageView alloc]initWithFrame: CGRectMake(0, 0, fullView.frame.size.width,fullView.frame.size.height)];
    filterView.alpha=0.4;
    [fullView addSubview:filterView];
    
    
    
    
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
    [userProfileButton addTarget:self action:@selector(userprofileButton_action:) forControlEvents:UIControlEventTouchUpInside];
    userProfileButton.tag=selectedIndexx;
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
    
    
    
    CGRect labelFrameee = CGRectMake (73+stringsize.width+6,5, stringsize.width, 25);
    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
    [location addTarget:self action:@selector(openNearByScreen:) forControlEvents:UIControlEventTouchUpInside];
    location.frame =labelFrameee;
    location.tag=selectedIndexx;
    
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
    [postDetailbutton addTarget:self action:@selector(postDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    postDetailbutton.tag=selectedIndexx;
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
-(void)closeFullView:(UIButton*)btn
{
    player.volume=0.0;;
    [player pause];
    duration=0;
    currentTime=0;
    [filterView removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    
    [mainScrlv setContentOffset:CGPointMake(0,mainScrlv.contentOffset.y-5) animated:YES];

    
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
    duration=0;
    currentTime=0;
    [self.mPlayer seekToTime:kCMTimeZero];
    [self.mPlayer play];
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
    
}
-(IBAction)profile_likes_Button:(id)sender
{
    api_obj=[[APIViewController alloc]init];
    [api_obj likeUserProfile:@selector(likeUserProfileResult:) tempTarget:self : friendID :@"true"];
    
}-(void)likeUserProfileResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    
    
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        if([[dict_Response valueForKey:@"status"] integerValue]==200){
            
            api_obj=[[APIViewController alloc]init];
            [api_obj getProfileInfo:@selector(getProfileInfoResult:) tempTarget:self : friendID];
        }
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (mainScrlv.contentOffset.y >= (mainScrlv.contentSize.height - mainScrlv.bounds.size.height))
    {
    }
    else
    {
        if(scrollView.tag==80)
        {
            if(scrollView.contentOffset.x<self.view.frame.size.width-50)
            {
                img1.image=[UIImage imageNamed:@"click"];
                img2.image=[UIImage imageNamed:@"unclick"];
            }
            else if(scrollView.contentOffset.x>=self.view.frame.size.width-50)
            {
                img2.image=[UIImage imageNamed:@"click"];
                img1.image=[UIImage imageNamed:@"unclick"];
            }
        }
        else
        {
            [self.mPlayer pause];
            int h=0;
            if(iphone6)
                h= 437;
            else if(iphone6p)
                h= 477;
            else
                h= 400;
            
            playingVideo=scrollView.contentOffset.y/(h);
            NSMutableDictionary *dict;
            NSMutableArray *arr;
            if(selectedbtn==0){
                if(playingVideo>=postsArr.count)
                {
                    
                }
                else{
                    arr=[postsArr mutableCopy];
                    dict=postsArr[playingVideo];
                }
            }
            
            else
            {
                if(playingVideo>=likedArr.count)
                {
                    
                }
                else
                {
                    dict=likedArr[playingVideo];
                    arr=[likedArr mutableCopy];
                }
            }
            
            
            
            if(arr.count>0 && scrollView.contentOffset.y>150)
            {
                
                UITabBarController *bar = [self tabBarController];
                if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
                    //iOS 7 - hide by property
                    NSLog(@"iOS 7");
                    [self setExtendedLayoutIncludesOpaqueBars:YES];
                    bar.tabBar.hidden = NO;
                }
                
                AVPlayerDemoPlaybackView *videoView = (AVPlayerDemoPlaybackView *)[tablev viewWithTag:3000+playingVideo];
                
                
                
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
                        
                        [videoView setPlayer:self.mPlayer];
                        [videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(playerItemDidReachEnd:)
                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                   object:[self.mPlayer currentItem]];
                        if(screencount==2)
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
            }
            
            
            
            
        }
        
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int h=0;
    if(iphone6)
        h= 437;
    else if(iphone6p)
        h= 477;
    else
        h= 400;
    
    playingVideo=scrollView.contentOffset.y/(h);
    NSMutableDictionary *dict;
    NSMutableArray *arr;
    if(selectedbtn==0){
        if(playingVideo>=postsArr.count)
        {
            
        }
        else{
            arr=[postsArr mutableCopy];
            dict=postsArr[playingVideo];
        }
    }
    
    else
    {
        if(playingVideo>=likedArr.count)
        {
            
        }
        else
        {
            dict=likedArr[playingVideo];
            arr=[likedArr mutableCopy];
        }
    }
    
    
    AVPlayerDemoPlaybackView *videoView = (AVPlayerDemoPlaybackView *)[tablev viewWithTag:3000+playingVideo];
    
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
            
            [videoView setPlayer:self.mPlayer];
            [videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[self.mPlayer currentItem]];
            if(screencount==2)
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
    
    
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self.mPlayer setVolume:0];
    [self.mPlayer pause];
    isScrolling=true;
    CGFloat y = -aScrollView.contentOffset.y;
    if (y > 0) {
        
        
        cover_img.frame = CGRectMake(0, aScrollView.contentOffset.y, cachedImageViewSize.size.width+y, cachedImageViewSize.size.height+y);
        cover_img.center = CGPointMake(self.view.center.x, cover_img.center.y);
        
        imgBlack.frame = CGRectMake(0, aScrollView.contentOffset.y, cachedImageViewSize.size.width+y, cachedImageViewSize.size.height+y);
        imgBlack.center = CGPointMake(self.view.center.x, imgBlack.center.y);
    }
    
    
    if(aScrollView.contentOffset.y>250)
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:1];
        imgCoverTop.alpha=1;
        imgProfileTop.alpha=1;
        lblNameTop.alpha=1;
        [imgCoverTop setImage:[UIImage imageNamed:@"topbar.png"]];
        [imgProfileTop setImage:profile_img.image];
        imgProfileTop.layer.cornerRadius=imgProfileTop.frame.size.width/2;
        imgProfileTop.clipsToBounds=YES;
        [lblNameTop setText:usernameforshow];
        [UIView commitAnimations];
        
    }
    else
    {
        imgCoverTop.alpha=0;
        imgProfileTop.alpha=0;
        lblNameTop.alpha=0;
        
    }
    
    if(selectedbtn==0){
        
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float g = size.height;
        
        
        if(y > g ) {
            if([isPrivate  isEqual: @"false"])
            {
            NSLog(@"load more rows");
            if(apicall==1)
            {
                apicall=0;
                min=[NSString stringWithFormat:@"%lu",(unsigned long)postsArr.count];
                max=[NSString stringWithFormat:@"10"];
                
                [self GetUserPost];
            }
            }
            
        }
    }
    else
    {
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float g = size.height;
        
        if(y > g ) {
            if([isPrivate  isEqual: @"false"])
            {
            NSLog(@"load more rows");
            if(apicall==1)
            {
                apicall=0;
                min=[NSString stringWithFormat:@"%lu",(unsigned long)likedArr.count];
                max=[NSString stringWithFormat:@"10"];
                [self GetFollowPost];
            }
            }
            
        }
        
    }
    
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    isScrolling=false;
    if (mainScrlv.contentOffset.y >= (mainScrlv.contentSize.height - mainScrlv.bounds.size.height))
    {
    }
    else
    {
        if(scrollView.tag==80)
        {
            if(scrollView.contentOffset.x<self.view.frame.size.width-50)
            {
                img1.image=[UIImage imageNamed:@"click"];
                img2.image=[UIImage imageNamed:@"unclick"];
            }
            else if(scrollView.contentOffset.x>=self.view.frame.size.width-50)
            {
                img2.image=[UIImage imageNamed:@"click"];
                img1.image=[UIImage imageNamed:@"unclick"];
            }
        }
        else
        {
            //NSLog(@"---cdccccccdcdc----%f",scrollView.contentOffset.x);
            int h=0;
            if(iphone6)
                h= 437;
            else if(iphone6p)
                h= 477;
            else
                h= 400;
            
            playingVideo=scrollView.contentOffset.y/h;
            [self.mPlayer pause];
            NSMutableDictionary *dict;
            NSMutableArray *arr;
            if(selectedbtn==0){
                if(playingVideo>=postsArr.count)
                {
                    
                }
                else{
                    arr=[postsArr mutableCopy];
                    dict=postsArr[playingVideo];
                }
            }
            
            else
            {
                if(playingVideo>=likedArr.count)
                {
                    
                }
                else
                {
                    dict=likedArr[playingVideo];
                    arr=[likedArr mutableCopy];
                }
            }
            
            
            
            if(arr.count>0 && scrollView.contentOffset.y>150)
            {
                
                UITabBarController *bar = [self tabBarController];
                if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
                    //iOS 7 - hide by property
                    NSLog(@"iOS 7");
                    [self setExtendedLayoutIncludesOpaqueBars:YES];
                    bar.tabBar.hidden = NO;
                }
                
                AVPlayerDemoPlaybackView *videoView = (AVPlayerDemoPlaybackView *)[tablev viewWithTag:3000+playingVideo];
                
                
                
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
                        
                        [videoView setPlayer:self.mPlayer];
                        [videoView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(playerItemDidReachEnd:)
                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                   object:[self.mPlayer currentItem]];
                        if(screencount==2)
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
            }
        }
    }
}
-(void)downloadUserimages:(NSDictionary*)dictTemp
{
    
    
    
    NSString *str=[[dictTemp objectForKey:@"userdetails"] objectForKey:@"wall_image"];
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
            cover_img.imageURL=[[NSURL alloc] initFileURLWithPath:dataPath];
            cover_img1.imageURL=[[NSURL alloc] initFileURLWithPath:dataPath];
        }
        else
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:dataPath append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                cover_img.imageURL=[[NSURL alloc] initFileURLWithPath:dataPath];
                 cover_img1.imageURL=[[NSURL alloc] initFileURLWithPath:dataPath];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dataPath forKey:@"cover_img"];
                [userDefaults synchronize];
                
                NSLog(@"Successfully downloaded file to %@", dataPath);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                cover_img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dictTemp objectForKey:@"userdetails"] objectForKey:@"wall_image"]]];
                cover_img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dictTemp objectForKey:@"userdetails"] objectForKey:@"wall_image"]]];
            }];
            
            
            [operation start];
        }
        
    }
    
    
    NSString *strr=[[dictTemp objectForKey:@"userdetails"] objectForKey:@"profile_pic"];
    NSString *strTempp = strr;
    NSString *profileURLl = [appUrl stringByAppendingPathComponent:strTempp];
    NSURL *URLl=[[NSURL alloc] initWithString:profileURLl];
    
    
    if(![strr isEqualToString:@""])
    {
        NSArray* foo = [profileURLl componentsSeparatedByString: @"IMG"];
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
            profile_img.imageURL=[[NSURL alloc] initFileURLWithPath:dataPath];
        }
        else
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:URLl];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:dataPath append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                profile_img.imageURL=[[NSURL alloc] initFileURLWithPath:dataPath];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dataPath forKey:@"profile_img"];
                [userDefaults synchronize];
                
                NSLog(@"Successfully downloaded file to %@", dataPath);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                profile_img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dictTemp objectForKey:@"userdetails"] objectForKey:@"profile_pic"]]];
            }];
            
            
            [operation start];
        }
        
    }
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    play=0;
    [self.mPlayer pause];
    [self.mPlayer setVolume:0];
    screencount=0;
    player.volume=0;
    [aTimer invalidate];
    [player pause];
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    [fullView removeFromSuperview];
    self.mPlayer=nil;
    player=nil;

    
    
    
    
}
#pragma mark Options
- (IBAction)Options:(UIButton*)sender
{
    if(viewOptions.tag==0)
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.5f];
        indexOptions=(int)[sender tag];
        [UIView setAnimationBeginsFromCurrentState: NO];
        [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,self.view.frame.size.height-viewOptions.frame.size.height-53, viewOptions.frame.size.width, viewOptions.frame.size.height)];
        viewOptions.tag=1;
        
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
-(IBAction)shareDirectLink:(UIButton*)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict;
        if(selectedbtn==0)
            dict=[postsArr objectAtIndex:indexOptions];
        else
            dict=[likedArr objectAtIndex:indexOptions];
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
-(IBAction)copyLink:(UIButton*)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict;
        if(selectedbtn==0)
            dict=[postsArr objectAtIndex:indexOptions];
        else
            dict=[likedArr objectAtIndex:indexOptions];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"link copied" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
        
    }
    [self cancelClick:0];
    
}

-(IBAction)Report:(id)sender
{
    if(viewOptions.tag==1)
    {
        NSMutableDictionary *dict;
        if(selectedbtn==0)
            dict=[postsArr objectAtIndex:indexOptions];
        else
            dict=[likedArr objectAtIndex:indexOptions];
        
        api_obj=[[APIViewController alloc]init];
        [api_obj ReportSpamPost:@selector(ReportSpamPostResult:) tempTarget:self :[dict valueForKey:@"postid"]];
    }
}
-(void)ReportSpamPostResult:(NSMutableDictionary*)dict
{
    NSLog(@"ReportSpamPostResult :%@",dict);
    [self viewWillAppear:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Successfully reported as Spam" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
        NSMutableDictionary *dict;
        if(selectedbtn==0)
            dict=[postsArr objectAtIndex:indexOptions];
        else
            dict=[likedArr objectAtIndex:indexOptions];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Reliveie is Successfull" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        NSMutableDictionary *dict;
        if(selectedbtn==0)
            dict=[postsArr objectAtIndex:indexOptions];
        else
            dict=[likedArr objectAtIndex:indexOptions];
        
        api_obj=[[APIViewController alloc]init];
        [api_obj HidePost:@selector(HidePostResult:) tempTarget:self :[dict valueForKey:@"postid"]];
    }
}
-(void)HidePostResult:(NSMutableDictionary*)dict
{
    NSLog(@"HidePostResult :%@",dict);
    
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewOptions setFrame:CGRectMake(viewOptions.frame.origin.x,790, viewOptions.frame.size.width, viewOptions.frame.size.height)];
    viewOptions.tag=0;
    [UIView commitAnimations];

    [self viewWillAppear:YES];
    
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
-(IBAction)reShareButton_action:(UIButton*)sender
{
    
    sender.imageView.frame = CGRectMake(sender.frame.origin.x+1, sender.frame.origin.y+1, sender.frame.size.width-2, sender.frame.size.height-2);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.imageView.frame = CGRectMake(sender.frame.origin.x-1, sender.frame.origin.y-1, sender.frame.size.width+2, sender.frame.size.height+2);
    [UIView commitAnimations];
    
    selectedFeed=[postsArr objectAtIndex:sender.tag];
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
- (void)likeActionOfReply:(UIButton*)sender
{
    //if(sele)
    
    
    NSString *st;
    int ccc;
    NSMutableDictionary *dict;//=postsArr[sender.tag];
    if(selectedbtn==0)
        dict=[postsArr[sender.tag-1]mutableCopy];
    else
        dict=[likedArr[sender.tag-1]mutableCopy];
    
    if([[dict valueForKey:@"like_status"]intValue]==1)
    {
        st=@"false";
        ccc=0;
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        UIButton *v = (UIButton *)[tablev viewWithTag:2300+sender.tag-1];
        [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]-1] forState:UIControlStateNormal];
        //;
    }
    else
    {
        st=@"true";
        ccc=1;
        [sender setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateNormal];
        UIButton *v = (UIButton *)[tablev viewWithTag:2300+sender.tag-1];
        [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]+1] forState:UIControlStateNormal];
    }
    
    api_obj=[[APIViewController alloc]init];
    [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[dict objectForKey:@"postid"] :st];
    
    
    if(selectedbtn==0)
    {
     int i=  (int) [postsArr indexOfObject:dict];
        [postsArr[i] setValue:[NSString stringWithFormat:@"%d",ccc] forKey:@"like_status"];
    }
    else
    {
        int i=  (int) [likedArr indexOfObject:dict];
        [likedArr[i] setValue:[NSString stringWithFormat:@"%d",ccc] forKey:@"like_status"];
    }
    
}
- (IBAction)comment_action:(UIButton*)sender
{
    
    sender.imageView.frame = CGRectMake(sender.frame.origin.x+1, sender.frame.origin.y+1, sender.frame.size.width-2, sender.frame.size.height-2);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.imageView.frame = CGRectMake(sender.frame.origin.x-1, sender.frame.origin.y-1, sender.frame.size.width+2, sender.frame.size.height+2);
    [UIView commitAnimations];
    
    if(selectedbtn==0)
        commentFeed=[postsArr objectAtIndex:sender.tag];
    else
        commentFeed=[likedArr objectAtIndex:sender.tag];
    
    
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
    
    // [self.navigationController pushViewController:mvc animated:YES];
}
-(void)getlikeresult:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];

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
-(IBAction)reportUser_Button:(id)sender
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report User",@"Block User", nil];
    [sheet showInView:self.view];
    [sheet setTag:2];
    
}
#pragma mark Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
     if (actionSheet.tag == 2){
        if (buttonIndex==0) {//Camera for image
            
            api_obj=[[APIViewController alloc]init];
            [api_obj reportUser:@selector(blockUserresult:) tempTarget:self :[NSString stringWithFormat:@"%@/%@",userid,friendID]];
            
                
            
        }
        else if (buttonIndex==1) {//gallary
            
            api_obj=[[APIViewController alloc]init];
            [api_obj blockUser:@selector(blockUserresult:) tempTarget:self :[NSString stringWithFormat:@"%@/%@",userid,friendID]];
            
            
        }
         
    }
    
    
}

-(void)blockUserresult:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];

    }
    
    else
    {
        if([[dict_Response  valueForKey:@"status"]integerValue]==200 )
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
        }
    }
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
        //        heartanimation.image=[UIImage imageNamed:@"WhiteHeart.png"];
        
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
        if([[selectedFeed valueForKey:@"post_type"]isEqualToString:@"public"]|| [[selectedFeed valueForKey:@"post_type"]isEqualToString:@"reshare"])
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


-(void)getlikeresult1:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];

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
-(void)postDetailAction:(UIButton*)btn
{
    [self.mPlayer setVolume:0];
    if(selectedbtn==0)
    {
        if([[[postsArr objectAtIndex:btn.tag]valueForKey:@"post_type"] isEqualToString:@"public"]||[[[postsArr objectAtIndex:btn.tag]valueForKey:@"post_type"] isEqualToString:@"reshare"])
        {
            selectedFeed=[postsArr objectAtIndex:btn.tag];
        }
        else
        {
            selectedFeed=[postsArr objectAtIndex:btn.tag];
            [selectedFeed setValue:[selectedFeed valueForKey:@"parent_id"] forKey:@"postid"];
        }
    }
    else
    {
        if([[[likedArr objectAtIndex:btn.tag]valueForKey:@"post_type"] isEqualToString:@"public"]||[[[likedArr objectAtIndex:btn.tag]valueForKey:@"post_type"] isEqualToString:@"reshare"])
        {
            selectedFeed=[likedArr objectAtIndex:btn.tag];
        }
        else
        {
            selectedFeed=[likedArr objectAtIndex:btn.tag];
            [selectedFeed setValue:[selectedFeed valueForKey:@"parent_id"] forKey:@"postid"];
        }
        
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
    NSMutableDictionary *dict;
    if(selectedbtn==0)
        dict=[postsArr objectAtIndex:but.tag];
    else
        dict=[likedArr objectAtIndex:but.tag];
    mvc.strTop=[NSString stringWithFormat:@"%f/%f",[[dict valueForKey:@"points"][0]floatValue],[[dict valueForKey:@"points"][1]floatValue]];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)handleSingleTap:(UIGestureRecognizer *)indexPath {
    //do your stuff for a double tap
    [player pause];
    selectedIndexx++;
    
    if(selectedbtn==0 && selectedIndexx==postsArr.count)
        selectedIndexx=0;
    
    if(selectedbtn==1 && selectedIndexx==likedArr.count)
        selectedIndexx=0;
    
    
    
    if(selectedbtn==0)
        selectedFeed=[postsArr[selectedIndexx]mutableCopy];
    else
        selectedFeed=[likedArr[selectedIndexx]mutableCopy];
    
    
    
    
    
    
    [filterView removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
    [fullView removeFromSuperview];
    
    
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
    
    btnNext.frame = self.view.frame;
    [fullView addSubview:btnNext];
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
    
    AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(8,4, 50, 50)];
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
    
    
    
    UILabel *timelbl;
    timelbl = [[UILabel alloc] initWithFrame:CGRectMake (viewBack.frame.size.width-30,10, 40, 20)];
    [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
    timelbl.textColor=[UIColor purpleColor];
    timelbl.backgroundColor=[UIColor clearColor];
    NSString *st= [AppDelegate HourCalculation:[selectedFeed valueForKey:@"time"]];
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
        NSMutableDictionary *dict=[postsArr objectAtIndex:indexOptions];
        api_obj=[[APIViewController alloc]init];
        [api_obj followUser:@selector(followPostResult:) tempTarget:self :[dict valueForKey:@"postid"] : @"true"];
        
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
- (void)like_action:(UIButton*)sender
{
    
    sender.imageView.frame = CGRectMake(sender.frame.origin.x+1, sender.frame.origin.y+1, sender.frame.size.width-2, sender.frame.size.height-2);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    sender.imageView.frame = CGRectMake(sender.frame.origin.x-1, sender.frame.origin.y-1, sender.frame.size.width+2, sender.frame.size.height+2);
    [UIView commitAnimations];
    
    NSString *st;
    
    
    if(selectedbtn==0)
        selectedFeed=[postsArr objectAtIndex:sender.tag];
    else
        selectedFeed=[likedArr objectAtIndex:sender.tag];
    
    
    
    if([UIImagePNGRepresentation([sender imageForState:UIControlStateNormal] )isEqualToData: UIImagePNGRepresentation([UIImage imageNamed:@"like_filled"])])
    {
        if(selectedbtn==0)
        {
            [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            [[postsArr objectAtIndex:sender.tag] setValue:@"0" forKey:@"like_status"];
            UIButton *v = (UIButton *)[tablev viewWithTag:6700+sender.tag];
            st=@"false";
            [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]-1] forState:UIControlStateNormal];
        }
        else
        {
            st=@"true";
            [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            [[likedArr objectAtIndex:sender.tag] setValue:@"0" forKey:@"like_status"];
            UIButton *v = (UIButton *)[tablev viewWithTag:6700+sender.tag];
            [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]-1] forState:UIControlStateNormal];
        }
    }
    else
    {
        if(selectedbtn==0)
        {
            st=@"true";
            [sender setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateNormal];
            
            [[postsArr objectAtIndex:sender.tag] setValue:@"1" forKey:@"like_status"];
            UIButton *v = (UIButton *)[tablev viewWithTag:6700+sender.tag];
            [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]+1] forState:UIControlStateNormal];
        }
        else
        {
            st=@"false";
            [sender setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateNormal];
            
            [[likedArr objectAtIndex:sender.tag] setValue:@"1" forKey:@"like_status"];
            UIButton *v = (UIButton *)[tablev viewWithTag:6700+sender.tag];
            [v setTitle:[NSString stringWithFormat:@"%d",[[v titleForState:UIControlStateNormal ]intValue]+1] forState:UIControlStateNormal];
        }
        
    }
    
    
    api_obj=[[APIViewController alloc]init];
    [api_obj likeOnFeed:@selector(getlikeresult:) tempTarget:self :[selectedFeed objectForKey:@"postid"] :st];
    
    
    
    
    
}

-(void)postdetailaction:(UIButton*)btn
{
    [self.mPlayer setVolume:0];
    if(selectedbtn==0)
    {
        if([[[postsArr objectAtIndex:btn.tag]valueForKey:@"post_type"] isEqualToString:@"public"]||[[[postsArr objectAtIndex:btn.tag]valueForKey:@"post_type"] isEqualToString:@"reshare"])
        {
            selectedFeed=[postsArr objectAtIndex:btn.tag];
        }
        else
        {
            selectedFeed=[postsArr objectAtIndex:btn.tag];
            [selectedFeed setValue:[selectedFeed valueForKey:@"parent_id"] forKey:@"postid"];
        }
    }
    else
    {
        if([[[likedArr objectAtIndex:btn.tag]valueForKey:@"post_type"] isEqualToString:@"public"]||[[[likedArr objectAtIndex:btn.tag]valueForKey:@"post_type"] isEqualToString:@"reshare"])
        {
            selectedFeed=[likedArr objectAtIndex:btn.tag];
        }
        else
        {
            selectedFeed=[likedArr objectAtIndex:btn.tag];
            [selectedFeed setValue:[selectedFeed valueForKey:@"parent_id"] forKey:@"postid"];
        }
        
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
- (void)userprofileButton_action:(UIButton*)sender
{
    if(selectedbtn==0)
        friendID=[postsArr[sender.tag] valueForKey:@"userid"];
    else
        friendID=[likedArr[sender.tag] valueForKey:@"userid"];
    
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
-(void)Likes:(UIButton*)sender
{
    NSMutableDictionary *dict;
    if(selectedbtn==0)
        dict=[postsArr objectAtIndex:sender.tag-6700];
    else
        dict=[likedArr objectAtIndex:sender.tag-6700];
    
    
    
    
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
-(void)playFullScreenVideo1:(UIButton*)sender
{
    [self.mPlayer pause];
    NSDictionary *dict;
    if(selectedbtn==0)
        dict=[postsArr[sender.tag]mutableCopy];
    else
        dict=[likedArr[sender.tag]mutableCopy];
    
    NSString *str=[dict valueForKey:@"url"];
    NSString *userid = [dict valueForKey:@"userid"];
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
            //            selectedFeed=[postsArr[sender.tag]mutableCopy];
            
            
            
            fullView=nil;
            fullView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            fullView.backgroundColor=[UIColor blackColor];
            
            //            selectedFeed=[postsArr[sender.tag]mutableCopy];
            //            NSMutableDictionary *dict=[selectedFeed mutableCopy];
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
            if(indexPost<postsArr.count-1)
                btnNext.tag=indexPost+1;
            else
                btnNext.tag=0;
            btnNext.frame = self.view.frame;
            [fullView addSubview:btnNext];
            UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            
            
            //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
            //longPress.minimumPressDuration = 0.4;
            //[btnNext addGestureRecognizer:longPress];
            
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
-(void)GetUserPost
{
    NSString *urlString=[NSString stringWithFormat:@"%@/GetPostPostedByUser/%@/%@/%@/%@",WEBURL1,userid,friendID,min,max];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            [LoaderViewController remove:self.view animated:YES];
            
            NSError *e;
            NSMutableDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            [self GetUserPostResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        [LoaderViewController remove:self.view animated:YES];
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self GetUserPostResult:nil];
        
    }];
    
    [operation start];
    
}
-(void)GetUserPostResult:(NSMutableDictionary*)dict
{
    if([[[dict valueForKey:@"response"] valueForKey:@"status"] isEqualToString:@"200"])
    {
        apicall=1;
        for(int i=0;i<[[dict valueForKey:@"userpost"] count];i++)
        {
            [postsArr addObject:[dict valueForKey:@"userpost"][i]];
        }
        
        downloadVideoCount=(int)postsArr.count;
        
        if([[dict valueForKey:@"userpost"] count])
        {
            stopLoader=NO;
            
        }
        else
        {
            
            [indicator removeFromSuperview];
            stopLoader=YES;
        }
        
        videoArray=[NSMutableArray new];
        
        downloadVideoCount=(int)postsArr.count;
        for(int i=0;i<(int)postsArr.count;i++)
        {
            [videoArray addObject:[postsArr objectAtIndex:i]];
        }
        [self btnImagesClick:0];
        if(selectedbtn==1)
        {
            
            CGRect f = tablev.frame;
            f.size.height = likedArr.count*700;
            tablev.frame =f;
            postCount_lbl.textColor=[UIColor whiteColor];
            followedCount_lbl.textColor=[UIColor whiteColor];
            [posts_Btn setImage:[UIImage imageNamed:@"posted"] forState:UIControlStateNormal];
            [liked_Btn setImage:[UIImage imageNamed:@"Likedb"] forState:UIControlStateNormal];
        }
        else
        {
            
            CGRect f = tablev.frame;
            f.size.height = postsArr.count*700;
            tablev.frame =f;
            selectedbtn=0;
            postCount_lbl.textColor=[UIColor whiteColor];
            followedCount_lbl.textColor=[UIColor whiteColor];
            [posts_Btn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
            [liked_Btn setImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
        }
        
        [tablev reloadData];
        
    }
    
}


-(void)GetFollowPost
{
    NSString *urlString=[NSString stringWithFormat:@"%@/GetFollowPostByCount/%@/%@/%@/%@",WEBURL1,userid,friendID,min,max];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            [LoaderViewController remove:self.view animated:YES];
            
            NSError *e;
            NSMutableDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            [self GetFollowPostResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        [LoaderViewController remove:self.view animated:YES];
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self GetFollowPostResult:nil];
        
    }];
    
    [operation start];
    
}
-(void)GetFollowPostResult:(NSMutableDictionary*)dict
{
    if([[[dict valueForKey:@"response"] valueForKey:@"status"] isEqualToString:@"200"])
    {
        for(int i=0;i<[[dict valueForKey:@"posts"] count];i++)
        {
            [likedArr addObject:[dict valueForKey:@"posts"][i]];
        }
        if([[dict valueForKey:@"posts"] count])
        {
            stopLoader=NO;
            
        }
        else
        {
            
            [indicator removeFromSuperview];
            stopLoader=YES;
        }
        
        
        downloadVideoCount1=(int)likedArr.count;
        
        
        [self btnImagesClick1:0];
        
        if(selectedbtn==1)
        {
            
            CGRect f = tablev.frame;
            f.size.height = likedArr.count*700;
            tablev.frame =f;
            postCount_lbl.textColor=[UIColor whiteColor];
            followedCount_lbl.textColor=[UIColor whiteColor];
            [posts_Btn setImage:[UIImage imageNamed:@"posted"] forState:UIControlStateNormal];
            [liked_Btn setImage:[UIImage imageNamed:@"Likedb"] forState:UIControlStateNormal];
        }
        else
        {
            
            CGRect f = tablev.frame;
            f.size.height = postsArr.count*700;
            tablev.frame =f;
            selectedbtn=0;
            postCount_lbl.textColor=[UIColor whiteColor];
            followedCount_lbl.textColor=[UIColor whiteColor];
            [posts_Btn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
            [liked_Btn setImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
        }
        
        
        [tablev reloadData];
        
    }
}
-(void)scrollTableOnNotification
{
    [mainScrlv setContentOffset:CGPointMake(0,mainScrlv.contentOffset.y+0.1) animated:YES];
}


@end
