//
//  commentsOnFeedViewController.m
//  Lively
//
//  Created by Brahmasys on 24/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "commentsOnFeedViewController.h"
#import "otheruserViewController.h"
#import "AppDelegate.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AsyncImageView.h"
#import "reSharePostViewController.h"
#import "AGPushNoteView.h"

@interface commentsOnFeedViewController ()
{
    APIViewController *api_obj;
    
    NSMutableArray *messg,*namechat,*idchat,*imgchat,*datechat,*commentid,*action_arr;
    UILabel *label;
    UIView *popview;
    int reportcommentid;
}
@end

@implementation commentsOnFeedViewController

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
    

        message_box.text=[NSString stringWithFormat:@"%s%@ ","@",[commentFeed objectForKey:@"username"]];
    

    
    [super viewDidLoad];
    [message_box becomeFirstResponder];
    
    //selectedFeed
    
//    topLabel.text=[selectedFeed objectForKey:@"caption"];
//    thumb_img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",appUrl,[selectedFeed objectForKey:@"thumb"]]];
//    profile_img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",appUrl,[selectedFeed objectForKey:@"user_pic"]]];
//    [profile_img.layer setMasksToBounds:YES];
//    profile_img.layer.cornerRadius=30;
//    profile_img.backgroundColor=[UIColor grayColor];
//      NSString *st= [AppDelegate HourCalculation:[selectedFeed valueForKey:@"time"]];
//    [lblTime setText:st];
//    
//    lblName.text=[NSString stringWithFormat:@"%@,",[selectedFeed objectForKey:@"username"]];
//    lblLocation.text=[selectedFeed objectForKey:@"location"];
//    lblCaption.text=[selectedFeed objectForKey:@"caption"];
//
//   
//    
//    
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getFeedmessage:@selector(feedmessageresult:) tempTarget:self :[selectedFeed objectForKey:@"postid"] ];
//    [LoaderViewController show:self.view animated:YES];
//    HUD.labelText=@"Please Wait";
//    
//    UITabBarController *bar = [self tabBarController];
//    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
//        //iOS 7 - hide by property
//        NSLog(@"iOS 7");
//        [self setExtendedLayoutIncludesOpaqueBars:YES];
//        bar.tabBar.hidden = YES;
//    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text view deligates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if([textView.text isEqualToString:@""])
        {
            //textView.text=@"Write a Comment";
        }
        //[textView resignFirstResponder];
        //[scrv setContentOffset:CGPointMake(0, 0) animated:YES];
        return NO;
    }
    if(textView.text.length + (text.length - range.length) <= 200)
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Maximum word limit is reached" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"Write a Comment"])
    {
        textView.text=@"";
    }
    //[scrv setContentOffset:CGPointMake(0, 253) animated:YES];
    return YES;
}
- (IBAction)cancel_action:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [message_box resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];

   // [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)comment_action:(id)sender
{
    NSMutableDictionary *dict=[messg objectAtIndex:[sender tag]];
     [message_box becomeFirstResponder];
    [message_box setText:[NSString stringWithFormat:@"@%@ ",[dict valueForKey:@"commenterUserName"]]];
    
}
#pragma mark Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //innerScrv
    CGRect f = tablev.frame;
    f.size.height = 1000;
    tablev.frame =f;
    innerScrv.contentSize=CGSizeMake(300, (messg.count*90)+515);
    return messg.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dict=messg[indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString * myText =[[dict objectForKey:@"comment"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    CGFloat constrainedSize = 150.0f; //or any other size
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:13]; //or any other font that matches what you will use in the UILabel

    CGSize textSize = [myText sizeWithFont: myFont constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    
          AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(8, 10, 60, 60)];
        [img1.layer setBorderWidth: 0.0];
        [img1.layer setCornerRadius:25.0f];
        [img1.layer setMasksToBounds:YES];
        img1.backgroundColor=[UIColor grayColor];
        img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"commenterProfilePic"]]];
        [cell addSubview:img1];
        



    
    
    UILabel *timelbl = [[UILabel alloc] initWithFrame:CGRectMake (cell.frame.size.width-40,10, 30, 20)];
    [timelbl setFont:[UIFont fontWithName:@"Arial" size:15]];
    timelbl.textColor=[UIColor purpleColor];
    timelbl.backgroundColor=[UIColor clearColor];
    NSString *st= [AppDelegate HourCalculation:[dict valueForKey:@"time"]];
    [timelbl setText:st];
    [cell addSubview:timelbl];
    
    
    
//    UILabel *Likelbl = [[UILabel alloc] initWithFrame:CGRectMake (cell.frame.size.width-40,10, 40, 20)];
//    [Likelbl setFont:[UIFont fontWithName:@"Arial" size:12]];
//    Likelbl.textColor=[UIColor lightGrayColor];
//
//    [Likelbl setText:@""];
//    [cell addSubview:Likelbl];
//
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(openPeople:)forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
        [button setTitle:[dict objectForKey:@"commenterUserName"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        button.tag=indexPath.row;
        //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.frame =CGRectMake (45, 5, 85, 30);
        [cell addSubview:button];
        
        
        
            CGRect labelFrame = CGRectMake (70, 35,self.view.frame.size.width-85, textSize.height+10);
            UILabel *labell = [[UILabel alloc] initWithFrame:labelFrame];
            [labell setFont:myFont];
            labell.textColor=[UIColor grayColor];
            labell.lineBreakMode=NSLineBreakByWordWrapping;
            labell.numberOfLines=6;
    labell.backgroundColor=[UIColor clearColor];
            labell.text=myText;
            [cell addSubview:labell];
    
    UIButton *Like = [UIButton buttonWithType:UIButtonTypeCustom];
    [Like addTarget:self action:@selector(likeComment_action:)forControlEvents:UIControlEventTouchUpInside];
    Like.tag=indexPath.row;
    if([[dict valueForKey:@"like_status"]boolValue])
    [Like setImage:[UIImage imageNamed:@"like__filled"] forState:UIControlStateNormal];
    else
        [Like setImage:[UIImage imageNamed:@"likeG"] forState:UIControlStateNormal];
    //[report setTitle:@"Show View" forState:UIControlStateNormal];
    Like.frame = CGRectMake(70,textSize.height+labell.frame.origin.y+15, 40, 20);
    [cell addSubview:Like];
    
    UIButton *replyicon = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyicon addTarget:self
                  action:@selector(comment_action:)
        forControlEvents:UIControlEventTouchUpInside];
    replyicon.tag=indexPath.row;
    [replyicon setImage:[UIImage imageNamed:@"replyG"] forState:UIControlStateNormal];
    //[report setTitle:@"Show View" forState:UIControlStateNormal];
    replyicon.frame = CGRectMake(120,textSize.height+labell.frame.origin.y+15, 40, 20.0);
    //[cell addSubview:replyicon];
    
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [comment addTarget:self
                action:@selector(comment_action:)
      forControlEvents:UIControlEventTouchUpInside];
    comment.tag=indexPath.row;
    [comment.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    
    [comment setTitle:@"Comment" forState:UIControlStateNormal];
    [comment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //[report setTitle:@"Show View" forState:UIControlStateNormal];
    comment.frame = CGRectMake(165,textSize.height+labell.frame.origin.y+15, 70, 20.0);
    [cell addSubview:comment];
    
    
    
    
    
    UIButton *options = [UIButton buttonWithType:UIButtonTypeCustom];
//    [options addTarget:self
//                action:@selector(options_action:)
//      forControlEvents:UIControlEventTouchUpInside];
    options.tag=indexPath.row;
    [options setImage:[UIImage imageNamed:@"optionG"] forState:UIControlStateNormal];
    //[report setTitle:@"Show View" forState:UIControlStateNormal];
    options.frame = CGRectMake(250,textSize.height+labell.frame.origin.y+15, 50, 20.0);
    //[cell addSubview:options];
    
    
     cell.backgroundColor=[UIColor clearColor];
    
    return cell;
    
    
    
}

- (void)openPeople:(UIButton*)btn
{
    friendID=[[messg objectAtIndex:btn.tag]valueForKey:@"commenterid"];
    [self userprofileopen];
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString * myText =messg[indexPath.row];
//    NSArray *stringArray = [myText componentsSeparatedByString: @"."];
//    if([[stringArray lastObject] isEqualToString:@"jpeg"] || [[stringArray lastObject] isEqualToString:@"jpg"] || [[stringArray lastObject] isEqualToString:@"png"])
//    {
//        
//        popview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        popview.backgroundColor=[UIColor blackColor];
//        //popview.alpha=0.9;
//        
//        
//        
//        AsyncImageView *img=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        img.imageURL=[NSURL URLWithString:myText];
//        
//        img.contentMode = UIViewContentModeScaleAspectFit;
//        
//        
//        [popview addSubview:img];
//        [self.view addSubview:popview];
//    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict=messg[indexPath.row];
    

    NSString * myText =[[dict objectForKey:@"comment"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    CGFloat constrainedSize = 150.0f; //or any other size
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:13]; //or any other font that matches what you will use in the UILabel
    
    CGSize textSize = [myText sizeWithFont: myFont constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];

            return textSize.height+70;
    
    
}
-(void)feedmessageresult:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];

    }
    
    else
    {
        [tablev setHidden:NO];

        messg=[[NSMutableArray alloc]init];
       
        messg=[[dict_Response objectForKey:@"comment_list"]mutableCopy];
        [tablev reloadData];
        if(messg.count==0)
            {
                CGRect labelFrame = CGRectMake (0, 375, 320, 30);
                label = [[UILabel alloc] initWithFrame:labelFrame];
                [label setFont:[UIFont fontWithName:@"Arial" size:18]];
                label.textAlignment=NSTextAlignmentCenter;
                label.textColor=[UIColor grayColor];
                label.backgroundColor=[UIColor clearColor];
                [label setText:@"No Comments"];
                [self.view addSubview:label];
                tablev.hidden=YES;
                
            }
            else
            {
                label.hidden=YES;
            }
    
           }
    
    if(messg.count>0){
       // NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(aTime) userInfo:nil repeats:NO];
    }
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }

    
}
//
-(void)aTime
{
    NSInteger lastSectionIndex = [tablev numberOfSections] - 1;
    
    // Then grab the number of rows in the last section
    NSInteger lastRowIndex = [tablev numberOfRowsInSection:lastSectionIndex] - 1;
    
    // Now just construct the index path
    NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
    [tablev scrollToRowAtIndexPath:pathToLastRow atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (IBAction)send_action:(id)sender
{
    if([message_box.text isEqualToString:@"Write a Comment"]|| [message_box.text isEqualToString:@""])
    {
        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {

        
        if([[commentFeed valueForKey:@"post_type"]isEqualToString:@"reshare"])
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj commetOnFeed:@selector(commetOnFeedresult:) tempTarget:self : message_box.text : [commentFeed objectForKey:@"postid"]];
            [LoaderViewController show:self.view animated:YES];
        }
        else if(![[commentFeed valueForKey:@"post_type"]isEqualToString:@"public"] )
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj commetOnFeed:@selector(commetOnFeedresult:) tempTarget:self : message_box.text : [commentFeed objectForKey:@"parent_id"]];
            [LoaderViewController show:self.view animated:YES];
            
        }
        else
        {
        
        api_obj=[[APIViewController alloc]init];
        [api_obj commetOnFeed:@selector(commetOnFeedresult:) tempTarget:self : message_box.text : [commentFeed objectForKey:@"postid"]];
        [LoaderViewController show:self.view animated:YES];
        }
    }
    
}
-(void)commetOnFeedresult:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];

    }
    
    else
    {

            
            
        
        if([[dict_Response valueForKey:@"status"]intValue]==200)
        {
            [message_box resignFirstResponder];
            postAfterComment=[commentFeed mutableCopy];
            [self dismissViewControllerAnimated:YES completion:nil];
            

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Message failed. Please check your carrier connection or wifi connection and try again. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
    }
}



-(void)viewDidDisappear:(BOOL)animated
{
    commentString=@"";
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
   
    

    
    

}
-(void)likeComment_action:(UIButton*)bt
{
    NSString *st;
    if([UIImagePNGRepresentation([bt imageForState:UIControlStateNormal] )isEqualToData: UIImagePNGRepresentation([UIImage imageNamed:@"like__filled"])])
    {
        st=@"false";
    }
    else
    {
        st=@"true";
    }

    NSMutableDictionary *dict=messg[bt.tag];
    api_obj=[[APIViewController alloc]init];
    [api_obj likeOnFeed:@selector(getCommentlikeresult:) tempTarget:self :[dict objectForKey:@"comment_id"] :st];
}
-(void)getCommentlikeresult:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    
    else
    {
        if([[dict_Response  valueForKey:@"status"]integerValue]==200 )
        {
            
            api_obj=[[APIViewController alloc]init];
            [api_obj getFeedmessage:@selector(feedmessageresult:) tempTarget:self :[commentFeed objectForKey:@"postid"] ];

       
        }
        else
        {
            
        }
    }
}

@end
