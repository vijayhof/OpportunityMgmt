//
//  Opportunity.m
//
//  Created by Vijayant.
//

#import "NSDictionary+Additions.h"
#import "Opportunity.h"

#define OPTY_ID_KEY           @"optyId"
#define OPTY_NAME_KEY         @"name"
#define OPTY_PRICEBOOK2ID_KEY @"pricebook2Id"

@implementation Opportunity

@synthesize optyId = _optyId;
@synthesize name = _name;
@synthesize pricebook2Id = _pricebook2Id;

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if (self) {
		self.optyId = [decoder decodeObjectForKey:OPTY_ID_KEY];
		self.name = [decoder decodeObjectForKey:OPTY_NAME_KEY];
		self.pricebook2Id = [decoder decodeObjectForKey:OPTY_PRICEBOOK2ID_KEY];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.optyId forKey:OPTY_ID_KEY];
	[coder encodeObject:self.name forKey:OPTY_NAME_KEY];
	[coder encodeObject:self.pricebook2Id forKey:OPTY_PRICEBOOK2ID_KEY];
}

- (id)copyWithZone:(NSZone *)zone
{
    Opportunity *copy = [[[self class] allocWithZone:zone] init];
    copy.optyId       = [self.optyId copyWithZone:zone];
    copy.name         = [self.name copyWithZone:zone];
    copy.pricebook2Id = [self.pricebook2Id copyWithZone:zone];
    return copy;
}


+ (Opportunity*)jsonToObject:(NSDictionary*)jsonObject {
    Opportunity* opty = [[[self class] alloc] init];
    
    opty.optyId = [jsonObject objectForKeyNotNull:@"Id"];
    opty.name = [jsonObject objectForKeyNotNull:@"Name"];
    opty.pricebook2Id = [jsonObject objectForKeyNotNull:@"Pricebook2Id"];
    
    return opty;
}
@end
