//
//  notificationViewController.m
//  Lively
//
//  Created by Brahmasys on 18/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "notificationViewController.h"
#import "AsyncImageView.h"
#import "otheruserViewController.h"
#import "reSharePostViewController.h"
#import "directPostViewController.h"
#import "AGPushNoteView.h"
#import "notificationPostScreen.h"

#import "AFHTTPClient.h"
#import "AFNetworking.h"

@interface notificationViewController ()
{
    APIViewController *api_obj;
    
    
    NSMutableArray *Noti_Array;
    int apicall;
    
    UILabel *fromLabel;
}

@end

@implementation notificationViewController

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
    

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [tablv addSubview:refreshControl];
    
    tablv.allowsMultipleSelectionDuringEditing = NO;
    [super viewDidLoad];
    
   

    


    
    
        self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view from its nib.
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self getNotifictions];
    [refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}//

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    notificationscren=0;
    screenName=@"notification";

    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopVideo" object:self];

    if(pushback==4)
    {
        pushback=0;
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
        [self.navigationController pushViewController:mvc animated:NO];
        
    }
 [LoaderViewController show:self.view animated:YES];
    [self getNotifictions];
    
    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getNotification:@selector(getNotificationResult:) tempTarget:self];
    

    
    
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    
    
    
    }

-(void)getNotifictions
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Notification.svc/GetNotifications/%@/%@/%@",appUrl,userid,@"0",@"50"];
    
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
            
            [self getNotificationResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getNotificationResult:nil];
        
    }];
    
    [operation start];

}
-(void)getNotificationResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    notificationscren=0;

    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        if([[[dict_Response objectForKey:@"response"]valueForKey:@"status" ] integerValue]==200)
        {
            Noti_Array=[[dict_Response valueForKey:@"list"]mutableCopy];
            if(Noti_Array.count>0)
            {
                [tablv setHidden:NO];
            }
            else
                [tablv setHidden:YES];

            [tablv reloadData];
            
        }
    }
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    api_obj=[[APIViewController alloc]init];
    [api_obj getNotificationCount:@selector(getNotificationCountResult:) tempTarget:self];
}
-(void)getNotificationCountResult:(NSDictionary*)dict_Response
{
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
    }
    else
    {
        
        if([[[dict_Response objectForKey:@"response"]valueForKey:@"status" ] integerValue]==200)
        {
            Noti_Count=[[dict_Response objectForKey:@"count"]intValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationCount" object:self];
        }
    }
}

#pragma mark Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(Noti_Array.count>0)
    {
        [fromLabel removeFromSuperview];
    }
    return Noti_Array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dict=Noti_Array[indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    [img1.layer setBorderWidth: 0.0];
    [img1.layer setCornerRadius:30];
    [img1.layer setMasksToBounds:YES];
    img1.layer.borderColor = [UIColor colorWithRed:201/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
    img1.backgroundColor=[UIColor whiteColor];
    img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"user_pic"]]];
    [cell addSubview:img1];
    
    UIButton *options = [UIButton buttonWithType:UIButtonTypeCustom];
        [options addTarget:self action:@selector(openOtherUser:) forControlEvents:UIControlEventTouchUpInside];
    options.tag=indexPath.row;
    options.frame = CGRectMake(10, 5, 60, 60);
    [cell addSubview:options];
    CGRect labelFrame;
    
    if([[dict objectForKey:@"type"] isEqualToString:@"flr"])
    {
        if(![[dict objectForKey:@"following_status"]boolValue])
        {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(self.view.frame.size.width-93, 25, 83, 19)];
            [btn setImage:[UIImage imageNamed:@"followbtn"] forState:UIControlStateNormal];
            [btn setTag:indexPath.row];
            [btn addTarget:self action:@selector(followuser:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            labelFrame = CGRectMake (75, 15, self.view.frame.size.width-170, 40);
        }
        else
        {
            labelFrame = CGRectMake (75, 15, self.view.frame.size.width-150, 40);

            
        }
        
    }
    else if([[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"comments"])
    {
        AsyncImageView *img2=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 10, 60, 60)];
        
        img2.layer.borderColor = [UIColor colorWithRed:281/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
        [img2.layer setBorderWidth: 0.0];
        [img2.layer setCornerRadius:0];
        [img2.layer setMasksToBounds:YES];
        img2.backgroundColor=[UIColor whiteColor];
        img2.contentMode=UIViewContentModeScaleAspectFill;

        img2.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"post_pic"]]];
        [cell addSubview:img2];
        
        
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:14];
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[dict objectForKey:@"message"]];
        [cell addSubview:label];
        
    
    labelFrame = CGRectMake (75, 15, self.view.frame.size.width-150, 40);
    }
    else if([[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"recentlyadded"])
    {
//        AsyncImageView *img2=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 10, 60, 60)];
//        
//        img2.layer.borderColor = [UIColor colorWithRed:281/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
//        [img2.layer setBorderWidth: 0.0];
//        [img2.layer setCornerRadius:0];
//        [img2.layer setMasksToBounds:YES];
//        img2.backgroundColor=[UIColor whiteColor];
//        img2.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"post_pic"]]];
//        [cell addSubview:img2];
        
        
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:14];
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor purpleColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[dict objectForKey:@"message"]];
        [cell addSubview:label];
        
        
        labelFrame = CGRectMake (75, 15, self.view.frame.size.width-150, 40);
    }

    else if([[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"flr_request"])
    {
        UIButton *accept=[UIButton buttonWithType:UIButtonTypeCustom];
        [accept setFrame:CGRectMake(self.view.frame.size.width-43, 22, 26, 26)];
        [accept setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
        [accept setTag:indexPath.row];
        [accept addTarget:self action:@selector(acceptuser:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:accept];
        
        UIButton *reject=[UIButton buttonWithType:UIButtonTypeCustom];
        [reject setFrame:CGRectMake(self.view.frame.size.width-93, 22, 26, 26)];
        [reject setImage:[UIImage imageNamed:@"reject"] forState:UIControlStateNormal];
        [reject setTag:indexPath.row];
        [reject addTarget:self action:@selector(rejectuser:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:reject];
        
        
        labelFrame = CGRectMake (75, 15, 150, 40);
    }
    else
    {
        if([[dict objectForKey:@"type"] isEqualToString:@"mention"])
        {
            
        }
        else
        {
    AsyncImageView *img2=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 10, 60, 60)];
    
    img2.layer.borderColor = [UIColor colorWithRed:281/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
            [img2.layer setBorderWidth: 0.0];
            [img2.layer setCornerRadius:0];
            [img2.layer setMasksToBounds:YES];
    img2.backgroundColor=[UIColor whiteColor];
            img2.contentMode=UIViewContentModeScaleAspectFill;
    img2.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"post_pic"]]];
    
    [cell addSubview:img2];
        }
        labelFrame = CGRectMake (75, 15, self.view.frame.size.width-150, 40);
    }
    
    
    
    
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:14];
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor grayColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:[dict objectForKey:@"message"]];
    [cell addSubview:label];
    
//    UIButton *postImg = [UIButton buttonWithType:UIButtonTypeCustom];
//    [postImg addTarget:self action:@selector(openPost_action:) forControlEvents:UIControlEventTouchUpInside];
//    postImg.tag=indexPath.row;
//    postImg.frame = CGRectMake(self.view.frame.size.width-200, 10, 60, 60);
//    [cell addSubview:postImg];

    UIView *viewLine=[[UIView alloc]initWithFrame:CGRectMake(0, 69, self.view.frame.size.width-55, 1)];
    [viewLine setBackgroundColor:[UIColor lightGrayColor]];
    [viewLine setAlpha:0.1];
    [cell addSubview:viewLine];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if([[dict objectForKey:@"isread"]boolValue] ==1)
    {
         cell.backgroundColor=[UIColor clearColor];
    }
    else
    {
         cell.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    }
    
   
    
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    api_obj=[[APIViewController alloc]init];
    [api_obj readNotification:@selector(readNotificationResult:) tempTarget:self : [[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"notificationid"]];
    
    int x=(int)indexPath.row;
    if([[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"flr"])
    {
        friendID=[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"sent_from_userid"];
        
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
    else if([[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"recentlyadded"])
    {
        friendID=[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"sent_from_userid"];
        
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
    else if([[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"flr_request"])
    {
        
    }
    else
    [self detailPost:x];
//    if([[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:@"like"])
//    self.tabBarController.selectedIndex=0;
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [LoaderViewController show:self.view animated:YES];

        
        NSString *urlString=[NSString stringWithFormat:@"%@/Notification.svc/DeleteNotification/%@",appUrl,[[Noti_Array objectAtIndex:indexPath.row]valueForKey:@"notificationid"]];
        
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
                
                [self getNotificationDeleteResult:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self getNotificationDeleteResult:nil];
            
        }];
        
        [operation start];

    
    }
}
-(void)getNotificationDeleteResult:(NSDictionary *)dict_Response

{
    NSLog(@"%@",dict_Response);
    [self getNotifictions];
}
-(void)acceptuser:(id)sender
{
    NSMutableDictionary *dict=  [Noti_Array objectAtIndex:[sender tag]];
    NSString *friendId=[dict valueForKey:@"sent_from_userid"];
    
    api_obj=[[APIViewController alloc]init];
    [api_obj ApproveFollowRequest:@selector(ApproveFollowRequestResult:) tempTarget:self : friendId ];

}
-(void)ApproveFollowRequestResult:(NSDictionary *)dict_Response
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
            [api_obj getNotification:@selector(getNotificationResult:) tempTarget:self];
            
        }
    }
}

-(void)rejectuser:(id)sender
{
    NSMutableDictionary *dict=  [Noti_Array objectAtIndex:[sender tag]];

    
    [LoaderViewController show:self.view animated:YES];
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Notification.svc/DeleteNotification/%@",appUrl,[dict valueForKey:@"notificationid"]];
    
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
            
            [self getNotificationDeleteResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getNotificationDeleteResult:nil];
        
    }];
    
    [operation start];
}
-(void)followuser:(id)sender
{
    NSMutableDictionary *dict=  [Noti_Array objectAtIndex:[sender tag]];
    NSString *friendId=[dict valueForKey:@"sent_from_userid"];
    NSString *st=@"true";
    
    api_obj=[[APIViewController alloc]init];
    [api_obj follow_user:@selector(follow_usersResult:) tempTarget:self : friendId :st];
    
}
-(void)follow_usersResult:(NSDictionary *)dict_Response
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
            [api_obj getNotification:@selector(getNotificationResult:) tempTarget:self];
            
        }
    }
}


-(void)detailPost:(int)btn
{
    
    selectedFeed=[Noti_Array objectAtIndex:btn];
    
    if([[selectedFeed valueForKey:@"type"]isEqualToString:@"direct"])
    {
        friendID=[selectedFeed valueForKey:@"sent_from_userid"];
        
        directPostViewController *cnev;
        if(iphone5)
        {
            cnev=[[directPostViewController alloc]initWithNibName:@"directPostViewController" bundle:nil];
        }
        else if (iphone4)
        {
            cnev=[[directPostViewController alloc]initWithNibName:@"directPostViewController@4" bundle:nil];
        }
        else if (iphone6)
        {
            cnev=[[directPostViewController alloc]initWithNibName:@"directPostViewController@6" bundle:nil];
        }
        else if (iphone6p)
        {
            cnev=[[directPostViewController alloc]initWithNibName:@"directPostViewController@6P" bundle:nil];
        }
        else if (ipad)
        {
            cnev=[[directPostViewController alloc]initWithNibName:@"directPostViewController@ipad" bundle:nil];
        }
        cnev.strOtherUserId=friendID;
        [self.navigationController pushViewController:cnev animated:YES];
    }
    else
    {
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
        mvc.strComment=@"true";
        [self.navigationController pushViewController:mvc animated:NO];

    }
    
}

-(void)readNotificationResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    api_obj=[[APIViewController alloc]init];
    [api_obj getNotification:@selector(getNotificationResult:) tempTarget:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)openOtherUser:(UIButton*)sender
{
    friendID=[[Noti_Array objectAtIndex:sender.tag]valueForKey:@"sent_from_userid"];
    
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
-(void)openPost_action:(UIButton*)btn
{

    
//    selectedFeed=[Noti_Array objectAtIndex:btn.tag];
//    reSharePostViewController *mvc;
//    if(iphone4)
//    {
//        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
//    }
//    else if(iphone5)
//    {
//        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
//    }
//    else
//    {
//        mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
//    }
//    [self.navigationController pushViewController:mvc animated:YES];
    
    
}
@end
