//
//  Util.h
//
//  Created by Vijayant.
//
#import "Util.h"

@implementation Util

+ (NSString*) formatCurrencyWithoutSymbol:(NSNumber*) number
{
    NSString* str = [[NSString alloc] initWithFormat:@"%.2f", [number floatValue]];
    return str;
}

+ (NSString*) formatCurrency:(NSNumber*) number forCurrency:(NSString*)currencyCode
{
    NSString* str = nil;
    
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setCurrencyCode:currencyCode];
    str = [_currencyFormatter stringFromNumber:number];
    
    return str;
}

+ (NSString*) formatDecimalNumber:(NSNumber*) number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *str = [formatter stringFromNumber:number];
    return str;
}


@end