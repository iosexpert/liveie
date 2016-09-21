//
//  editCommentViewController.m
//  Lively
//
//  Created by Brahmasys on 10/05/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "editCommentViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"


@interface editCommentViewController ()
{
    APIViewController *api_obj;
}
@end

@implementation editCommentViewController
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
    message_box.text=[NSString stringWithFormat:@"%@ ",[commentFeed objectForKey:@"caption"]];
    
    
    [super viewDidLoad];
    [message_box becomeFirstResponder];
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
- (IBAction)send_action:(id)sender
{
    if([message_box.text isEqualToString:@"Write a Comment"]|| [message_box.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
        if(![[commentFeed valueForKey:@"post_type"]isEqualToString:@"public"] )
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj editCommetOnFeed:@selector(commetOnFeedresult:) tempTarget:self : message_box.text : [commentFeed objectForKey:@"postid"]];
            [LoaderViewController show:self.view animated:YES];
            
        }
        else if([[commentFeed valueForKey:@"post_type"]isEqualToString:@"reshare"])
        {
            api_obj=[[APIViewController alloc]init];
            [api_obj editCommetOnFeed:@selector(commetOnFeedresult:) tempTarget:self : message_box.text : [commentFeed objectForKey:@"postid"]];
            [LoaderViewController show:self.view animated:YES];
        }
        else
        {
            
            api_obj=[[APIViewController alloc]init];
            [api_obj editCommetOnFeed:@selector(commetOnFeedresult:) tempTarget:self : message_box.text : [commentFeed objectForKey:@"postid"]];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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

@end
