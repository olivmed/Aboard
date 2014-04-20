//
//  NSArray+Extras.h
//  aboard
//
//  Created by Olivier Medina on 11/03/2014.
//  Copyright (c) 2014 Olivier Medina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extras)

typedef NSInteger (^compareBlock)(id a, id b);

-(NSUInteger)indexForInsertingObject:(id)anObject sortedUsingBlock:(compareBlock)compare;

@end

