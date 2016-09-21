//
//  AppDelegate.m
//  Lively
//
//  Created by Brahmasys on 16/11/15.
//  Copyright (c) 2015 Brahmasys. All rights reserved.
//

#import "AppDelegate.h"
#import "loginViewController.h"
#import "onBordingViewController.h"
#import "APIViewController.h"
#import "UpdateViewController.h"
#import "tabbarViewController.h"
#import <AWSCore/AWSCore.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation AppDelegate
{
    APIViewController *api_obj;
    UIImageView *imgv;
}
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions


{
    
    
    

    
    
    splash=0;
    [Fabric with:@[[Crashlytics class]]];
    // TODO: Move this to where you establish a user session
    [self logUser];

    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    //[Fabric with:@[[AWSCognito class], [Crashlytics class]]];

    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    AWSStaticCredentialsProvider *credentialsProvider = [AWSStaticCredentialsProvider credentialsWithAccessKey:@"AKIAIMAEIS6NY63AG64Q" secretKey:@"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"];
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionEUWest1 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
//    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
//                                                          initWithRegionType:AWSRegionEUWest1
//                                                          identityPoolId:@"eu-west-1:4654bab6-c14d-43e2-97b7-13ebe1236385"];
//    
//    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUWest1 credentialsProvider:credentialsProvider];
//    
//    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
//NSString *cognitoId = credentialsProvider.identityId;
//    NSLog(@"%@",cognitoId);


    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    
    
    NSArray *pathss = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathss objectAtIndex:0];
    NSURL *pathURL= [NSURL fileURLWithPath:documentsDirectory];
    [self addSkipBackupAttributeToFolder:pathURL];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSArray *documents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
    NSURL *URL;
    NSString *completeFilePath;
    for (NSString *file in documents) {
        completeFilePath = [NSString stringWithFormat:@"%@/%@", basePath, file];
        URL = [NSURL fileURLWithPath:completeFilePath];
        NSLog(@"File %@  is excluded from backup %@", file, [URL resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsExcludedFromBackupKey] error:nil]);
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    NSLog(@"%f",[ [ UIScreen mainScreen ] bounds ].size.height);
    if([ [ UIScreen mainScreen ] bounds ].size.height>=736.0)
    {
        //iphone5=true;
        iphone6p=true;
        
    }
    else if([ [ UIScreen mainScreen ] bounds ].size.height>=667.0)
    {
        //iphone5=true;
        iphone6=true;
    }
    else if( [ [ UIScreen mainScreen ] bounds ].size.height>=568.0)
    {
        iphone5=true;
    }
    else if([ [ UIScreen mainScreen ] bounds ].size.height>=480.0)
    {
        iphone4=true;
    }
    else
    {
        iphone5=true;
    }

 
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications]; // you can also set here for local notification.
    } else {
        
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [userDefault setObject:currentAppVersion forKey:@"version"];
    [userDefault synchronize];

    NSString *previousVersion = [userDefault objectForKey:@"version"];
    if(!previousVersion)
    {
        [userDefault setObject:currentAppVersion forKey:@"version"];
        [userDefault synchronize];
        
        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
        userid = [NSString stringWithFormat:@"%@",[userDefaults1 objectForKey:@"userid"]];
        
        
        
        if(userid == (id)[NSNull null]|| userid.length == 0  || [userid isEqual:@"(null)"])
        {
            onBordingViewController *mvc;
            if(iphone4)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@6p" bundle:nil];
            }
            
            
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
            self.window.rootViewController=nav;
        }
        else
        {
            tabbarViewController *mvc;
            mvc=[[tabbarViewController alloc]init];
            AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
            nav.navigationBarHidden=YES;
            testAppDelegate.window.rootViewController=nav;
            
        }

    }
     else if (![previousVersion isEqualToString:@"1.11"]) {
        //Different version
        UpdateViewController *mvc;
        if(iphone4)
        {
            mvc=[[UpdateViewController alloc]initWithNibName:@"UpdateViewController@4" bundle:nil];
        }
        else if(iphone5)
        {
            mvc=[[UpdateViewController alloc]initWithNibName:@"UpdateViewController" bundle:nil];
        }
        else if(iphone6)
        {
            mvc=[[UpdateViewController alloc]initWithNibName:@"UpdateViewController@6" bundle:nil];
        }
        else if(iphone6p)
        {
            mvc=[[UpdateViewController alloc]initWithNibName:@"UpdateViewController@6p" bundle:nil];
        }
        
        
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
        self.window.rootViewController=nav;
    }  else {
        
        [userDefault setObject:currentAppVersion forKey:@"version"];
        [userDefault synchronize];
        
        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
        userid = [NSString stringWithFormat:@"%@",[userDefaults1 objectForKey:@"userid"]];
        
        
        
        if(userid == (id)[NSNull null]|| userid.length == 0  || [userid isEqual:@"(null)"])
        {
            onBordingViewController *mvc;
            if(iphone4)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@6p" bundle:nil];
            }
            
            
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
            self.window.rootViewController=nav;
        }
        else
        {
            tabbarViewController *mvc;
            mvc=[[tabbarViewController alloc]init];
            AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
            nav.navigationBarHidden=YES;
            testAppDelegate.window.rootViewController=nav;
            
        }

   
        
    }

   
    
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)GetAppSettingsResult:(NSDictionary*)dict_Response
{
//    WEBURL=[NSString stringWithFormat:@"%@WCFServices/UserServices.svc",[dict_Response valueForKey:@"BASEURL_PROD"]];
//    appUrl=[NSString stringWithFormat:@"%@WCFServices",[dict_Response valueForKey:@"BASEURL_PROD"]];
//    WEBURL1=[NSString stringWithFormat:@"%@WCFServices/Post.svc",[dict_Response valueForKey:@"BASEURL_PROD"]];
//    CONNECTURL=[NSString stringWithFormat:@"%@WCFServices/Connects.svc",[dict_Response valueForKey:@"BASEURL_PROD"]];
//    appUrlThumb=[NSString stringWithFormat:@"%@",[dict_Response valueForKey:@"BASEURL_PROD"]];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if([[userDefault valueForKey:@"version"] isEqual:nil] || [[userDefault valueForKey:@"version"] isEqual:[NSNull null]])
    {
        [userDefault setValue:[dict_Response valueForKey:@"VERSION_NO"] forKey:@"version"];
        
        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
        userid = [NSString stringWithFormat:@"%@",[userDefaults1 objectForKey:@"userid"]];
        
        
        
        if(userid == (id)[NSNull null]|| userid.length == 0  || [userid isEqual:@"(null)"])
        {
            onBordingViewController *mvc;
            if(iphone4)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@4" bundle:nil];
            }
            else if(iphone5)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController" bundle:nil];
            }
            else if(iphone6)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@6" bundle:nil];
            }
            else if(iphone6p)
            {
                mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@6p" bundle:nil];
            }
            
            
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
            self.window.rootViewController=nav;
        }
        else
        {
            tabbarViewController *mvc;
            mvc=[[tabbarViewController alloc]init];
            AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
            nav.navigationBarHidden=YES;
            testAppDelegate.window.rootViewController=nav;
            
        }

        
        
    }
    else
    {
        if([[dict_Response valueForKey:@"VERSION_NO"] isEqualToString:[userDefault valueForKey:@"version"]])
        {
            NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
            userid = [NSString stringWithFormat:@"%@",[userDefaults1 objectForKey:@"userid"]];
            
            
            
            if(userid == (id)[NSNull null]|| userid.length == 0  || [userid isEqual:@"(null)"])
            {
                onBordingViewController *mvc;
                if(iphone4)
                {
                    mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@4" bundle:nil];
                }
                else if(iphone5)
                {
                    mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController" bundle:nil];
                }
                else if(iphone6)
                {
                    mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@6" bundle:nil];
                }
                else if(iphone6p)
                {
                    mvc=[[onBordingViewController alloc]initWithNibName:@"onBordingViewController@6p" bundle:nil];
                }
                
                
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
                self.window.rootViewController=nav;
            }
            else
            {
                tabbarViewController *mvc;
                mvc=[[tabbarViewController alloc]init];
                AppDelegate *testAppDelegate = [UIApplication sharedApplication].delegate;
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mvc];
                nav.navigationBarHidden=YES;
                testAppDelegate.window.rootViewController=nav;
                
            }

        }
        else
        {
            
        }
    }
    
}
- (void) addSkipBackupAttributeToFolder:(NSURL*)folder
{
    [self addSkipBackupAttributeToItemAtURL:folder];
    
    NSError* error = nil;
    NSArray* folderContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[folder path] error:&error];
    
    for (NSString* item in folderContent)
    {
        NSString* path = [folder.path stringByAppendingPathComponent:item];
        [self addSkipBackupAttributeToFolder:[NSURL fileURLWithPath:path]];
    }
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    api_obj=[[APIViewController alloc]init];
    [api_obj ClearBadgeCount:self];
    if([screenName isEqualToString:@"home"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:self];
    }
    else if([screenName isEqualToString:@"post"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"post" object:self];
    }
    else if([screenName isEqualToString:@"nearby"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"nearby" object:self];
    }
    else if([screenName isEqualToString:@"hashtag"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hashtag" object:self];
    }
    else if([screenName isEqualToString:@"profile"])
    {
        
    }
    else if([screenName isEqualToString:@"otherprofile"])
    {
        
    }
    else if([screenName isEqualToString:@"liked"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"liked" object:self];
    }
    else if([screenName isEqualToString:@"directinner"])
    {
        
    }
    else {
        
        
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL) needsUpdate{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            return YES;
        }
    }
    return NO;
}

+(NSString*)HourCalculation:(NSString*)PostDate

{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[PostDate integerValue]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormat setTimeZone:gmt];
    NSDate *ExpDate = date;//[dateFormat dateFromString:PostDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit|NSWeekCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:ExpDate toDate:[NSDate date] options:0];
    NSString *time;
    if(components.year!=0)
    {
        if(components.year==1)
        {
            time=[NSString stringWithFormat:@"%ldy",(long)components.year];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ldy",(long)components.year];
        }
    }
    else if(components.month!=0)
    {
        if(components.month==1)
        {
            time=[NSString stringWithFormat:@"%ldM",(long)components.month];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ldM",(long)components.month];
        }
    }
    else if(components.week!=0)
    {
        if(components.week==1)
        {
            time=[NSString stringWithFormat:@"%ldw",(long)components.week];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ldw",(long)components.week];
        }
    }
    else if(components.day!=0)
    {
        if(components.day==1)
        {
            time=[NSString stringWithFormat:@"%ldd",(long)components.day];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ldd",(long)components.day];
        }
    }
    else if(components.hour!=0)
    {
        if(components.hour==1)
        {
            time=[NSString stringWithFormat:@"%ldh",(long)components.hour];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ldh",(long)components.hour];
        }
    }
    else if(components.minute!=0)
    {
        if(components.minute==1)
        {
            time=[NSString stringWithFormat:@"%ldm",(long)components.minute];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ldm",(long)components.minute];
        }
    }
    else if(components.second>=0)
    {
        if(components.second==0)
        {
            time=[NSString stringWithFormat:@"1s"];
        }
        else
        {
            time=[NSString stringWithFormat:@"%lds",(long)components.second];
        }
    }
    return [NSString stringWithFormat:@"%@",time];
}
- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"livelyMod" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"livelyMod.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark PUSH NOTIFICATION

#pragma mark - Remote notifications handling
//Push Notification
-(void)handleRemoteNotifications:(NSDictionary *)userInfo
{
    notificationscren=1;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationRedirect" object:self];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    
    NSString *deviceToken = [[[[token description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"device token = %@", deviceToken);
    device_id=deviceToken;

    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"PN REG Failed" message:err.description delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    alertView.tag = 11;
    [alertView show];
    
    NSString *str1 = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str1);

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //Receiving Of Remote Notification
    NSLog(@"Remote Notification Received: %@", userInfo);
    //    application.applicationIconBadgeNumber = 0;
    
    for (id key in userInfo)
    {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    notificationscren=1;

    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = userInfo[@"aps"];
    
    NSString *alert = apsInfo[@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    
    NSString *sound = apsInfo[@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    
    NSString *badge = apsInfo[@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[badge intValue]];
    
    NSString *jsonString  = apsInfo[@"category"];
    NSLog(@"Received Push category: %@", jsonString);
    
    [self handleRemoteNotifications:userInfo];
    
    
    

    
}
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    /*
     Store the completion handler.
     */
    [AWSS3TransferUtility interceptApplication:application
           handleEventsForBackgroundURLSession:identifier
                             completionHandler:completionHandler];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}
- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"user@fabric.io"];
    [CrashlyticsKit setUserName:@"Test User"];
}

@end
