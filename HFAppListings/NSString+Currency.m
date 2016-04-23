//
//  NSString+Currency.m
//  HFAppListings
//
//  Created by Sami B on 2016-04-23.
//  Copyright © 2016 Sami B. All rights reserved.
//

#import "NSString+Currency.h"

@implementation NSString (Currency)
- (instancetype) dollarAmount {
    NSNumberFormatter * currencyFormatter = [NSNumberFormatter new];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString * dollarAmountString = [currencyFormatter stringFromNumber:[NSDecimalNumber decimalNumberWithString:self.copy]];
    return dollarAmountString;
}
@end
