//
//  SitesCell.h
//  aboard
//
//  Created by Olivier Medina on 05/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sites;

@interface SitesCell : UITableViewCell

- (void)refreshWithSite:(Sites *)DSite;

@end
