//
//  FluxCell.m
//  aboard
//
//  Created by Olivier Medina on 06/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//

#import "FluxCell.h"
#import "Flux.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+Resize.h"

@interface FluxCell ()


@property (weak, nonatomic) IBOutlet UIImageView *ImageViewCell;

@property (weak, nonatomic) IBOutlet UIImageView *WhiteShadow;
@property (weak, nonatomic) IBOutlet UIImageView *GreyBar;
@property (weak, nonatomic) IBOutlet UILabel *LabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *LabelDate;
@property (weak, nonatomic) IBOutlet UILabel *LabelSep;
@property (weak, nonatomic) IBOutlet UILabel *LabelSiteName;
@property (weak, nonatomic) IBOutlet UIButton *buttonExt;
@property (weak, nonatomic) IBOutlet UIImageView *imgLink;

@property (nonatomic, strong) NSCache *cacheImage;

@end


@implementation FluxCell




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cacheImage = [[NSCache alloc] init];
    }
    return self;
}

- (void)prepareForReuse {
    [_ImageViewCell cancelImageRequestOperation];
    [_ImageViewCell setImage:nil];
}

- (void)refreshWithFlux:(Flux *)DFlux{
    
    if ([[DFlux image]isEqualToString:@"not-found.png"]) {
        _ImageViewCell.image = [UIImage imageNamed:[DFlux image]];
    }else
    {
        [_ImageViewCell setImageWithURL:[NSURL URLWithString:[DFlux image]]];
    }
}

-(void)ShowDetails:(Flux *)DFlux{
    
    
    
   /* NSString *newString = [[DFlux date] substringToIndex:[[DFlux date] length]-3];
    
    NSString * timeStampString = newString;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"MMM dd"];
    NSString *_date=[_formatter stringFromDate:date];*/
    
    NSDateFormatter *FormatedDate = [[NSDateFormatter alloc]init];
    [FormatedDate setDateFormat:@"MMM dd"];
    
    _LabelDate.text = [FormatedDate stringFromDate:[DFlux date]];
    _LabelSiteName.text = [DFlux source];
    _LabelTitle.text = [DFlux title];
   
    
    _WhiteShadow.hidden = NO;
    _GreyBar.hidden = NO;
    _LabelDate.hidden = NO;
    _LabelSep.hidden = NO;
    _LabelSiteName.hidden = NO;
    _LabelTitle.hidden = NO;
    _buttonExt.hidden = NO;
    _imgLink.hidden = NO;
}

-(void)HideDetails:(Flux *)DFlux{
    
    
    _WhiteShadow.hidden = YES;
    _GreyBar.hidden = YES;
    _LabelDate.hidden = YES;
    _LabelSep.hidden = YES;
    _LabelSiteName.hidden = YES;
    _LabelTitle.hidden = YES;
    _buttonExt.hidden = YES;
    _imgLink.hidden = YES;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)GoToLink:(Flux *)DFlux {
    Flux *url = [[Flux alloc]init];
    NSString *urlString = [url url];
    NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
}
@end
