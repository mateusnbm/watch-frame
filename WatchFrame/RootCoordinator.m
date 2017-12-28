//
//  RootCoordinator.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "RootCoordinator.h"
#import "RootViewController.h"
#import "SettingsCoordinator.h"

@interface RootCoordinator ()

@property (nonatomic, retain) NSMutableArray *childCoordinators;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

@implementation RootCoordinator

#pragma mark -
#pragma mark - Lifecycle

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.childCoordinators = [[NSMutableArray alloc] init];
        
    }
    
    return self;
    
}

#pragma mark -
#pragma mark - Public

- (void)start {
    
    RootViewController *con = [[RootViewController alloc] init];
    con.delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:con];
    self.rootViewController = self.navigationController;
    
}

#pragma mark -
#pragma mark - RootViewControllerDelegate

- (void)rootViewControllerDidTapSettings {
    
    SettingsCoordinator *coordinator = [[SettingsCoordinator alloc] init];
    coordinator.delegate = self;
    [coordinator start];
    [self.childCoordinators addObject:coordinator];
    [self.rootViewController presentViewController:coordinator.rootViewController animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark - SettingsCoordinatorProtocol

- (void)settingsCoordinatorDidRequestCancel:(NSObject *)coordinator {
    
    [self.childCoordinators removeObject:coordinator];
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)settingsCoordinator:(NSObject *)coordinator didSelectNewWatchCase:(kWatchCase)watchCase {
    
    RootViewController *con = (RootViewController *) self.navigationController.viewControllers.firstObject;
    
    [con changeWatchCase:watchCase];
    
}

@end
