//
//  searchViewController.m
//  Lively
//
//  Created by Brahmasys on 18/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "searchViewController.h"
#import "otheruserViewController.h"
#import "trendingViewController.h"
#import "recentViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "reSharePostViewController.h"
#import "postOfHashTagView.h"
#import "getNearByViewController.h"
#import "AGPushNoteView.h"
@interface searchViewController ()
{
    
    APIViewController *api_obj;
    
    
    NSMutableArray *trendArr,*peopleArr,*recentArr,*nearbyArr;
    NSMutableArray *searchtrendArr,*searchpeopleArr,*searchrecentArr,*searchnearbyArr;
}
@end

@implementation searchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText  isEqual: @""])
    {
        [tblSearch setHidden:NO];
        
        api_obj=[[APIViewController alloc]init];
        [api_obj Search:@selector(searchresult:) tempTarget:self :searchText];
    }

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchbar.showsCancelButton=NO;
    [tblSearch setHidden:YES];
    [searchBar resignFirstResponder];
    [search_b resignFirstResponder];
    searchbar.text=@"";
    
      
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchbar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
    [tblSearch setHidden:YES];
    [search_b resignFirstResponder];
    searchbar.text=@"";
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchbar.showsCancelButton=YES;
    [tblSearch setHidden:NO];
    searchbar.returnKeyType=UIReturnKeyDone;

    return YES;
}
- (void)viewDidLoad
{
    [LoaderViewController show:self.view animated:YES];


    for (UIView *subview in searchbar.subviews)
    {
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)])
        {
            [(UITextField *)subview setClearButtonMode:UITextFieldViewModeWhileEditing];
        }
    }
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor darkGrayColor]];
    
    searchbar.barTintColor = [UIColor clearColor];
    searchbar.backgroundImage = [UIImage new];
    
    
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    searchbar.returnKeyType=UIReturnKeyDone;
    
    mainScrolV.contentSize=CGSizeMake(100, self.view.frame.size.height-64);
    
}
-(void)viewWillDisappear:(BOOL)animated
{
searchbar.showsCancelButton=NO;
[searchbar resignFirstResponder];
[tblSearch setHidden:YES];
[search_b resignFirstResponder];
searchbar.text=@"";
}
-(void)viewWillAppear:(BOOL)animated
{
    

    screenName=@"search";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopVideo" object:self];

    if(pushback==4)
    {
        pushback=0;
        reSharePostViewController *mvc;
        if(iphone4)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:NO];
        
    }

    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    

    api_obj=[[APIViewController alloc]init];
    [api_obj searchScreenData:@selector(searchScreenDataResult:) tempTarget:self ];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchScreenDataResult:(NSDictionary *)dict_Response
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
            if(self.tabBarController.selectedIndex==1)
            {
            trendArr=[[dict_Response objectForKey:@"trending"]mutableCopy];
            peopleArr=[[dict_Response objectForKey:@"peoples"]mutableCopy];
                if(peopleArr.count == 0)
                {
                    [lblNoPeople setHidden:NO];
                }
                else
                {
                    [lblNoPeople setHidden:YES];
                }
            recentArr=[[dict_Response objectForKey:@"recent"]mutableCopy];
            nearbyArr=[[dict_Response objectForKey:@"nearby_post"]mutableCopy];
                
                
                arrSearch=[NSMutableArray new];
                arrSearch=[[dict_Response objectForKey:@"trending"]mutableCopy];
                [tblSearch reloadData];
            
            [self addDataToScrollViews];
            }
            
        }
    }
}
-(void)addDataToScrollViews
{
    
    for(UIView *subview in [trendingScrv subviews]) {
        [subview removeFromSuperview];
    }
    for(UIView *subview in [recentScrv subviews]) {
        [subview removeFromSuperview];
    }
    for(UIView *subview in [nearByScrv subviews]) {
        [subview removeFromSuperview];
    }
    for(UIView *subview in [peopleScrv subviews]) {
        [subview removeFromSuperview];
    }
    int x=10;
    for(int i=0;i<trendArr.count;i++)
    {
        NSMutableDictionary *dict=trendArr[i];
        AsyncImageView *img1;
        if(iphone5||iphone4)
        img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, 5, 60, 60)];
        else
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, 5, 90, 90)];
        img1.contentMode = UIViewContentModeScaleAspectFill;
        [img1.layer setMasksToBounds:YES];
        img1.layer.cornerRadius=img1.frame.size.width/2;
        img1.backgroundColor=[UIColor whiteColor];
        img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"pic"]]];
        [trendingScrv addSubview:img1];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(openTrending:)forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:11]];
        NSArray* foo = [[dict valueForKey:@"hashtag"] componentsSeparatedByString: @" "];
        [button setTitle:foo[0]  forState:UIControlStateNormal];

        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.tag=i;
        //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if(iphone5||iphone4){
        button.frame =CGRectMake  (x+3, 10, 60,80);
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -64, 0.0)];
        }
        else
        {
            button.frame =CGRectMake  (x+3, 10, 90,100);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -94, 0.0)];
        }
        [trendingScrv addSubview:button];
            x=x+img1.frame.size.width+10;

        if(i==trendArr.count-1)
        {
            UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [morebutton addTarget:self action:@selector(openTrending:)forControlEvents:UIControlEventTouchUpInside];
            [morebutton.titleLabel setFont:[UIFont fontWithName:@"Arial Bold" size:12]];
            [morebutton setTitle:@"MORE" forState:UIControlStateNormal];
            [morebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [morebutton.layer setMasksToBounds:YES];
            morebutton.layer.cornerRadius=img1.frame.size.width/2;
            morebutton.backgroundColor=[UIColor purpleColor];
            morebutton.alpha=0.8;
            morebutton.tag=i+1;
            //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if(iphone5||iphone4)
            morebutton.frame =CGRectMake  (x, 5, 60,60);
            else
                morebutton.frame =CGRectMake  (x, 5, 90,90);

            [morebutton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)];
            [trendingScrv addSubview:morebutton];
            x=x+70;
        }
        
        
    }
    trendingScrv.contentSize=CGSizeMake(x+80, 60);
    x=10;
    for(int i=0;i<nearbyArr.count;i++)
    {
        
        NSMutableDictionary *dict=nearbyArr[i];
        AsyncImageView *img1;
        if(iphone5||iphone4)
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, 5, 60, 60)];
        else
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, 5, 90, 90)];        img1.contentMode = UIViewContentModeScaleAspectFill;
        [img1.layer setMasksToBounds:YES];
        img1.layer.cornerRadius=img1.frame.size.width/2;
        img1.backgroundColor=[UIColor whiteColor];
        
        if([[dict valueForKey:@"thumb_small"] isEqualToString:@""])
            img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
        else
            img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb_small"]]];
        [nearByScrv addSubview:img1];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(openNearBY:)forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:11]];
        NSArray* foo = [[dict valueForKey:@"caption"] componentsSeparatedByString: @" "];
        [button setTitle:foo[0]  forState:UIControlStateNormal];

        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.tag=i;
        //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if(iphone5||iphone4){
            button.frame =CGRectMake  (x+3, 10, 60,80);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -64, 0.0)];
        }
        else
        {
            button.frame =CGRectMake  (x+3, 10, 90,100);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -94, 0.0)];
        }

        [nearByScrv addSubview:button];
        x=x+img1.frame.size.width+10;
        if(i==nearbyArr.count-1)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(openNearBY:)forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont fontWithName:@"Arial Bold" size:12]];
            [button setTitle:@"MORE" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.alpha=0.8;
            
            [button.layer setMasksToBounds:YES];
            button.layer.cornerRadius=img1.frame.size.width/2;
            button.backgroundColor=[UIColor purpleColor];
            button.tag=i+1;
            //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if(iphone5||iphone4)
                button.frame =CGRectMake  (x, 5, 60,60);
            else
                button.frame =CGRectMake  (x, 5, 90,90);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)];
            [nearByScrv addSubview:button];
            
            x=x+70;
        }

        
    }
    nearByScrv.contentSize=CGSizeMake(x+80, 60);
    x=10;
    
    for(int i=0;i<peopleArr.count;i++)
    {
        
        NSMutableDictionary *dict=peopleArr[i];
        AsyncImageView *img1;
        if(iphone5||iphone4)
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, 5, 60, 60)];
        else
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, 5, 90, 90)];        img1.contentMode = UIViewContentModeScaleAspectFill;
        [img1.layer setMasksToBounds:YES];
        img1.layer.cornerRadius=img1.frame.size.width/2;
        img1.backgroundColor=[UIColor whiteColor];
        img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"pic"]]];
        [peopleScrv addSubview:img1];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(openPeople:)forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:11]];
        NSArray* foo = [[dict valueForKey:@"name"] componentsSeparatedByString: @" "];
        [button setTitle:foo[0]  forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.tag=i;
        //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if(iphone5||iphone4){
            button.frame =CGRectMake  (x+3, 10, 60,80);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -64, 0.0)];
        }
        else
        {
            button.frame =CGRectMake  (x+3, 10, 90,100);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -94, 0.0)];
        }

        [peopleScrv addSubview:button];
        x=x+img1.frame.size.width+10;
        if(i==peopleArr.count-1)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(openUsers)forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont fontWithName:@"Arial Bold" size:12]];
            [button setTitle:@"MORE" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
            button.alpha=0.8;
            
            [button.layer setMasksToBounds:YES];
            button.layer.cornerRadius=img1.frame.size.width/2;
            button.backgroundColor=[UIColor purpleColor];
            button.tag=i+1;
            //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if(iphone5||iphone4)
                button.frame =CGRectMake  (x, 5, 60,60);
            else
                button.frame =CGRectMake  (x, 5, 90,90);             [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)];
            [peopleScrv addSubview:button];
            
            x=x+70;
        }

    }
    peopleScrv.contentSize=CGSizeMake(x+70, 60);
    x=10;
    
    for(int i=0;i<recentArr.count;i++)
    {
        
        NSMutableDictionary *dict=recentArr[i];
        AsyncImageView *img1;
        if(iphone5||iphone4)
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, 5, 60, 60)];
        else
            img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(x, 5, 90, 90)];
        img1.contentMode = UIViewContentModeScaleAspectFill;
        [img1.layer setMasksToBounds:YES];
        img1.layer.cornerRadius=img1.frame.size.width/2;
        img1.backgroundColor=[UIColor whiteColor];
        if([[dict valueForKey:@"thumb_small"] isEqualToString:@""])
            img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb"]]];
        else
            img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"thumb_small"]]];
        
        [recentScrv addSubview:img1];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(openRecent:)forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:11]];
        NSArray* foo = [[dict valueForKey:@"caption"] componentsSeparatedByString: @" "];
        [button setTitle:foo[0]  forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.tag=i;
        //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if(iphone5||iphone4){
            button.frame =CGRectMake  (x+3, 10, 60,80);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -64, 0.0)];
        }
        else
        {
            button.frame =CGRectMake  (x+3, 10, 90,100);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -94, 0.0)];
        }

        [recentScrv addSubview:button];
        x=x+img1.frame.size.width+10;
        if(i==recentArr.count-1)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(openRecent:)forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont fontWithName:@"Arial Bold" size:12]];
            [button setTitle:@"MORE" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.alpha=0.8;

            [button.layer setMasksToBounds:YES];
            button.layer.cornerRadius=img1.frame.size.width/2;
            button.backgroundColor=[UIColor purpleColor];
            button.tag=i+1;
            //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if(iphone5||iphone4)
                button.frame =CGRectMake  (x, 5, 60,60);
            else
                button.frame =CGRectMake  (x, 5, 90,90);
            
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)];
            [recentScrv addSubview:button];

 x=x+70;
            
        }
       
    }
    recentScrv.contentSize=CGSizeMake(x+70, 60);
    
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    

}

- (void)openTrending:(UIButton*)btn
{
    if(btn.tag<trendArr.count)
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
    else
    {
        trendingViewController *mvc;
        if(iphone4)
        {
            mvc=[[trendingViewController alloc]initWithNibName:@"trendingViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[trendingViewController alloc]initWithNibName:@"trendingViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[trendingViewController alloc]initWithNibName:@"trendingViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[trendingViewController alloc]initWithNibName:@"trendingViewController@6P" bundle:nil];
        }
        else
        {
            mvc=[[trendingViewController alloc]initWithNibName:@"trendingViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }

}
- (void)openNearBY:(UIButton*)btn
{
    if(btn.tag==nearbyArr.count)
    {
        getNearByViewController *mvc;
        
        if(iphone4)
        {
            mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController@6P" bundle:nil];
        }
        else
        {
            mvc=[[getNearByViewController alloc]initWithNibName:@"getNearByViewController@ipad" bundle:nil];
        }
        mvc.postArr=nearbyArr;
        mvc.strTop=[NSString stringWithFormat:@"%f/%f",lng,lat];
        [self.navigationController pushViewController:mvc animated:YES];
    }
    else
    {
        selectedFeed=[nearbyArr objectAtIndex:btn.tag];
        reSharePostViewController *mvc;
        if(iphone4)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
        
    }

}
- (void)openRecent:(UIButton*)btn
{
    if(btn.tag==recentArr.count)
    {
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
         mvc.postArr=recentArr;
        mvc.strTop=@"RECENT";

        [self.navigationController pushViewController:mvc animated:YES];
    }
    else
    {
        selectedFeed=[recentArr objectAtIndex:btn.tag];
        reSharePostViewController *mvc;
        if(iphone4)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];

    }
}

-(void)openUsers
{
    recentViewController *mvc;
    if(iphone4)
    {
        mvc=[[recentViewController alloc]initWithNibName:@"recentViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[recentViewController alloc]initWithNibName:@"recentViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[recentViewController alloc]initWithNibName:@"recentViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[recentViewController alloc]initWithNibName:@"recentViewController@6P" bundle:nil];
    }
    else
    {
        mvc=[[recentViewController alloc]initWithNibName:@"recentViewController@ipad" bundle:nil];
    }
    mvc.recentArr=peopleArr;
    [self.navigationController pushViewController:mvc animated:YES];

}
- (void)openPeople:(UIButton*)btn
{
    friendID=[[peopleArr objectAtIndex:btn.tag]valueForKey:@"userid"];
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

#pragma mark Text Field Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor=[UIColor purpleColor].CGColor;
    textField.layer.borderWidth=1.0;
    textField.layer.cornerRadius=5;
    [tblSearch setHidden:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:NO];
    //[tblSearch reloadData];

}
-(void)targetMethod:(NSTimer *)timer {
    //do smth
    [tblSearch reloadData];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([textField.text  isEqual:@""])
    {
        [tblSearch setHidden:YES];
        
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([textField.text  isEqual:@""])
    {
        [tblSearch setHidden:YES];
        textField.layer.borderWidth=0.0;
        
    }
    return YES;
}
-(void)textFieldDidChange :(UITextField *)theTextField
{
   if(![theTextField.text  isEqual: @""])
   {
       [tblSearch setHidden:NO];

       api_obj=[[APIViewController alloc]init];
       [api_obj Search:@selector(searchresult:) tempTarget:self :theTextField.text];
   }
 
    
    
}
-(void)searchresult:(NSMutableArray*)arr_Response
{
    if(arr_Response.count>0)
    {
        searchtrendArr=[[arr_Response valueForKey:@"hash_list"]mutableCopy];
        searchpeopleArr=[[arr_Response valueForKey:@"people_list"]mutableCopy];
        searchrecentArr=[[arr_Response valueForKey:@"recent_list"]mutableCopy];
        searchnearbyArr=[[arr_Response valueForKey:@"nearby_list"]mutableCopy];
        arrSearch=[arr_Response mutableCopy];
        [tblSearch reloadData];
    }
}

-(IBAction)cancelSearch:(id)sender
{
    [tblSearch setHidden:YES];
    [search_b resignFirstResponder];
    search_b.text=@"";
}


#pragma mark Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(searchtrendArr.count>0 || searchpeopleArr.count>0 || searchrecentArr.count>0 || searchnearbyArr.count>0)
    {
    return 4;
    }
    else
    {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return searchtrendArr.count;
    else if(section==1)
        return searchpeopleArr.count;
    else if(section==2)
        return searchrecentArr.count;
        else
            return searchnearbyArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string =@"";
    if(section==0)
        string =@"TRENDING";
        else if(section==1)
            string =@"PEOPLE";
            else if(section==2)
                string =@"RECENT";
                else if(section==3)
                    string =@"NEAR BY";
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if(indexPath.section==0)
    {
        NSMutableDictionary *dict=  searchtrendArr[indexPath.row];
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:14];
        CGRect labelFrame = CGRectMake (20, 20, 230, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[dict objectForKey:@"hashtag"]];
        [cell addSubview:label];

    }
    if(indexPath.section==1)
    {
        NSMutableDictionary *dict=  searchpeopleArr[indexPath.row];
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:14];
        CGRect labelFrame = CGRectMake (20, 20, 230, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[dict objectForKey:@"username"]];
        [cell addSubview:label];
        
    }

    if(indexPath.section==2)
    {
        NSMutableDictionary *dict=  searchrecentArr[indexPath.row];
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:14];
        CGRect labelFrame = CGRectMake (20, 20, 230, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[dict objectForKey:@"hashtag"]];
        [cell addSubview:label];
        
    }

    if(indexPath.section==3)
    {
        NSMutableDictionary *dict=  searchnearbyArr[indexPath.row];
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:14];
        CGRect labelFrame = CGRectMake (20, 20, 230, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:[dict objectForKey:@"caption"]];
        [cell addSubview:label];
        
    }

    
    
   
    
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
        selectedHashTag=[[searchtrendArr objectAtIndex:indexPath.row]valueForKey:@"hashtag"];
        
        
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
    else if(indexPath.section==1)
    {
        friendID=[[searchpeopleArr objectAtIndex:indexPath.row]valueForKey:@"userid"];
        [self userprofileopen];

    }
    else if(indexPath.section==2)
    {
        NSMutableDictionary *dict=searchrecentArr[indexPath.row];
        selectedHashTag=[dict valueForKey:@"hashtag"];
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
    else
    {
        selectedFeed=[searchnearbyArr objectAtIndex:indexPath.row];
        reSharePostViewController *mvc;
        if(iphone4)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
        }
        else
        {
            mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
        }
        [self.navigationController pushViewController:mvc animated:YES];
        
    }

   
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return 60;
}

@end
