//
//  NSString+Additions.m
//
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)urlEncodedString {
	NSString *encodedForm = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																								  (__bridge CFStringRef)self,
																								  NULL, CFSTR(":/?#[]@!$&’()*+,;="),
																								  kCFStringEncodingUTF8);
	return encodedForm;
}

@end
