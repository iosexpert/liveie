//
//  settingsViewController.h
//  Lively
//
//  Created by Vinay Sharma on 07/01/16.
//  Copyright (c) 2016 Brahmasys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AFNetworking.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface settingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate, UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    NSArray *arrSettings;
    IBOutlet UITableView *tblSettings;
    NSString *strPass;

}
@property (nonatomic, retain) UIDocumentInteractionController *documentController;

@end
