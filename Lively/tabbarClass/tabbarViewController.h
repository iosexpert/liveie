//
//  tabbarViewController.h
//  Huntway
//
//  Created by Suffescom solutions on 19/05/14.
//  Copyright (c) 2014 Suffescom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tabbarViewController : UIViewController<UITabBarDelegate>

{
    UITabBarController *tabbar;
    UIImageView *imgFirst,*imgSecond,*imgThird,*imgFourth;
}
@property(nonatomic, weak) IBOutlet UIButton *FirstButton;
-(void)addFirstButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;
@end
