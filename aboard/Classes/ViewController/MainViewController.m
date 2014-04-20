//
//  MainViewController.m
//  aboard
//
//  Created by Olivier Medina on 02/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import <AFNetworking.h>
#import "CellViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Flux.h"
#import "FluxCell.h"
#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray *HomeBoard;
@property (strong, nonatomic) IBOutlet UICollectionView *TimelineCollectionView;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property (nonatomic, strong) NSString *urlButton;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavItem;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *itemArray;

- (IBAction)refresh:(id)sender;
- (void) getSiteJson:(NSURL *)url;

@end

@implementation MainViewController

NSMutableArray *DataOfFlux_;
NSMutableArray *SavedListFlux;
NSMutableArray *cellSelected;
NSMutableArray *dataArray;
NSMutableArray *pickerViewArray;

NSURL *site;
int indice = 0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = FALSE;
    _pickerView.backgroundColor = [UIColor clearColor];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [_pickerView setTransform:rotate];
    [_pickerView setFrame:CGRectMake(0, 0, 320, 162.0)];
   
    


    // Add swipeGestures
    //    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];

    NSUserDefaults *GetSavedData = [NSUserDefaults standardUserDefaults];
    
    if ([NSKeyedUnarchiver unarchiveObjectWithData:[GetSavedData objectForKey:@"Flux"]]) {
        SavedListFlux = [NSKeyedUnarchiver unarchiveObjectWithData:[GetSavedData objectForKey:@"Flux"]];

        
    }else{
        SavedListFlux = [[NSMutableArray alloc]init];

    }
    
    cellSelected = [[NSMutableArray alloc]init];
    site = [[NSURL alloc]init];
	// Do any additional setup after loading the view.
    _HomeBoard = [[NSMutableArray alloc]init];
 
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _SidebarButton.width = 20;
    _SidebarButton.target = self.revealViewController;
    _SidebarButton.action = @selector(revealToggle:);
    self.LoaderView.hidden = NO;
    [self.LoaderElement startAnimating];
    
    if([SavedListFlux count] == 1)
    {
        site =  [[SavedListFlux objectAtIndex:0]objectAtIndex:2];
        self.NavItem.title = [[SavedListFlux objectAtIndex:0]objectAtIndex:0];
        [self getSiteJson:site];

    }else if ([SavedListFlux count] > 1) {
       
        pickerViewArray = [[NSMutableArray alloc] initWithObjects:@"All", nil];
        for (int i = 0; i<[SavedListFlux count]; i++)
        {
            site =  [[SavedListFlux objectAtIndex:i]objectAtIndex:2];
            [pickerViewArray  addObject:[[SavedListFlux objectAtIndex:i]objectAtIndex:0]];
            [self getSiteJson:site];
        }
        [self.navigationController.navigationBar.topItem setTitleView:_pickerView];


    }else{
        site = [NSURL URLWithString:@"http://dribbble.com/shots/popular.rss"];
       self.NavItem.title = @"Dribbble Popular";
        [self getSiteJson:site];

    }
    //nslog
    
    
    
   
    
    

}

-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        [self refresh:self];
        indice = (int)row;


    }else{
    [self getSiteJson:[[SavedListFlux objectAtIndex:row-1]objectAtIndex:2]];
        indice = (int)row-1;

    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    [[_pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[_pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    return [SavedListFlux count]+1;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CGRect rect = CGRectMake(0, 0, 320, 40);
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [label setTransform:rotate];
    label.text = [pickerViewArray objectAtIndex:row];
    label.font = [UIFont systemFontOfSize:31.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 1;
    label.backgroundColor = [UIColor clearColor];
    label.clipsToBounds = YES;
    
    return label ;
}



-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 120;
}


-(void)getSiteJson:(NSURL *)url
{

    
    DataOfFlux_ = [[NSMutableArray alloc]init];
    
    // Set the gesture
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/feed/load?v=2.0&num=100&q=%@",url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //application/javascript
    
    AFJSONResponseSerializer *responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/javascript"]];
    [responseSerializer setStringEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setResponseSerializer:responseSerializer];
    
    
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *allDataDictionary = [responseObject objectForKey:@"responseData"];
        NSDictionary *feed = [allDataDictionary objectForKey:@"feed"];
        NSDictionary *entries = [feed objectForKey:@"entries"];
    
        for (NSDictionary *elements in entries) {
            
            Flux *DataOfFlux = [[Flux alloc] init];
            
            
            [DataOfFlux setFeed:[elements objectForKey:@"title"]];
            [DataOfFlux setSource:[feed objectForKey:@"link"]];
            [DataOfFlux setTitle:[elements objectForKey:@"title"]];
            [DataOfFlux setAuthor:[elements objectForKey:@"author"]];
            [DataOfFlux setDate:[NSDate dateFromInternetDateTimeString:[elements objectForKey:@"publishedDate"] formatHint:DateFormatHintRFC822]];
            [DataOfFlux setUrl:[elements objectForKey:@"link"]];
            
            NSString *content = [elements objectForKey:@"content"];
            NSArray *imgurl = [content componentsSeparatedByString:@"src=\""];
            if ([imgurl count] > 1) {
                
            NSString *buffer = imgurl[1];
            imgurl = [buffer componentsSeparatedByString:@"\""];
            [DataOfFlux setImage:imgurl[0]];
            }else{
                [DataOfFlux setImage:@"not-found.png"];

            }
            
            
            long insertIdx = [DataOfFlux_ indexForInsertingObject:DataOfFlux sortedUsingBlock:^(id a, id b){
                Flux *entry1 = (Flux *) a;
                Flux *entry2 = (Flux *) b;
                return [entry1.date compare:entry2.date];
            }];
            [DataOfFlux_ insertObject:DataOfFlux atIndex:insertIdx];

            
        }
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view for home data source



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   
        return [DataOfFlux_ count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     */
    static NSString *identifier = @"Cell";
    
    FluxCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    Flux *flux = [DataOfFlux_ objectAtIndex:[indexPath row]];
    [cell refreshWithFlux:flux];

    
    cell.backgroundColor = [UIColor blackColor];
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        [cell ShowDetails:flux];
        _urlButton = flux.url;
    }else{
        [cell HideDetails:flux];

    }
    self.LoaderView.hidden = YES;
    [self.LoaderElement stopAnimating];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //FluxCell *cell = (FluxCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Flux *FluxDet = [DataOfFlux_ objectAtIndex:[indexPath row]];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            self.selectedItemIndexPath = nil;
        }
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        
        self.selectedItemIndexPath = indexPath;
    }
    
    
    [cellSelected removeLastObject];
    [cellSelected addObject:[FluxDet title]];
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];

}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if ([SavedListFlux count] > 1)
    {
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
        {
            if (indice < [SavedListFlux count])
            {
                
                [_pickerView selectRow:indice+1 inComponent:0 animated:YES];
                [self getSiteJson:[[SavedListFlux objectAtIndex:indice]objectAtIndex:2]];
                indice++;
            
            }
        }

        if (sender.direction == UISwipeGestureRecognizerDirectionRight)
        {
            if (indice > 0 ){indice--;}
            if (indice > 0)
            {
                [_pickerView selectRow:indice inComponent:0 animated:YES];
                [self getSiteJson:[[SavedListFlux objectAtIndex:indice-1]objectAtIndex:2]];
            }
            else if (indice == 0)
            {
                [_pickerView selectRow:indice inComponent:0 animated:YES];
                [self refresh:self];
            }
        }

    }
    
}



- (IBAction)refresh:(id)sender {
    if([SavedListFlux count] == 1)
    {
        [self.navigationController.navigationBar.topItem setTitleView:nil];
        site =  [[SavedListFlux objectAtIndex:0]objectAtIndex:2];
        self.NavItem.title = [[SavedListFlux objectAtIndex:0]objectAtIndex:0];
        [self getSiteJson:site];
        
    }else if ([SavedListFlux count] > 1) {
        [self.navigationController.navigationBar.topItem setTitleView:nil];

        pickerViewArray = [[NSMutableArray alloc] initWithObjects:@"All", nil];
        for (int i = 0; i<[SavedListFlux count]; i++)
        {
            site =  [[SavedListFlux objectAtIndex:i]objectAtIndex:2];
            [pickerViewArray  addObject:[[SavedListFlux objectAtIndex:i]objectAtIndex:0]];
            [self getSiteJson:site];
        }
        [self.navigationController.navigationBar.topItem setTitleView:_pickerView];

        
    }else{
        [self.navigationController.navigationBar.topItem setTitleView:nil];
        site = [NSURL URLWithString:@"http://dribbble.com/shots/popular.rss"];
        self.NavItem.title = @"Dribbble Popular";
        [self getSiteJson:site];
        
    }
}

- (IBAction)goToLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_urlButton]];

}


@end
