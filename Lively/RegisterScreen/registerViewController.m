//
//  registerViewController.m
//  Lively App
//
//  Created by Brahmasys on 05/10/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "registerViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "StartViewController.h"
#import "Utilities.h"
#import "loginViewController.h"
#import "termofServiceViewController.h"
#import "tabbarViewController.h"
#import "AppDelegate.h"

#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.@_-"

@interface registerViewController ()
{
    APIViewController *api_obj;
    
    NSString *strCity,*dateOfBirth;

    UIDatePicker *datePicker;
    UIView *popupscreen,*dateview;
}

@end

@implementation registerViewController

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
    
   
    
    userImage.layer.cornerRadius=33.0;
    
    txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email:" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password:" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username:" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txtlast.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    txtfirst.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



#pragma mark User Name Check API
-(void)checkUserName
{
    if([Utilities CheckInternetConnection])//0: internet working
    {
    [btnRegister setUserInteractionEnabled:NO];
    api_obj=[[APIViewController alloc]init];
    [api_obj CheckUserName:@selector(checkUserNameResult:) tempTarget:self:txtUserName.text];
    }
}
-(void)checkUserNameResult:(NSDictionary*)dict_Response
{
    NSLog(@"checkUserNameResult : %@",dict_Response);
    [btnRegister setUserInteractionEnabled:YES];

    if (dict_Response==NULL)
    {
        txtUserName.text=@"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=10;
        [alert show];
    }
    else
    {
        if([[dict_Response valueForKey:@"status"] integerValue]!=200)
        {
           txtUserName.text=@"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"User Name Already Exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=10;

            [alert show];
        }
    }
}


#pragma mark EmailID Check API
-(void)checkEmailId
{
    [btnRegister setUserInteractionEnabled:NO];
    api_obj=[[APIViewController alloc]init];
    [api_obj CheckEmailID:@selector(CheckEmailIDResult:) tempTarget:self :txtEmail.text];

}
-(void)CheckEmailIDResult:(NSString *)dict_Response
{
    NSLog(@"checkUserNameResult : %@",dict_Response);
    [btnRegister setUserInteractionEnabled:YES];

    if (dict_Response==NULL)
    {
        txtEmail.text=@"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=10;

        [alert show];
    }
    else
    {
        if(![dict_Response isEqualToString:@"false"])
        {
            txtEmail.text=@"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Email ID Already Exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=10;

            [alert show];
        }
    }

}

#pragma mark Register API
-(IBAction)RegisterUser:(id)sender
{

    NSString *emailid = txtEmail.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    
    
    
    if([txtEmail.text isEqual:@""]  ||  [txtUserName.text isEqual:@""]||  [txtPassword.text isEqual:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter all of the empty fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=10;

        [alert show];
        return;
    }
    else if(!myStringMatchesRegEx)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@" This email address is invalid. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        al.tag=10;

        [al show];
    }
    else if(txtPassword.text.length<5)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@"Password enter minimum 5 character/digit" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        al.tag=10;

        [al show];
    }
    else if (txtUserName.text.length<1 || txtUserName.text.length>15)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@"Username must be between 4 to 15 Characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        al.tag=10;
        
        [al show];
    }
    else
    {
        NSString *url=[NSString stringWithFormat:@"%@/%@/%@/%@/%f/%f/0",txtUserName.text,txtEmail.text,txtPassword.text,device_id,lng,lat];
        NSLog(@"%@",url);
        api_obj=[[APIViewController alloc]init];
        [api_obj registerNewUser:@selector(RegisterUserResult:) tempTarget:self :url :UIImageJPEGRepresentation([userImage image], 0.1)];
        [LoaderViewController show:self.view animated:YES];
    } 

}
-(IBAction)TermsClick:(id)sender
{
    termofServiceViewController *mvc;
    if(iphone4)
    {
        mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[termofServiceViewController alloc]initWithNibName:@"termofServiceViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:NO];
}
-(void)RegisterUserResult:(NSDictionary *)dict_Response
{
     NSLog(@"Register Result : %@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    if (dict_Response==NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Re-establising lost connection May be its slow or not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=10;

        [alert show];
    }
    else
    {
        if([[dict_Response valueForKey:@"status"] integerValue]==200)
        {
            userid=[dict_Response objectForKey:@"userid"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userid forKey:@"userid"];
            [userDefaults synchronize];
            
            
            StartViewController *mvc;
            if(iphone4)
            {
                mvc=[[StartViewController alloc]initWithNibName:@"StartViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[StartViewController alloc]initWithNibName:@"StartViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[StartViewController alloc]initWithNibName:@"StartViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[StartViewController alloc]initWithNibName:@"StartViewController@6p" bundle:nil];
            }
            else
            {
                mvc=[[StartViewController alloc]initWithNibName:@"StartViewController@ipad" bundle:nil];
            }
            [self.navigationController pushViewController:mvc animated:NO];
            
            
           

        }
    }

}

#pragma mark BackButton Action
-(IBAction)backButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)Login:(id)sender
{
    loginViewController *mvc;
    if(iphone4)
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController@6" bundle:nil];
    }
    
    else if(iphone6p)
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController@6p" bundle:nil];
    }
    
    else
    {
        mvc=[[loginViewController alloc]initWithNibName:@"loginViewController@ipad" bundle:nil];
    }
    [self.navigationController pushViewController:mvc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- text feild deligate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if(textField.tag==7)
    {
        dateview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        dateview.backgroundColor=[UIColor grayColor];
        dateview.alpha=1.0;
        
        UIView *tape=[[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 50)];
        tape.backgroundColor=[UIColor blackColor];
        UIButton *button31 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button31 addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button31 setTitle:@"Done" forState:UIControlStateNormal];
        button31.frame = CGRectMake(30, 10, 90, 30);
        button31.titleLabel.font = [UIFont systemFontOfSize:16];
        button31.backgroundColor=[UIColor clearColor];
        [button31 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tape addSubview:button31];
        
        
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 320, 300)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;
        datePicker.date = [NSDate date];
        
        [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
        [dateview addSubview:datePicker];
        [dateview addSubview:tape];
        [self.view addSubview:dateview];
        return NO;
  
    }
    [scrv setContentOffset:CGPointMake(0, 120) animated:YES];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag==33)
    {
        if(textField.text && textField.text.length > 0)
        {
            [self checkUserName];
        }
        
    }
    else if(textField.tag==44)
    {
        if(textField.text && textField.text.length > 0)
        {
            [self checkEmailId];
        }
        
    }

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==33)
    {
        if(textField.text && textField.text.length > 0)
        {
            [self checkUserName];
        }
        
    }
    else if(textField.tag==44)
    {
        if(textField.text && textField.text.length > 0)
        {
            [self checkEmailId];
        }
        
    }


    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
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
- (void)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
       [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    [dateview removeFromSuperview];
 
}
- (void)LabelChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd, yyyy"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"dd-MMM-yyyy"];
    NSDate *dateDOB = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",datePicker.date]];
    int timestamp = [dateDOB timeIntervalSince1970];
    dateOfBirth=[NSString stringWithFormat:@"%d",timestamp];
    
}
- (IBAction)image_button_action:(id)sender
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Image",@"Gallary", nil];
    [sheet showInView:self.view];
    [sheet setTag:1];
    
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:YES completion:NULL];
    
}
#pragma mark Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    if (actionSheet.tag == 1){
        if (buttonIndex==0) {//Camera for image
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:NULL];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                               message:@"Unable to find a camera on your device."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
                alert.tag=10;

                [alert show];
                alert = nil;
            }
            
            
        }
        else if (buttonIndex==1) {//gallary
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            
            
        }
        else if (buttonIndex==2){//Video
            
            
            
            
            
        }
        
    }
    
    
    
}


#pragma mark Image picker Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    userImage.image=chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    api_obj=nil; [LoaderViewController remove:self.view animated:YES];;
}


@end
