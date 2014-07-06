//
//  NSDictionary+DateAdditions.h
//
//  Created by Vijayant.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (NSDate *)dateForKey:(NSString *)key;
- (id)objectForKeyNotNull:(id)key;

@end
