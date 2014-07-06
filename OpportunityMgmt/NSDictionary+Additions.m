//
//  NSDictionary+DateAdditions.m
//
//

#import "NSDictionary+Additions.h"

#define DATE_FORMAT @"yyyy-MM-dd'T'HH:mm:ss'Z'"

@implementation NSDictionary (Additions)

- (NSDate *)dateForKey:(id)key {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[formatter setDateFormat:DATE_FORMAT];
	return [formatter dateFromString:[self objectForKey:key]];
}

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

@end
