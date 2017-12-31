//
//  RootCoordinator.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "RootCoordinator.h"
#import "WatchCases.h"
#import "RootViewController.h"
#import "SettingsCoordinator.h"

@interface RootCoordinator ()

@property (nonatomic) kWatchCase selectedCase;

@property (nonatomic, retain) NSMutableArray *childCoordinators;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

@implementation RootCoordinator

#pragma mark -
#pragma mark - Lifecycle

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.selectedCase = kWatchCaseGoldAluminum;
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
    coordinator.selectedCase = self.selectedCase;
    coordinator.delegate = self;
    [coordinator start];
    [self.childCoordinators addObject:coordinator];
    [self.rootViewController presentViewController:coordinator.rootViewController animated:YES completion:nil];
    
}

- (void)rootViewControllerDidTapImageSelection {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark - SettingsCoordinatorProtocol

- (void)settingsCoordinatorDidRequestCancel:(NSObject *)coordinator {
    
    [self.childCoordinators removeObject:coordinator];
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)settingsCoordinator:(NSObject *)coordinator didSelectNewWatchCase:(kWatchCase)watchCase {
    
    self.selectedCase = watchCase;
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    RootViewController *viewController = (RootViewController *) viewControllers.firstObject;
    [viewController didChangeWatchCase:watchCase];
    
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    RootViewController *con = (RootViewController *) self.navigationController.viewControllers.firstObject;
    [con didChangeImageSelection:image];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
