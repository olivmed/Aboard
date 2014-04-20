//
//  SitesCell.m
//  aboard
//
//  Created by Olivier Medina on 05/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//

#import "SitesCell.h"
#import "Sites.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+Resize.h"

@interface SitesCell ()
@property (weak, nonatomic) IBOutlet UIImageView *favImageView;
@property (weak, nonatomic) IBOutlet UILabel *SiteName;



@end

@implementation SitesCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)refreshWithSite:(Sites *)DSite{
    NSURL *urlFormated = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=%@",[DSite url]]];
    [_favImageView setImageWithURL:urlFormated];
    [_SiteName setText:[DSite name]];
   
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
