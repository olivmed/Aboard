//
//  SidebarViewController.h
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteDelegate.h"

@interface SidebarViewController : UITableViewController <SiteDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, weak) id<SiteDelegate> delegate;
//@property (strong,nonatomic) NSMutableArray *filteredFeedsArray;
@property IBOutlet UISearchBar *feedsSearchBar;

@end
