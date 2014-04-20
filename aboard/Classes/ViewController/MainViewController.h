//
//  MainViewController.h
//  aboard
//
//  Created by Olivier Medina on 02/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SidebarButton;
@property (nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIImageView *Loader;
@property (weak, nonatomic) IBOutlet UIView *LoaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *LoaderElement;

-(IBAction)goToLink:(id)sender;


@end

