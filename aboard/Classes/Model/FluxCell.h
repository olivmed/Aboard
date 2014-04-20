//
//  FluxCell.h
//  aboard
//
//  Created by Olivier Medina on 06/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flux;

@interface FluxCell : UICollectionViewCell

- (void)refreshWithFlux:(Flux *)DFlux;

- (void)ShowDetails:(Flux *)DFlux;
- (void)HideDetails:(Flux *)DFlux;


@end
