//
//  editProfileViewController.m
//  
//
//  Created by Brahmasys on 11/01/16.
//
//

#import "editProfileViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AFNetworking.h"
#import "GKImagePicker.h"
#import "RSKImageCropper.h"
#import "AGPushNoteView.h"
#import "AppDelegate.h"
@interface editProfileViewController ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>
{
    APIViewController *api_obj;
    
    int imgclick,imageFOr;
    UIView *popview;;
    
    NSString * timestamp;
    UIDatePicker *datePicker;
    UIView *dateview;
    
    int genderSelected;

}
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@end

@implementation editProfileViewController

- (void)viewDidLayoutSubviews
{
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    tabFrame.size.height = 40;
    tabFrame.origin.y = self.view.frame.size.height - 40;
    self.tabBarController.tabBar.frame= tabFrame;
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenName=@"edit";

    //
//    api_obj=[[APIViewController alloc]init];
//    [api_obj getDetailUserProfile:@selector(getdetailProfileInfoResult:) tempTarget:self ];
    
    
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetAccountDetails/%@",appUrl,userid];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            
            NSError *e;
            NSMutableDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            [self getdetailProfileInfoResult:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self getdetailProfileInfoResult:nil];
        
    }];
    
    [operation start];

    
    
    
    scrv.contentSize=CGSizeMake(self.view.frame.size.width, 730);
     UIToolbar* keyboardDoneButtonView1 = [[UIToolbar alloc] init];
    [keyboardDoneButtonView1 sizeToFit];
    keyboardDoneButtonView1.barTintColor=[UIColor purpleColor];
    
    UIBarButtonItem* doneButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(doneClicked1:)];
    [keyboardDoneButtonView1 setItems:[NSArray arrayWithObjects:doneButton1, nil]];
    phone.inputAccessoryView = keyboardDoneButtonView1;
     countryCode.inputAccessoryView = keyboardDoneButtonView1;
    
    profile_img.layer.cornerRadius=35.0;
    profile_img.layer.borderWidth=0.0;
    
    
    maleBtn.layer.cornerRadius=5.0;
    maleBtn.layer.borderColor=[UIColor purpleColor].CGColor;
    maleBtn.layer.borderWidth=1.0;
    [maleBtn setBackgroundColor:[UIColor purpleColor]];
    [maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    genderSelected=0;

    
    femaleBtn.layer.cornerRadius=5.0;
    femaleBtn.layer.borderColor=[UIColor purpleColor].CGColor;
    femaleBtn.layer.borderWidth=1.0;
    
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)showPicker{
    
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = cover_img.frame.size;
    self.imagePicker.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
        
    } else {
        
        [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        
    }
}
# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    cover_img.image = image;

    [LoaderViewController show:self.view animated:YES];
    UIImage *chosenImage = image;
    
    NSURL *urla;
    
    //cover_img.image=chosenImage;
    urla = [NSURL URLWithString:[NSString stringWithFormat:@"%@/UserServices.svc/UpdateWallPic/",appUrl]];
    
    NSString *url = [NSString stringWithFormat:@"%@/profile/img",userid];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:urla];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                    {
                                        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.3) name:@"fileContent" fileName:@"profile.png" mimeType:@"image/png"];
                                    }];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest: request];
    
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
     {
         NSLog(@"Sent %lld of %d bytes", totalBytesWritten, (int)((totalBytesWritten/totalBytesExpectedToWrite)*100));
         
     }];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"image Uploaded Successfully%@",operation.responseString);
         [LoaderViewController remove:self.view animated:YES];
         
         
         
         
         
     }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {NSLog(@"Error : %@",  operation.responseString);
                                          [LoaderViewController remove:self.view animated:YES];}];
    
    
    [operation start];
    
    [self hideImagePicker];
}

- (void)hideImagePicker{
    
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    }
}



-(IBAction)maleAction:(UIButton*)sender
{
    [maleBtn setBackgroundColor:[UIColor purpleColor]];
    [maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    genderSelected=0;
    [femaleBtn setBackgroundColor:[UIColor clearColor]];
    [femaleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
}
-(IBAction)femaleAction:(UIButton*)sender
{
    [femaleBtn setBackgroundColor:[UIColor purpleColor]];
    [femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    genderSelected=1;
    [maleBtn setBackgroundColor:[UIColor clearColor]];
    [maleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
}
-(void)doneClicked1:(id)sender
{
    [phone resignFirstResponder];
    [self.view endEditing:YES];
}
-(IBAction)backButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getdetailProfileInfoResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    [imgSplash removeFromSuperview];
    
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
       
        if([[[dict_Response objectForKey:@"response"] valueForKey:@"status"] integerValue]==200){

        if([[[dict_Response objectForKey:@"details"]valueForKey:@"dob"] isEqualToString:@"nil"]||[[[dict_Response objectForKey:@"details"]valueForKey:@"dob"] isEqualToString:@""])
                dob.text=@"";
            else
            {
                NSString *dateStr = [NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"details"]valueForKey:@"dob"]];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];

                NSDate *date = [dateFormat dateFromString:dateStr];
                [dateFormat setDateFormat:@"MMM dd, YYYY"];
                NSString *stringFromDate = [dateFormat stringFromDate:date];
                dob.text=stringFromDate;
            }
            
            if([[[dict_Response objectForKey:@"details"]valueForKey:@"phone"] isEqualToString:@"nil"])
                phone.text=@"";
            else
                phone.text=[[dict_Response objectForKey:@"details"]valueForKey:@"phone"];
            
            if([[[dict_Response objectForKey:@"details"]valueForKey:@"gender"] isEqualToString:@"male"])
            {
                [maleBtn setBackgroundColor:[UIColor purpleColor]];
                [maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                genderSelected=0;
                [femaleBtn setBackgroundColor:[UIColor clearColor]];
                [femaleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
            }
            else
            {
                [femaleBtn setBackgroundColor:[UIColor purpleColor]];
                [femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                genderSelected=1;
                [maleBtn setBackgroundColor:[UIColor clearColor]];
                [maleBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
            }
            
            email.text=[[dict_Response objectForKey:@"details"]valueForKey:@"email"];
            fname.text=[[dict_Response objectForKey:@"details"]valueForKey:@"first_name"];
            lname.text=[[dict_Response objectForKey:@"details"]valueForKey:@"last_name"];
            about.text=[[dict_Response objectForKey:@"details"]valueForKey:@"about"];
           countryCode.text=[[dict_Response objectForKey:@"details"]valueForKey:@"country_code"];
            profile_img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"details"]valueForKey:@"pic"]]];
            cover_img.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dict_Response objectForKey:@"details"]valueForKey:@"wall_pic"]]];
            cover_img.contentMode=UIViewContentModeScaleAspectFill;
            cover_img.clipsToBounds=YES;
            if([[[dict_Response objectForKey:@"userdetails"] objectForKey:@"wall_image"] isEqualToString:@""])
            {
                cover_img.image=[UIImage imageNamed:@"coverimage.png"];
            }
            
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)changeProfilePic:(UIButton*)recognizer
{
    imgclick=0;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Image",@"Gallery", nil];
    [sheet showInView:self.view];
    [sheet setTag:2];
    
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
                
                cameraCheck=0;
                imageFOr=1;
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:NULL];
                // [self showPicker];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                               message:@"Unable to find a camera on your device."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                alert = nil;
            }
            
            
        }
        else if (buttonIndex==1) {//gallary
            cameraCheck=1;
            imageFOr=1;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            
            //[self showPicker];
            
            
            
        }
        else if (buttonIndex==2){//Video
            
            
            
            
            
        }
        
    }
    else if (actionSheet.tag == 2){
        if (buttonIndex==0) {//Camera for image
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imageFOr=0;
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = NO;
                [self presentViewController:imagePicker animated:YES completion:NULL];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                               message:@"Unable to find a camera on your device."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                alert = nil;
            }
            
            
        }
        else if (buttonIndex==1) {//gallary
            imageFOr=0;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
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
    if(imageFOr==1)
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        [LoaderViewController show:self.view animated:YES];
        NSURL *urla;
        
        //cover_img.image=chosenImage;
        urla = [NSURL URLWithString:[NSString stringWithFormat:@"%@/UserServices.svc/UpdateWallPic/",appUrl]];
        
        NSString *url = [NSString stringWithFormat:@"%@/profile/img",userid];
        AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:urla];
        
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                        {
                                            [formData appendPartWithFileData:UIImageJPEGRepresentation(chosenImage, 0.3) name:@"fileContent" fileName:@"profile.png" mimeType:@"image/png"];
                                        }];
        
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest: request];
        
        
        [operation setUploadProgressBlock:^(NSInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
         {
             NSLog(@"Sent %lld of %d bytes", totalBytesWritten, (int)((totalBytesWritten/totalBytesExpectedToWrite)*100));
             
         }];
        
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [LoaderViewController remove:self.view animated:YES];
             NSLog(@"image Uploaded Successfully%@",operation.responseString);
             NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetAccountDetails/%@",appUrl,userid];
             
             NSLog(@"url %@",urlString);
             NSURL *url = [[NSURL alloc] initWithString:urlString];
             NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
             AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request];
             
             [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
                 
                 NSString *jsonString = operation1.responseString;
                 NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                 
                 if (JSONdata != nil) {
                     
                     NSError *e;
                     NSMutableDictionary *JSON =
                     [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                     options: NSJSONReadingMutableContainers
                                                       error: &e];
                     
                     [self getdetailProfileInfoResult:JSON];
                     
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
                 
                 NSLog(@"error: %@",  operation1.responseString);
                 
                 NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
                 
                 if (errStr==Nil) {
                     errStr=@"Server not reachable";
                 }
                 
                 [self getdetailProfileInfoResult:nil];
                 
             }];
             
             [operation1 start];
             
             
             
             
         }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {NSLog(@"Error : %@",  operation.responseString);
                                              [LoaderViewController remove:self.view animated:YES];}];
        
        
        [operation start];
        
    }
    else
    {
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:chosenImage cropMode:RSKImageCropModeCircle];
        imageCropVC.delegate = self;
        [self.navigationController pushViewController:imageCropVC animated:YES];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    
    profile_img.image=croppedImage;
    [LoaderViewController show:self.view animated:YES];
    
    NSURL *urla;
    
    //profile_img.image=chosenImage;
    urla = [NSURL URLWithString:[NSString stringWithFormat:@"%@/UserServices.svc/UpdateProfilePic/",appUrl]];
    
    NSString *url = [NSString stringWithFormat:@"%@/profile/img",userid];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:urla];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                    {
                                        [formData appendPartWithFileData:UIImageJPEGRepresentation(croppedImage, 0.3) name:@"fileContent" fileName:@"profile.png" mimeType:@"image/png"];
                                    }];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest: request];
    
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
     {
         NSLog(@"Sent %lld of %d bytes", totalBytesWritten, (int)((totalBytesWritten/totalBytesExpectedToWrite)*100));
         
     }];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"image Uploaded Successfully%@",operation.responseString);
         [LoaderViewController remove:self.view animated:YES];
         NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetAccountDetails/%@",appUrl,userid];
         
         NSLog(@"url %@",urlString);
         NSURL *url = [[NSURL alloc] initWithString:urlString];
         NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
         AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request];
         
         [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation1, id responseObject) {
             
             NSString *jsonString = operation1.responseString;
             NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
             
             if (JSONdata != nil) {
                 
                 NSError *e;
                 NSMutableDictionary *JSON =
                 [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                 options: NSJSONReadingMutableContainers
                                                   error: &e];
                 
                 [self getdetailProfileInfoResult:JSON];
                 
             }
             
         } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
             
             NSLog(@"error: %@",  operation1.responseString);
             
             NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
             
             if (errStr==Nil) {
                 errStr=@"Server not reachable";
             }
             
             [self getdetailProfileInfoResult:nil];
             
         }];
         
         [operation1 start];
         
         
         
         
         
     }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {NSLog(@"Error : %@",  operation.responseString);
                                          [LoaderViewController remove:self.view animated:YES];}];
    
    
    [operation start];
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(IBAction)changeCoverImage:(UIButton*)recognizer
{
    imgclick=1;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Image",@"Gallery", nil];
    [sheet showInView:self.view];
    [sheet setTag:1];
    
}

#pragma mark - Text view deligates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"About Me";
        }
        [textView resignFirstResponder];
        scrv.contentSize=CGSizeMake(self.view.frame.size.width, 730);
        return NO;
    }
    if(textView.text.length + (text.length - range.length) <= 200)
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Maximum word limit is reached" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    scrv.contentSize=CGSizeMake(self.view.frame.size.width, 930);
    
    [scrv setContentOffset:CGPointMake(0,410) animated:YES];
    if([textView.text isEqualToString:@"About Me"])
    {
        textView.text=@"";
    }

    return YES;
}
#pragma mark- text feild deligate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isFirstResponder])
    {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
        {
            return NO;
        }
    }
    if(textField.tag==4)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        int length = (int)[currentString length];
        if (length > 10) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    
    if(textField.tag==1)
    {
        [scrv setContentOffset:CGPointMake(0, 200) animated:NO];
    }
    else if(textField.tag==2)
    {
        [scrv setContentOffset:CGPointMake(0, 230) animated:NO];
    }
    else if(textField.tag==3)
    {
        [scrv setContentOffset:CGPointMake(0, 260) animated:NO];
    }
    else if(textField.tag==4)
    {
        [scrv setContentOffset:CGPointMake(0, 300) animated:NO];
    }
    
    if(textField.tag==33)
    {
        
        dateview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        dateview.backgroundColor=[UIColor whiteColor];
        dateview.alpha=1.0;
        
        UIView *tape=[[UIView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 50)];
        tape.backgroundColor=[UIColor blackColor];
        UIButton *button31 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button31 addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button31 setTitle:@"Done" forState:UIControlStateNormal];
        button31.frame = CGRectMake(30, 10, 90, 30);
        button31.titleLabel.font = [UIFont systemFontOfSize:16];
        button31.backgroundColor=[UIColor clearColor];
        [button31 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tape addSubview:button31];
        
        
        [phone resignFirstResponder];
        [self.view endEditing:YES];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 300)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-13];
        NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        datePicker.date=minDate;
        datePicker.maximumDate=minDate;

        datePicker.hidden = NO;
        datePicker.date = [NSDate date];
        
        [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
        [dateview addSubview:datePicker];
        [dateview addSubview:tape];
        [self.view addSubview:dateview];
        return NO;
    }

    if(textField.tag==234)
    {
         [self.view endEditing:YES];
        
        popview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        popview.backgroundColor=[UIColor clearColor];
        //popview.alpha=0.7;
        //[scrv setContentOffset:CGPointMake(0, 260) animated:NO];
        
        
        UIView *popview1=[[UIView alloc]initWithFrame:CGRectMake(15, 305, self.view.frame.size.width-30,70)];
        popview1.backgroundColor=[UIColor purpleColor];
        
        UIButton *uim=[[UIButton alloc]initWithFrame:CGRectMake(30, 20, 40, 40)];
        uim.tag=235;
        [uim setBackgroundImage:[UIImage imageNamed:@"male.png"] forState:UIControlStateNormal];
        [uim addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *uim1=[[UIButton alloc]initWithFrame:CGRectMake(210, 20, 40, 40)];
        uim1.tag=236;
        [uim1 setBackgroundImage:[UIImage imageNamed:@"female.png"] forState:UIControlStateNormal];
        [uim1 addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [popview1 addSubview:uim];
        [popview1 addSubview:uim1];
        [popview addSubview:popview1];

        [self.view addSubview:popview];
        
        return NO;
    }
    
    else
    {
        
     
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    scrv.contentSize=CGSizeMake(self.view.frame.size.width, 730);
    [textField resignFirstResponder];
    return YES;
}
-(void)buttonclick:(UIButton*)but
{
    if(but.tag==235)
    {
        gender.text=@"Male";
        [popview removeFromSuperview];
    }
    else if(but.tag==236)
    {
        gender.text=@"Female";
        [popview removeFromSuperview];
    }
    
}
- (void)LabelChange:(id)sender{
 

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd, yyyy"];
    dob.text = [df stringFromDate:datePicker.date];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"ddMMMyyyy"];
    NSString *d=[dateFormat stringFromDate:datePicker.date];
    NSDate *dateDOB = [dateFormat dateFromString:d];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *datee = [calendar dateBySettingHour:5 minute:30 second:0 ofDate:dateDOB options:0];
    int a=[datee timeIntervalSince1970];
    timestamp=[NSString stringWithFormat:@"%d",a];
    
}
- (void)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
    if([dob.text isEqualToString:@""])
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM dd, yyyy"];
        dob.text = [df stringFromDate:currDate];
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"ddMMMyyyy"];
        NSString *d=[dateFormat stringFromDate:currDate];
        NSDate *dateDOB = [dateFormat dateFromString:d];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *datee = [calendar dateBySettingHour:5 minute:30 second:0 ofDate:dateDOB options:0];
        int a=[datee timeIntervalSince1970];
        timestamp=[NSString stringWithFormat:@"%d",a];

    }
    [dateview removeFromSuperview];
  
    [UIView commitAnimations];
}
- (IBAction)submit_action:(id)sender
{
    NSString *emailid = email.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    
    
    if(!myStringMatchesRegEx)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@" This email address is invalid. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
    }
    else if([about.text isEqual:@"About Me"])
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter somthing about yourself." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
    }
    else if (fname.text.length>15)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@"First Name must be of maximum 15 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
    }
    else if (lname.text.length>15)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@"Last Name must be of maximum 15 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
    }
    else if([phone.text length] == 0)
    {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"" message:@"Please enter Phone No." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
    }
    else if([phone.text length]!=0)
    {
      
            NSString *st;
            if(genderSelected==0)
                st=@"male";
            else
                st=@"female";
            
            
            
            NSDictionary *params;
            params=@{
                     @"userid"         :userid,
                     @"about"          :about.text,
                     @"dob"            :dob.text,
                     @"email"          :email.text,
                     @"first_name"     :fname.text,
                     @"last_name"      :lname.text,
                     @"gender"         :st,
                     @"phone"          :phone.text,
                     @"country_code"   :countryCode.text
                     };
            api_obj=[[APIViewController alloc]init];
            [api_obj updateDetailUserProfile:@selector(updateDetailUserProfileResult:) tempTarget:self :params];
            [LoaderViewController show:self.view animated:YES];
        
    }
    else
    {
        NSString *st;
        if(genderSelected==0)
            st=@"male";
        else
            st=@"female";
        

    
        NSDictionary *params;
        params=@{
                 @"userid"         :userid,
                 @"about"          :about.text,
                 @"dob"            :dob.text,
                 @"email"          :email.text,
                 @"first_name"     :fname.text,
                 @"last_name"      :lname.text,
                 @"gender"         :st,
                 @"phone"          :phone.text,
                 @"country_code"   :countryCode.text
                 };
        api_obj=[[APIViewController alloc]init];
        [api_obj updateDetailUserProfile:@selector(updateDetailUserProfileResult:) tempTarget:self :params];
        [LoaderViewController show:self.view animated:YES];
    }
        
    
    
}
-(void)updateDetailUserProfileResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);\
    [LoaderViewController remove:self.view animated:YES];
    
    
    
    if (dict_Response==NULL)
    {
        [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        if([[dict_Response valueForKey:@"status"] integerValue]==200){
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lively" message:@"Profile Updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    api_obj=nil;
    [LoaderViewController remove:self.view animated:YES];
    
    
    
}
@end
