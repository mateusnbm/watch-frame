//
//  RootCoordinator.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RootViewControllerProtocols.h"
#import "SettingsCoordinatorProtocols.h"

@interface RootCoordinator : NSObject <
    RootViewControllerDelegate,
    SettingsCoordinatorProtocols
    >

@property (nonatomic, retain) UIViewController *rootViewController;

- (void)start;

@end
