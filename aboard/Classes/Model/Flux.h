//
//  Flux.h
//  aboard
//
//  Created by Olivier Medina on 05/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flux : NSObject

@property (nonatomic, copy) NSString *feed;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *image;



@end
