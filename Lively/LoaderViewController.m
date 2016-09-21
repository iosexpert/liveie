//
//  LoaderViewController.m
//  Lively
//
//  Created by azadhada on 03/05/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "LoaderViewController.h"

@interface LoaderViewController ()

@end

@implementation LoaderViewController
- (void)viewDidLoad {
    
  
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (BOOL)show:(UIView *)view animated:(BOOL)animated
{
   
    viewLoader =[[UIView alloc]init];
    [viewLoader setBackgroundColor:[UIColor clearColor]];
    [viewLoader setFrame:view.bounds];
    [view addSubview:viewLoader];
    UIImageView *imgLoader=[[UIImageView alloc]init];
    [imgLoader setFrame:CGRectMake(view.center.x-20, view.center.y-20, 40, 40)];
    [viewLoader addSubview:imgLoader];
    
    imgLoader.animationImages = [[NSArray alloc] initWithObjects:
                                 [UIImage imageNamed:@"1 (1).png"],
                                 [UIImage imageNamed:@"1 (2).png"],
                                 [UIImage imageNamed:@"1 (3).png"],
                                 [UIImage imageNamed:@"1 (4).png"],
                                 [UIImage imageNamed:@"1 (5).png"],
                                 [UIImage imageNamed:@"1 (6).png"],
                                 [UIImage imageNamed:@"1 (7).png"],
                                 [UIImage imageNamed:@"1 (8).png"],
                                 [UIImage imageNamed:@"1 (9).png"],
                                 [UIImage imageNamed:@"1 (10).png"],
                                 [UIImage imageNamed:@"1 (11).png"],
                                 [UIImage imageNamed:@"1 (12).png"],
                                 [UIImage imageNamed:@"1 (13).png"],
                                 [UIImage imageNamed:@"1 (14).png"],
                                 [UIImage imageNamed:@"1 (15).png"],
                                 [UIImage imageNamed:@"1 (16).png"],
                                 [UIImage imageNamed:@"1 (17).png"],
                                 [UIImage imageNamed:@"1 (18).png"],
                                 [UIImage imageNamed:@"1 (19).png"],
                                 [UIImage imageNamed:@"1 (20).png"],
                                 [UIImage imageNamed:@"1 (21).png"],
                                 [UIImage imageNamed:@"1 (22).png"],
                                 [UIImage imageNamed:@"1 (23).png"],
                                 [UIImage imageNamed:@"1 (24).png"],
                                 [UIImage imageNamed:@"1 (25).png"],
                                 [UIImage imageNamed:@"1 (26).png"],
                                 [UIImage imageNamed:@"1 (27).png"],
                                 [UIImage imageNamed:@"1 (28).png"],
                                 [UIImage imageNamed:@"1 (29).png"],
                                 [UIImage imageNamed:@"1 (30).png"],
                                 nil];
    [imgLoader startAnimating];
    
    return YES;

}

+ (BOOL)remove:(UIView *)view animated:(BOOL)animated
{
    [viewLoader removeFromSuperview];
    viewLoader=nil;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
