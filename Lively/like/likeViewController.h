//
//  likeViewController.h
//  Lively
//
//  Created by Vinay Sharma on 21/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface likeViewController : UIViewController
{
    IBOutlet UITableView *tablev;
}
@property (strong, nonatomic) NSString *strPostId;
@end
