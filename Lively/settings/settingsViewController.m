//
//  settingsViewController.m
//  Lively
//
//  Created by Vinay Sharma on 07/01/16.
//  Copyright (c) 2016 Brahmasys. All rights reserved.
//

#import "settingsViewController.h"
#import "loginViewController.h"
#import "AppDelegate.h"
#import "editProfileViewController.h"
#import "blockedUSerViewController.h"
#import "hidePostViewController.h"
#import "likedVideoViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AsyncImageView.h"
#import "privacyTermsViewController.h"
#import "termofServiceViewController.h"

#import "AGPushNoteView.h"

@interface settingsViewController ()
{
    APIViewController *api_obj;
    UIView *shareView;
    BOOL noti_status,private_status;
    int anim;
    NSTimer *tm;
    SLComposeViewController *slComposer;

}
@end

@implementation settingsViewController

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
    screenName=@"setting";

    arrSettings=[NSArray arrayWithObjects:@"Edit Profile",@"Notification",@"Private Profile",@"Invite Friends",@"Share On Social Media",@"Liked Videos",@"Hide Post",@"Blocked User",@"Privacy Policy",@"Help",@"Terms of Service",@"Logout",@"Deactivate Account", nil];
    [super viewDidLoad];
    
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"on" forKey:@"loc"];
        [userDefaults synchronize];
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"off" forKey:@"loc"];
        [userDefaults synchronize];
    }
    

    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getNotificationStatus:@selector(getNotificationStatusResult:) tempTarget:self];
    
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetNotificationStatus/%@",appUrl,userid];
    
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
            
            [self getNotificationStatusResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getNotificationStatusResult:nil];
        
    }];
    
    [operation start];
    
    // Do any additional setup after loading the view from its nib.
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
}
-(void)getNotificationStatusResult:(NSMutableDictionary*)dict_Response
{
    NSLog(@"%@",dict_Response);
    
    
    
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        
        if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){
            if([[dict_Response objectForKey:@"ntfcn_status"] boolValue]==1)
            {
                noti_status=true;
                
                
            }
            else
            {
                noti_status=false;
            }
            if([[dict_Response objectForKey:@"privacy_Status"] boolValue]==1)
            {
                private_status=true;
                
            }
            else
            {
                private_status=false;
            }

        }
    }
    [tblSettings reloadData];
}
#pragma mark Table View Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSettings.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    
    UIView *viewLine=[[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width-55, 1)];
    [viewLine setBackgroundColor:[UIColor lightGrayColor]];
    [viewLine setAlpha:0.1];
    [cell addSubview:viewLine];
    
    
    UIFont * myFont = [UIFont fontWithName:@"System" size:13];
    CGRect labelFrame = CGRectMake (10, 5, 310, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor grayColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:arrSettings[indexPath.row]];
    [cell addSubview:label];
    
    if(indexPath.row==1)
    {
        UISwitch *onoff = [[UISwitch alloc] initWithFrame: CGRectZero];
        [onoff addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
        onoff.tag=indexPath.row;
        onoff.onTintColor = [UIColor purpleColor];
        cell.accessoryView=onoff;
        if(noti_status==1)
        {
            
            [onoff setOn:YES];
            
        }
        else
        {
            [onoff setOn:NO];
        }
    }
    if(indexPath.row==2)
    {
        UISwitch *onoff = [[UISwitch alloc] initWithFrame: CGRectZero];
        [onoff addTarget: self action: @selector(privateProfileAction:) forControlEvents:UIControlEventValueChanged];
        onoff.tag=indexPath.row;
        onoff.onTintColor = [UIColor purpleColor];
        cell.accessoryView=onoff;
        if(private_status==1)
        {
            
            [onoff setOn:YES];
            
        }
        else
        {
            [onoff setOn:NO];
        }
    }

    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"high" forKey:@"quality"];
            [userDefaults synchronize];
            break;
        }
        case 1:{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"low" forKey:@"quality"];
            [userDefaults synchronize];
            break;
        }
    }
}
- (void)privateProfileAction:(UISwitch*)sender {
    
    NSString *value;
    if (sender.on)
    {
        value=@"true";

    }
    
    else
    {
        value=@"false";
 
        
    }
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/UpdateProfilePrivacy/%@/%@",appUrl,userid,value];
    
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
            
            [self notiChange:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self notiChange:nil];
        
    }];
    
    [operation start];

    

   
}
- (void)flip:(UISwitch*)sender {
     if(sender.tag==1)
    {
        NSString *value;
        if (sender.on)
        {
            value=@"true";
         
        }
        
        else
        {
             value=@"false";
       
            
        }
        NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/ChangeNotification/%@/%@",appUrl,userid,value];
        
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
                
                [self notiChange:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self notiChange:nil];
            
        }];
        
        [operation start];
        

    }
    
}
-(void)notiChange:(UIButton*)btn
{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        
        
        editProfileViewController *mvc;
        if(iphone4)
        {
            mvc=[[editProfileViewController alloc]initWithNibName:@"editProfileViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[editProfileViewController alloc]initWithNibName:@"editProfileViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[editProfileViewController alloc]initWithNibName:@"editProfileViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[editProfileViewController alloc]initWithNibName:@"editProfileViewController@6P" bundle:nil];
        }
        else
        {
            mvc=[[editProfileViewController alloc]initWithNibName:@"editProfileViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];

    }
    else if(indexPath.row==5)
    {
        likedVideoViewController *mvc;
        if(iphone4)
        {
            mvc=[[likedVideoViewController alloc]initWithNibName:@"likedVideoViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[likedVideoViewController alloc]initWithNibName:@"likedVideoViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[likedVideoViewController alloc]initWithNibName:@"likedVideoViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[likedVideoViewController alloc]initWithNibName:@"likedVideoViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[likedVideoViewController alloc]initWithNibName:@"likedVideoViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }
    else if(indexPath.row==6)
    {
        
        hidePostViewController *mvc;
        if(iphone4)
        {
            mvc=[[hidePostViewController alloc]initWithNibName:@"hidePostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[hidePostViewController alloc]initWithNibName:@"hidePostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[hidePostViewController alloc]initWithNibName:@"hidePostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[hidePostViewController alloc]initWithNibName:@"hidePostViewController@6P" bundle:nil];
        }
        else
        {
            mvc=[[hidePostViewController alloc]initWithNibName:@"hidePostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
        
    }
    
    else if(indexPath.row==7)
    {
        
        blockedUSerViewController *mvc;
        if(iphone4)
        {
            mvc=[[blockedUSerViewController alloc]initWithNibName:@"blockedUSerViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[blockedUSerViewController alloc]initWithNibName:@"blockedUSerViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[blockedUSerViewController alloc]initWithNibName:@"blockedUSerViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[blockedUSerViewController alloc]initWithNibName:@"blockedUSerViewController@6P" bundle:nil];
        }
        else
        {
            mvc=[[blockedUSerViewController alloc]initWithNibName:@"blockedUSerViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
        
    }
    else if(indexPath.row==8)
    {
        
        privacyTermsViewController *mvc;
        if(iphone4)
        {
            mvc=[[privacyTermsViewController alloc]initWithNibName:@"privacyTermsViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[privacyTermsViewController alloc]initWithNibName:@"privacyTermsViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[privacyTermsViewController alloc]initWithNibName:@"privacyTermsViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[privacyTermsViewController alloc]initWithNibName:@"privacyTermsViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[privacyTermsViewController alloc]initWithNibName:@"privacyTermsViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
        
    }
    else if(indexPath.row==10)
    {
        
        termofServiceViewController *mvc;
        if(iphone4)
        {
            mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
        
    }
    
    else if(indexPath.row==arrSettings.count-2)
    {
        UIAlertView* alert1 = [[UIAlertView alloc] init];
        [alert1 setDelegate:self];
        [alert1 setTitle:@""];
        [alert1 setMessage:@"Do you want to Logout? "];
        [alert1 addButtonWithTitle:@"Yes"];
        [alert1 addButtonWithTitle:@"No"];
        alert1.tag=6;
        alert1.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert1 show];
        
    }
    else if(indexPath.row==arrSettings.count-1)
    {
        UIAlertView* alert1 = [[UIAlertView alloc] init];
        [alert1 setDelegate:self];
        [alert1 setTitle:@""];
        [alert1 setMessage:@"Do you want to Deactivate your account? "];
        [alert1 addButtonWithTitle:@"Yes"];
        [alert1 addButtonWithTitle:@"No"];
        alert1.tag=9;
        alert1.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert1 show];
        
    }

    else if(indexPath.row==9)
    {
        NSURL *url = [NSURL URLWithString:@"http://liveieapp.com/"];
        
        if (![[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
    }
    else if(indexPath.row==3)
    {
        FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
        content.appLinkURL = [NSURL URLWithString:@"https://fb.me/628160487332608"];
        //optionally set previewImageURL
//        content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
        [FBSDKAppInviteDialog showWithContent:content delegate:nil];

    }
    else if(indexPath.row==4)
    {
        
        shareView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        shareView.backgroundColor=[UIColor blackColor];
        shareView.alpha=0.0;

        NSArray *buttonArray = [[NSArray alloc]initWithObjects:@"Facebook",@"Instagram",@"Twitter",@"What's app",@"Email",@"Contacts",@"Cancel", nil];
        NSArray *imageArray = [[NSArray alloc]initWithObjects:@"facebook",@"instagram",@"twitter",@"whatsapp",@"msg",@"contact",@"cancelbutton", nil];
        int y=70;
        for(int i=0;i<buttonArray.count;i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(socialMediaShare:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i+1;
            button.alpha=0.0;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setTitle:buttonArray[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(55, y, 150, 40);
            [shareView addSubview:button];
            

            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(20, y+10, 20, 20)];
            img.tag=i+200+1;
            img.alpha=0.0;
            img.image=[UIImage imageNamed:imageArray[i]];
            [shareView addSubview:img];
            
            y=y+50;
        }
        
        [self.view addSubview:shareView];
        [UIView beginAnimations:@"Zoom" context:NULL];
        [UIView setAnimationDuration:0.1];
        shareView.alpha=0.8;
        [UIView commitAnimations];
        
        anim=1;
     tm=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(buttonShowAnimation)userInfo:nil repeats:YES];
        
    }
    
}

-(IBAction)backButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==6)
    {
        if(buttonIndex==0)
        {
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookieJar = [storage cookies];
            
            for (NSHTTPCookie *cookie in cookieJar)
            {
                [storage deleteCookie:cookie];
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"" forKey:@"userid"];
            [userDefaults setObject:@"" forKey:@"profilepic"];
            [userDefaults setObject:@"" forKey:@"wallImage"];
            [userDefaults setObject:@"" forKey:@"name"];
            [userDefaults setObject:@"" forKey:@"followers"];
            [userDefaults setObject:@"" forKey:@"followings"];
            [userDefaults setObject:@"" forKey:@"profile_pic"];
            [userDefaults setObject:@"" forKey:@"wall_image"];

            [userDefaults synchronize];
            
           
            

            
            
            NSError *error;
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"HomeEntries"];
            NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
            if (objects1 == nil) {
                // handle error
            } else {
                for (NSManagedObject *object in objects1) {
                    [context deleteObject:object];
                }
                [context save:&error];
            }

            [LoaderViewController show:self.view animated:YES];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(logout) userInfo:nil repeats:NO];
            
        }
        
    }
    if (alertView.tag==9)
    {
        if(buttonIndex==0)
        {
         
            
                UIAlertView* alert1 = [[UIAlertView alloc] init];
                [alert1 setDelegate:self];
                [alert1 setTitle:@""];
                [alert1 setMessage:@"Please Enter your password to deactivate."];
                [alert1 addButtonWithTitle:@"Yes"];
                [alert1 addButtonWithTitle:@"No"];
                alert1.tag=10;
                alert1.alertViewStyle = UIAlertViewStyleSecureTextInput;
                
                [alert1 show];
            }
        
           
            
        }
    if(alertView.tag==10)
    {
        if(buttonIndex==0)
        {
        UITextField *textField = [alertView textFieldAtIndex:0];
        strPass = textField.text;
        [LoaderViewController show:self.view animated:YES];
        [self deleteAccount];
        }
    }
        
    

}
-(void)logout
{
    [LoaderViewController remove:self.view animated:YES];
    loginViewController *login;
    if(iphone5)
    {
        login=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
        
    }
    else if(iphone4)
    {
        login=[[loginViewController alloc]initWithNibName:@"loginViewController@4" bundle:nil];
    }
    else if(iphone6)
    {
        login=[[loginViewController alloc]initWithNibName:@"loginViewController@6" bundle:nil];
    }

    else if(iphone6p)
    {
        login=[[loginViewController alloc]initWithNibName:@"loginViewController@6p" bundle:nil];
    }

    else
    {
        login=[[loginViewController alloc]initWithNibName:@"loginViewController@ipad" bundle:nil];
        
    }
    
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
    AppDelegate* blah = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    blah.window.rootViewController= nav  ;
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{

    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    

    //[scrolv removeFromSuperview];
    
}

-(void)deleteAccount
{
    NSString *urlString=[NSString stringWithFormat:@"%@/UserServices.svc/DeleteUserAccount/%@/%@",appUrl,userid,strPass];
    
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
            
            [self deleteAccountResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Account not deleted,Please try after some time" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [LoaderViewController remove:self.view animated:YES];

    }];
    
    [operation start];

}
-(void)deleteAccountResult:(NSMutableDictionary*)dict_Response
{
    NSLog(@"%@",dict_Response);
    
    [LoaderViewController remove:self.view animated:YES];
    
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        
        if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){
            
            
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookieJar = [storage cookies];
            
            for (NSHTTPCookie *cookie in cookieJar)
            {
                [storage deleteCookie:cookie];
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"" forKey:@"userid"];
            [userDefaults setObject:@"" forKey:@"profilepic"];
            [userDefaults setObject:@"" forKey:@"wallImage"];
            [userDefaults synchronize];
            
            
            
            NSError *error;
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"HomeEntries"];
            NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
            if (objects1 == nil) {
                // handle error
            } else {
                for (NSManagedObject *object in objects1) {
                    [context deleteObject:object];
                }
                [context save:&error];
            }
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(logout) userInfo:nil repeats:NO];
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Liveie" message:@"Please Enter the correct password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
}

}
-(void)buttonShowAnimation
{
    UIButton* btn = [shareView viewWithTag:anim];
    UIImageView* img = [shareView viewWithTag:200+anim];
    
    anim++;
    if(anim==8)
        [tm invalidate];
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.1];
    btn.alpha=0.8;
    img.alpha=0.8;
    
    [UIView commitAnimations];
}
-(void)buttonhideAnimation
{
    UIButton* btn = [shareView viewWithTag:anim];
    UIImageView* img = [shareView viewWithTag:200+anim];
    
    anim--;
    
    [UIView beginAnimations:@"Zoom" context:NULL];
    [UIView setAnimationDuration:0.1];
    btn.alpha=0.0;
    img.alpha=0.0;
    
    [UIView commitAnimations];
    if(anim==1)
    {
        [tm invalidate];
        [shareView removeFromSuperview];
    }
}
-(void)socialMediaShare:(UIButton*)btn
{
    
    if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Cancel"])
    {
         tm=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(buttonhideAnimation)userInfo:nil repeats:YES];
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Facebook"])
    {
        if (NSClassFromString(@"SLComposeViewController") != nil)
        {

            slComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [slComposer setInitialText:[NSString stringWithFormat:@"Liveie : %@",@"https://itunes.apple.com/us/app/liveie/id1096042366?mt=8"]];
            
;
            
            SLComposeViewControllerCompletionHandler handler = ^(SLComposeViewControllerResult result)
            {
                switch (result)
                {
                    case SLComposeViewControllerResultDone:
                        
                        break;
                    case SLComposeViewControllerResultCancelled:
                        break;
                    default:
                        break;
                }
            };
            slComposer.completionHandler = handler;
            [self presentViewController:slComposer animated:YES completion:nil];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"https://itunes.apple.com/us/app/liveie/id1096042366?mt=8";
        }
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Instagram"])
    {
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
        if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
        {
            
            NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"logo"]); //convert image into .png format.
            NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
            NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
            [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
            NSLog(@"image saved");
            
            CGRect rect = CGRectMake(0 ,0 , 0, 0);
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIGraphicsEndImageContext();
            NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
            NSLog(@"jpg path %@",jpgPath);
            NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
            NSLog(@"with File path %@",newJpgPath);
            NSURL *igImageHookFile = [NSURL URLWithString:newJpgPath];
            NSLog(@"url Path %@",igImageHookFile);
            
            self.documentController.UTI = @"com.instagram.exclusivegram";
            // self.documentController = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
            
            
            self.documentController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
            NSString *caption = @"https://itunes.apple.com/us/app/liveie/id1096042366?mt=8"; //settext as Default Caption
            self.documentController.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
            [self.documentController presentOpenInMenuFromRect:rect inView: self.view animated:YES];
        }
        else
        {
            UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Instagram Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errMsg show];
        }
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"What's app"])
    {
        
        NSString * msg = @"Liveie%20https://itunes.apple.com/us/app/liveie/id1096042366?mt=8";
        
        msg = [msg stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        msg = [msg stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        msg = [msg stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        msg = [msg stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
        msg = [msg stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        msg = [msg stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
        NSURL * whatsappURL = [NSURL URLWithString:urlWhats];
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
            [[UIApplication sharedApplication] openURL: whatsappURL];
        }else{
            [[[UIAlertView alloc] initWithTitle:nil message:@"Whatsapp not installed on this device! Please install first." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]show];
        }
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Contacts"])
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = @"https://itunes.apple.com/us/app/liveie/id1096042366?mt=8";
//            controller.recipients = tempArrayForSMS;// any NSMutable Array holding numbers
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Twitter"])
    {
        if (NSClassFromString(@"SLComposeViewController") != nil)
        {
            slComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [slComposer setInitialText:[NSString stringWithFormat:@"Liveie : %@",@"https://itunes.apple.com/us/app/liveie/id1096042366?mt=8"]];
            
            
            SLComposeViewControllerCompletionHandler handler = ^(SLComposeViewControllerResult result)
            {
                switch (result)
                {
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Done");
                        break;
                        
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Cancel");
                        
                        break;
                    default:
                        break;
                        
                }
                
                
            };
            slComposer.completionHandler = handler;
            
            [self presentViewController:slComposer animated:YES completion:nil];
        }

    }
    else if([[btn titleForState:UIControlStateNormal] isEqualToString:@"Email"])
    {
        NSString *emailTitle = @"Livie";
        // Email Content
        
        NSString *messageBody=[NSString stringWithFormat:@"Livie  %@",@"https://itunes.apple.com/us/app/liveie/id1096042366?mt=8"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        if ([MFMailComposeViewController canSendMail])
        {
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:YES];
//            NSData *imageDataForEmail = [NSData dataWithData:UIImagePNGRepresentation(img1)];
//            [mc addAttachmentData:imageDataForEmail mimeType:@"image/png" fileName:@"savingImage"];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }

    }
}

-  (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result 

{
    NSLog(@"Entered messageComposeController");
    switch (result) {
        case MessageComposeResultSent: NSLog(@"SENT"); [self dismissViewControllerAnimated:YES completion:nil]; break;
        case MessageComposeResultFailed: NSLog(@"FAILED"); [self dismissViewControllerAnimated:YES completion:nil]; break;
        case MessageComposeResultCancelled: NSLog(@"CANCELLED"); [self dismissViewControllerAnimated:YES completion:nil]; break;
    }
}

#pragma mark - Email Composer Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *objAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Mail has been sent Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [objAlert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - UIDocumentInteractionController Delegate

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate
{
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    interactionController.delegate = self;
    
    return interactionController;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller canPerformAction:(SEL)action
{
    return YES;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller performAction:(SEL)action
{
    return YES;
}
@end
