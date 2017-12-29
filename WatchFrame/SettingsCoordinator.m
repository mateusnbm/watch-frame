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

#define kInAppPurchasesProductIdAllCases @"mateusnbm.watchframe.unlockallcases"

@interface SettingsCoordinator ()

@property (nonatomic) BOOL isLoadingInAppPurchases;
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
        
        self.childCoordinators = [[NSMutableArray alloc] init];
        
    }
    
    return self;
    
}

#pragma mark -
#pragma mark - Public

- (void)start {
    
    SettingsViewController *con = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    con.delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:con];
    self.rootViewController = self.navigationController;
    
    [self loadInAppPurchases];
    
}

#pragma mark -
#pragma mark - Private

- (void)loadInAppPurchases {
    
    self.isLoadingInAppPurchases = YES;
    
    NSSet *productIDs = [NSSet setWithObject:kInAppPurchasesProductIdAllCases];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDs];
    request.delegate = self;
    [request start];
    
}

- (void)showProductPrice {
    
    if (self.product == nil) return;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = self.product.priceLocale;
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    NSString *formattedPrice = [formatter stringFromNumber:self.product.price];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) viewControllers.firstObject;
    
    [viewController showProductAccessoryLabelWithText:formattedPrice];
    
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
    
    SKPayment *payment = [SKPayment paymentWithProduct:self.product];
    [SKPaymentQueue.defaultQueue addTransactionObserver:self];
    [SKPaymentQueue.defaultQueue addPayment:payment];
    
}

- (void)settingsViewControllerDidTapRestorePurchases {
    
    //
    
}

#pragma mark -
#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.isLoadingInAppPurchases = NO;
    
    if (response.products.count == 0) return;
    
    self.product = response.products.firstObject;
    
    [self showProductPrice];
    
}

#pragma mark -
#pragma mark - SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    NSString *pid = kInAppPurchasesProductIdAllCases;
    SKPaymentTransaction *transaction = [transactions transactionWithProductIdentifier:pid];
    
    NSArray *controllers = self.navigationController.viewControllers;
    SettingsViewController *viewController = (SettingsViewController *) controllers.firstObject;
    
    switch (transaction.transactionState) {
            
        case SKPaymentTransactionStatePurchasing:
            
            // The transaction is being processed by the App Store.
            
            [viewController showProductActivityIndicator];
            
            break;
            
        case SKPaymentTransactionStatePurchased:
            
            // The App Store successfully processed payment. Your application
            // should provide the content the user purchased.
            
            [SKPaymentQueue.defaultQueue finishTransaction:transaction];
            [viewController showProductAccessoryLabelWithText:@"Purchased"];
            
            break;
            
        case SKPaymentTransactionStateRestored:
            
            // This transaction restores content previously purchased by the
            // user. Read the 'originalTransaction' property to obtain information
            // about the original purchase.
            
            [SKPaymentQueue.defaultQueue finishTransaction:transaction];
            [viewController showProductAccessoryLabelWithText:@"Purchased"];
            
            break;
            
        case SKPaymentTransactionStateFailed:
            
            // The transaction failed. Check the 'error' property to determine what happened.
            
            [viewController showProductAccessoryLabelWithText:@"Failed"];
            
            break;
            
        case SKPaymentTransactionStateDeferred:
            
            // The transaction is in the queue, but its final status is pending
            // external action such as Ask to Buy. Update your UI to show the
            // deferred state, and wait for another callback that indicates the
            // final status.
            
            [viewController showProductAccessoryLabelWithText:@"Deferred"];
            
            break;
            
    }
    
}

@end
