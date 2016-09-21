//
//  onBordingViewController.m
//  Lively
//
//  Created by Brahmasys on 23/03/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "onBordingViewController.h"
#import "loginViewController.h"
#import "registerViewController.h"
#import "tabbarViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface onBordingViewController ()
{
    AVPlayer *avPlayer;
}

@end

@implementation onBordingViewController
-(BOOL) prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    

    CGRect oldFrame = imgLogo.frame;
    CGPoint oldCenter = imgLogo.center;
    
    imgLogo.frame = CGRectZero;
    imgLogo.center = oldCenter;
    
    imgLogo.hidden = NO;
    
    NSTimeInterval duration = 1;
    
    [UIView animateWithDuration:duration delay:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        // New position and size after the animation should be the same as in Interface Builder
        imgLogo.frame = oldFrame;
    }
                     completion:^(BOOL finished){
                         // You can do some stuff here after the animation finished
                     }];
    [super viewDidLoad];
    donebtn.enabled=false;

    self.navigationController.navigationBarHidden=YES;
    self.navigationController.navigationBar.translucent = NO;

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    donebtn.enabled=false;
    scrv.contentSize=CGSizeMake(self.view.frame.size.width*5, 0);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (IBAction)next_action:(id)sender
{
    
    if(scrv.contentOffset.x<self.view.frame.size.width*4)
    {
        [scrv setContentOffset:CGPointMake(scrv.contentOffset.x+self.view.frame.size.width, 0) animated:YES];
    }
    if(scrv.contentOffset.x==self.view.frame.size.width*3)
        donebtn.enabled=true;
    else
        donebtn.enabled=false;
}
- (IBAction)back_action:(id)sender
{
    if(scrv.contentOffset.x>0)
    {
        [scrv setContentOffset:CGPointMake(scrv.contentOffset.x-self.view.frame.size.width, 0) animated:YES];
    }
    if(scrv.contentOffset.x==self.view.frame.size.width*3)
        donebtn.enabled=true;
    else
        donebtn.enabled=false;
        
}
-(IBAction)LoginClick:(id)sender
{
    loginViewController *mvc;
    if(iphone4)
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController@6" bundle:nil];
    }
    
    else if(iphone6p)
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController@6p" bundle:nil];
    }
    
    else
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];

}
-(IBAction)SignUpClick:(id)sender
{
    registerViewController *mvc;
    if(iphone4)
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController@6" bundle:nil];
    }
    
    else if(iphone6p)
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController@6p" bundle:nil];
    }
    
    else
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
}
- (IBAction)done_action:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"done" forKey:@"onBoard"];
    [userDefaults synchronize];

    tabbarViewController *mvc;
    mvc=[[tabbarViewController alloc]init];
    AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
    nav.navigationBarHidden=YES;
    testAppDelegate.window.rootViewController=nav;
    
   }
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    avPlayer=[[AVPlayer alloc]init];
    if(scrv.contentOffset.x==self.view.frame.size.width)
    {
        
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            // New position and size after the animation should be the same as in Interface Builder
            dot1.center=CGPointMake(self.view.center.x-25,dot1.frame.origin.y+5);
            dot2.center=CGPointMake(self.view.center.x-50, dot1.frame.origin.y+5);
            dot3.center=CGPointMake(self.view.center.x, dot1.frame.origin.y+5);
            dot4.center=CGPointMake(self.view.center.x+25, dot1.frame.origin.y+5);
            dot5.center=CGPointMake(self.view.center.x+50, dot1.frame.origin.y+5);

        }
                         completion:^(BOOL finished){
                             // You can do some stuff here after the animation finished
                         }];

        
        

        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"share" ofType:@"mp4"];
        
        // - - -
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
        avPlayer =[AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer=[[AVPlayerLayer alloc]init];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
        playerLayer.frame = view1.bounds;
        [view1.layer addSublayer:playerLayer];
        [avPlayer play];
    }
    else if (scrv.contentOffset.x==self.view.frame.size.width*2)
    {
        
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            // New position and size after the animation should be the same as in Interface Builder
            dot1.center=CGPointMake(self.view.center.x,dot1.frame.origin.y+5);
            dot2.center=CGPointMake(self.view.center.x-50, dot1.frame.origin.y+5);
            dot3.center=CGPointMake(self.view.center.x-25, dot1.frame.origin.y+5);
            dot4.center=CGPointMake(self.view.center.x+25, dot1.frame.origin.y+5);
            dot5.center=CGPointMake(self.view.center.x+50, dot1.frame.origin.y+5);

            
        }
                         completion:^(BOOL finished){
                             // You can do some stuff here after the animation finished
                         }];

        

        NSString *path = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"mp4"];
        
        // - - -
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
        avPlayer =[AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer=[[AVPlayerLayer alloc]init];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];        playerLayer.frame = view2.bounds;
        [view2.layer addSublayer:playerLayer];
        [avPlayer play];

    }
    else if (scrv.contentOffset.x==self.view.frame.size.width*3)
    {

        
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            // New position and size after the animation should be the same as in Interface Builder
            dot1.center=CGPointMake(self.view.center.x+25,dot1.frame.origin.y+5);
            dot2.center=CGPointMake(self.view.center.x-50, dot1.frame.origin.y+5);
            dot3.center=CGPointMake(self.view.center.x-25, dot1.frame.origin.y+5);
            dot4.center=CGPointMake(self.view.center.x, dot1.frame.origin.y+5);
            dot5.center=CGPointMake(self.view.center.x+50, dot1.frame.origin.y+5);
            
            
        }
                         completion:^(BOOL finished){
                             // You can do some stuff here after the animation finished
                         }];

        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"profile" ofType:@"mp4"];
        
        // - - -
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
        avPlayer =[AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer=[[AVPlayerLayer alloc]init];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];        playerLayer.frame = view3.bounds;
        [view3.layer addSublayer:playerLayer];
        [avPlayer play];
    }
    else if (scrv.contentOffset.x==self.view.frame.size.width*4)
    {


        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            // New position and size after the animation should be the same as in Interface Builder
            dot1.center=CGPointMake(self.view.center.x+50,dot1.frame.origin.y+5);
            dot2.center=CGPointMake(self.view.center.x-50, dot1.frame.origin.y+5);
            dot3.center=CGPointMake(self.view.center.x-25, dot1.frame.origin.y+5);
            dot4.center=CGPointMake(self.view.center.x, dot1.frame.origin.y+5);
            dot5.center=CGPointMake(self.view.center.x+25, dot1.frame.origin.y+5);
            
            
            
        }
                         completion:^(BOOL finished){
                             // You can do some stuff here after the animation finished
                         }];

        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"final" ofType:@"mp4"];
        
        // - - -
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
        avPlayer =[AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer=[[AVPlayerLayer alloc]init];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];        playerLayer.frame = view4.bounds;
        [view4.layer addSublayer:playerLayer];
        [avPlayer play];

    }
    else if (scrv.contentOffset.x==0)
    {
         [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        dot1.center=CGPointMake(self.view.center.x-50,dot1.frame.origin.y+5);
        dot2.center=CGPointMake(self.view.center.x-25, dot1.frame.origin.y+5);
        dot3.center=CGPointMake(self.view.center.x, dot1.frame.origin.y+5);
        dot4.center=CGPointMake(self.view.center.x+25, dot1.frame.origin.y+5);
        dot5.center=CGPointMake(self.view.center.x+50, dot1.frame.origin.y+5);
         }
                          completion:^(BOOL finished){
                              // You can do some stuff here after the animation finished
                          }];

        CGRect oldFrame = imgLogo.frame;
        CGPoint oldCenter = imgLogo.center;
        
        imgLogo.frame = CGRectZero;
        imgLogo.center = oldCenter;
        
        imgLogo.hidden = NO;
        
        NSTimeInterval duration = 1;
        
        [UIView animateWithDuration:duration delay:0.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            // New position and size after the animation should be the same as in Interface Builder
            imgLogo.frame = oldFrame;
        }
                         completion:^(BOOL finished){
                             // You can do some stuff here after the animation finished
                         }];

    }
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrv.contentOffset.x==self.view.frame.size.width*4)
        donebtn.enabled=true;
    else
        donebtn.enabled=false;
 
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView
{


}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrv.contentOffset.x>self.view.frame.size.width*4)
    {
        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];

        dot1.center=CGPointMake(self.view.center.x-50,dot1.frame.origin.y+5);
        dot2.center=CGPointMake(self.view.center.x-25, dot1.frame.origin.y+5);
        dot3.center=CGPointMake(self.view.center.x, dot1.frame.origin.y+5);
        dot4.center=CGPointMake(self.view.center.x+25, dot1.frame.origin.y+5);
        dot5.center=CGPointMake(self.view.center.x+50, dot1.frame.origin.y+5);
        CGRect oldFrame = imgLogo.frame;
        CGPoint oldCenter = imgLogo.center;
        
        imgLogo.frame = CGRectZero;
        imgLogo.center = oldCenter;
        
        imgLogo.hidden = NO;
        
        NSTimeInterval duration = 1;
        
        [UIView animateWithDuration:duration delay:0.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            // New position and size after the animation should be the same as in Interface Builder
            imgLogo.frame = oldFrame;
        }
                         completion:^(BOOL finished){
                             // You can do some stuff here after the animation finished
                         }];

    }
    
}


@end
