//
//  directVideoViewController.m
//  
//
//  Created by Brahmasys on 21/01/16.
//
//

#import "directVideoViewController.h"
#import "APIViewController.h"
#import "AsyncImageView.h"
#import "LoaderViewController.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AGPushNoteView.h"
@interface directVideoViewController ()
{
    APIViewController *api_obj;
    
}
@end

@implementation directVideoViewController

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
    strId=@"";
    screenName=@"directsend";

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Text Field Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
   
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    [txtSearch setText:[txtSearch.text stringByReplacingCharactersInRange:range withString:string]];
    if(![txtSearch.text  isEqual: @""])
    {
        NSString *urlString=[NSString stringWithFormat:@"%@/SearchUser/%@/%@",WEBURL,userid,txtSearch.text];
        
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
                
                [self SearchUserResult:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self SearchUserResult:nil];
            
        }];
        
        [operation start];
        

    }
    return YES;
    
}
-(void)SearchUserResult:(NSMutableArray *)arr_Response
{
    if(arr_Response != NULL)
    {
        [tablev setHidden:NO];
        arrUsers=[arr_Response mutableCopy];
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
    return arrUsers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dict=  arrUsers[indexPath.row];
    AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 60, 60)];
    [img1.layer setBorderWidth: 0.0];
    [img1.layer setCornerRadius:30.0f];
    [img1.layer setMasksToBounds:YES];
    img1.layer.borderColor = [UIColor colorWithRed:201/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
    //img1.transform=CGAffineTransformMakeRotation(M_PI/2);
    img1.backgroundColor=[UIColor whiteColor];
    img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"userPic"]]];
    [cell addSubview:img1];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (75, 15, 230, 20);
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
    
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict=  arrUsers[indexPath.row];
    strId=[dict valueForKey:@"userid"];
    if([[dict objectForKey:@"name"] isEqualToString:@" "])
        [txtSearch setText:[dict objectForKey:@"username"]];
    else
        [txtSearch setText:[dict objectForKey:@"name"]];
    
    //[tablev setHidden:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(IBAction)doneButton:(id)sender
{
 if(![strId isEqualToString:@""])
 {
             NSString *url=[NSString stringWithFormat:@"%@/Post.svc/SharePostAsDirect/%@/%@/%@",appUrl,userid,strId,[selectedFeed valueForKey:@"postid"]];
            NSLog(@"%@",url);
          
            
    api_obj=[[APIViewController alloc]init];
    [api_obj directShareThePost:@selector(directShareThePostResult:) tempTarget:self :url];
     [LoaderViewController show:self.view animated:YES];
 }
    
        
    
}
-(void)directShareThePostResult:(NSDictionary *)dict_Response
{
    NSLog(@"Upload Result : %@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    if (dict_Response==NULL)
    {
        
      
        
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        
        if([[dict_Response valueForKey:@"status"] integerValue]==200)
        {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
