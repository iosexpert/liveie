//
//  uploadVideoViewController.h
//  Lively
//
//  Created by Brahmasys on 19/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface uploadVideoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITextView *descView;
    IBOutlet UIView *videoThumb;
    IBOutlet UIScrollView *names_scrv;
    IBOutlet UIButton *location_feild;;
    IBOutlet UITableView *tablev,*tblSelected;
    IBOutlet UITextField *txtSearch;
    NSMutableArray *arrUsers,*selectedArr;
    NSString *strId;
    IBOutlet UIView *viewSc;
    
    
     IBOutlet UIButton *public_btn;
     IBOutlet UIButton *direct_btn;
}
@property (retain, nonatomic) NSData *vCompressedData;


-(IBAction)doneButton:(id)sender;
-(IBAction)addLocationButton:(id)sender;
@end
