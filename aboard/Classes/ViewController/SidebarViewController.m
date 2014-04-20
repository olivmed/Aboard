//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import <AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Sites.h"
#import "SitesCell.h"
#import "MainViewController.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSMutableArray *menuItems;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SidebarViewController

static NSString * const cellIdentifier = @"SiteCell";

NSMutableArray *DataOfSites_;
NSMutableArray *SavedListFlux;
@synthesize feedsSearchBar;
NSMutableArray *filteredFeedsArray;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    return self;
}

- (void)viewDidLoad
{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
    
    //self.edgesForExtendedLayout=UIRectEdgeNone;
    //self.extendedLayoutIncludesOpaqueBars=NO;
    //self.automaticallyAdjustsScrollViewInsets=NO;
    
    [super viewDidLoad];
    [self.tableView setContentOffset:CGPointMake(0, -10)];


   /* NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];*/
    
    //******************** Initialisations ***********************
    
    //Get user saved datas
    NSUserDefaults *GetSavedData = [NSUserDefaults standardUserDefaults];

    
    if ([NSKeyedUnarchiver unarchiveObjectWithData:[GetSavedData objectForKey:@"Flux"]]) {
        SavedListFlux = [NSKeyedUnarchiver unarchiveObjectWithData:[GetSavedData objectForKey:@"Flux"]];

    }else{
        SavedListFlux = [[NSMutableArray alloc]init];
    }
    
    _menuItems = [[NSMutableArray alloc]init];
    DataOfSites_ = [[NSMutableArray alloc]init];
    
    // Connexion
    NSURL *URL = [NSURL URLWithString:@"https://spreadsheets.google.com/feeds/list/0AnqTdoRZw_IRdHctX2RyQncwRVA0eWZsSERsdUxOT0E/od6/public/basic?alt=json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFJSONResponseSerializer *responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [responseSerializer setStringEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setResponseSerializer:responseSerializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *feed = [responseObject objectForKey:@"feed"];
        NSDictionary *entry = [feed objectForKey:@"entry"];
        
        for (NSDictionary *elements in entry) {
            
            Sites *DataOfSites = [[Sites alloc] init];
            NSDictionary *content = [elements objectForKey:@"content"];
            NSDictionary *title = [elements objectForKey:@"title"];
            NSString *FinalContent = [content objectForKey:@"$t"];
            NSArray *stringArray = [FinalContent componentsSeparatedByString:@","];
            [DataOfSites setIdentifier:[title objectForKey:@"$t"]];
            [DataOfSites setName:[stringArray[0] substringFromIndex:6]];
            [DataOfSites setTags:[stringArray[1] substringFromIndex:7]];
            [DataOfSites setUrl:[NSURL URLWithString:[stringArray[2] substringFromIndex:6]]];
            [DataOfSites setFeed:[NSURL URLWithString:[stringArray[3] substringFromIndex:7]]];
            [DataOfSites setOnline:[stringArray[4] substringFromIndex:9]];
            [DataOfSites setStatus:[stringArray[5] substringFromIndex:9]];
            
           
            
            [DataOfSites_ addObject:DataOfSites];

        }
        

        [_myTableView reloadData];
    
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    filteredFeedsArray = [NSMutableArray arrayWithCapacity:[DataOfSites_ count]];

    


}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredFeedsArray count];
    } else {
        return [DataOfSites_ count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     SitesCell *cell = (SitesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setBackgroundColor:[UIColor blackColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [tableView setSeparatorStyle:NO];
    [tableView setBackgroundColor:[UIColor blackColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    Sites *site = [[Sites alloc]init];
    
    if (cell == nil) {
        cell = [[SitesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        site = [filteredFeedsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = site.name;

    } else {
        site = [DataOfSites_ objectAtIndex:indexPath.row];
        [cell refreshWithSite:site];
    }

        if ([SavedListFlux  containsObject:[NSArray arrayWithObjects:[site name],[site identifier], [site feed], nil]] || [filteredFeedsArray  containsObject:[NSArray arrayWithObjects:[site name],[site identifier], [site feed], nil]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    return cell;
     
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return @"FEEDS                 *mature content";
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *SelectedFlux = [NSUserDefaults standardUserDefaults];

    SitesCell *cell = (SitesCell *)[aTableView cellForRowAtIndexPath:indexPath];
   // MainViewController *mainController = ((UICollectionView *)self. .centerController).visibleViewController.navigationController.viewControllers[0];
    Sites *CellState = [DataOfSites_ objectAtIndex:[indexPath row]];

    if (aTableView == self.searchDisplayController.searchResultsTableView) {
         CellState = [filteredFeedsArray objectAtIndex:[indexPath row]];
    }
    
    if ([SavedListFlux  containsObject:[NSArray arrayWithObjects:[CellState name],[CellState identifier], [CellState feed], nil]]) {
        [SavedListFlux removeObject:[ NSArray arrayWithObjects:[CellState name],[CellState identifier], [CellState feed], nil] ];
        if (aTableView == self.searchDisplayController.searchResultsTableView) {
            cell.accessoryType = UITableViewCellAccessoryNone;

        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:SavedListFlux];
        
        [SelectedFlux setObject:data forKey:@"Flux"];
        
        [SelectedFlux synchronize];
        [_myTableView reloadData];
      //  [main.collectionView setNeedsDisplay];
        
    }else{
        [SavedListFlux addObject:[ NSArray arrayWithObjects:[CellState name],[CellState identifier], [CellState feed], nil] ];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:SavedListFlux];
        if (aTableView == self.searchDisplayController.searchResultsTableView) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;

        }
        
        [SelectedFlux setObject:data forKey:@"Flux"];
        
        [SelectedFlux synchronize];
        
        [_myTableView reloadData];

       // [main.collectionView vi];

    }
}

- (void)didLoadSites:(Sites *)site {
    [DataOfSites_ addObject:site];
    [[self tableView] reloadData];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [filteredFeedsArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.tags contains[c] %@ || SELF.name contains[c] %@",searchText, searchText];
    filteredFeedsArray = [NSMutableArray arrayWithArray:[DataOfSites_ filteredArrayUsingPredicate:predicate]];
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    self.searchDisplayController.searchBar.showsCancelButton = YES;
    UIButton *cancelButton;
    UIView *topView = self.searchDisplayController.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        [cancelButton setTitle:@"Finish" forState:UIControlStateNormal];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
