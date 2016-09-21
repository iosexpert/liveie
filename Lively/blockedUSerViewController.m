//
//  blockedUSerViewController.m
//  Lively
//
//  Created by Brahmasys on 11/01/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "blockedUSerViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AFNetworking.h"
#import "AsyncImageView.h"
#import "AGPushNoteView.h"
@interface blockedUSerViewController ()
{
    APIViewController *api_obj;
    
     NSMutableArray *frndname,*frnduserid,*frndimage;
}
@end

@implementation blockedUSerViewController

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
    screenName=@"blocked";

    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getBlockedUser:@selector(getBlockedUserResult:) tempTarget:self ];
    
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetBlockedUser/%@",appUrl,userid];
    
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
            
            [self getBlockedUserResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getBlockedUserResult:nil];
        
    }];
    
    [operation start];

    ///
    // Do any additional setup after loading the view from its nib.
}

-(void)getBlockedUserResult:(NSDictionary *)dict_Response
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
            frnduserid =[NSMutableArray new];
            frnduserid=[[dict_Response valueForKey:@"users"]mutableCopy];
            [tablev reloadData];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return frnduserid.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDictionary *dict=frnduserid[indexPath.row];
    
    AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    [img1.layer setBorderWidth: 0.0];
    [img1.layer setCornerRadius:25];
    [img1.layer setMasksToBounds:YES];
    img1.layer.borderColor = [UIColor clearColor].CGColor;
    img1.backgroundColor=[UIColor whiteColor];
    img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"pic"]]];
    [cell addSubview:img1];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (75, 15, 230, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor purpleColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:[dict valueForKey:@"username"]];
    [cell addSubview:label];
    
    UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:13];
    CGRect labelFrame1 = CGRectMake (75, 35, 230, 20);
    UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
    [label1 setFont:myFont1];
    label1.lineBreakMode=NSLineBreakByWordWrapping;
    label1.numberOfLines=5;
    label1.textColor=[UIColor grayColor];
    label1.backgroundColor=[UIColor clearColor];
    [label1 setText:[dict valueForKey:@"name"]];
    [cell addSubview:label1];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(unblockuser:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=indexPath.row;
    [button setBackgroundImage:[UIImage imageNamed:@"unblock"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0,40, 40);
    cell.accessoryView=button;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)unblockuser:(UIButton*)btn
{
    NSDictionary *dict=frnduserid[btn.tag];
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/UnBlockUser/%@/%@",appUrl,userid,[dict valueForKey:@"userid"]];
    
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
            
            [self unhidepostResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self unhidepostResult:nil];
        
    }];
    
    [operation start];
    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj unblockuser:@selector(unhidepostResult:) tempTarget:self :[dict valueForKey:@"userid"]];
//    
}
-(void)unhidepostResult:(NSDictionary *)dict_Response
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
            
            NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetBlockedUser/%@",appUrl,userid];
            
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
                    
                    [self getBlockedUserResult:JSON];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error: %@",  operation.responseString);
                
                NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
                
                if (errStr==Nil) {
                    errStr=@"Server not reachable";
                }
                
                [self getBlockedUserResult:nil];
                
            }];
            
            [operation start];

            
                      
            
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    
}
@end
