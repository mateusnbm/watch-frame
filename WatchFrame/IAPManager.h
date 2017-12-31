//
//  IAPManager.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/29/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const kIAPManagerFailedNotification;
UIKIT_EXTERN NSString *const kIAPManagerDeferredNotification;
UIKIT_EXTERN NSString *const kIAPManagerPurchasedNotification;
UIKIT_EXTERN NSString *const kIAPManagerDidEndRestoringNotification;
UIKIT_EXTERN NSString *const kIAPManagerDidFailRestoringNotification;

UIKIT_EXTERN NSString *const kIAPProductUnlockPremiumCasesProductIdentifier;

typedef void (^ProductsRequestCompletion)(BOOL success, NSArray * products);

@interface IAPManager : NSObject <
    SKProductsRequestDelegate,
    SKPaymentTransactionObserver
    >

+ (IAPManager *)sharedInstance;

- (id)initWithProductIdentifiers:(NSSet *)identifiers;

- (BOOL)purchasedProduct:(NSString *)productIdentifier;
- (void)requestProducts:(ProductsRequestCompletion)completion;
- (void)buyProduct:(SKProduct *)product;
- (void)restorePurchases;

@end
