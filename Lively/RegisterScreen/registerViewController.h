//
//  registerViewController.h
//  Lively App
//
//  Created by Brahmasys on 05/10/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface registerViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{


    IBOutlet UITextField *txtUserName,*txtEmail,*txtPassword,*txtfirst,*txtlast;
    IBOutlet UIButton *btnRegister;
    IBOutlet UIScrollView *scrv;
    IBOutlet UIImageView *userImage;
}


@end
