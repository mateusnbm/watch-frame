//
//  NSArray+Payments.m
//  WatchFrame
//
//  Created by Mateus Nunes de B Magalhaes on 12/29/17.
//  Copyright © 2017 mateusnbm. All rights reserved.
//

#import "NSArray+Payments.h"

@implementation NSArray (Payments)

- (SKPaymentTransaction *)transactionWithProductIdentifier:(NSString *)pid {
    
    for (SKPaymentTransaction *transaction in self) {
        
        if ([transaction.payment.productIdentifier isEqualToString:pid]) {
            
            return transaction;
            
        }
        
    }
    
    return nil;
    
}

@end
