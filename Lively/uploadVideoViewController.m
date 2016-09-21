//
//  uploadVideoViewController.m
//  Lively
//
//  Created by Brahmasys on 19/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "uploadVideoViewController.h"
#import "APIViewController.h"
#import "AsyncImageView.h"
#import "LoaderViewController.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "homeViewController.h"
#import "SCRecorderViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "locationSearchViewController.h"
#import <AWSS3/AWSS3.h>



#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3TransferManager.h>
#import <AWSCore/AWSCredentialsProvider.h>
#import "AGPushNoteView.h"


@import CoreLocation;
@interface uploadVideoViewController ()<CLLocationManagerDelegate>
{
    APIViewController *api_obj;
    int locationApiComplete;
    AVPlayer *player;
    int segment;
    NSString *tempPath;
    NSString *uuuu;
    int vidUpload,doneBtnPressed;
    NSURLSessionUploadTask *uploadTask;
}
@end

@implementation uploadVideoViewController
@synthesize vCompressedData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    //videoThumb.transform=CGAffineTransformMakeRotation(M_PI/2);
    avPlayerLayer.backgroundColor=[UIColor clearColor].CGColor;
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    
    
    // NSData *videoData = [NSData dataWithContentsOfURL:exportSession.outputUrl];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];
    //BOOL success = [videoData writeToFile:tempPath atomically:NO];
    
    [self convertVideoToLowQuailtyWithInputURL:[NSURL fileURLWithPath:vPath] outputURL:[NSURL fileURLWithPath:tempPath] handler: ^(AVAssetExportSession *exportSession) {
        
       // vCompressedData=[NSData dataWithContentsOfFile:tempPath];

        [self performSelectorOnMainThread:@selector(compressionSuccessFull) withObject:nil waitUntilDone:NO];
    }];
    
    
    
    
    
    
}
-(void)compressionSuccessFull
{
    //[LoaderViewController remove:self.view animated:YES];

    vCompressedData=[NSData dataWithContentsOfFile:tempPath];
    [self Upload];
    
    
}
-(void)doneClicked1:(id)sender
{
    [descView resignFirstResponder];
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    screenName=@"upload";

    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }
    
    
    if( directOrSimple==0)
    {
        segment=0;
        [public_btn setImage:[UIImage imageNamed:@"publicblue"] forState:UIControlStateNormal];
        [direct_btn setImage:[UIImage imageNamed:@"Directwhite"] forState:UIControlStateNormal];
        
        [tablev setHidden:YES];
        [txtSearch setHidden:YES];   }
    else
    {
        segment=1;
        txtSearch.text=@"";
        [txtSearch setHidden:NO];
        
        [public_btn setImage:[UIImage imageNamed:@"publicwhite"] forState:UIControlStateNormal];
        [direct_btn setImage:[UIImage imageNamed:@"DirectBlue"] forState:UIControlStateNormal];
        
    }
    
    
    [txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    
    UIToolbar* keyboardDoneButtonView1 = [[UIToolbar alloc] init];
    [keyboardDoneButtonView1 sizeToFit];
    UIBarButtonItem* doneButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(doneClicked1:)];
    [keyboardDoneButtonView1 setItems:[NSArray arrayWithObjects:doneButton1, nil]];
    descView.inputAccessoryView = keyboardDoneButtonView1;
    
    
    
    if(![locationToSend isEqualToString:@""])
        [location_feild setTitle:locationToSend forState:UIControlStateNormal];
    
    
    
}
- (void)viewDidLoad
{
    locationApiComplete=0;
    [NSTimer scheduledTimerWithTimeInterval: 3.0 target:self selector:@selector(stopLoader) userInfo:nil repeats:NO];
    
    [LoaderViewController show:self.view animated:YES];

    vidUpload=0;
    doneBtnPressed=0;
    
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(showVideoThumb:)
                                   userInfo:nil
                                    repeats:NO];
    
    
    selectedArr=[NSMutableArray new];
    [location_feild setTitle:savedLocation forState:UIControlStateNormal];

    //[self getAddressFromLatLon:lat withLongitude:lng];
    [super viewDidLoad];
    
    
    locationToSend=@"";
//    api_obj=[[APIViewController alloc]init];
//    [api_obj searchNearestPlaces:@selector(searchNearestPlacesResult:) tempTarget:self : lat : lng];
    
    
    
    
    int x=0;
    for(int i=0;i<arrNearPlaces.count;i++)
    {
        NSMutableDictionary *dict=[arrNearPlaces objectAtIndex:i];
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
-(void)Upload
{
    @try {
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
                                    [alert1 setMessage:[NSString stringWithFormat:@"%@",error]];
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
                                    [self Upload1];                    }
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
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Task Error" message:[NSString stringWithFormat:@"%@",task.error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Task Exception" message:[NSString stringWithFormat:@"%@",task.exception] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        if (task.result) {
            AWSS3TransferUtilityUploadTask *uploadTask = task.result; 
            // 6. Should i be saving uploadTasks here?
        }
        
        return nil;
    }];
    
    
    });
//    AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
//    getPreSignedURLRequest.bucket = @"liveie";
//    getPreSignedURLRequest.key = [NSString stringWithFormat:@"%@-%@.mp4",[uuid lastObject],uuid1[0]];
//    getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodPUT;
//    getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:3600];
//    NSString *fileContentTypeString = @"video/quicktime";
//    getPreSignedURLRequest.contentType = fileContentTypeString;
//    
//    
//    NSArray* foo = [uuuu componentsSeparatedByString: @"/"];
//    NSArray* foo1= [[foo lastObject] componentsSeparatedByString: @"."];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//    NSString *dataPath = [[documentsDirectory stringByAppendingPathComponent:userid]stringByAppendingString:[NSString stringWithFormat:@"%@%@",foo1[0],@".mp4"]];
//    [vCompressedData writeToFile:dataPath atomically:NO];
//    
//    
//    [[[AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] getPreSignedURL:getPreSignedURLRequest] continueWithBlock:^id(AWSTask *task) {
//        
//        if (task.error) {
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            UIAlertView* alert1 = [[UIAlertView alloc] init];
//            [alert1 setDelegate:self];
//            [alert1 setTitle:@""];
//            [alert1 setMessage:@"Re-establising lost connection"];
//            [alert1 addButtonWithTitle:@"Retry"];
//            [alert1 addButtonWithTitle:@"Cancel"];
//            alert1.tag=6;
//            alert1.alertViewStyle = UIAlertViewStyleDefault;
//            
//            [alert1 show];
//            }];
//            
//            NSLog(@"Error: %@", task.error);
//        }
//        else {
//            
//            NSURL *presignedURL = task.result;
//            NSLog(@"upload presignedURL is \n%@", presignedURL);
//            
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:presignedURL];
//            request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//            [request setHTTPMethod:@"PUT"];
//            //            [request setValue:@"public" forHTTPHeaderField:@"x-amz-acl"];
//            [request setValue:fileContentTypeString forHTTPHeaderField:@"Content-Type"];
//            
//            uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:vCompressedData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                
//                
//                
//                if (error) {
//                    
//                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//
//                    UIAlertView* alert1 = [[UIAlertView alloc] init];
//                    [alert1 setDelegate:self];
//                    [alert1 setTitle:@""];
//                    [alert1 setMessage:@"Re-establising lost connection"];
//                    [alert1 addButtonWithTitle:@"Retry"];
//                    [alert1 addButtonWithTitle:@"Cancel"];
//                    alert1.tag=6;
//                    alert1.alertViewStyle = UIAlertViewStyleDefault;
//                    
//                    [alert1 show];
//                    }];
//                    NSLog(@"Upload errer: %@", error);
//                }
//                else
//                {
//                    vidUpload=1;
//                    if(doneBtnPressed==1)
//                    {
//                    [self Upload1];                    }
//                }
//            }];
//            
//            [uploadTask resume];
//        }
//        
//        
//        return nil;
//        
//    }];
//     });
        
    }
    
    @catch (NSException *exception) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",exception] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }


        
        
        
}
#pragma mark Segment Action
-(IBAction)public_Button:(id)sender
{
    
    segment=0;
    [public_btn setImage:[UIImage imageNamed:@"publicblue"] forState:UIControlStateNormal];
    [direct_btn setImage:[UIImage imageNamed:@"Directwhite"] forState:UIControlStateNormal];
    
    [tablev setHidden:YES];
    [txtSearch setHidden:YES];
}
-(IBAction)direct_Button:(id)sender
{
    
    segment=1;
    txtSearch.text=@"";
    [txtSearch setHidden:NO];
    
    [public_btn setImage:[UIImage imageNamed:@"publicwhite"] forState:UIControlStateNormal];
    [direct_btn setImage:[UIImage imageNamed:@"DirectBlue"] forState:UIControlStateNormal];
}
- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    segment = (int)segmentedControl.selectedSegmentIndex;
    
    if (segment == 0) {
        //toggle the correct view to be visible
        [tablev setHidden:YES];
        [txtSearch setHidden:YES];
        
    }
    else if (segment == 1){
        txtSearch.text=@"";
        //toggle the correct view to be visible
        [txtSearch setHidden:NO];
    }
}

//-(void)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
//{
//    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
//    NSLog(@"%f %f", lat, lng);
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation:LocationAtual
//                   completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (error)
//         {
//             NSLog(@"Geocode failed with error: %@", error);
//             return;
//         }
//         CLPlacemark *placemark = [placemarks objectAtIndex:0];
//         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
//         NSLog(@"locality %@",placemark.locality);
//         NSLog(@"postalCode %@",placemark.postalCode);
//         [location_feild setTitle:placemark.locality forState:UIControlStateNormal];
//     }];
//    
//}
-(void) buttonClicked:(UIButton*)sender
{
    //NSLog(@"you clicked on button %d", sender.tag);
    [location_feild setTitle:[sender titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Text view deligates
- (BOOL)textView:(UITextView *)textView  shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

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
    if([textView.text isEqualToString:@"Description with # HashTag"])
    {
        textView.text=@"";
    }
    descView.textColor=[UIColor whiteColor];
    
    
    return YES;
}
-(IBAction)backButton:(id)sender
{
    splash=1;
   // [uploadTask suspend];
    SCRecorderViewController *mevc;
    
    if(iphone5)
        mevc=[[SCRecorderViewController alloc]initWithNibName:@"SCRecorderViewController" bundle:nil];
    else if (iphone6)
        mevc=[[SCRecorderViewController alloc]initWithNibName:@"SCRecorderViewController@6" bundle:nil];
    else if (iphone6p)
        mevc=[[SCRecorderViewController alloc]initWithNibName:@"SCRecorderViewController@6p" bundle:nil];
    else if (iphone4)
        mevc=[[SCRecorderViewController alloc]initWithNibName:@"SCRecorderViewController@4" bundle:nil];
    [self.navigationController pushViewController:mevc animated:YES];
}
-(IBAction)doneButton:(id)sender
{
    [descView resignFirstResponder];
    descView.text = [descView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([descView.text isEqualToString:@"Description with # HashTag"]||[descView.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Please write the description with hashtag" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else
    {
        if(segment==1)
        {
            if(selectedArr.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liveie" message:@"Please select user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
           else
           {
               doneBtnPressed=1;
               [LoaderViewController show:self.view animated:YES];
               [self Upload1];
           }

        }
        else
        {
            doneBtnPressed=1;
            [LoaderViewController show:self.view animated:YES];
            [self Upload1];
        }
      
    
    }

}
-(void)Upload1
{
    if(vidUpload==1)
    {
        NSArray* foo = [descView.text componentsSeparatedByString: @" "];
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
        
        if([vFilters isEqualToString:@""])
            vFilters=@"none";
        //
        
        NSString *loc=[location_feild titleForState:UIControlStateNormal];
        if([loc isEqualToString:@"Add Location"])
            loc=@"none";
        else
            loc=[[location_feild titleForState:UIControlStateNormal]stringByReplacingOccurrencesOfString:@" " withString:@"@"];
        
        if(loc == nil)
        {
            loc=@"";
        }
        if(segment==0)
        {
            
            
            
            NSDictionary *params;
            NSLog(@"%@",descView.text);
            params=@{
                     @"caption"          :descView.text,
                     @"filter"           :[NSString stringWithFormat:@"%@",vFilters],
                     @"hashtag"          :hashTag,
                     @"lat"              :[NSString stringWithFormat:@"%f",lat],
                     @"location"         :loc,
                     @"url"              :uuuu,
                     @"lon"              :[NSString stringWithFormat:@"%f",lng],
                     @"userid"           :userid
                     };
            
            api_obj=[[APIViewController alloc]init];
            [api_obj uploadVideoUrlOnServer:@selector(uploadVideoUrlOnServerresult:) tempTarget:self :params];
            
            
            
        }
        else
        {
                            NSMutableArray *arrId=[[NSMutableArray alloc]init];
                for(int i=0;i<selectedArr.count;i++)
                {
                    NSMutableDictionary *dict=[selectedArr objectAtIndex:i];
                    [arrId addObject:[dict valueForKey:@"userid"]];
                }
                NSDictionary *params;
                params=@{
                         
                         @"caption"          :descView.text,
                         @"datatype"         :@"vid",
                         @"directRecipient":arrId,
                         @"filter"           :[NSString stringWithFormat:@"%@",vFilters],
                         @"hashtag"          :hashTag,
                         @"sharewith"        :@"",
                         @"location"         :loc,
                         @"url"              :uuuu,
                         @"userid"           :userid
                         };
                
                api_obj=[[APIViewController alloc]init];
                [ api_obj uploadVideoDirectOnServer:@selector(uploadVideoDirectOnServerresult:) tempTarget:self :params];
                
                
                NSLog(@"Done");
                
                
            }
        
        
        
        
    }
}
-(void)uploadVideoDirectOnServerresult:(NSDictionary*)dict_Response
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
            UIAlertView* alert1 = [[UIAlertView alloc] init];
            [alert1 setDelegate:self];
            [alert1 setTitle:@""];
            [alert1 setMessage:@"Video has been shared in Direct"];
            [alert1 addButtonWithTitle:@"OK"];;
            alert1.tag=7;
            alert1.alertViewStyle = UIAlertViewStyleDefault;
            
            [alert1 show];
            
            
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==7)
    {
        if(buttonIndex==0)
        {
            videoUploaded=true;
            splash=1;
            homeViewController *mvc;
            if(iphone4)
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@6p" bundle:nil];
            }
            else
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@ipad" bundle:nil];
            }
            [self.navigationController pushViewController:mvc animated:YES];
            
        }
    }
    if (alertView.tag==6)
    {
        if(buttonIndex==0)
        {
            [self Upload];
        }
        else
        {
            videoUploaded=YES;
            splash=1;
            homeViewController *mvc;
            if(iphone4)
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@6p" bundle:nil];
            }
            else
            {
                mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@ipad" bundle:nil];
            }
            [self.navigationController pushViewController:mvc animated:YES];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    
}

-(void)uploadVideoUrlOnServerresult:(NSDictionary*)dict_Response
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
            videoUploaded=YES;
            if([[dict_Response valueForKey:@"status"] integerValue]==200){
                
                UITabBarController *bar = [self tabBarController];
                if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
                    //iOS 7 - hide by property
                    NSLog(@"iOS 7");
                    [self setExtendedLayoutIncludesOpaqueBars:YES];
                    bar.tabBar.hidden = NO;
                }
                splash=1;
                videoUploaded=true;
                homeViewController *mvc;
                if(iphone4)
                {
                    mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@4" bundle:nil];
                }
                else if(iphone5)
                {
                    mvc=[[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
                }
                else if(iphone6)
                {
                    mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@6" bundle:nil];
                }
                else if(iphone6p)
                {
                    mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@6p" bundle:nil];
                }
                else
                {
                    mvc=[[homeViewController alloc]initWithNibName:@"homeViewController@ipad" bundle:nil];
                }
                [self.navigationController pushViewController:mvc animated:YES];            }
            
            
            
        }
    }
}


- (void)resetUploadPicHUDWithSucessinProfileView:(NSNumber *)isSucess
{
    
    
    if ([isSucess boolValue]) {
        // Update UI.
        
        
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
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             
         });
     }];
}
-(void)generateImage
{
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:vPath] options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        //videoThumb.image=[UIImage imageWithCGImage:im];
        
    };
    
    CGSize maxSize = CGSizeMake(320, 180);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
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

#pragma mark Text Field Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewSc setFrame:CGRectMake(0,-120, self.view.frame.size.width, viewSc.frame.size.height)];
    [UIView commitAnimations];
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewSc setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text isEqual:@""])
    {
        [tablev setHidden:YES];
    }
    [textField resignFirstResponder];
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    [viewSc setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText  isEqual: @""])
    {
        api_obj=[[APIViewController alloc]init];
        [api_obj SearchUser:@selector(SearchUserResult:) tempTarget:self :searchText];
    }
}
-(void)textFieldDidChange :(UITextField *) textField
{
    if(![textField.text  isEqual: @""])
    {
        api_obj=[[APIViewController alloc]init];
        [api_obj SearchUser:@selector(SearchUserResult:) tempTarget:self :textField.text];
    }
    
    
}
-(void)SearchUserResult:(NSMutableArray *)arr_Response
{
    if(arr_Response != NULL)
    {
        [tablev setHidden:NO];
        [tblSelected setHidden:YES];
        
        tablev.layer.zPosition=100;
        tblSelected.layer.zPosition=99;
        arrUsers=[arr_Response mutableCopy];
        [tablev reloadData];
    }
}


#pragma mark Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==2)
        return arrUsers.count;
    else
        return selectedArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==2)
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        NSMutableDictionary *dict=  arrUsers[indexPath.row];
        AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 60, 60)];
        [img1.layer setBorderWidth: 0.0];
        [img1.layer setCornerRadius:30.0f];
        [img1.layer setMasksToBounds:YES];
        img1.layer.borderColor = [UIColor colorWithRed:201/255.0 green:73/255.0 blue:24/255.0 alpha:1.0].CGColor;
        //img1.transform=CGAffineTransformMakeRotation(M_PI/2);
        img1.backgroundColor=[UIColor whiteColor];
        img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"userPic"]]];
        [cell addSubview:img1];
        
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame = CGRectMake (75, 15, 230, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        if([[dict objectForKey:@"name"] isEqualToString:@" "])
            [label setText:[dict objectForKey:@"username"]];
        else
            [label setText:[dict objectForKey:@"name"]];
        
        [cell addSubview:label];
        
        //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        NSMutableDictionary *dict=  selectedArr[indexPath.row];
        
        AsyncImageView *img1=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
        [img1.layer setBorderWidth: 0.0];
        [img1.layer setCornerRadius:22.5f];
        [img1.layer setMasksToBounds:YES];
        img1.backgroundColor=[UIColor whiteColor];
        img1.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"userPic"]]];
        [cell addSubview:img1];
        
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame = CGRectMake (85, 20, 230, 24);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor clearColor];
        if([[dict objectForKey:@"name"] isEqualToString:@" "])
            [label setText:[dict objectForKey:@"username"]];
        else
            [label setText:[dict objectForKey:@"name"]];
        [cell addSubview:label];
        
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=indexPath.row;
        button.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        
        [button setImage:[UIImage imageNamed:@"cancelbutton"]  forState:UIControlStateNormal];
        cell.accessoryView=button;
        
        
        
        
        
        
        
        //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==2)
    {
        if(![selectedArr containsObject:arrUsers[indexPath.row]])
        {
            if(selectedArr.count <10)
            {
                [selectedArr addObject:arrUsers[indexPath.row]];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Limit Exceeded" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            
        }
        [txtSearch resignFirstResponder];
        txtSearch.text=@"";
        [tablev setHidden:YES];
        [arrUsers removeObject:arrUsers[indexPath.row]];
        [tblSelected setHidden:NO];
        [tblSelected reloadData];
        [tablev reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (void)deleteAction:(UIButton *)btn
{
    [selectedArr removeObjectAtIndex:btn.tag];
    [tblSelected reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    vCompressedData=nil;
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = NO;
    }
    
}
-(void)stopLoader
{
    if(locationApiComplete==1)
    {
        locationApiComplete=0;
        //[self Upload];
    }
    else
    {
        locationApiComplete=2;
    }
    [LoaderViewController remove:self.view animated:YES];
}

@end
