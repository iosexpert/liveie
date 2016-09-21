//
//  directVideoViewController.h
//  
//
//  Created by Brahmasys on 21/01/16.
//
//

#import <UIKit/UIKit.h>

@interface directVideoViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITableView *tablev;
    IBOutlet UITextField *txtSearch;
    NSMutableArray *arrUsers;
    NSString *strId;
}
@end
