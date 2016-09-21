//
//  tabbarViewController.m
//  Huntway
//
//  Created by Suffescom solutions on 19/05/14.
//  Copyright (c) 2014 Suffescom. All rights reserved.
//

#import "tabbarViewController.h"
#import "userProfileViewController.h"
#import "homeViewController.h"
#import "searchViewController.h"
#import "notificationViewController.h"
#import "SCRecorderViewController.h"
@interface tabbarViewController ()
{
    UILabel *Notification_count_lbl;
}
@end

@implementation tabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    tabbar=[[UITabBarController alloc]init];
    tabbar.delegate=self;
    homeViewController *hvc;
    if(iphone5)
        hvc=[[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
    else if (iphone6)
        hvc=[[homeViewController alloc]initWithNibName:@"homeViewController@6" bundle:nil];
    else if (iphone6p)
        hvc=[[homeViewController alloc]initWithNibName:@"homeViewController@6p" bundle:nil];
    else if (iphone4)
        hvc=[[homeViewController alloc]initWithNibName:@"homeViewController@4" bundle:nil];
    else
    {
        
    }
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:hvc];
//    hvc.title=@"";
//    hvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    hvc.tabBarItem.image=[[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    hvc.tabBarItem.selectedImage=[[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    searchViewController *ajvc;
    if(iphone5)
        ajvc=[[searchViewController alloc]initWithNibName:@"searchViewController" bundle:nil];
    else if (iphone6)
        ajvc=[[searchViewController alloc]initWithNibName:@"searchViewController@6" bundle:nil];
    else if (iphone6p)
        ajvc=[[searchViewController alloc]initWithNibName:@"searchViewController@6p" bundle:nil];
    else if (iphone4)
        ajvc=[[searchViewController alloc]initWithNibName:@"searchViewController@4" bundle:nil];
    else
    {
        
    }
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:ajvc];
//    ajvc.title=@"";
//    ajvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    ajvc.tabBarItem.image=[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    ajvc.tabBarItem.selectedImage=[[UIImage imageNamed:@"search_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SCRecorderViewController *mevc;
    
    if(iphone5)
        mevc=[[SCRecorderViewController alloc]initWithNibName:@"SCRecorderViewController" bundle:nil];
    else if (iphone6)
        mevc=[[SCRecorderViewController alloc]initWithNibName:@"SCRecorderViewController@6" bundle:nil];
    else if (iphone6p)
        mevc=[[SCRecorderViewController alloc]initWithNibName:@"SCRecorderViewController@6p" bundle:nil];
    else if (iphone4)
        mevc=[[SCRecorderViewController alloc]initWithNibName:@"SCRecorderViewController@4" bundle:nil];
    else
    {
        
    }

    
//    cameraViewController *mevc;
//    
//    if(iphone5)
//        mevc=[[cameraViewController alloc]initWithNibName:@"cameraViewController" bundle:nil];
//    else if (iphone6)
//        mevc=[[cameraViewController alloc]initWithNibName:@"cameraViewController@6" bundle:nil];
//    else if (iphone6p)
//        mevc=[[cameraViewController alloc]initWithNibName:@"cameraViewController@6p" bundle:nil];
//    else if (iphone4)
//        mevc=[[cameraViewController alloc]initWithNibName:@"cameraViewController@4" bundle:nil];
//    else
//    {
//        
//    }
    
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:mevc];
    mevc.title=@"";
    mevc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    
    mevc.tabBarItem.image=[[UIImage imageNamed:@"camIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mevc.tabBarItem.selectedImage=[[UIImage imageNamed:@"camIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    
    
    notificationViewController *hmvc;
    if(iphone5)
        hmvc=[[notificationViewController alloc]initWithNibName:@"notificationViewController" bundle:nil];
    else if (iphone6)
        hmvc=[[notificationViewController alloc]initWithNibName:@"notificationViewController@6" bundle:nil];
    else if (iphone6p)
        hmvc=[[notificationViewController alloc]initWithNibName:@"notificationViewController@6p" bundle:nil];
    else if (iphone4)
        hmvc=[[notificationViewController alloc]initWithNibName:@"notificationViewController@4" bundle:nil];
    else
    {
        
    }
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:hmvc];
//    hmvc.title=@"";
//     hmvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//       hmvc.tabBarItem.image=[[UIImage imageNamed:@"notification"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
//       hmvc.tabBarItem.selectedImage=[[UIImage imageNamed:@"notification_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    userProfileViewController *upvc;
    if(iphone5)
        upvc=[[userProfileViewController alloc]initWithNibName:@"userProfileViewController" bundle:nil];
    else if (iphone6)
        upvc=[[userProfileViewController alloc]initWithNibName:@"userProfileViewController@6" bundle:nil];
    else if (iphone6p)
        upvc=[[userProfileViewController alloc]initWithNibName:@"userProfileViewController@6p" bundle:nil];
    else if (iphone4)
        upvc=[[userProfileViewController alloc]initWithNibName:@"userProfileViewController@4" bundle:nil];
    else
    {
        
    }
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:upvc];
//    upvc.title=@"";
//    upvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    upvc.tabBarItem.image=[[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
//    upvc.tabBarItem.selectedImage=[[UIImage imageNamed:@"profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
   //if(iphone6 || iphone6p)
        [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
//      else
//[[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"footer"]];
    
    
  //  UIImage *whiteBackground = [UIImage imageNamed:@"tab_bar_selected"];
   // [[UITabBar appearance] setSelectionIndicatorImage:whiteBackground];
    
        //[[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor:[UIColor clearColor]];
       // [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
//    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] } forState:UIControlStateSelected];
    
    
   // UIImage *NavigationPortraitBackground = [[UIImage imageNamed:@"topbar_bg.jpg"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    int x=self.view.frame.size.width/5;
    
    imgFirst=[[UIImageView alloc]initWithFrame:CGRectMake(x/2-10, 8, 25, 25)];
    [imgFirst setImage:[UIImage imageNamed:@"home_selected"]];
    [tabbar.tabBar addSubview:imgFirst];
    
    imgSecond=[[UIImageView alloc]initWithFrame:CGRectMake(x+x/2-10, 8, 25, 25)];
    [imgSecond setImage:[UIImage imageNamed:@"search"]];
    [tabbar.tabBar addSubview:imgSecond];
    
    imgThird=[[UIImageView alloc]initWithFrame:CGRectMake(3*x+x/2-5, 8, 25, 25)];
    [imgThird setImage:[UIImage imageNamed:@"notification"]];
    [tabbar.tabBar addSubview:imgThird];
    
   imgFourth=[[UIImageView alloc]initWithFrame:CGRectMake(4*x+x/2-5, 8, 25, 25)];
    [imgFourth setImage:[UIImage imageNamed:@"profile"]];
    [tabbar.tabBar addSubview:imgFourth];
    
    NSLog(@"%f",tabbar.tabBar.frame.size.width/4);
    Notification_count_lbl = [[UILabel alloc]initWithFrame:CGRectMake(((tabbar.tabBar.frame.size.width/4)*3)-13,2,18,18)];
    Notification_count_lbl.text = @"";
    Notification_count_lbl.font=[UIFont systemFontOfSize:9];
    Notification_count_lbl.backgroundColor = [UIColor purpleColor];
    Notification_count_lbl.textColor = [UIColor whiteColor];
    Notification_count_lbl.textAlignment = NSTextAlignmentCenter;
    Notification_count_lbl.layer.cornerRadius=9;
    Notification_count_lbl.clipsToBounds = YES;
    [tabbar.tabBar addSubview:Notification_count_lbl];
    Notification_count_lbl.hidden=YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UserSelected:)
                                                 name:@"UserSelected"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"NotificationCount"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NotificationRedirectAction:)
                                                 name:@"NotificationRedirect"
                                               object:nil];

    tabbar.viewControllers=[NSArray arrayWithObjects:nav,nav1,nav2,nav3,nav4, nil];
    if(notificationscren==1)
    {
        tabbar.selectedIndex = 3;
        
    }
    [self.view addSubview:tabbar.view];
    
    
    
       // Do any additional setup after loading the view.
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController1{
    
    int x=self.view.frame.size.width/5;
    if (viewController1 == [tabbar.viewControllers objectAtIndex:0])
        
    {
        selectedIndex=0;
        [imgFirst removeFromSuperview];
        
        imgFirst=[[UIImageView alloc]init ];
              
        [imgFirst setImage:[UIImage imageNamed:@"home_selected"]];
        [tabbar.tabBar addSubview:imgFirst];
        imgFirst.frame = CGRectMake(x/2-10, 8, 20, 20);
        [UIView beginAnimations:@"Zoom" context:NULL];
        [UIView setAnimationDuration:0.5];
        imgFirst.frame = CGRectMake(x/2-10, 8, 25, 25);
        [UIView commitAnimations];
        
        
        [imgSecond removeFromSuperview];
        imgSecond=[[UIImageView alloc]initWithFrame:CGRectMake(x+x/2-10, 8, 25, 25)];
        [imgSecond setImage:[UIImage imageNamed:@"search"]];
        [tabbar.tabBar addSubview:imgSecond];
        
        [imgThird removeFromSuperview];
        imgThird=[[UIImageView alloc]initWithFrame:CGRectMake(3*x+x/2-5, 8, 25, 25)];
        [imgThird setImage:[UIImage imageNamed:@"notification"]];
        [tabbar.tabBar addSubview:imgThird];
        
        [imgFourth removeFromSuperview];
        imgFourth=[[UIImageView alloc]initWithFrame:CGRectMake(4*x+x/2-5, 8, 25, 25)];
        [imgFourth setImage:[UIImage imageNamed:@"profile"]];
        [tabbar.tabBar addSubview:imgFourth];
        
        
    }
    else if (viewController1 == [tabbar.viewControllers objectAtIndex:1])
        
    {
        selectedIndex=1;

        [imgFirst removeFromSuperview];
        imgFirst=[[UIImageView alloc]initWithFrame:CGRectMake(x/2-10, 8, 25, 25)];
        [imgFirst setImage:[UIImage imageNamed:@"home"]];
        [tabbar.tabBar addSubview:imgFirst];
        
        [imgSecond removeFromSuperview];
        imgSecond=[[UIImageView alloc]init];
        [imgSecond setImage:[UIImage imageNamed:@"search_selected"]];
        [tabbar.tabBar addSubview:imgSecond];
        imgSecond.frame = CGRectMake(x+x/2-10, 8, 20, 20);
        [UIView beginAnimations:@"Zoom" context:NULL];
        [UIView setAnimationDuration:0.5];
        imgSecond.frame = CGRectMake(x+x/2-10, 8, 25, 25);
        [UIView commitAnimations];
        
        [imgThird removeFromSuperview];
        imgThird=[[UIImageView alloc]initWithFrame:CGRectMake(3*x+x/2-5, 8, 25, 25)];
        [imgThird setImage:[UIImage imageNamed:@"notification"]];
        [tabbar.tabBar addSubview:imgThird];
        
        [imgFourth removeFromSuperview];
        imgFourth=[[UIImageView alloc]initWithFrame:CGRectMake(4*x+x/2-5, 8, 25, 25)];
        [imgFourth setImage:[UIImage imageNamed:@"profile"]];
        [tabbar.tabBar addSubview:imgFourth];

    }
    else if (viewController1 == [tabbar.viewControllers objectAtIndex:3])
        
    {
        selectedIndex=3;

        [imgFirst removeFromSuperview];
        imgFirst=[[UIImageView alloc]initWithFrame:CGRectMake(x/2-10, 8, 25, 25)];
        [imgFirst setImage:[UIImage imageNamed:@"home"]];
        [tabbar.tabBar addSubview:imgFirst];
        
        [imgSecond removeFromSuperview];
        imgSecond=[[UIImageView alloc]initWithFrame:CGRectMake(x+x/2-10, 8, 25, 25)];
        [imgSecond setImage:[UIImage imageNamed:@"search"]];
        [tabbar.tabBar addSubview:imgSecond];
        
        [imgThird removeFromSuperview];
        imgThird=[[UIImageView alloc]init];
        [imgThird setImage:[UIImage imageNamed:@"notification_selected"]];
        [tabbar.tabBar addSubview:imgThird];
        imgThird.frame = CGRectMake(3*x+x/2-5, 8, 20, 20);
        [UIView beginAnimations:@"Zoom" context:NULL];
        [UIView setAnimationDuration:0.5];
        imgThird.frame = CGRectMake(3*x+x/2-5, 8, 25, 25);
        [UIView commitAnimations];
        
        
        
        [imgFourth removeFromSuperview];
        imgFourth=[[UIImageView alloc]initWithFrame:CGRectMake(4*x+x/2-5, 8, 25, 25)];
        [imgFourth setImage:[UIImage imageNamed:@"profile"]];
        [tabbar.tabBar addSubview:imgFourth];
        
    }
    else if (viewController1 == [tabbar.viewControllers objectAtIndex:4])
    {
        selectedIndex=4;

        [imgFirst removeFromSuperview];
        imgFirst=[[UIImageView alloc]initWithFrame:CGRectMake(x/2-10, 8, 25, 25)];
        [imgFirst setImage:[UIImage imageNamed:@"home"]];
        [tabbar.tabBar addSubview:imgFirst];
        
        [imgSecond removeFromSuperview];
        imgSecond=[[UIImageView alloc]initWithFrame:CGRectMake(x+x/2-10, 8, 25, 25)];
        [imgSecond setImage:[UIImage imageNamed:@"search"]];
        [tabbar.tabBar addSubview:imgSecond];
        
        [imgThird removeFromSuperview];
        imgThird=[[UIImageView alloc]initWithFrame:CGRectMake(3*x+x/2-5, 8, 25, 25)];
        [imgThird setImage:[UIImage imageNamed:@"notification"]];
        [tabbar.tabBar addSubview:imgThird];
        
        [imgFourth removeFromSuperview];
        imgFourth=[[UIImageView alloc]initWithFrame:CGRectMake(4*x+x/2-5, 8, 30, 30)];
        [imgFourth setImage:[UIImage imageNamed:@"profile_selected"]];
        [tabbar.tabBar addSubview:imgFourth];
        
        imgFourth.frame = CGRectMake(4*x+x/2-5, 8, 20, 20);
        [UIView beginAnimations:@"Zoom" context:NULL];
        [UIView setAnimationDuration:0.5];
        imgFourth.frame = CGRectMake(4*x+x/2-5, 8, 25, 25);
        [UIView commitAnimations];
        
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) UserSelected:(NSNotification *)sourceDictionary
{   int x=self.view.frame.size.width/5;
    [imgFirst removeFromSuperview];
    imgFirst=[[UIImageView alloc]initWithFrame:CGRectMake(x/2-10, 8, 25, 25)];
    [imgFirst setImage:[UIImage imageNamed:@"home"]];
    [tabbar.tabBar addSubview:imgFirst];
    
    [imgSecond removeFromSuperview];
    imgSecond=[[UIImageView alloc]initWithFrame:CGRectMake(x+x/2-10, 8, 25, 25)];
    [imgSecond setImage:[UIImage imageNamed:@"search"]];
    [tabbar.tabBar addSubview:imgSecond];
    
    [imgThird removeFromSuperview];
    imgThird=[[UIImageView alloc]initWithFrame:CGRectMake(3*x+x/2-5, 8, 25, 25)];
    [imgThird setImage:[UIImage imageNamed:@"notification"]];
    [tabbar.tabBar addSubview:imgThird];
    
    [imgFourth removeFromSuperview];
    imgFourth=[[UIImageView alloc]initWithFrame:CGRectMake(4*x+x/2-5, 8, 30, 30)];
    [imgFourth setImage:[UIImage imageNamed:@"profile_selected"]];
    [tabbar.tabBar addSubview:imgFourth];
    
    imgFourth.frame = CGRectMake(4*x+x/2-5, 8, 20, 20);
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.5];
    imgFourth.frame = CGRectMake(4*x+x/2-5, 8, 25, 25);
    [UIView commitAnimations];
}
- (void) NotificationRedirectAction:(NSNotification *)sourceDictionary
{
    if(notificationscren==1)
    {
        tabbar.selectedIndex = 3;
        
    }
}
- (void) receiveTestNotification:(NSNotification *)sourceDictionary
{
    if(Noti_Count>0)
    {
    Notification_count_lbl.hidden=false;
    Notification_count_lbl.text=[NSString stringWithFormat:@"%d",Noti_Count];
    }
    else
    {
      Notification_count_lbl.hidden=YES;
    }
    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
