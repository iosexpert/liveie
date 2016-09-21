//
//  loginViewController.h
//  Lively
//
//  Created by Brahmasys on 16/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;


@interface loginViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
IBOutlet UITextField *email_feild;
IBOutlet UITextField *password;
IBOutlet UIScrollView *scrv;
}
@property (strong, nonatomic) CLLocation *cLocation;

@end
