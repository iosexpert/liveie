//
//  directViewController.m
//  Lively
//
//  Created by Vinay Sharma on 21/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "directViewController.h"
#import "directPostViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"

#import "AsyncImageView.h"
#import "AFNetworking.h"
#import "recordDirectViewController.h"
#import "AGPushNoteView.h"
@interface directViewController ()
{
    APIViewController *api_obj;
    NSMutableArray *DirectUserArray;
    
}
@end

@implementation directViewController

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

    
    screenName=@"direct";

//    api_obj=[[APIViewController alloc]init];
//    [api_obj getDirectUsers:@selector(getDirectUsersResult:) tempTarget:self];

    NSString *urlString=[NSString stringWithFormat:@"%@/GetDirectUser/%@",WEBURL1,userid];
    
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
            
            [self getDirectUsersResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getDirectUsersResult:nil];
        
    }];
    
    [operation start];

}
-(void)getDirectUsersResult:(NSMutableDictionary*)dict_Response
{
    NSLog(@"%@",dict_Response);
    
    
    
    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        
        if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){
            
            DirectUserArray=[[dict_Response objectForKey:@"users" ] mutableCopy];
            
        }
        if(DirectUserArray.count>0)
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
    return DirectUserArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dict=  DirectUserArray[indexPath.row];
    AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    [img1.layer setBorderWidth: 0.0];
    [img1.layer setCornerRadius:30.0f];
    [img1.layer setMasksToBounds:YES];
    img1.layer.borderColor = [UIColor colorWithRed:201/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
    img1.backgroundColor=[UIColor whiteColor];
    img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
    [cell addSubview:img1];
    
    AsyncImageView *img2=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 10, 70, 50)];

    img2.layer.borderColor = [UIColor colorWithRed:201/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
    img2.backgroundColor=[UIColor whiteColor];
    img2.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"thumbnail"]]];
    img2.contentMode=UIViewContentModeScaleAspectFill;
    [img2.layer setBorderWidth: 0.0];
    [img2.layer setCornerRadius:0];
    [img2.layer setMasksToBounds:YES];

    [cell addSubview:img2];

    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (75, 18, 200, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=1;
    label.textColor=[UIColor purpleColor];
    label.backgroundColor=[UIColor clearColor];
    if([[dict objectForKey:@"name"] isEqualToString:@" "])
        [label setText:[dict objectForKey:@"username"]];
    else
        [label setText:[dict objectForKey:@"name"]];
    [cell addSubview:label];
    
    UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:12];
    CGRect labelFrame1 = CGRectMake (75, 35, self.view.frame.size.width-155, 35);
    UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
    [label1 setFont:myFont1];
    label1.lineBreakMode=NSLineBreakByWordWrapping;
    label1.numberOfLines=2;
    label1.textColor=[UIColor grayColor];
    label1.backgroundColor=[UIColor clearColor];
    [label1 setText:[dict objectForKey:@"caption"]];
    [cell addSubview:label1];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *dict=  DirectUserArray[indexPath.row];;
    friendID=[dict valueForKey:@"userid"];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)backButton:(id)sender
{
    [tablev removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)plusButton:(id)sender
{
    recordDirectViewController *cnev;
    if(iphone5)
    {
        cnev=[[recordDirectViewController alloc]initWithNibName:@"recordDirectViewController" bundle:nil];
    }
    else if (iphone4)
    {
        cnev=[[recordDirectViewController alloc]initWithNibName:@"recordDirectViewController@4" bundle:nil];
    }
    else if (iphone6)
    {
        cnev=[[recordDirectViewController alloc]initWithNibName:@"recordDirectViewController@6" bundle:nil];
    }
    else if (iphone6p)
    {
        cnev=[[recordDirectViewController alloc]initWithNibName:@"recordDirectViewController@6p" bundle:nil];
    }
    else if (ipad)
    {
        cnev=[[recordDirectViewController alloc]initWithNibName:@"recordDirectViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:cnev animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
 
    api_obj=nil;

    api_obj=nil;
    
    
}
@end
