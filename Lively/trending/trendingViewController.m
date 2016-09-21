//
//  trendingViewController.m
//  Lively
//
//  Created by Vinay Sharma on 21/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "trendingViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "postOfHashTagView.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AGPushNoteView.h"
@interface trendingViewController ()
{
    
    APIViewController *api_obj;
    
    NSMutableArray *videoArray;
    int scrollXPossition;

    int downloadVideoCount,count,downloadImageCount;

}
@end

@implementation trendingViewController
@synthesize trendArr;

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
    if(scrollXPossition==0)
    {
        [collectionscrolv setContentOffset:CGPointMake(0, 0) animated:YES];
        [gridListbtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        gridListbtn.tag=0;
        
    }
    else
    {
        [collectionscrolv setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        [gridListbtn setImage:[UIImage imageNamed:@"thumbnial"] forState:UIControlStateNormal];
        gridListbtn.tag=1;
    }
 
        UITabBarController *bar = [self tabBarController];
        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
            //iOS 7 - hide by property
            NSLog(@"iOS 7");
            [self setExtendedLayoutIncludesOpaqueBars:YES];
            bar.tabBar.hidden = NO;
        }
        
  

    
}
- (void)viewDidLoad {
    screenName=@"tranding";

    
    if(iphone5||iphone4)
        [collectV registerNib:[UINib nibWithNibName:@"MachineCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    else if(iphone6)
        [collectV registerNib:[UINib nibWithNibName:@"MachineCollectionCell@6" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    else if(iphone6p)
        [collectV registerNib:[UINib nibWithNibName:@"MachineCollectionCell@6p" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    [gridListbtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];

    
    
    NSString *st=[NSString stringWithFormat:@"%@/%f/%f/%@/%@",userid,lng,lat,@"0",@"30"];
    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getTrendingPost:@selector(getTrendingPostResult:) tempTarget:self :st];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Post.svc/GetTrendings/%@",appUrl,st];
    
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
            
            [self getTrendingPostResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getTrendingPostResult:nil];
        
    }];
    
    [operation start];

    
    
    
    
    
        [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)getTrendingPostResult:(NSDictionary *)dict_Response
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
            trendArr=[[dict_Response objectForKey:@"trending"]mutableCopy];
            //[self showDataAfterApi];

            [collectV reloadData];
            [tablev reloadData];

        }
    }
}
-(IBAction)ListGrid:(id)sender
{
    if(gridListbtn.tag==1)
    {
        [collectionscrolv setContentOffset:CGPointMake(0, 0) animated:YES];
        [gridListbtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        gridListbtn.tag=0;
       
    }
    else
    {
        [collectionscrolv setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        [gridListbtn setImage:[UIImage imageNamed:@"thumbnial"] forState:UIControlStateNormal];
        gridListbtn.tag=1;
    }
}


#pragma mark Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return trendArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dict=  trendArr[indexPath.row];
    AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 60, 60)];
    [img1.layer setBorderWidth: 0.0];
    [img1.layer setCornerRadius:30.0f];
    [img1.layer setMasksToBounds:YES];
    img1.layer.borderColor = [UIColor colorWithRed:201/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
    img1.backgroundColor=[UIColor whiteColor];
    img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
    [cell addSubview:img1];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (75, 28, 230, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor grayColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:[dict objectForKey:@"hashtag"]];
    [cell addSubview:label];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSMutableDictionary *dict=  trendArr[indexPath.row];
    selectedHashTag=[dict objectForKey:@"hashtag"];
    
    
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
- (void)openTrending:(UIButton*)btn
{
   
        selectedHashTag=[[trendArr objectAtIndex:btn.tag]valueForKey:@"hashtag"];
        
        
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

-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    scrollXPossition=collectionscrolv.contentOffset.x;
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    
   
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    int h=0;
    if(iphone6)
        h= 165;
    else if(iphone6p)
        h= 175;
    else
        h= 140;
    
    CGRect f = collectV.frame;
    f.size.height = trendArr.count*h/3+100;
    collectV.frame =f;
    // NSLog(@"%d",(int)postsArr.count*h);
//    if((trendArr.count*h/3+100)<=self.view.frame.size.height+20)
//        collectionscrolv1.contentSize=CGSizeMake(300, self.view.frame.size.height);
//    else
        collectionscrolv1.contentSize=CGSizeMake(300, self.view.frame.size.height-90);
    collectV.scrollEnabled=false;
    
    
    return trendArr.count;
}

- (MachineCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MachineCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    NSMutableDictionary *dict=trendArr[indexPath.row];
    cell.ImgView.layer.cornerRadius=cell.ImgView.frame.size.width/2;
    [cell.ImgView.layer setMasksToBounds:YES];
    
    cell.ImgView.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"pic"]]];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:11];
    CGRect labelFrame = CGRectMake (0, cell.ImgView.frame.size.height+12,cell.frame.size.width, 35);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=2;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor grayColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:[dict objectForKey:@"hashtag"]];
    [cell addSubview:label];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // LOG_SELECTOR_ENTRY();
    
    selectedHashTag=[[trendArr objectAtIndex:indexPath.row]valueForKey:@"hashtag"];
    
    
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

@end
