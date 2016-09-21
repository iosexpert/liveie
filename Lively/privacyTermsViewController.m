//
//  privacyTermsViewController.m
//  Lively
//
//  Created by Brahmasys on 10/05/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "privacyTermsViewController.h"

@interface privacyTermsViewController ()

@end

@implementation privacyTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back_Button:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
