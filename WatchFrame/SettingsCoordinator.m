//
//  SettingsCoordinator.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "SettingsCoordinator.h"
#import "SettingsViewController.h"

@interface SettingsCoordinator ()

@property (nonatomic, retain) UINavigationController *navigationController;

@end

@implementation SettingsCoordinator

- (void)start {
    
    SettingsViewController *con = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    con.delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:con];
    self.rootViewController = self.navigationController;
    
}

#pragma mark -
#pragma mark - SettingsViewControllerDelegate

- (void)settingsViewControllerDidTapDone {
    
    if ([self.delegate respondsToSelector:@selector(settingsCoordinatorDidRequestCancel:)]) {
        
        [self.delegate settingsCoordinatorDidRequestCancel:self];
        
    }
    
}

- (void)settingsViewControllerDidSelectNewWatchCase:(kWatchCase)watchCase {
    
    if ([self.delegate respondsToSelector:@selector(settingsCoordinator:didSelectNewWatchCase:)]) {
        
        [self.delegate settingsCoordinator:self didSelectNewWatchCase:watchCase];
        
    }
    
}

@end
