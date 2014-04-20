//
//  SiteDelegate.h
//  aboard
//
//  Created by Olivier Medina on 05/12/13.
//  Copyright (c) 2013 Olivier Medina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sites;

@protocol SiteDelegate <NSObject>

//Méthode de callback pour retourner le jeu créé ou trouvé
- (void)didLoadSites:(Sites *)site;

@end
