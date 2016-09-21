//
//  UpdateViewController.m
//  Lively
//
//  Created by azadhada on 16/08/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden=YES;
    self.navigationController.navigationBar.translucent = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)UpdateClick:(id)sender
{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/liveie/id1096042366?mt=8"]];
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
