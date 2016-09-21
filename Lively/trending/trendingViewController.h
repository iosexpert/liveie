//
//  trendingViewController.h
//  Lively
//
//  Created by Vinay Sharma on 21/12/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "MachineCollectionCell.h"

@interface trendingViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIScrollView *collectionscrolv;
    IBOutlet UITableView *tablev;
    IBOutlet UIScrollView *collectionscrolv1;

    IBOutlet UICollectionView *collectV;
    
    IBOutlet UIButton *gridListbtn;
}
@property (strong, nonatomic)NSMutableArray *trendArr;

@end
