//
//  locationSearchViewController.h
//  
//
//  Created by Brahmasys on 03/12/15.
//
//

#import <UIKit/UIKit.h>

@interface locationSearchViewController : UIViewController
{
    IBOutlet UISearchBar *serchb;
    
    IBOutlet UITableView *tablv;
}
@property (strong ,nonatomic) NSMutableArray *arrLoc;
-(IBAction)backButton:(id)sender;
-(IBAction)doneButton:(id)sender;
@end
