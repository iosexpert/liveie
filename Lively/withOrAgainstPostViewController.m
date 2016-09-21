//
//  withOrAgainstPostViewController.m
//  
//
//  Created by Brahmasys on 03/12/15.
//
//

#import "withOrAgainstPostViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "reSharePostViewController.h"
#import "locationSearchViewController.h"
#import "AGPushNoteView.h"
@interface withOrAgainstPostViewController ()
{
    APIViewController *api_obj;
    
    NSData *vCompressedData;
    AVPlayer *player;
    NSString *tempPath;
    NSString *uuuu;
int vidUpload,doneBtnPressed;

}
@end

@implementation withOrAgainstPostViewController

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
-(void)viewWillAppear:(BOOL)animated
{
    screenName=@"upload";

    if(pushback==4)
    {
        pushback=0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    
    if([savedLocation isEqualToString:@""])
        [location_feild setTitle:@"Add Location" forState:UIControlStateNormal];
    else
        [location_feild setTitle:savedLocation forState:UIControlStateNormal];
    
    if(![locationToSend isEqualToString:@""])
        [location_feild setTitle:locationToSend forState:UIControlStateNormal];
    
}
- (void)viewDidLoad {
    
    vidUpload=0;
    doneBtnPressed=0;
    
    [super viewDidLoad];
    
    locationToSend=@"";
    //[self getAddressFromLatLon:lat withLongitude:lng];

    withTextView.textColor=[UIColor whiteColor];

    
    api_obj=[[APIViewController alloc]init];
    [api_obj searchNearestPlaces:@selector(searchNearestPlacesResult:) tempTarget:self : lat : lng];
    
    [LoaderViewController show:self.view animated:YES];
    
    
    NSArray* foo = [[selectedFeed objectForKey:@"caption"] componentsSeparatedByString: @" "];
    NSString *hashTag=@"";
    for(int i=0;i<foo.count;i++)
    {
        if([foo[i] hasPrefix:@"#"])
        {
            if(foo.count>0)
                hashTag=[NSString stringWithFormat:@"%@ #%@",hashTag,[foo[i] substringFromIndex:1]];
            else
                hashTag=[NSString stringWithFormat:@"%@",[foo[i] substringFromIndex:1]];
            NSLog(@"%@",foo[i]);
        }
        
        
    }
    if(![hashTag isEqualToString:@""])
    {
    hashTag = [hashTag substringFromIndex:1];
        withTextView.text=hashTag;
    }
    else{
       withTextView.text=@"Write Description.....";
    }
    
    
    UIToolbar* keyboardDoneButtonView1 = [[UIToolbar alloc] init];
    [keyboardDoneButtonView1 sizeToFit];
    UIBarButtonItem* doneButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(doneClicked1:)];
    [keyboardDoneButtonView1 setItems:[NSArray arrayWithObjects:doneButton1, nil]];
    withTextView.inputAccessoryView = keyboardDoneButtonView1;


    

    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(showVideoThumb:)
                                   userInfo:nil
                                    repeats:NO];
}


-(void)Upload
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    
    NSString * uniqueIdentifier = [[NSUUID UUID]UUIDString];
    NSArray *uuid=[uniqueIdentifier componentsSeparatedByString: @"-"];
    
    
    
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSArray *uuid1=[timestamp componentsSeparatedByString: @"."];
    
    
    
    
    uuuu=[NSString stringWithFormat:@"https://s3-eu-west-1.amazonaws.com/liveie/%@-%@.mp4",[uuid lastObject],uuid1[0]];
        NSArray* foo = [uuuu componentsSeparatedByString: @"/"];
        NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
        [vCompressedData writeToFile:dataPath atomically:NO];
        AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
        expression.uploadProgress = ^(AWSS3TransferUtilityTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Do something e.g. Update a progress bar.
            });
        };
        
        AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                if (error) {
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        UIAlertView* alert1 = [[UIAlertView alloc] init];
                        [alert1 setDelegate:self];
                        [alert1 setTitle:@""];
                        [alert1 setMessage:@"Re-establising lost connection"];
                        [alert1 addButtonWithTitle:@"Retry"];
                        [alert1 addButtonWithTitle:@"Cancel"];
                        alert1.tag=6;
                        alert1.alertViewStyle = UIAlertViewStyleDefault;
                        
                        [alert1 show];
                    }];
                    NSLog(@"Upload errer: %@", error);
                }
                else
                {
                    vidUpload=1;
                    if(doneBtnPressed==1)
                    {
                        [self doneButton:self];                    }
                }        });
        };
        
        // 3. Create Transfer Utility
        
        AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
        
        // 4. Rewire Transfer Utility blocks
        
        [transferUtility
         enumerateToAssignBlocksForUploadTask:^(AWSS3TransferUtilityUploadTask *uploadTask, __autoreleasing AWSS3TransferUtilityUploadProgressBlock *uploadProgressBlockReference, __autoreleasing AWSS3TransferUtilityUploadCompletionHandlerBlock *completionHandlerReference) {
             NSLog(@"Upload task identifier = %lu", (unsigned long)uploadTask.taskIdentifier);
             
             // Use `uploadTask.taskIdentifier` to determine what blocks to assign.
             
             //*uploadProgressBlockReference = // Reassign your progress feedback block.
             *completionHandlerReference = completionHandler;// Reassign your completion handler.
         }
         downloadTask:^(AWSS3TransferUtilityDownloadTask *downloadTask, __autoreleasing AWSS3TransferUtilityDownloadProgressBlock *downloadProgressBlockReference, __autoreleasing AWSS3TransferUtilityDownloadCompletionHandlerBlock *completionHandlerReference) {
         }];
        
        // 5. Upload data using Transfer Utility
        
        [[transferUtility uploadData:vCompressedData
                              bucket:@"liveie"
                                 key:[NSString stringWithFormat:@"%@-%@.mp4",[uuid lastObject],uuid1[0]]
                         contentType:@"video/quicktime"
                          expression:expression
                    completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
            
            if (task.error) {
                NSLog(@"Error: %@", task.error);
            }
            if (task.exception) {
                NSLog(@"Exception: %@", task.exception);
            }
            if (task.result) {
                AWSS3TransferUtilityUploadTask *uploadTask = task.result;
                // 6. Should i be saving uploadTasks here?
            }
            
            return nil;
        }];
    });
    
}




-(void)doneClicked1:(id)sender
{
    [withTextView resignFirstResponder];
    [self.view endEditing:YES];
}
-(void)showVideoThumb:(NSTimer *)timer
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:vPath] options:nil];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:player];
    avPlayerLayer.frame=CGRectMake(0, 0, videoThumb.frame.size.width,videoThumb.frame.size.height);
    [videoThumb.layer addSublayer:avPlayerLayer];
    videoThumb.userInteractionEnabled=false;
    avPlayerLayer.backgroundColor=[UIColor clearColor].CGColor;
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];

    [self convertVideoToLowQuailtyWithInputURL:[NSURL fileURLWithPath:vPath] outputURL:[NSURL fileURLWithPath:tempPath] handler: ^(AVAssetExportSession *exportSession) {
        
        [self performSelectorOnMainThread:@selector(compressionSuccessFull) withObject:nil waitUntilDone:NO];
    }];
    
    
    
    
    
    
}
-(void)compressionSuccessFull
{
    vCompressedData=[NSData dataWithContentsOfFile:tempPath];
    [LoaderViewController remove:self.view animated:YES];
    
        [self Upload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)back_Button:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButton:(id)sender
{
    [withTextView resignFirstResponder];
    
    
    NSString *loc=[location_feild titleForState:UIControlStateNormal];
    if([loc isEqualToString:@"Add Location"])
        loc=@"none";
    else
        loc=[[location_feild titleForState:UIControlStateNormal]stringByReplacingOccurrencesOfString:@" " withString:@"@"];
    
    

    withTextView.text = [withTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([withTextView.text isEqualToString:@"Write Description....."]||[withTextView.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Please write the description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else
    {
        
        doneBtnPressed=1;
        [LoaderViewController show:self.view animated:YES];
        if(vidUpload==1)
        {

        NSArray* foo = [withTextView.text componentsSeparatedByString: @" "];
        NSString *hashTag=@"";
        for(int i=0;i<foo.count;i++)
        {
            if([foo[i] hasPrefix:@"#"])
            {
                if(foo.count>0)
                    hashTag=[NSString stringWithFormat:@"%@!%@",hashTag,[foo[i] substringFromIndex:1]];
                else
                    hashTag=[NSString stringWithFormat:@"%@",[foo[i] substringFromIndex:1]];
                NSLog(@"%@",foo[i]);
            }
            
        }
        if([hashTag isEqualToString:@""])
            hashTag=@"none";
            else
            hashTag = [hashTag substringFromIndex:1];

        if([reply  isEqual: @"0"] || reply == nil )
        {
                           NSString *repyid;
//                    if([[selectedFeed objectForKey:@"post_type"] isEqualToString:@"public"]||[[selectedFeed objectForKey:@"post_type"] isEqualToString:@"reshare"])
                        repyid=[selectedFeed objectForKey:@"postid"];
//                        else
//                    repyid=[selectedFeed objectForKey:@"parent_id"];
//                        if([vFilters isEqualToString:@""])
//                            vFilters=@"none";
            
            
            if(loc == nil)
            {
                loc = @"";
            }
            
            NSDictionary *params;
            params=@{
                     
                     @"caption"          :withTextView.text,
                     @"filter"           :vFilters,
                     @"hashtag"          :hashTag,
                     @"lat"              :[NSString stringWithFormat:@"%f",lat],
                     @"location"         :loc,
                     @"url"              :uuuu,
                     @"lon"              :[NSString stringWithFormat:@"%f",lng],
                     @"parentid"        :repyid,
                     @"userid"           :userid
                     };
            
            api_obj=[[APIViewController alloc]init];
            [ api_obj uploadVideoasReply:@selector(uploadVideoasReplyresult:) tempTarget:self :params];
        }
            else if([reply  isEqual: @"1"])
            {
                NSString *repyid;
                repyid=[selectedFeed objectForKey:@"postid"];
                if([vFilters isEqualToString:@""])
                    vFilters=@"none";
                
                if(loc == nil)
                {
                    loc = @"";
                }

                
                NSDictionary *params;
                params=@{
                         
                         @"caption"          :withTextView.text,
                         @"filter"           :vFilters,
                         @"hashtag"          :hashTag,
                         @"lat"              :[NSString stringWithFormat:@"%f",lat],
                         @"location"         :loc,
                         @"url"              :uuuu,
                         @"lon"              :[NSString stringWithFormat:@"%f",lng],
                         @"parentid"        :repyid,
                         @"userid"           :userid
                         };
                
                api_obj=[[APIViewController alloc]init];
                [ api_obj uploadVideoasReply:@selector(uploadVideoasReplyresult:) tempTarget:self :params];

            }
            
            
                    
                    NSLog(@"Done");
                    }
  
        }
    
    
}
-(void)uploadVideoasReplyresult:(NSDictionary*)dict_Response
{
    [LoaderViewController remove:self.view animated:YES];
    NSLog(@"%@",dict_Response);
    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        if([[dict_Response valueForKey:@"status"] integerValue]==200){
            [LoaderViewController remove:self.view animated:YES];
            selectedFeed=selectedFeed;
            pushback=4;
            reSharePostViewController *mvc;
            if(iphone4)
            {
                mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@6p" bundle:nil];
            }
            else
            {
                mvc=[[reSharePostViewController alloc]initWithNibName:@"reSharePostViewController@ipad" bundle:nil];
            }
            [self.navigationController pushViewController:mvc animated:YES];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==6)
    {
        if(buttonIndex==0)
        {
            [self doneButton:0];
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
}

//Video Converter to Low Quality
- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler  {
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session1 = [[AVAssetExportSession alloc] initWithAsset: urlAsset presetName:AVAssetExportPresetMediumQuality];
    session1.outputURL = outputURL;
    
    session1.outputFileType = AVFileTypeMPEG4;
    session1.shouldOptimizeForNetworkUse = YES;
    [session1 exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session1);
         

         
     }];
}
#pragma mark - Text view deligates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(textView.tag==1)
    {
    if ([text isEqualToString:@"\n"]) {
        
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"Write Description.....";
            withTextView.textColor=[UIColor whiteColor];
            
        }
        [textView resignFirstResponder];
        
        
        return NO;
    }
    }
    else
    {
        
            if ([text isEqualToString:@"\n"]) {
                
                if([textView.text isEqualToString:@""])
                {
                    textView.text=@"Write Description..";
                    
                }
                [textView resignFirstResponder];
                
                
                return NO;
            }

    
    }
    if(textView.text.length + (text.length - range.length) <= 200)
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Maximum word limit is reached" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
        
    }

    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag==1)
    {
    if([textView.text isEqualToString:@"Write Description....."])
    {
        textView.text=@"";
    }

    }
    else
    {
        if([textView.text isEqualToString:@"Write Description.."])
        {
            textView.text=@"";

            
        }
    }

   
    
    return YES;
}
-(IBAction)addLocationButton:(id)sender

{
    locationSearchViewController *mvc;
    if(iphone4)
    {
        mvc=[[locationSearchViewController alloc]initWithNibName:@"locationSearchViewController@4" bundle:nil];
    }
    else if(iphone5)
    {
        mvc=[[locationSearchViewController alloc]initWithNibName:@"locationSearchViewController" bundle:nil];
    }
    else if(iphone6)
    {
        mvc=[[locationSearchViewController alloc]initWithNibName:@"locationSearchViewController@6" bundle:nil];
    }
    else if(iphone6p)
    {
        mvc=[[locationSearchViewController alloc]initWithNibName:@"locationSearchViewController@6p" bundle:nil];
    }
    else
    {
        mvc=[[locationSearchViewController alloc]initWithNibName:@"locationSearchViewController@ipad" bundle:nil];
    }
    mvc.arrLoc=[arrNearPlaces mutableCopy];
    [self.navigationController pushViewController:mvc animated:YES];
    
}
-(void)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    NSLog(@"%f %f", lat, lng);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:LocationAtual
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         NSLog(@"locality %@",placemark.locality);
         NSLog(@"postalCode %@",placemark.postalCode);
         [location_feild setTitle:placemark.locality forState:UIControlStateNormal];
         
         
     }];
    
}
-(void)searchNearestPlacesResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    
    
    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
        
    }
    else
    {
        NSMutableArray *arrGroup=[[[dict_Response valueForKey:@"response"] valueForKey:@"venues"] mutableCopy];
        NSMutableArray *arrTemp = [arrGroup mutableCopy];
        
        arrNearPlaces=[arrGroup mutableCopy];
        int x=0;
        for(int i=0;i<arrTemp.count;i++)
        {
            NSMutableDictionary *dict=[arrTemp objectAtIndex:i];
            NSLog(@"%@",[dict valueForKey:@"name"]);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [button.titleLabel setFont:[UIFont fontWithName:@"American Typewriter" size:12.0]];
            //button.userInteractionEnabled=false;
            CGSize textSize = [[dict valueForKey:@"name"] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"American Typewriter" size:12.0]}];
            [button setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
            button.frame = CGRectMake(x+10, 9, textSize.width+5, 30.0);
            button.layer.borderWidth=1.0;
            button.layer.borderColor=[UIColor whiteColor].CGColor;
            button.layer.cornerRadius=15;
            [names_scrv addSubview:button];
            x=x+textSize.width+15;
        }
        names_scrv.contentSize=CGSizeMake(x+50, 10);
        
    }
}
-(void) buttonClicked:(UIButton*)sender
{
    [location_feild setTitle:[sender titleForState:UIControlStateNormal] forState:UIControlStateNormal];
}
-(void)viewWillDisappear:(BOOL)animated
{
    api_obj=nil; [LoaderViewController remove:self.view animated:YES];;
}
@end
