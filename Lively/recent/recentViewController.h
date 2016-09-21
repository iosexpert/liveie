//
//  recentViewController.h
//  Lively
//
//  Created by Vinay Sharma on 23/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    IBOutlet UIScrollView *recentScrv;
    IBOutlet UITableView *tablev;
    IBOutlet UIButton *gridListbtn;
    
}
@property (strong, nonatomic)NSMutableArray *recentArr;
@end
