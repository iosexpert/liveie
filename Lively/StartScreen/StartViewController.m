//
//  StartViewController.m
//  Lively
//
//  Created by azadhada on 27/04/16.
//  Copyright © 2016 Brahmasys. All rights reserved.
//

#import "StartViewController.h"
#import "tabbarViewController.h"
#import "AppDelegate.h"
#import "APIViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LoaderViewController.h"

@interface StartViewController ()
{
    NSMutableArray *arrWorkContact,*arrOtherContacts;
    APIViewController *api_obj;
}
@end

@implementation StartViewController

- (void)viewDidLoad {
    
    
    
    
    arrWorkContact=[NSMutableArray new];
    arrOtherContacts=[NSMutableArray new];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    [LoaderViewController show:self.view animated:YES];

    
    
    NSMutableArray *arrName = [[NSMutableArray alloc] init];
    NSMutableArray *arrContactLabel=[NSMutableArray new];
    NSMutableArray *arrAllNumbers=[NSMutableArray new];
    NSMutableArray *arrNumbers=[NSMutableArray new];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    
    for (int i=0;i < nPeople;i++) {
      NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        // ABMultiValueRef images =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonImageFormatOriginalSize));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if(firstName==NULL)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@""] forKey:@"name"];
        }
        else if(lastName==NULL)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@", firstName] forKey:@"name"];
        }
        else
        {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        }
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, i);
           NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            [arrContactLabel addObject:phoneLabel];
            [arrAllNumbers addObject:phoneNumber];
            NSLog(@"  - %@ (%@)", phoneNumber, phoneLabel);
            
            [dOfPerson setObject:phoneNumber forKey:@"Phone"];
            if(![phoneNumber isEqualToString:@""])
            {
                [arrNumbers addObject:dOfPerson];
            }
            //  for(int i =0; i<[arraytwo count]; i++)
            //  {
            //      if (![arrayone containsObject:[arraytwo objectAtIndex:i]])
            //         [arraythree addObject: [arraytwo obectAtIndex:i]];
            // }
            //  NSLog(@"%@",arraythree);
            
        }
        
        //for images
        
        
        CFDataRef imageData = ABPersonCopyImageData(ref);
        //UIImage *image = [UIImage imageWithData:(__bridge NSData *)imageData];
        if(imageData==NULL)
        {
            [dOfPerson setObject:[NSString stringWithFormat:@""] forKey:@"image"];
        }
        else
        {
            [dOfPerson setObject:(__bridge id)(imageData) forKey:@"image"];
        }
        // [arrayUserList addObject:dOfPerson];
        //for check
        
        
        [arrName addObject:dOfPerson];
    }
    for(int i=0;i<arrContactLabel.count;i++)
    {
       NSMutableDictionary *dictTemp=[arrNumbers objectAtIndex:i] ;
        
        //Work Contacts
        if([[arrContactLabel objectAtIndex:i] isEqual:@"work"])
        {
            NSString *code;
            NSString *str=[dictTemp objectForKey:@"Phone"];
            //            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()-+ "];
            str = [[str componentsSeparatedByCharactersInSet:
                    [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                   componentsJoinedByString:@""];
            if(!(str.length<10))
            {
                code = [str substringFromIndex: [str length] - 10];
                [arrWorkContact addObject:code];
                
            }
        }
        else                   //Other Contacts
        {
            NSString *code;
            NSString *str=[dictTemp objectForKey:@"Phone"];
            //            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()-+ "];
            str = [[str componentsSeparatedByCharactersInSet:
                    [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                   componentsJoinedByString:@""];
            if(!(str.length<10))
            {
                code = [str substringFromIndex: [str length] - 10];
                [arrOtherContacts addObject:code];
                
            }
        }
    }
    
    
    
    
    NSLog(@"Contacts = %@",arrOtherContacts);
    NSLog(@"WorkContacts = %@",arrWorkContact);
    [self SyncPhoneBook];
    
}

-(void)SyncPhoneBook
{
    api_obj=[[APIViewController alloc]init];
    [api_obj SyncPhoneBook:@selector(SyncPhoneBookResult:) tempTarget:self :arrOtherContacts :arrWorkContact];
}
-(void)SyncPhoneBookResult:(NSMutableDictionary*)dict
{
    NSLog(@"SyncPhoneBookResult%@",dict);
    [LoaderViewController remove:self.view animated:YES];
}

-(IBAction)FindFriends:(id)sender
{
    tabbarViewController *mvc;
    mvc=[[tabbarViewController alloc]init];
    AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
    start=@"find";
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
    nav.navigationBarHidden=YES;
    testAppDelegate.window.rootViewController=nav;
}
-(IBAction)SkipClick:(id)sender
{
    tabbarViewController *mvc;
    mvc=[[tabbarViewController alloc]init];
    AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
    start=@"skip";
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
    nav.navigationBarHidden=YES;
    testAppDelegate.window.rootViewController=nav;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
