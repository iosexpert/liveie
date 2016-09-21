//
//  loginViewController.m
//  Lively
//
//  Created by Brahmasys on 16/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "loginViewController.h"
#import "Utilities.h"

#import "APIViewController.h"
#import "LoaderViewController.h"
#import "homeViewController.h"
#import "registerViewController.h"
#import "tabbarViewController.h"
#import "AppDelegate.h"
#import "onBordingViewController.h"
#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.@"


@interface loginViewController ()
{
    CLLocationManager *locationManager;

    APIViewController *api_obj;
    
    NSString *emailid123,*gender,*useremail,*username;
    
}

@end

@implementation loginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    
    
  

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];

    
    
    email_feild.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
  
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    // Do any additional setup after loading the view from its nib.
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)login_action:(id)sender
{
    
    if([email_feild.text isEqual:@""] ||  [password.text isEqual:@""])
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill required feilds" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=10;

        [alert show];
        return;
    }
    else
    {
        api_obj=[[APIViewController alloc]init];
        [ api_obj loginuser:@selector(loginresult:) tempTarget:self :email_feild.text :password.text];
        [LoaderViewController show:self.view animated:YES];
        
        
        
    }
    
}
-(void)loginresult:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        alert.tag=10;

        [alert show];
    }
    else
    {
       
        
        if([[dict_Response valueForKey:@"status"] integerValue]==200){
            userid=[dict_Response valueForKey:@"userid"];
            
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userid forKey:@"userid"];
            [userDefaults synchronize];
            
           
            tabbarViewController *mvc;
            mvc=[[tabbarViewController alloc]init];
            AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
                nav.navigationBarHidden=YES;
            testAppDelegate.window.rootViewController=nav;
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Wrong Username or Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=10;

            [alert show];
        }
    }
}

- (IBAction)forgot_action:(id)sender
{
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    [email_feild resignFirstResponder];
    [password resignFirstResponder];
    if([Utilities CheckInternetConnection])//0: internet working
    {
        UIAlertView* alert1 = [[UIAlertView alloc] init];
        [alert1 setDelegate:self];
        [alert1 setTitle:@"Enter Valid Email Id"];
        [alert1 setMessage:@" "];
        [alert1 addButtonWithTitle:@"Proceed"];
        [alert1 addButtonWithTitle:@"Cancel"];
        alert1.tag=1;
        alert1.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [alert1 show];
    }
    
}
- (IBAction)register_action:(id)sender
{
    registerViewController *mvc;
    if(iphone4)
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController@6" bundle:nil];
    }

    else if(iphone6p)
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController@6p" bundle:nil];
    }

    else
    {
        mvc=[[registerViewController alloc]initWithNibName:@"registerViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==1)
        
    {
        if(buttonIndex==0)
            
        {
            if([[alertView textFieldAtIndex:0].text isEqual:@""])
            {
                [self forgot_action:0];
            }
            else
            {
                emailid123 = [alertView textFieldAtIndex:0].text;
                NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid123];
                if(!myStringMatchesRegEx)
                {
                    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@" Please enter valid email id " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    al.tag=2;
                    [al show];
                }
                else
                {
                    api_obj=[[APIViewController alloc]init];
                    [ api_obj forgotpass:@selector(forgotresult:) tempTarget:self :emailid123];
                    [LoaderViewController show:self.view animated:YES];
                    //
                    
                    
                }
            }
        }
        else if(buttonIndex==1)
        {
            NSLog(@"string123");
        }
    }
    else
    {
        if(buttonIndex == 0)//Settings button pressed
        {
            if (alertView.tag == 100)
            {
                //This will open ios devices location settings
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
            else if (alertView.tag == 200)
            {
                //This will opne particular app location settings
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
        else if(buttonIndex == 1)//Cancel button pressed.
        {
            //TODO for cancel
        }

    }
}
-(void)forgotresult:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=10;

        [alert show];
    }
    else
    {
        if([[dict_Response valueForKey:@"status"] integerValue]==200){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please check email" message:@"Password reset link sent to your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=10;

            [alert show];
            alert.tag=10;

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Email Id did not exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=10;

            [alert show];
        }
    }
}
#pragma mark- text feild deligate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if ( [string isEqual:@" "]){
        
        return NO;
    }
    else {
        return [string isEqualToString:filtered];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    
    if(textField.tag==33)
    {
        [scrv setContentOffset:CGPointMake(0, 100) animated:YES];
        
    }
    if(textField.tag==55)
    {
        [scrv setContentOffset:CGPointMake(0, 130) animated:YES];
        
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - Location Manager delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations: %@", [locations lastObject]);
    
    _cLocation = [locations lastObject];
    
    lat=_cLocation.coordinate.latitude;
    lng=_cLocation.coordinate.longitude;

    
    [locationManager stopUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized) {
        [locationManager startUpdatingLocation];
        
    } else if (status == kCLAuthorizationStatusDenied) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location services not authorized"
//                                                        message:@"This app needs you to authorize locations services to work.Please Allow Location from Settings"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled!"
                                                            message:@"Please enable Location Based Services for better results! We promise to keep your location private"
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"Cancel", nil];
        
        //TODO if user has not given permission to device
        if (![CLLocationManager locationServicesEnabled])
        {
            alertView.tag = 100;
        }
        //TODO if user has not given permission to particular app
        else
        {
            alertView.tag = 200;
        }
        
        [alertView show];
    } else
        NSLog(@"Wrong location status");
}


@end
