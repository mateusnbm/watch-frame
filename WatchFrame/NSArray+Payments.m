//
//  NSArray+Payments.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/29/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "NSArray+Payments.h"

@implementation NSArray (Payments)

- (SKProduct *)productWithIdentifier:(NSString *)identifier {
    
    for (SKProduct *product in self) {
        
        if ([product.productIdentifier isEqualToString:identifier]) {
            
            return product;
            
        }
        
    }
    
    return nil;
    
}

- (SKPaymentTransaction *)transactionWithProductIdentifier:(NSString *)pid {
    
    for (SKPaymentTransaction *transaction in self) {
        
        if ([transaction.payment.productIdentifier isEqualToString:pid]) {
            
            return transaction;
            
        }
        
    }
    
    return nil;
    
}

@end
