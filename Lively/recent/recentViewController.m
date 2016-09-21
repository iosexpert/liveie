//
//  recentViewController.m
//  Lively
//
//  Created by Vinay Sharma on 23/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "recentViewController.h"
#import "AsyncImageView.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "otheruserViewController.h"

#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AGPushNoteView.h"
@interface recentViewController ()
{
    APIViewController *api_obj;
    NSURLSessionDownloadTask *downloadTask ;

    int downloadVideoCount,count,downloadImageCount;
    NSMutableArray *videoArray;
    
    BOOL stopLoader;
    int apicall;
    NSString *min,*max;
    UIActivityIndicatorView *indicator;
    NSMutableArray *arrSearch;
    UISearchBar *searchBaar;
    UITableView *tablevv;

}
@end

@implementation recentViewController
@synthesize recentArr;

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
    
    screenName=@"people";

    stopLoader=NO;
    apicall=0;
    NSString *st=[NSString stringWithFormat:@"%@/%@/%@",userid,@"0",@"20"];
    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getPeople:@selector(getPeoplePostResult:) tempTarget:self :st];
    
    tablev.tag=33;
    
    searchBaar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 70, self.view.frame.size.width-40, 44)];
    searchBaar.delegate = self;
    for (UIView *subview in searchBaar.subviews)
    {
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)])
        {
            [(UITextField *)subview setClearButtonMode:UITextFieldViewModeWhileEditing];
        }
    }
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];

    searchBaar.barTintColor = [UIColor clearColor];
        searchBaar.backgroundImage = [UIImage new];
    UIImageView *imgSearchBack=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbor"]];
       imgSearchBack.frame = CGRectMake(20, 75, self.view.frame.size.width-40, 34);
    [self.view addSubview:imgSearchBack];
    [self.view addSubview:searchBaar];
    
    
    searchBaar.returnKeyType=UIReturnKeyDone;

    
    NSString *urlString=[NSString stringWithFormat:@"%@/Post.svc/GetPeopleToFollow/%@",appUrl,st];
    
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
            
            [self getPeoplePostResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getPeoplePostResult:nil];
        
    }];
    
    [operation start];

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)getShowMoreData
{
    if(apicall==1)
    {
        NSString *st=[NSString stringWithFormat:@"%@/%@/%@",userid,min,max];
        
            api_obj=[[APIViewController alloc]init];
            [api_obj getPeople:@selector(getShowMoreDataResult:) tempTarget:self :st];
    }
}
-(void)getShowMoreDataResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
       
            
            [indicator removeFromSuperview];
            apicall=0;
            if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){
                for(int i=0;i<[[dict_Response objectForKey:@"peoples"]count];i++)
                {
                [recentArr addObject:[dict_Response objectForKey:@"peoples"][i]];
                }
                [self showResultAfterApiCall];
                [tablev reloadData];
            
            }
            if([recentArr count]==0)
            {
                stopLoader=YES;
                [self showResultAfterApiCall];
               [tablev reloadData];

            }
        
    }
    
}


-(void)getPeoplePostResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:3.0];
    imgSplash.transform = CGAffineTransformMakeScale(5,5);
    imgSplash.alpha = 0.0f;
    [UIView commitAnimations];
    imgSplash=nil;

    [LoaderViewController remove:self.view animated:YES];
    
    
    
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){
            recentArr=[[dict_Response objectForKey:@"peoples"]mutableCopy];
            downloadVideoCount=(int)recentArr.count;
            //videoArray=[NSMutableArray new];

//            for(int i=(int)recentArr.count-1;i>=0;i--)
//            {
//                [videoArray addObject:[recentArr objectAtIndex:i]];
//            }
//
//            [self btnImagesClick:0];
            [self showResultAfterApiCall];
        }
    }
}

-(void)showResultAfterApiCall
{
    for (UIView *subview in recentScrv.subviews) {
        [subview removeFromSuperview];
    }
    
    int x = 0,y;
    if(iphone5 || iphone4)
        x=10;
        else if(iphone6)
            x=19;
            else if (iphone6p)
             x=29;


     y=10;
    for(int i=0;i<recentArr.count;i++)
    {
        NSMutableDictionary *dict=recentArr[i];
        AsyncImageView *img1;

        if(iphone5 || iphone4)
        {
            if(i%3==0 && i!=0)
            {
            y=y+110;
            x=10;
            }
            
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, y, 70, 70)];
            img1.layer.cornerRadius=35;
            img1.contentMode = UIViewContentModeScaleAspectFill;
            [img1.layer setMasksToBounds:YES];
            img1.backgroundColor=[UIColor clearColor];
            img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"pic"]]];
            [recentScrv addSubview:img1];
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(openRecent:)forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
            [button setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.tag=i;
            button.frame =CGRectMake  (x-10, y+5, 90,80);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -64, 0.0)];
            [recentScrv addSubview:button];
            
             x=x+110;
        }
        else if(iphone6)
        {
            if(i%3==0 && i!=0)
            {
                y=y+120;
                x=19;
            }
            
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, y, 100, 100)];
            img1.layer.cornerRadius=50;
            img1.contentMode = UIViewContentModeScaleAspectFill;
            [img1.layer setMasksToBounds:YES];
            img1.backgroundColor=[UIColor clearColor];
            img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"pic"]]];
            [recentScrv addSubview:img1];
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(openRecent:)forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
            [button setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.tag=i;
            button.frame =CGRectMake  (x-10, y+15, 110,95);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -90, 0.0)];
            [recentScrv addSubview:button];
            
            x=x+119;

        }
        else if (iphone6p)
        {
            if(i%3==0 && i!=0)
            {
                y=y+120;
                x=28;
            }
            
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, y, 100, 100)];
            img1.layer.cornerRadius=50;
            img1.contentMode = UIViewContentModeScaleAspectFill;
            [img1.layer setMasksToBounds:YES];
            img1.backgroundColor=[UIColor clearColor];
            img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"pic"]]];
            [recentScrv addSubview:img1];
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(openRecent:)forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
            [button setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.tag=i;
            button.frame =CGRectMake  (x-10, y+15, 110,95);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -90, 0.0)];
            [recentScrv addSubview:button];
            
            x=x+128;

        }
        
        
        
        
    }
    recentScrv.contentSize=CGSizeMake(self.view.frame.size.width, y+210);
//    recentScrv.contentOffset = CGPointMake(0, 0);
    [tablev reloadData];
    
    
 
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {


    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        NSLog(@"reload");
        if(apicall==0)
        {

        if(!stopLoader)
        {
            
            indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.frame = CGRectMake(self.view.frame.size.width/2-20,scrollView.contentOffset.y+scrollView.frame.size.height-50, 40.0, 40.0);
            [scrollView addSubview:indicator];
            [indicator bringSubviewToFront:tablev];
            [indicator startAnimating];
            
            min=[NSString stringWithFormat:@"%d",(int)recentArr.count];
            max=[NSString stringWithFormat:@"%d",10];
        
            apicall=1;
            [self getShowMoreData];
        }
        }
    }

}
-(IBAction)ListGrid:(id)sender
{
    [searchBaar resignFirstResponder];
    if(recentArr.count>0)
    {
    if(tablev.tag==0)
    {
        [tablev setHidden:NO];
        [tablev reloadData];
        [recentScrv setHidden:YES];
        tablev.tag=1;
        [gridListbtn setImage:[UIImage imageNamed:@"thumbnial"] forState:UIControlStateNormal];
        [tablevv removeFromSuperview];

    }
    else
    {
        [tablev setHidden:YES];
        [recentScrv setHidden:NO];
        tablev.tag=0;
        [gridListbtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        [tablevv removeFromSuperview];

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
    if(tableView.tag==43)
        return arrSearch.count;
    else
        return recentArr.count;

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==43)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        NSMutableDictionary *dict=  arrSearch[indexPath.row];
        
        
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame = CGRectMake (20, 10, 230, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[dict objectForKey:@"username"]];
        [cell addSubview:label];
        
        //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
        
    }
    else
    {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dict=  recentArr[indexPath.row];
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
    [label setText:[dict objectForKey:@"name"]];
    [cell addSubview:label];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(self.view.frame.size.width-93, 29, 83, 19)];
    [btn setImage:[UIImage imageNamed:@"followbtn"] forState:UIControlStateNormal];
    
    [btn setTag:indexPath.row];
    [btn addTarget:self action:@selector(followUser:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell addSubview:btn];
    
    
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==43)
    {
        searchBaar.showsCancelButton=NO;
        [searchBaar resignFirstResponder];
        [tablevv removeFromSuperview];
        [searchBaar resignFirstResponder];
        searchBaar.text=@"";
        NSMutableDictionary *dict=  arrSearch[indexPath.row];

        friendID=[dict valueForKey:@"userid"];
        
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
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==43)
        return 40;
    
    return 75;
}


- (void)openRecent:(UIButton*)btn
{
    friendID=[[recentArr objectAtIndex:btn.tag]valueForKey:@"userid"];
    [self userprofileopen];
    
}
-(void)followUser:(UIButton*)sender
{
    NSMutableDictionary *dict=  [recentArr objectAtIndex:[sender tag]];
    NSString *friendId=[dict valueForKey:@"userid"];
    NSString *st=@"true";

    
    api_obj=[[APIViewController alloc]init];
    [api_obj follow_user:@selector(follow_userResult:) tempTarget:self : friendId :st];
    
    [sender setImage:[UIImage imageNamed:@"followingbtn"] forState:UIControlStateNormal];
    
    
    
    
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
            
            NSString *st=[NSString stringWithFormat:@"%@/%@/%@",userid,@"0",@"100"];

            api_obj=[[APIViewController alloc]init];
            [api_obj getPeople:@selector(getPeoplePostResult:) tempTarget:self :st];
            
        }
    }
}

- (void)userprofileopen
{

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


-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                NSLog(@"Successfully downloaded file to %@",dataPath);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self btnImagesClick:0];
                
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

-(void)viewWillDisappear:(BOOL)animated
{
    
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    
    
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText  isEqual: @""])
    {
        
        
////        
//        api_obj=[[APIViewController alloc]init];
//        [api_obj SearchUser:@selector(searchresult:) tempTarget:self :searchText];
        NSString *urlString=[NSString stringWithFormat:@"%@/SearchUser/%@/%@",WEBURL,userid,searchText];
        
        NSLog(@"url %@",urlString);
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableArray *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self searchresult:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self searchresult:nil];
            
        }];
        
        [operation start];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBaar.showsCancelButton=NO;
    [searchBaar resignFirstResponder];
    [tablevv removeFromSuperview];
    [searchBaar resignFirstResponder];
    searchBaar.text=@"";
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    searchBaar.showsCancelButton=NO;
    [searchBaar resignFirstResponder];
    [tablevv removeFromSuperview];
    [searchBaar resignFirstResponder];
    searchBaar.text=@"";
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBaar.showsCancelButton=YES;
    tablevv = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBaar.frame.origin.y+45, self.view.frame.size.width, self.view.frame.size.height-330) style:UITableViewStylePlain];
    [tablevv setDataSource:self];
    [tablevv setDelegate:self];
    tablevv.tag=43;
    [tablevv setShowsVerticalScrollIndicator:NO];
    tablevv.translatesAutoresizingMaskIntoConstraints = NO;
    tablevv.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tablevv];
    return YES;
}
-(void)searchresult:(NSMutableArray*)arr_Response
{
    if(arr_Response.count>0)
    {
        arrSearch=[arr_Response mutableCopy];
        [tablevv reloadData];
    }
}
@end
