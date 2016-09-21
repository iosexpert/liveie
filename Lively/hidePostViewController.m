//
//  hidePostViewController.m
//  
//
//  Created by Brahmasys on 11/01/16.
//
//

#import "hidePostViewController.h"
#import "AsyncImageView.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "AGPushNoteView.h"
@interface hidePostViewController ()
{
    APIViewController *api_obj;
    
    NSMutableArray *frnduserid;
}
@end

@implementation hidePostViewController

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
    screenName=@"hidepost";

//    api_obj=[[APIViewController alloc]init];
//    [api_obj gethidepost:@selector(gethidepostResult:) tempTarget:self ];

    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetHidePostList/%@",appUrl,userid];
    
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
            
            [self gethidepostResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self gethidepostResult:nil];
        
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gethidepostResult:(NSDictionary *)dict_Response
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
            frnduserid=[[dict_Response valueForKey:@"posts"]mutableCopy];
            [tablev reloadData];
        }
    }
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
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.layer.cornerRadius=30;
    img.layer.masksToBounds = YES;
    [img.layer setMasksToBounds:YES];
    img.backgroundColor=[UIColor whiteColor];
    img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"user_pic"]]];
    [cell addSubview:img];
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:15];
    CGRect labelFrame = CGRectMake (75, 5, 250, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor grayColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:[dict valueForKey:@"username"]];
    [cell addSubview:label];
    
    UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:13];
    CGRect labelFrame1 = CGRectMake (75, 30, 250, 32);
    UILabel *labell = [[UILabel alloc] initWithFrame:labelFrame1];
    [labell setFont:myFont1];
    labell.lineBreakMode=NSLineBreakByWordWrapping;
    labell.numberOfLines=2;
    labell.textColor=[UIColor grayColor];
    labell.backgroundColor=[UIColor clearColor];
    [labell setText:[dict valueForKey:@"caption"]];
    [cell addSubview:labell];
    
    
    AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.width)];
    img1.contentMode = UIViewContentModeScaleAspectFill;
    [img1.layer setMasksToBounds:YES];
    img1.backgroundColor=[UIColor whiteColor];
    img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
    [cell addSubview:img1];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(unhidepost:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=indexPath.row;
    [button setBackgroundImage:[UIImage imageNamed:@"unhide.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.width);
    button.alpha=0.3;
    [cell addSubview:button];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width+70;
}

-(void)unhidepost:(UIButton*)btn
{
    
    [LoaderViewController show:self.view animated:YES];

    
     NSDictionary *dict=frnduserid[btn.tag];
  ;
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/UnHidePOst/%@/%@",appUrl,userid,[dict valueForKey:@"postid"]];
    
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
            
            NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetHidePostList/%@",appUrl,userid];
            
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
                    
                    [self gethidepostResult:JSON];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"error: %@",  operation.responseString);
                
                NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
                
                if (errStr==Nil) {
                    errStr=@"Server not reachable";
                }
                
                [self gethidepostResult:nil];
                
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
