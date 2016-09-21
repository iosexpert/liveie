//
//  homeViewController.h
//  Lively
//
//  Created by Brahmasys on 17/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeFeedsCell.h"
#import "STTweetLabel.h"

#import <MediaPlayer/MediaPlayer.h>
#import "AVPlayerDemoPlaybackView.h"
@import CoreLocation;
@import MapKit;
@interface homeViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet homeFeedsCell *celll;
    
    IBOutlet UITableView *collectionV;
    UIView *viewOptions,*viewOptions1;
    int indexOptions;
    int indexPost;
    IBOutlet UIScrollView *scrolv;
    CGRect oldFrame;
    IBOutlet UIImageView *imgPull;
    IBOutlet UIButton *cancelbtn;
    IBOutlet UIView *navigationView;

    
    IBOutlet UIActivityIndicatorView *Act_indicator;
}
@property (strong, nonatomic) CLLocation *cLocation;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end
