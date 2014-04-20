//
//  SitesDelegate.h
//  aboard
//
//  Created by Olivier Medina on 05/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//



#import <Foundation/Foundation.h>

@class Sites;

@protocol SitesDelegate <NSObject>

//Méthode de callback pour retourner le site trouvé
- (void)IsSetSite:(Sites *)sites;

@end




