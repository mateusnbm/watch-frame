//
//  AppCoordinator.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "AppCoordinator.h"
#import "RootCoordinator.h"

@interface AppCoordinator ()

@property (nonatomic, retain) NSMutableArray *childCoordinators;

@end

@implementation AppCoordinator

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
    
    RootCoordinator *coordinator = [[RootCoordinator alloc] init];
    [coordinator start];
    [self.childCoordinators addObject:coordinator];
    self.rootViewController = coordinator.rootViewController;
    
}

@end
