//
//  IAPManager.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/29/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "IAPManager.h"

NSString *const kIAPManagerFailedNotification = @"kIAPManagerFailedNotification";
NSString *const kIAPManagerDeferredNotification = @"kIAPManagerDeferredNotification";
NSString *const kIAPManagerPurchasedNotification = @"kIAPManagerPurchasedNotification";
NSString *const kIAPManagerDidEndRestoringNotification = @"kIAPManagerDidEndRestoringNotification";
NSString *const kIAPManagerDidFailRestoringNotification = @"kIAPManagerDidFailRestoringNotification";

NSString *const kIAPProductUnlockPremiumCasesProductIdentifier = @"mateusnbm.watchframe.unlockallcases";

@interface IAPManager ()

@property (nonatomic, copy) ProductsRequestCompletion completionHandler;

@property (nonatomic, retain) SKProductsRequest *productRequest;
@property (nonatomic, retain) NSSet *productIdentifiers;
@property (nonatomic, retain) NSMutableSet *purchasedProductIdentifiers;

@end

@implementation IAPManager

#pragma mark -
#pragma mark - Lifecycle

+ (IAPManager *)sharedInstance {
    
    static dispatch_once_t once;
    static IAPManager *sharedInstance;
    
    dispatch_once(&once, ^{
        
        NSSet *productIdentifiers = [NSSet setWithObjects:kIAPProductUnlockPremiumCasesProductIdentifier, nil];
        sharedInstance = [[IAPManager alloc] initWithProductIdentifiers:productIdentifiers];
        
    });
    
    return sharedInstance;
    
}

- (id)initWithProductIdentifiers:(NSSet *)identifiers {
    
    self = [super init];
    
    if (self) {
        
        self.productRequest = nil;
        self.productIdentifiers = identifiers;
        self.purchasedProductIdentifiers = [NSMutableSet set];
        
        for (NSString *identifier in identifiers) {
            
            BOOL purchased = [NSUserDefaults.standardUserDefaults boolForKey:identifier];
            
            if (purchased == YES) {
                
                [self.purchasedProductIdentifiers addObject:identifier];
                
            }
            
        }
        
        [SKPaymentQueue.defaultQueue addTransactionObserver:self];
        
    }
    
    return self;
    
}

#pragma mark -
#pragma mark - Private

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    
    NSString *notificationName = kIAPManagerPurchasedNotification;
    NSString *notificationObject = productIdentifier;
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    
    [self.purchasedProductIdentifiers addObject:productIdentifier];
    [defaults setBool:YES forKey:productIdentifier];
    [defaults synchronize];
    [center postNotificationName:notificationName object:notificationObject userInfo:nil];
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [SKPaymentQueue.defaultQueue finishTransaction:transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [SKPaymentQueue.defaultQueue finishTransaction:transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        
        NSString *notificationName = kIAPManagerFailedNotification;
        NSString *notificationObject = transaction.payment.productIdentifier;
        NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
        
        [center postNotificationName:notificationName object:notificationObject userInfo:nil];
        
    }
    
    [SKPaymentQueue.defaultQueue finishTransaction:transaction];
    
}

- (void)deferredTransaction:(SKPaymentTransaction *)transaction {
    
    NSString *notificationName = kIAPManagerDeferredNotification;
    NSString *notificationObject = transaction.payment.productIdentifier;
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    
    [center postNotificationName:notificationName object:notificationObject userInfo:nil];
    [SKPaymentQueue.defaultQueue finishTransaction:transaction];
    
}

#pragma mark -
#pragma mark - Public

- (BOOL)purchasedProduct:(NSString *)productIdentifier {
    
    return [self.purchasedProductIdentifiers containsObject:productIdentifier];
    
}

- (void)requestProducts:(void (^) (BOOL success, NSArray *products))completion {
    
    if (self.productRequest) return;
    
    self.completionHandler = [completion copy];
    
    self.productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    self.productRequest.delegate = self;
    [self.productRequest start];
    
}

- (void)buyProduct:(SKProduct *)product {
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [SKPaymentQueue.defaultQueue addPayment:payment];
    
}

- (void)restorePurchases {
    
    [SKPaymentQueue.defaultQueue restoreCompletedTransactions];
    
}

#pragma mark -
#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.productRequest = nil;
    self.completionHandler(YES, response.products);
    self.completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    self.productRequest = nil;
    self.completionHandler(NO, nil);
    self.completionHandler = nil;
    
}

#pragma mark -
#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
    // This method is called after all restorable transactions have been
    // processed by the payment queue. Your application is not required
    // to do anything in this method.
    
    NSString *notificationName = kIAPManagerDidEndRestoringNotification;
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    
    [center postNotificationName:notificationName object:nil userInfo:nil];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    // Tells the observer that an error occurred while restoring transactions.
    
    NSString *notificationName = kIAPManagerDidFailRestoringNotification;
    NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
    
    [center postNotificationName:notificationName object:error userInfo:nil];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchasing:
                
                // The transaction is being processed by the App Store.
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                // The App Store successfully processed payment. Your application
                // should provide the content the user purchased.
                
                [self completeTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                // This transaction restores content previously purchased by the
                // user. Read the 'originalTransaction' property to obtain information
                // about the original purchase.
                
                [self restoreTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                // The transaction failed. Check the 'error' property to determine what happened.
                
                [self failedTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateDeferred:
                
                // The transaction is in the queue, but its final status is pending
                // external action such as Ask to Buy. Update your UI to show the
                // deferred state, and wait for another callback that indicates the
                // final status.
                
                [self deferredTransaction:transaction];
                
                break;
                
        }
        
    }
    
}

@end
