//
//  directViewController.h
//  Lively
//
//  Created by Vinay Sharma on 21/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface directViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tablev;
}
@end
