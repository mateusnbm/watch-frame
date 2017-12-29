//
//  NSArray+Payments.h
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/29/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

@interface NSArray (Payments)

- (SKPaymentTransaction *)transactionWithProductIdentifier:(NSString *)identifier;

@end
