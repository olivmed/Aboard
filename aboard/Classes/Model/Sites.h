//
//  Sites.h
//  aboard
//
//  Created by Olivier Medina on 05/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sites : NSObject


@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSURL *feed;
@property (nonatomic, copy) NSString *online;
@property (nonatomic, copy) NSString *status;


@end
