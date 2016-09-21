//
//  editProfileViewController.h
//  
//
//  Created by Brahmasys on 11/01/16.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface editProfileViewController : UIViewController<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITextField *fname;
    IBOutlet UITextField *lname;
    IBOutlet UITextField *email;
    IBOutlet UITextField *gender;
    IBOutlet UITextField *phone;
    IBOutlet UITextField *dob;
    IBOutlet UITextField *countryCode;
    
    IBOutlet UITextView *about;
    
    IBOutlet AsyncImageView *cover_img;
    IBOutlet AsyncImageView *profile_img;
    
    IBOutlet UIButton *maleBtn;
    IBOutlet UIButton *femaleBtn;
    
    IBOutlet UIScrollView *scrv;
}
-(IBAction)changeProfilePic:(UIButton*)sender;
-(IBAction)changeCoverImage:(UIButton*)recognizer;

-(IBAction)maleAction:(UIButton*)sender;
-(IBAction)femaleAction:(UIButton*)sender;
@end
