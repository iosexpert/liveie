
//  Created by AppHub on 2/28/14.
//  Copyright (c) 2014 AppHub. All rights reserved.
//

#import "APIViewController.h"
#import "AppDelegate.h"
#import "Utilities.h"

#import "AFHTTPClient.h"
#import "AFNetworking.h"

#import "LoaderViewController.h"
#define kGooglePlacesAPIBrowserKey2 @"AIzaSyD-Wqu3mbLcb2sRM_coKvjHzv-KRwFOpHo"

//#define WEBURL @"http://54.186.130.129/Lively/UserServices.svc"
//#define WEBURL1  @"http://54.186.130.129/Lively/Post.svc"
//#define CONNECTURL  @"http://54.186.130.129/Lively/Connects.svc"
//#define WEBURL1 @"http://52.27.100.133:28017"




@implementation APIViewController
{
    
}
//@synthesize callBackSelector;
//@synthesize callBackTarget;

AppDelegate *l_appDelegate;
#pragma mark getVINinfo API (get data related VIN Number)3


-(void) ResponseAFCountry:(NSDictionary * ) dict
{
    
    
    if (_callBackTarget != nil && _callBackSelector != nil) {
         [_callBackTarget performSelector:_callBackSelector withObject:dict];
    }

    
}
-(void) ResponseAFCountry1:(NSMutableArray * ) dict
{
    
    
    if (_callBackTarget != nil && _callBackSelector != nil) {
        [_callBackTarget performSelector:_callBackSelector withObject:dict];
    }
    
    
}
-(void) ResponseAFCountry2:(NSString * ) dict
{
    
    
    if (_callBackTarget != nil && _callBackSelector != nil) {
        [_callBackTarget performSelector:_callBackSelector withObject:dict];
    }
    
    
}
/*
 This method called to report user
 */
-(void)reportUser:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *completeURL = [NSString stringWithFormat:@"%@/UserServices.svc/ReportUserAsSpam/%@",appUrl,urlll];
    
    NSLog(@"url %@",completeURL);
    NSURL *url = [[NSURL alloc] initWithString:completeURL];
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
}
/*
 This method called to follow post
 */
-(void)followUser:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll :(NSString *)status
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *completeURL = [NSString stringWithFormat:@"%@/Post.svc/FollowPost/%@/%@/%@",appUrl,userid,urlll,status];
    
    NSLog(@"url %@",completeURL);
    NSURL *url = [[NSURL alloc] initWithString:completeURL];
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    
}

/*
 This method called to Get Details Of application
 */
-(void)GetAppSettings:(SEL)tempSelector tempTarget:(id)tempTarget
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *completeURL = [NSString stringWithFormat:@"%@/Settings.svc/GetAppSettings",appUrl];
    
    NSLog(@"url %@",completeURL);
    NSURL *url = [[NSURL alloc] initWithString:completeURL];
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    
}


-(void)SyncPhoneBook:(SEL)tempSelector tempTarget:(id)tempTarget :(NSMutableArray *)contacts :(NSMutableArray*)workContacts
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSDictionary *params=@{
                           @"contact":contacts,
                           @"userid":userid,
                           @"work_contact":workContacts
                           
                           };
    // Prepare the URL and request.
    NSString *completeURL = [NSString stringWithFormat:@"%@/UserServices.svc/SyncPhoneBook",appUrl];
    NSURL *url = [[NSURL alloc]initWithString:[completeURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Complete url:%@",url);
    // Make the network call.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=utf-8"]
   forHTTPHeaderField:@"Content-Type"];
    NSError *paramError = nil;
    [request setHTTPBody:[NSJSONSerialization
                          dataWithJSONObject:params options:0 error:&paramError]];
    NSLog(@"%@",request);
    if (!paramError) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry:JSON];
                
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
            [self ResponseAFCountry:nil];
            
        }];
        [operation start];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Some Text" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
    }
    

}


/*
 This method called to block user
 */
-(void)blockUser:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *completeURL = [NSString stringWithFormat:@"%@/Settings.svc/BlockUser/%@",appUrl,urlll];
    
    NSLog(@"url %@",completeURL);
    NSURL *url = [[NSURL alloc] initWithString:completeURL];
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
/*
 This method called to get nearByPost
 */
-(void)getNearByPost:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll
{
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *completeURL = [NSString stringWithFormat:@"%@/Post.svc/GetNearbyPost/%@",appUrl,urlll];
    
    NSLog(@"url %@",completeURL);
    NSURL *url = [[NSURL alloc] initWithString:completeURL];
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
}
/*
 This method called to save user profile detail
 */
-(void)updateDetailUserProfile:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary*) params
{
    
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
       NSLog(@"params thought %@",params);
    // Prepare the URL and request.
    NSString *completeURL = [NSString stringWithFormat:@"%@/Settings.svc/UpdateDetails",appUrl ];
    NSURL *url = [[NSURL alloc]initWithString:[completeURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Complete url:%@",url);
    // Make the network call.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=utf-8"]
   forHTTPHeaderField:@"Content-Type"];
    NSError *paramError = nil;
    [request setHTTPBody:[NSJSONSerialization
                          dataWithJSONObject:params options:0 error:&paramError]];
    NSLog(@"%@",request);
    if (!paramError) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry:JSON];
                
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
             [self ResponseAFCountry:NULL];
        }];
        [operation start];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Some Text" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
    }
    
    
  
}
/*
 This method called to directShareThePost
 */
-(void)directShareThePost:(SEL)tempSelector tempTarget:(id)tempTarget  :(NSString *)urlll
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSURL *url = [[NSURL alloc] initWithString:urlll];
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
  
}

/*
 This method called to check notification get or not
 */
-(void)getNotificationStatus:(SEL)tempSelector tempTarget:(id)tempTarget
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetNotificationStatus/%@",appUrl,userid];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    

    
}

/*
 This method called to get notification
 */
-(void)getNotification:(SEL)tempSelector tempTarget:(id)tempTarget

{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Notification.svc/GetNotifications/%@/%@/%@",appUrl,userid,@"0",@"50"];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    
 
}
/*
 This method called get notification count
 */
-(void)getNotificationCount:(SEL)tempSelector tempTarget:(id)tempTarget
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@//Notification.svc/GetNotificationCount/%@",appUrl,userid];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
/*
 This method called to read notification
 */
-(void)readNotification:(SEL)tempSelector tempTarget:(id)tempTarget  :(NSString *)value
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Notification.svc/UpdateNotificationAsRead/%@",appUrl,value];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
  
}
/*
 This method called to change profile private
 */
-(void)makeProfilePrivate:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)value
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/UpdateProfilePrivacy/%@/%@",appUrl,userid,value];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
/*
 This method called to change notification
 */
-(void)changeNotification:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)value
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/ChangeNotification/%@/%@",appUrl,userid,value];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
 
}

/*
 This method called to un block user
 */
-(void)unblockuser:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)unblockid
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/UnBlockUser/%@/%@",appUrl,userid,unblockid];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
 
}
/*
 This method called to get hide posts
 */
-(void)unhidepost:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)postiddd
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/UnHidePOst/%@/%@",appUrl,userid,postiddd];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
/*
 This method called to get hide posts
 */
-(void)gethidepost:(SEL)tempSelector tempTarget:(id)tempTarget
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetHidePostList/%@",appUrl,userid];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    
  
}
/*
 This method called to get blocked users
 */
-(void)getBlockedUser:(SEL)tempSelector tempTarget:(id)tempTarget
{
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Settings.svc/GetBlockedUser/%@",appUrl,userid];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
/*
 This method called to get user profile detail
 */
-(void)getDetailUserProfile:(SEL)tempSelector tempTarget:(id)tempTarget
{
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;

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
            
            [self ResponseAFCountry:JSON];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
/*
 This method called to mark post view
 */
-(void)markviewresd:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) postid
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/MarkPostAdView/%@/%@",WEBURL1,userid,postid];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        //[self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}

-(void)getDirectUsers:(SEL)tempSelector tempTarget:(id)tempTarget
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetDirectUser/%@",WEBURL1,userid];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}

-(void)FollowingSearch:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)OtherID :(NSString*)searchdata
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetSearchFollowings/%@/%@/%@",CONNECTURL,userid,OtherID,searchdata];
    
    //  NSString *urlString=[NSString stringWithFormat:@"%@/GetSearchResult/%@/%@",WEBURL1,userid,searchdata];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
}


-(void)FollowerSearch:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)OtherID :(NSString*)searchdata
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetSearchFollowers/%@/%@/%@",CONNECTURL,userid,OtherID,searchdata];
    
    //  NSString *urlString=[NSString stringWithFormat:@"%@/GetSearchResult/%@/%@",WEBURL1,userid,searchdata];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
}

-(void)Search:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)searchdata
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetCollectiveSearch/%@/%@/%f/%f",WEBURL1,userid,searchdata,lng,lat];
    
   //  NSString *urlString=[NSString stringWithFormat:@"%@/GetSearchResult/%@/%@",WEBURL1,userid,searchdata];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            
            NSError *e;
            NSMutableArray *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            [self ResponseAFCountry1:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry1:nil];
        
    }];
    
    [operation start];
}
-(void)GetSearchNearby:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)searchdata
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetSearchNearby/%@/%@/%f/%f",WEBURL1,userid,searchdata,lng,lat];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            
            NSError *e;
            NSMutableArray *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            [self ResponseAFCountry1:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry1:nil];
        
    }];
    
    [operation start];
}

-(void)RecentSearch:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)searchdata
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetSearchRecentby/%@/%@",WEBURL1,userid,searchdata];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            
            NSError *e;
            NSMutableArray *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            [self ResponseAFCountry1:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry1:nil];
        
    }];
    
    [operation start];
}



-(void)getPostLikes:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)postId
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetPostLike/%@/%@",WEBURL1,userid,postId];
    
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
            
            [self ResponseAFCountry:JSON];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
}

/*
 This method called to like user profile
 */
-(void)likeUserProfile:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid :(NSString*) value
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
   
    NSString *urlString=[NSString stringWithFormat:@"%@/LikeUserProfile/%@/%@/%@",WEBURL,userid,frdid,value];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
/*
 This method called to get follower list
 */
-(void)getFollowerList:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetFollowers/%@/%@/%@/%@",CONNECTURL,userid,frdid,@"0",@"200"];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
}


-(void)ApproveFollowRequest:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/ApproveFollowRequest/%@/%@",CONNECTURL,userid,frdid];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
}



/*
 This method called to get following list
 */
-(void)getFollowingList:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetFollowings/%@/%@/%@/%@",CONNECTURL,userid,frdid,@"0",@"200"];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
 
}
/*
 This method called to follow the user
 */
-(void)follow_user:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) frdid :(NSString*) value
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/FollowUser/%@/%@/%@",CONNECTURL,userid,frdid,value];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
/*
 This method called to get people
 */
-(void)getPeople:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Post.svc/GetPeopleToFollow/%@",appUrl,urlll];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    

}
/*
 This method called to get trending post
 */
-(void)getTrendingPost:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Post.svc/GetTrendings/%@",appUrl,urlll];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
  
}
/*
 This method called to get recent post
 */
-(void)getRecentPost:(SEL)tempSelector tempTarget:(id)tempTarget   :(NSString *)urlll
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Post.svc/GetRecentPost/%@",appUrl,urlll];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    

}
/*
 This method called to  get data for search screen
 */
-(void)searchScreenData:(SEL)tempSelector tempTarget:(id)tempTarget
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;

    NSString *urlString=[NSString stringWithFormat:@"%@/GetTrendings/%@/%f/%f/0/5",WEBURL1,userid,lng,lat];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        else
        {
            [self ResponseAFCountry:nil];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
 
}
/*
 This method called to get profile info
 */
-(void)getProfileInfo:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)otherUserid
{

    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    //
    NSString *urlString=[NSString stringWithFormat:@"%@/GetUserProfile/%@/%@/%@/%@",WEBURL,userid,otherUserid,@"0",@"10"];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    

}
/*
 This method called to get post of hashtag
 */
-(void)postOfHashTags:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary*) urls
{
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSLog(@"params thought %@",urls);
    // Prepare the URL and requestx.
    NSString *completeURL = [NSString stringWithFormat:@"%@/Post.svc/GetUserPostByHashTag",appUrl];
    NSURL *url = [[NSURL alloc]initWithString:[completeURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Complete url:%@",url);
    // Make the network call.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=utf-8"]
   forHTTPHeaderField:@"Content-Type"];
    NSError *paramError = nil;
    [request setHTTPBody:[NSJSONSerialization
                          dataWithJSONObject:urls options:0 error:&paramError]];
    NSLog(@"%@",request);
    if (!paramError) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry:JSON];
                
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
            [self ResponseAFCountry:nil];
            
        }];
        [operation start];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Some Text" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
    }

    
    
    
    
       

}
/*
 This method called to With&agaist
 */
-(void)getWithAndagaist:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) urls
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    //
    NSString *urlString=[NSString stringWithFormat:@"%@/GetUserPostWithReply/%@",WEBURL1,urls];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    
    
}

/*
 This method called to get nearest places
 */
-(void)searchNearestPlaces:(SEL)tempSelector tempTarget:(id)tempTarget :(float)lati :(float)longi
{
//    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//    _callBackSelector=tempSelector;
//    _callBackTarget=tempTarget;
//    if([Utilities CheckInternetConnection])//0: internet working
//    {
//       
//        NSString *urlString=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&rankby=distance&types=establishment|locality|country|cafe|restaurant|bar|park&key=%@",lati,longi,kGooglePlacesAPIBrowserKey2];
//        
//        NSLog(@"url %@",urlString);
//       // NSURL *url = [[NSURL alloc] initWithString:urlString];
//        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//         NSLog(@"url %@",url);
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSString *jsonString = operation.responseString;
//            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//            
//            if (JSONdata != nil) {
//                
//                NSError *e;
//                NSMutableArray *JSON =
//                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
//                                                options: NSJSONReadingMutableContainers
//                                                  error: &e];
//                
//                [self ResponseAFCountry1:JSON];
//                
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            NSLog(@"error: %@",  operation.responseString);
//            
//            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
//            
//            if (errStr==Nil) {
//                errStr=@"Server not reachable";
//            }
//            
//            [self ResponseAFCountry:nil];
//            
//        }];
//        
//        [operation start];
//    }
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
        
        NSString *urlString=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&client_id=3P1KGZPYB5XETWEGOAS235WEZTGFTHOF11CB3AXM2YDVRI3N&client_secret=AB5UEOONXC1TGOGZPS5LDOFGUVF4ZAU21SF5BGQELQXMRBHF&categoryId=4d4b7105d754a06375d81259,4e67e38e036454776db1fb3a,4d4b7105d754a06378d81259,4d4b7105d754a06377d81259,4d4b7104d754a06370d81259,4d4b7105d754a06372d81259,4d4b7105d754a06373d81259,4d4b7105d754a06374d81259,4d4b7105d754a06376d81259,4d4b7105d754a06379d81259&v=20161304&radius=5000&limit=100",lati,longi];
        
        NSLog(@"url %@",urlString);
        // NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSLog(@"url %@",url);
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableArray *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry1:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self ResponseAFCountry:nil];
            
        }];
        
        [operation start];
    }

}
/*
 This method called to get nearest text
 */
-(void)searchNearesttext:(SEL)tempSelector tempTarget:(id)tempTarget :(float)lati :(float)longi :(NSString *)searchText
{
//    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//    _callBackSelector=tempSelector;
//    _callBackTarget=tempTarget;
//    if([Utilities CheckInternetConnection])//0: internet working
//    {
//        
//       NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%f,%f&types=establishment|locality|country|cafe|food|bar|park|route&radius=0000&query=%@&key=%@",lati,longi,searchText,kGooglePlacesAPIBrowserKey2];
//        
//        NSLog(@"url %@",urlString);
//        // NSURL *url = [[NSURL alloc] initWithString:urlString];
//        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//        NSLog(@"url %@",url);
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSString *jsonString = operation.responseString;
//            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//            
//            if (JSONdata != nil) {
//                
//                NSError *e;
//                NSMutableArray *JSON =
//                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
//                                                options: NSJSONReadingMutableContainers
//                                                  error: &e];
//                
//                [self ResponseAFCountry1:JSON];
//                
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            NSLog(@"error: %@",  operation.responseString);
//            
//            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
//            
//            if (errStr==Nil) {
//                errStr=@"Server not reachable";
//            }
//            
//            [self ResponseAFCountry:nil];
//            
//        }];
//        
//        [operation start];
//    }
    
    
    
    
    
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
        
        NSString* urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&categoryId=4bf58dd8d48988d124941735,4d4b7105d754a06375d81259,4d4b7105d754a06379d81259,4d4b7105d754a06378d81259,4e67e38e036454776db1fb3a,4d4b7105d754a06377d81259,4d4b7104d754a06370d81259,4d4b7105d754a06372d81259,4d4b7105d754a06373d81259,4d4b7105d754a06374d81259,4d4b7105d754a06376d81259&client_id=3P1KGZPYB5XETWEGOAS235WEZTGFTHOF11CB3AXM2YDVRI3N&client_secret=AB5UEOONXC1TGOGZPS5LDOFGUVF4ZAU21SF5BGQELQXMRBHF&v=20161006&query=%@&limit=100",lati,longi,searchText];
        
        NSLog(@"url %@",urlString);
        // NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSLog(@"url %@",url);
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableArray *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry1:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            //[self ResponseAFCountry:nil];
            
        }];
        
        [operation start];
    }

}
/*
 This method called to upload video as reply
 */
-(void)uploadVideoasReply:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary *)params
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSLog(@"params thought %@",params);
    // Prepare the URL and request.
    NSString *completeURL = [NSString stringWithFormat:@"%@/Post.svc/ReplyAsWith",appUrl];
    NSURL *url = [[NSURL alloc]initWithString:[completeURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Complete url:%@",url);
    // Make the network call.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=utf-8"]
   forHTTPHeaderField:@"Content-Type"];
    NSError *paramError = nil;
    [request setHTTPBody:[NSJSONSerialization
                          dataWithJSONObject:params options:0 error:&paramError]];
    NSLog(@"%@",request);
    if (!paramError) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry:JSON];
                
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
             [self ResponseAFCountry:nil];
            
        }];
        [operation start];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Some Text" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
    }

}
/*
 This method called to uploadVideoDirectOnServer
 */
-(void)uploadVideoDirectOnServer:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary *)params
{
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSLog(@"params thought %@",params);
    // Prepare the URL and request.
    NSString *completeURL = [NSString stringWithFormat:@"%@/Post.svc/PostMediaDirect",appUrl];
    NSURL *url = [[NSURL alloc]initWithString:[completeURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Complete url:%@",url);
    // Make the network call.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=utf-8"]
   forHTTPHeaderField:@"Content-Type"];
    NSError *paramError = nil;
    [request setHTTPBody:[NSJSONSerialization
                          dataWithJSONObject:params options:0 error:&paramError]];
    NSLog(@"%@",request);
    if (!paramError) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry:JSON];
                
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
             [self ResponseAFCountry:nil];
            
        }];
        [operation start];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Some Text" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
    }
 
}
/*
 This method called to uploadVideoUrlOnServer
 */
-(void)uploadVideoUrlOnServer:(SEL)tempSelector tempTarget:(id)tempTarget :(NSDictionary *)params
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSLog(@"params thought %@",params);
    // Prepare the URL and request.
    NSString *completeURL = [NSString stringWithFormat:@"%@/Post.svc/PostMedia",appUrl];
    NSURL *url = [[NSURL alloc]initWithString:[completeURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Complete url:%@",url);
    // Make the network call.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=utf-8"]
   forHTTPHeaderField:@"Content-Type"];
    NSError *paramError = nil;
    [request setHTTPBody:[NSJSONSerialization
                          dataWithJSONObject:params options:0 error:&paramError]];
    NSLog(@"%@",request);
    if (!paramError) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry:JSON];
                
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
             [self ResponseAFCountry:nil];
            
        }];
        [operation start];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Some Text" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
    }
   
}
/*
 This method called to comment on feed
 */
-(void)commetOnFeed:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)comment :(NSString*)feeedid
{
    
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSDictionary *params;
    params=@{
             @"userUid"         :userid,
             @"comment"         :comment,
             @"postid"         :feeedid
             };
    NSLog(@"params thought %@",params);
    // Prepare the URL and request.
    NSString *completeURL = [NSString stringWithFormat:@"%@/AddPostComment",WEBURL1];
    NSURL *url = [[NSURL alloc]initWithString:[completeURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Complete url:%@",url);
    // Make the network call.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=utf-8"]
   forHTTPHeaderField:@"Content-Type"];
    NSError *paramError = nil;
    [request setHTTPBody:[NSJSONSerialization
                          dataWithJSONObject:params options:0 error:&paramError]];
    NSLog(@"%@",request);
    if (!paramError) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry:JSON];
                
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
             [self ResponseAFCountry:nil];
            
        }];
        [operation start];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Some Text" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
    }
    
}
/*
 This method called to edit comment on feed
 */
-(void)editCommetOnFeed:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)comment :(NSString*)feeedid
{
    
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSDictionary *params;
    params=@{
             @"userUid"         :userid,
             @"comment"         :comment,
             @"postid"         :feeedid
             };
    NSLog(@"params thought %@",params);
    // Prepare the URL and request.
    NSString *completeURL = [NSString stringWithFormat:@"%@/EditComment",WEBURL1];
    NSURL *url = [[NSURL alloc]initWithString:[completeURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Complete url:%@",url);
    // Make the network call.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=utf-8"]
   forHTTPHeaderField:@"Content-Type"];
    NSError *paramError = nil;
    [request setHTTPBody:[NSJSONSerialization
                          dataWithJSONObject:params options:0 error:&paramError]];
    NSLog(@"%@",request);
    if (!paramError) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableDictionary *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry:JSON];
                
            }
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                  error);
            [self ResponseAFCountry:nil];
            
        }];
        [operation start];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter Some Text" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
    }
    
}

/*
 This method called to get feed msg list
 */
-(void)getFeedmessage:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)feed_id
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
       // http://54.186.130.129/Lively/Post.svc/GetAllComments/{USERID}/{POSTID}/{PAGENO}/{LIMIT}
        NSString *urlString=[NSString stringWithFormat:@"%@/GetAllComments/%@/%@/%@/%@",WEBURL1,userid,feed_id,@"0",@"500"];
        
        NSLog(@"url %@",urlString);
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableArray *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry1:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self ResponseAFCountry:nil];
            
        }];
        
        [operation start];
    }
    
}


/*
 This method called to ClearBadgeCount
 */
-(void)ClearBadgeCount:(id)tempTarget {
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
        
        NSString *urlString=[NSString stringWithFormat:@"%@/ClearBadgeCount/%@",WEBURL1,userid];
        
        NSLog(@"url %@",urlString);
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableArray *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry1:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self ResponseAFCountry:nil];
            
        }];
        
        [operation start];
    }
    
}



/*
 This method called to like on feed
 */
-(void)likeOnFeed:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString* )feeedid :(NSString* )value
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
       
        NSString *urlString=[NSString stringWithFormat:@"%@/LikePost/%@/%@/%@",WEBURL1,userid,feeedid,value];
        
        NSLog(@"url %@",urlString);
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (JSONdata != nil) {
                
                NSError *e;
                NSMutableArray *JSON =
                [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &e];
                
                [self ResponseAFCountry1:JSON];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error: %@",  operation.responseString);
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            
            if (errStr==Nil) {
                errStr=@"Server not reachable";
            }
            
            [self ResponseAFCountry:nil];
            
        }];
        
        [operation start];
    }
    
}

/*
 This method called to upload the video
 */
-(void)getAllVideos:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) urls
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    //
    NSString *urlString=[NSString stringWithFormat:@"%@/GetUserPost/%@",WEBURL1,urls];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    

}

-(void)SearchUser:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)SEARCHDATA
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    //
    NSString *urlString=[NSString stringWithFormat:@"%@/SearchUser/%@/%@",WEBURL,userid,SEARCHDATA];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (JSONdata != nil) {
            
            NSError *e;
            NSMutableArray *JSON =
            [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &e];
            
            [self ResponseAFCountry1:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry1:nil];
        
    }];
    
    [operation start];

    
}

-(void)ReportSpamPost:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)postId
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    //
    NSString *urlString=[NSString stringWithFormat:@"%@/ReportSpamPost/%@/%@",WEBURL1,userid,postId];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}
-(void)ReShare:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)postId
{ l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    //
    NSString *urlString=[NSString stringWithFormat:@"%@/ReShare/%@/%@",WEBURL1,userid,postId];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

    
}
-(void)HidePost:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)postId
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    //
    NSString *urlString=[NSString stringWithFormat:@"%@/HidePost/%@/%@",WEBURL1,userid,postId];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];

}



-(void)getDirectPost:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)otherUserId
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    //
    NSString *urlString=[NSString stringWithFormat:@"%@/GetDirectPost/%@/%@/0/500",WEBURL1,userid,otherUserId];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
}


/*
 This method called to login user
 */
-(void)loginuser:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) email :(NSString *)pass
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
	///UserLogin/{USER_USERID}/{PASSWORD}/{DEVICE_UID}/{LONGLAT}
	_callBackSelector=tempSelector;
	_callBackTarget=tempTarget;
    NSString *urlString=[NSString stringWithFormat:@"%@/UserLogin/%@/%@/%@/%f!%f",WEBURL,email,pass,device_id,lng,lat];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    
}
/*
 This method called to forgot pass user
 */
-(void)forgotpass:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) email
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/Forgotpassword/%@",WEBURL,email];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    
    


}

//API for User Name Availability
-(void)CheckUserName:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*)UserName
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetUsernameAvailability/%@",WEBURL,UserName];
    
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
            
            [self ResponseAFCountry:JSON];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];

    }];
    
    [operation start];

    
    
    
}

//API for emailID Availability
-(void)CheckEmailID:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString *)emailID
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    
    NSString *urlString=[NSString stringWithFormat:@"%@/GetEmailIdAvailability/%@",WEBURL,emailID];
    
    NSLog(@"url %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",operation.responseString);
        [self ResponseAFCountry2:jsonString];
        if (JSONdata != nil) {
            
           // NSError *e;
           // NSMutableDictionary *JSON =[NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]options: NSJSONReadingMutableContainers error: &e];
            
          //  [self ResponseAFCountry:jsonString];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",  operation.responseString);
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        [self ResponseAFCountry:nil];
        
    }];
    
    [operation start];
    
    
    
    
}
/*
 This method called to upload the video
 */
-(void)uploadVideo:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) urls :(NSData*) video
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
        //==========================================================BASE URL
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/PostMedia",WEBURL1]];
        NSLog(@"%@",url);
        //==========================================================REQUIRED PARAMETERS(ONLY TEXT)
        

        //==========================================================AFNETWORKING HEADER
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        httpClient.parameterEncoding = AFFormURLParameterEncoding;
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSDate *sendimgename=[NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"ddMMyyyy:hh:mm:ss"];
        NSString *stringFromDate = [formatter stringFromDate:sendimgename];
        NSLog(@"%@",urls);
        
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:urls parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:video name:[NSString stringWithFormat:@"%@",@"fileContent"] fileName:[NSString stringWithFormat:@"%@.mov",stringFromDate] mimeType:@"video/quicktime"];
            
        }];
        //===========================================================RESPONSE
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        
        [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
            
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
            
        }];
        
        
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error = nil;
             NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
             NSString *response = [operation responseString];
             NSLog(@"%@",response);
             
             [self ResponseAFCountry:JSON];
         }
         //===========================================================ERROR
         
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             
                                             NSLog(@"error: %@",  operation.responseString);
                                             NSLog(@"error: %d",  operation.response.statusCode);
                                             
                                             if([operation.response statusCode] == 406){
                                                 
                                                 // [SVProgressHUD showErrorWithStatus:@"This Mail Id Is Not Exist Please Choose Our Account Mail Address"];
                                                 return;
                                             }
                                             if([operation.response statusCode] == 403){
                                                 NSLog(@"Upload Failed");
                                                 return;
                                             }
                                             if ([[operation error] code] == -1009) {
                                                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Liveie"
                                                                                              message:@"Please check your internet connection"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                                 [av show];
                                             }
                                             else if ([[operation error] code] == -1001) {
                                                 //[self AFCountry];
                                             }
                                         }];
        [operation start];
        
    }
    else if(![Utilities CheckInternetConnection])
    {
        
    }

}

/*
 This method called to upload the video
 */
-(void)changeprofile_pic:(SEL)tempSelector tempTarget:(id)tempTarget :(NSData*) img
{
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
        //==========================================================BASE URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/UpdateProfilePic/%@",WEBURL,userid]];
        NSLog(@"%@",url);
        //==========================================================REQUIRED PARAMETERS(ONLY TEXT)
        
        
        
        //==========================================================AFNETWORKING HEADER
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        httpClient.parameterEncoding = AFFormURLParameterEncoding;
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSDate *sendimgename=[NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"ddMMyyyy:hh:mm:ss"];
        NSString *stringFromDate = [formatter stringFromDate:sendimgename];
        
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/profile.png/img" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:img name:[NSString stringWithFormat:@"%@",@"fileContent"] fileName:[NSString stringWithFormat:@"%@.png",stringFromDate] mimeType:@"image/png"];
        }];
        //===========================================================RESPONSE
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        
        [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
            
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
            
        }];
        
        
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error = nil;
             NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
             NSString *response = [operation responseString];
             NSLog(@"%@",response);
             
             [self ResponseAFCountry:JSON];
         }
         //===========================================================ERROR
         
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             
                                             
                                             
                                             if([operation.response statusCode] == 406){
                                                 
                                                 // [SVProgressHUD showErrorWithStatus:@"This Mail Id Is Not Exist Please Choose Our Account Mail Address"];
                                                 return;
                                             }
                                             if([operation.response statusCode] == 403){
                                                 NSLog(@"Upload Failed");
                                                 return;
                                             }
                                             if ([[operation error] code] == -1009) {
                                                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Liveie"
                                                                                              message:@"Please check your internet connection"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                                 [av show];
                                             }
                                             else if ([[operation error] code] == -1001) {
                                                 //[self AFCountry];
                                             }
                                         }];
        [operation start];
        
    }
    else if(![Utilities CheckInternetConnection])
    {
        
    }

}
/*
 This method called to upload the video
 */
-(void)chnage_cover_pic:(SEL)tempSelector tempTarget:(id)tempTarget :(NSData*) img
{
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
        //==========================================================BASE URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/UpdateWallPic/%@",WEBURL,userid]];
        NSLog(@"%@",url);
        //==========================================================REQUIRED PARAMETERS(ONLY TEXT)
        
        
        
        //==========================================================AFNETWORKING HEADER
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        httpClient.parameterEncoding = AFFormURLParameterEncoding;
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSDate *sendimgename=[NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"ddMMyyyy:hh:mm:ss"];
        NSString *stringFromDate = [formatter stringFromDate:sendimgename];
        
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/profile.png/img" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:img name:[NSString stringWithFormat:@"%@",@"fileContent"] fileName:[NSString stringWithFormat:@"%@.png",stringFromDate] mimeType:@"image/png"];
        }];
        //===========================================================RESPONSE
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        
        [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
            
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
            
        }];
        
        
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error = nil;
             NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
             NSString *response = [operation responseString];
             NSLog(@"%@",response);
             
             [self ResponseAFCountry:JSON];
         }
         //===========================================================ERROR
         
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             
                                             
                                             
                                             if([operation.response statusCode] == 406){
                                                 
                                                 // [SVProgressHUD showErrorWithStatus:@"This Mail Id Is Not Exist Please Choose Our Account Mail Address"];
                                                 return;
                                             }
                                             if([operation.response statusCode] == 403){
                                                 NSLog(@"Upload Failed");
                                                 return;
                                             }
                                             if ([[operation error] code] == -1009) {
                                                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Liveie"
                                                                                              message:@"Please check your internet connection"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                                 [av show];
                                             }
                                             else if ([[operation error] code] == -1001) {
                                                 //[self AFCountry];
                                             }
                                         }];
        [operation start];
        
    }
    else if(![Utilities CheckInternetConnection])
    {
        
    }

}
//API for RegisterUser

-(void)registerNewUser:(SEL)tempSelector tempTarget:(id)tempTarget :(NSString*) urls :(NSData*) image
{
   
    
    l_appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _callBackSelector=tempSelector;
    _callBackTarget=tempTarget;
    if([Utilities CheckInternetConnection])//0: internet working
    {
        //==========================================================BASE URL
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterUser/",WEBURL]];
        NSLog(@"%@",url);
        //==========================================================REQUIRED PARAMETERS(ONLY TEXT)
        
        
        
        //==========================================================AFNETWORKING HEADER
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        httpClient.parameterEncoding = AFFormURLParameterEncoding;
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSDate *sendimgename=[NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"ddMMyyyy:hh:mm:ss"];
        NSString *stringFromDate = [formatter stringFromDate:sendimgename];
        
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:urls parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:image name:[NSString stringWithFormat:@"%@",@"fileContent"] fileName:[NSString stringWithFormat:@"%@.jpeg",stringFromDate] mimeType:@"image/jpeg"];
        }];
        //===========================================================RESPONSE
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        
        [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
            
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
            
        }];
        
        
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error = nil;
             NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
             NSString *response = [operation responseString];
             NSLog(@"%@",response);
             
             [self ResponseAFCountry:JSON];
         }
         //===========================================================ERROR
         
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             
                                             
                                             
                                             if([operation.response statusCode] == 406){
                                                 
                                                 // [SVProgressHUD showErrorWithStatus:@"This Mail Id Is Not Exist Please Choose Our Account Mail Address"];
                                                 return;
                                             }
                                             if([operation.response statusCode] == 403){
                                                 NSLog(@"Upload Failed");
                                                 return;
                                             }
                                             if ([[operation error] code] == -1009) {
                                                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Liveie"
                                                                                              message:@"Please check your internet connection"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                                 [av show];
                                             }
                                             else if ([[operation error] code] == -1001) {
                                                 //[self AFCountry];
                                             }
                                         }];
        [operation start];
        
    }
    else if(![Utilities CheckInternetConnection])
    {
        
    }

    
}





- (void)makeConnection : (NSString *) post1 url:(NSString *)url1
{
    
    NSLog(@"hello");
    NSString *post = post1;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    
    [request setURL:[NSURL URLWithString:url1]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    l_theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [l_theConnection start];
    
    if(l_theConnection)
    {
        NSLog(@"Request sent to get data");
    }
    //[temp_strJson release];
    
    request = nil;
    
    
}









@end
