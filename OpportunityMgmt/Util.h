//
//  Util.h
//
//  Created by Vijayant.
//

@interface Util : NSObject

+ (NSString*) formatCurrencyWithoutSymbol:(NSNumber*) number;
+ (NSString*) formatCurrency:(NSNumber*) number forCurrency:(NSString*)currencyCode;
+ (NSString*) formatDecimalNumber:(NSNumber*) number;

@end