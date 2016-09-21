//
//  likeViewController.m
//  Lively
//
//  Created by Vinay Sharma on 21/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "likeViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "otheruserViewController.h"
#import "AsyncImageView.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AGPushNoteView.h"
@interface likeViewController ()
{
    APIViewController *api_obj;
    NSMutableArray *PostLikeArray;

}

@end

@implementation likeViewController
@synthesize strPostId;



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
- (void)viewDidLoad {
    
    screenName=@"like";

    NSString *urlString=[NSString stringWithFormat:@"%@/GetPostLike/%@/%@",WEBURL1,userid,strPostId];
    
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
            
            [self getPostLikesResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getPostLikesResult:nil];
        
    }];
    
    [operation start];

    
    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getPostLikes:@selector(getPostLikesResult:) tempTarget:self :strPostId];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)getPostLikesResult:(NSMutableDictionary*)dict_Response
{
    NSLog(@"%@",dict_Response);
    
    
    
    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        
        if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){
            
            PostLikeArray=[[dict_Response objectForKey:@"users" ] mutableCopy];
            
        }
        [tablev reloadData];
    }

    
}

#pragma mark Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return PostLikeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dict=  PostLikeArray[indexPath.row];
    AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 60, 60)];
    [img1.layer setBorderWidth: 0.0];
    [img1.layer setCornerRadius:30.0f];
    [img1.layer setMasksToBounds:YES];
    img1.layer.borderColor = [UIColor colorWithRed:201/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
    img1.backgroundColor=[UIColor whiteColor];
    img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
    [cell addSubview:img1];
    
    
    UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userProfileButton addTarget:self action:@selector(userprofileButton_action:) forControlEvents:UIControlEventTouchUpInside];
    userProfileButton.tag=indexPath.row;
    [userProfileButton setTitle:@"" forState:UIControlStateNormal];
  
        userProfileButton.frame = CGRectMake(5, 10, 60, 60);
    
    [cell addSubview:userProfileButton];

    
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (75, 30, 230, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor grayColor];
    label.backgroundColor=[UIColor clearColor];
    if([[dict objectForKey:@"name"] isEqualToString:@" "])
        [label setText:[dict objectForKey:@"username"]];
    else
        [label setText:[dict objectForKey:@"name"]];
    [cell addSubview:label];
    [cell addSubview:label];
    
    if(![[dict valueForKey:@"userid"] isEqualToString:userid])
    {
    if([[dict valueForKey:@"status"] boolValue]==true)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width-93, 29, 83,19)];
        [btn setBackgroundImage:[UIImage imageNamed:@"followingbtn"] forState:UIControlStateNormal];
        [btn setTag:indexPath.row];
        
        [btn addTarget:self action:@selector(Unfollow:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:btn];
    }
    else
    {
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width-93, 29, 83, 19)];
        [btn setBackgroundImage:[UIImage imageNamed:@"followbtn"] forState:UIControlStateNormal];
        
        [btn setTag:indexPath.row];
        [btn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell addSubview:btn];
    }
    }
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}



- (void)userprofileButton_action:(UIButton*)sender
{
    friendID=[[PostLikeArray objectAtIndex:sender.tag]valueForKey:@"userid"];
    
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



-(IBAction)Unfollow:(id)sender
{
    NSMutableDictionary *dict=  [PostLikeArray objectAtIndex:[sender tag]];
    NSString *friendId=[dict valueForKey:@"userid"];
    NSString *st=@"false";
    
    api_obj=[[APIViewController alloc]init];
    [api_obj follow_user:@selector(follow_userResult:) tempTarget:self : friendId :st];
    
}
-(IBAction)follow:(id)sender
{
    NSMutableDictionary *dict=  [PostLikeArray objectAtIndex:[sender tag]];
    NSString *friendId=[dict valueForKey:@"userid"];
    NSString *st=@"true";
    
    api_obj=[[APIViewController alloc]init];
    [api_obj follow_user:@selector(follow_userResult:) tempTarget:self : friendId :st];
    
}
-(void)follow_userResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    
    
    
    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        if([[dict_Response valueForKey:@"status"] integerValue]==200){
            
            api_obj=[[APIViewController alloc]init];
            [api_obj getPostLikes:@selector(getPostLikesResult:) tempTarget:self :strPostId];
            
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    api_obj=nil; 
}
-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
