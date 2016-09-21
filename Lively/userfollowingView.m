//
//  userfollowingView.m
//  
//
//  Created by Brahmasys on 09/12/15.
//
//

#import "userfollowingView.h"
#import "AsyncImageView.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "otheruserViewController.h"
#import "AGPushNoteView.h"
@interface userfollowingView ()
{
    APIViewController *api_obj;
    
    
    NSMutableArray *followListArray,*arrFollower;
}
@end

@implementation userfollowingView

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
    self.navigationController.navigationBarHidden=YES;
    searchbar.returnKeyType=UIReturnKeyDone;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma Mark Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText  isEqual: @""])
    {
        [tablev setHidden:NO];
        
        api_obj=[[APIViewController alloc]init];
        [api_obj FollowingSearch:@selector(searchresult:) tempTarget:self :followingID :searchText];
        
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchbar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
    searchbar.text=@"";
    followListArray=[arrFollower mutableCopy];
    [tablev reloadData];
    [tablev setFrame:CGRectMake(0, tablev.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-100)];
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchbar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
    searchbar.text=@"";
    followListArray=[arrFollower mutableCopy];
    [tablev reloadData];
    [tablev setFrame:CGRectMake(0, tablev.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-100)];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchbar.showsCancelButton=YES;
    searchbar.returnKeyType=UIReturnKeyDone;
    
    return YES;
}

-(void)searchresult:(NSMutableDictionary*)dict
{
    if([[[dict valueForKey:@"response"]valueForKey:@"status"] isEqualToString:@"200"])
    {
        followListArray=[dict valueForKey:@"users"];
        [tablev setFrame:CGRectMake(0, tablev.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-100-240)];
        [tablev reloadData];
    }
}
-(IBAction)backButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    screenName=@"following";

//    api_obj=[[APIViewController alloc]init];
//    [api_obj getFollowingList:@selector(getFollowingResult:) tempTarget:self : followingID];
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetFollowings/%@/%@/%@/%@",CONNECTURL,userid,followingID,@"0",@"200"];
    
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
            
            [self getFollowingResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getFollowingResult:nil];
        
    }];
    
    [operation start];

    
}
-(void)getFollowingResult:(NSDictionary *)dict_Response
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
            
            followListArray=[[dict_Response objectForKey:@"users" ] mutableCopy];
            arrFollower=[[dict_Response objectForKey:@"users" ] mutableCopy];

            
        }        [tablev reloadData];
    }
}
#pragma mark Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return followListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dict=  followListArray[indexPath.row];
    AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    [img1.layer setBorderWidth: 0.0];
    [img1.layer setCornerRadius:20.0f];
    [img1.layer setMasksToBounds:YES];
    img1.layer.borderColor = [UIColor colorWithRed:201/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
    img1.backgroundColor=[UIColor whiteColor];
    img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic"]]];
    [cell addSubview:img1];
    
    UIView *viewLine=[[UIView alloc]initWithFrame:CGRectMake(55, 64, self.view.frame.size.width-55, 1)];
    [viewLine setBackgroundColor:[UIColor lightGrayColor]];
    [viewLine setAlpha:0.1];
    [cell addSubview:viewLine];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (75, 23, 230, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor purpleColor];
    label.backgroundColor=[UIColor clearColor];
    if([[dict objectForKey:@"name"] isEqualToString:@" "])
        [label setText:[dict objectForKey:@"username"]];
    else
        [label setText:[dict objectForKey:@"name"]];
    [cell addSubview:label];
    
    if([[dict valueForKey:@"userid"] isEqualToString:userid])
       {
           
       }
    else if([[dict valueForKey:@"status"]  isEqual: @"approved"])
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width-93, 15, 83, 40)];
        [btn setImage:[UIImage imageNamed:@"followingbtn"] forState:UIControlStateNormal];
        [btn setTag:indexPath.row];
        
        [btn addTarget:self action:@selector(Unfollow:) forControlEvents:UIControlEventTouchUpInside];
        [btn setUserInteractionEnabled:YES];
        
        [cell addSubview:btn];
    }
    else if([[dict valueForKey:@"status"]  isEqual: @"na"])
    {
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width-93, 15, 83, 40)];
        [btn setImage:[UIImage imageNamed:@"followbtn"] forState:UIControlStateNormal];
        
        [btn setTag:indexPath.row];
        [btn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
        [btn setUserInteractionEnabled:YES];
        
        
        [cell addSubview:btn];
    }
    else if([[dict valueForKey:@"status"]  isEqual: @"p"])
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(self.view.frame.size.width-93, 15, 83, 40)];
        [btn setImage:[UIImage imageNamed:@"requestedcolour"] forState:UIControlStateNormal];
        
        [btn setTag:indexPath.row];
        [btn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
        [btn setUserInteractionEnabled:NO];
        
        [cell addSubview:btn];
    }
    
    
    
    
    
    
    
    
    
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
}
-(IBAction)Unfollow:(UIButton*)sender
{
//     [sender setImage:[UIImage imageNamed:@"followbtn"] forState:UIControlStateNormal];
  NSMutableDictionary *dict=  [followListArray objectAtIndex:[sender tag]];
    NSString *friendId1=[dict valueForKey:@"userid"];
        NSString *st=@"false";
    
//        api_obj=[[APIViewController alloc]init];
//        [api_obj follow_user:@selector(follow_userResult:) tempTarget:self : friendId1 :st];
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@/FollowUser/%@/%@/%@",CONNECTURL,userid,friendId1,st];
    
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
            
            [self follow_userResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self follow_userResult:nil];
        
    }];
    
    [operation start];

    
    
    
}
-(IBAction)follow:(UIButton*)sender
{

//     [sender setImage:[UIImage imageNamed:@"followingbtn"] forState:UIControlStateNormal];

    NSMutableDictionary *dict=  [followListArray objectAtIndex:[sender tag]];
    NSString *friendId1=[dict valueForKey:@"userid"];
    NSString *st=@"true";
    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj follow_user:@selector(follow_userResult:) tempTarget:self : friendId1 :st];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/FollowUser/%@/%@/%@",CONNECTURL,userid,friendId1,st];
    
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
            
            [self follow_userResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self follow_userResult:nil];
        
    }];
    
    [operation start];

    
    
    
}

-(void)follow_userResult:(NSDictionary *)dict_Response
    {
        NSLog(@"%@",dict_Response);
        [LoaderViewController remove:self.view animated:YES];
        
        
        
        if (dict_Response==NULL)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            
            if([[dict_Response valueForKey:@"status"] integerValue]==200){
                
//                api_obj=[[APIViewController alloc]init];
//                [api_obj getFollowingList:@selector(getFollowingResult:) tempTarget:self : followingID];
                
                
                NSString *urlString=[NSString stringWithFormat:@"%@/GetFollowings/%@/%@/%@/%@",CONNECTURL,userid,followingID,@"0",@"200"];
                
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
                        
                        [self getFollowingResult:JSON];
                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"error: %@",  operation.responseString);
                    
                    NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
                    
                    if (errStr==Nil) {
                        errStr=@"Server not reachable";
                    }
                    
                    [self getFollowingResult:nil];
                    
                }];
                
                [operation start];

                

            }
        }
    }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *dict=  followListArray[indexPath.row];;
    friendID=[dict valueForKey:@"userid"];
    if([friendID isEqualToString:userid])
    {
        [self.tabBarController setSelectedIndex:4];
    }
    else
    {
        friendID=[dict valueForKey:@"userid"];

        otheruserViewController *cnev;
        if(iphone5)
        {
            cnev=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController" bundle:nil];
        }
        else if (iphone4)
        {
            cnev=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController@4" bundle:nil];
        }
        else if (iphone6)
        {
            cnev=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController@6" bundle:nil];
        }
        else if (iphone6p)
        {
            cnev=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController@6p" bundle:nil];
        }
        else if (ipad)
        {
            cnev=[[otheruserViewController alloc]initWithNibName:@"otheruserViewController@ipad" bundle:nil];
        }
        
        [self.navigationController pushViewController:cnev animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    api_obj=nil; [LoaderViewController remove:self.view animated:YES];;
}


@end
