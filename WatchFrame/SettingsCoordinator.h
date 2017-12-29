//
//  SettingsCoordinator.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>
#import "WatchCases.h"
#import "SettingsCoordinatorProtocols.h"
#import "SettingsViewControllerProtocols.h"

@interface SettingsCoordinator : NSObject <
    SettingsViewControllerDelegate,
    SKProductsRequestDelegate,
    SKPaymentTransactionObserver
    >

@property (nonatomic, retain) id <SettingsCoordinatorProtocols> delegate;
@property (nonatomic, retain) UIViewController *rootViewController;

- (void)start;

@end
