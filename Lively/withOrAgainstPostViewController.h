//
//  withOrAgainstPostViewController.h
//  
//
//  Created by Brahmasys on 03/12/15.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

#import <AWSS3/AWSS3.h>
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3TransferManager.h>
#import <AWSCore/AWSCredentialsProvider.h>

@import CoreLocation;
@interface withOrAgainstPostViewController : UIViewController<CLLocationManagerDelegate>
{
    IBOutlet AsyncImageView *thumb_img;
    IBOutlet UIView *videoThumb;
    IBOutlet UITextView *withTextView;
    
    
    IBOutlet UIScrollView *names_scrv;
    IBOutlet UIButton *location_feild;;

}
-(IBAction)addLocationButton:(id)sender;
-(IBAction)back_Button:(id)sender;
@end
