//
//  searchViewController.h
//  Lively
//
//  Created by Brahmasys on 18/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface searchViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    IBOutlet UIScrollView *trendingScrv;
    IBOutlet UIScrollView *peopleScrv;
    IBOutlet UIScrollView *recentScrv;
    IBOutlet UIScrollView *nearByScrv;
    IBOutlet UITableView *tblSearch;
    IBOutlet UITextField *search_b;
    NSMutableArray *arrSearch;
    IBOutlet UILabel *lblNoPeople;
    
    IBOutlet UISearchBar *searchbar;
    
    IBOutlet UIScrollView *mainScrolV;
}
@end
