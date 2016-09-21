//
//  LoaderViewController.h
//  Lively
//
//  Created by azadhada on 03/05/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderViewController : UIViewController


+ (BOOL)show:(UIView *)view animated:(BOOL)animated;
+ (BOOL)remove:(UIView *)view animated:(BOOL)animated;

@end
