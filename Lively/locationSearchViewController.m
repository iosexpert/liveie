//
//  locationSearchViewController.m
//
//
//  Created by Brahmasys on 03/12/15.
//
//

#import "locationSearchViewController.h"
#import "APIViewController.h"
#import "LoaderViewController.h"
#import "AGPushNoteView.h"
#define kGooglePlacesAPIBrowserKey2 @"AIzaSyD-Wqu3mbLcb2sRM_coKvjHzv-KRwFOpHo"
@interface locationSearchViewController ()
{
    NSString *completeURL ;
    APIViewController *api_obj;
    
    BOOL isSearching;
    NSMutableData *receivedData;
    NSMutableArray *arSrResultArray;
    NSMutableArray *arrGeometry,*arrLocation,*arrSorted,*arrMain,*arrNotSorted,*arrCheck,*arrFinal;
    NSInteger searchStatus;
}
@end

@implementation locationSearchViewController

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
-(IBAction)doneButton:(id)sender
{
    
}
- (void)viewDidLoad {
    arrNearPlaces=[_arrLoc mutableCopy];
    [tablv reloadData];
    [super viewDidLoad];
    isSearching=false;
    UITabBarController *bar = [self tabBarController];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        //iOS 7 - hide by property
        NSLog(@"iOS 7");
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        bar.tabBar.hidden = YES;
    }

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Google API for searching places
-(void) getSearchResults:(NSString *)searchText
{
    
    
    api_obj=[[APIViewController alloc]init];
    [api_obj searchNearesttext:@selector(searchNearesttextResult:) tempTarget:self : lat : lng :serchb.text];
    
}
-(void)searchNearesttextResult:(NSDictionary *)dict_Response
{
    NSLog(@"%@",dict_Response);
    [LoaderViewController remove:self.view animated:YES];
    
    
    
    if (dict_Response==NULL)
    {
     [AGPushNoteView showWithNotificationMessage:@"Re-establising lost connection"];
    }
    else
    {
        
        arrFinal = [[[dict_Response objectForKey:@"response"] valueForKey:@"venues"]mutableCopy];;
        [tablv reloadData];
    
    }
}
#pragma mark Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    if(section==0)
    {
        sectionName=@"Near By Places";
    }
    return sectionName;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor grayColor]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearching)
    {
        return [arrFinal count];
    }
    else
    {
        return [arrNearPlaces count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if(isSearching)
    {
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame = CGRectMake (25, 20, 280, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        NSMutableDictionary *dict=[arrFinal objectAtIndex:indexPath.row];
        [label setText:[dict valueForKey:@"name"]];

        [cell addSubview:label];

        
    }
    else
    {
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame = CGRectMake (25, 20, 280, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        NSMutableDictionary *dict=[arrNearPlaces objectAtIndex:indexPath.row];
        [label setText:[dict valueForKey:@"name"]];
        [cell addSubview:label];
        

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSearching)
    {
        NSMutableDictionary *dict=[arrFinal objectAtIndex:indexPath.row];
     locationToSend=[dict valueForKey:@"name"];
    }
    else
    {
        NSMutableDictionary *dict=[arrNearPlaces objectAtIndex:indexPath.row];
        
        locationToSend=[dict valueForKey:@"name"];
//        NSMutableDictionary *dict=[arrNearPlaces objectAtIndex:indexPath.row];
//
//        locationToSend=[dict valueForKey:@"name"];
    }
    [self.navigationController popViewControllerAnimated:YES];
        
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [serchb resignFirstResponder];
    [searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    
    
    if(searchText.length == 0)
    {
        [searchBar resignFirstResponder];
        isSearching=false;
        [tablv reloadData];
    }
    else
    {
        isSearching=YES;
        [self  getSearchResults:searchText];
        
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.text=@"";
    isSearching=false;
    
    [tablv reloadData];
    [searchBar resignFirstResponder];
    
    
}
-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [serchb resignFirstResponder];
 
}

@end
