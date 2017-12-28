//
//  SettingsCoordinatorProtocols.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WatchCases.h"

@protocol SettingsCoordinatorProtocols <NSObject>

- (void)settingsCoordinatorDidRequestCancel:(NSObject *)coordinator;
- (void)settingsCoordinator:(NSObject *)coordinator didSelectNewWatchCase:(kWatchCase)watchCase;

@end
