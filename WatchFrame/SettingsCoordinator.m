//
//  SettingsCoordinator.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/27/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "SettingsCoordinator.h"
#import "SettingsViewController.h"
#import "NSArray+Payments.h"
#import "IAPManager.h"

@interface SettingsCoordinator ()

@property (nonatomic) BOOL purchasedPremiumCases;
@property (nonatomic) BOOL isLoadingInAppPurchases;
@property (nonatomic) BOOL isRestoringInAppPurchases;

@property (nonatomic, retain) SKProduct *product;

@property (nonatomic, retain) NSMutableArray *childCoordinators;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

@implementation SettingsCoordinator

#pragma mark -
#pragma mark - Lifecycle

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.purchasedPremiumCases = NO;
        self.childCoordinators = [[NSMutableArray alloc] init];
        
        NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
        
        [center addObserver:self selector:@selector(transactionFailed) name:kIAPManagerFailedNotification object:nil];
        [center addObserver:self selector:@selector(transactionDeferred) name:kIAPManagerDeferredNotification object:nil];
        [center addObserver:self selector:@selector(purchasedProduct) name:kIAPManagerPurchasedNotification object:nil];
        [center addObserver:self selector:@selector(didEndRestoringPurchases) name:kIAPManagerDidEndRestoringNotification object:nil];
        [center addObserver:self selector:@selector(didFailRestoringPurchases) name:kIAPManagerDidFailRestoringNotification object:nil];
        
    }
    
    return self;
    
}

- (void)dealloc {
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
}

#pragma mark -
#pragma mark - Public

- (void)start {
    
    SettingsViewController *viewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.selectedCase = self.selectedCase;
    viewController.delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.rootViewController = self.navigationController;
    
    IAPManager *manager = IAPManager.sharedInstance;
    NSString *productIdentifier = kIAPProductUnlockPremiumCasesProductIdentifier;
    BOOL purchasedPremiumCases = [manager purchasedProduct:productIdentifier];
    
    if (purchasedPremiumCases == YES) {
        
        self.purchasedPremiumCases = YES;
        
        [viewController unlockPremiumCases];
        [viewController showProductAccessoryLabelWithText:@"Purchased"];
        
    }else{
        
        [self retrieveInAppPurchases];
        
    }
    
}

#pragma mark -
#pragma mark - Private

- (void)showProductPrice:(SKProduct *)product {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = self.product.priceLocale;
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    NSString *formattedPrice = [formatter stringFromNumber:product.price];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) viewControllers.firstObject;
    
    [viewController showProductAccessoryLabelWithText:formattedPrice];
    
}

- (void)unableToRetrieveProducts {
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) viewControllers.firstObject;
    
    [viewController showProductAccessoryLabelWithText:@"Network Error"];
    
}

- (void)retrievedProducts:(NSArray *)products {
    
    NSString *identifier = kIAPProductUnlockPremiumCasesProductIdentifier;
    SKProduct *product = [products productWithIdentifier:identifier];
    
    if (product == nil) {
        
        [self unableToRetrieveProducts];
        
    }else{
        
        self.product = product;
        
        [self showProductPrice:product];
        
    }
    
}

- (void)retrieveInAppPurchases {
    
    if (self.isLoadingInAppPurchases == YES) return;
    
    self.isLoadingInAppPurchases = YES;
    
    [IAPManager.sharedInstance requestProducts:^(BOOL success, NSArray *products) {
        
        if (success == NO) {
            
            [self unableToRetrieveProducts];
            
        }else{
            
            [self retrievedProducts:products];
            
        }
        
        self.isLoadingInAppPurchases = NO;
        
    }];
    
}

#pragma mark -
#pragma mark - IAPManager Observers

- (void)transactionFailed {
    
    NSArray *controllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) controllers.firstObject;
    
    [viewController showProductAccessoryLabelWithText:@"Failed"];
    
}

- (void)transactionDeferred {
    
    NSArray *controllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) controllers.firstObject;
    
    [viewController showProductAccessoryLabelWithText:@"Deferred"];
    
}

- (void)purchasedProduct {
    
    NSArray *controllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) controllers.firstObject;
    
    [viewController unlockPremiumCases];
    [viewController showProductAccessoryLabelWithText:@"Purchased"];
    
}

- (void)didEndRestoringPurchases {
    
    self.isRestoringInAppPurchases = NO;
    
    NSArray *controllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) controllers.firstObject;
    [viewController hideRestoreActivityIndicator];
    
}

- (void)didFailRestoringPurchases {
    
    self.isRestoringInAppPurchases = NO;
    
    NSArray *controllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) controllers.firstObject;
    [viewController hideRestoreActivityIndicator];
    
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

- (void)settingsViewControllerDidTapUnlockAllCases {
    
    NSString *title, *message;
    BOOL showAlertController = NO;
    
    if (SKPaymentQueue.canMakePayments == NO) {
        
        title = @"Error";
        message = @"Unable to accept payments. Please, verify your account restrictions.";
        showAlertController = YES;
        
    }else if (self.isLoadingInAppPurchases == YES) {
        
        title = @"Error";
        message = @"Loading product information. Please, try again in a moment.";
        showAlertController = YES;
        
    }else if (self.product == nil) {
        
        title = @"Error";
        message = @"Unable to load product information. Please, try again later.";
        showAlertController = YES;
        
    }
    
    if (showAlertController == YES) {
        
        UIAlertControllerStyle style = UIAlertControllerStyleAlert;
        NSString *actionTitle = @"Ok";
        UIAlertActionStyle actionStyle = UIAlertActionStyleCancel;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:nil];
        [alert addAction:action];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        return;
        
    }
    
    NSArray *controllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) controllers.firstObject;
    
    [viewController showProductActivityIndicator];
    
    [IAPManager.sharedInstance buyProduct:self.product];
    
}

- (void)settingsViewControllerDidTapRestorePurchases {
    
    if (self.isRestoringInAppPurchases == YES) return;
    
    self.isRestoringInAppPurchases = YES;
    
    NSArray *controllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) controllers.firstObject;
    [viewController showRestoreActivityIndicator];
    
    [IAPManager.sharedInstance restorePurchases];
    
}

@end
