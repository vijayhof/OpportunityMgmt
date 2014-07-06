//
//  Product.m
//
//  Created by Vijayant.
//

#import "NSDictionary+Additions.h"
#import "Product.h"

#define PRODUCT_ID_KEY	@"productId"
#define PRODUCT_NAME_KEY @"name"

@implementation Product

@synthesize productId = _productId;
@synthesize name = _name;


- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if (self) {
		self.productId = [decoder decodeObjectForKey:PRODUCT_ID_KEY];
		self.name = [decoder decodeObjectForKey:PRODUCT_NAME_KEY];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.productId forKey:PRODUCT_ID_KEY];
	[coder encodeObject:self.name forKey:PRODUCT_NAME_KEY];
}

- (id)copyWithZone:(NSZone *)zone
{
    Product *copy = [[[self class] allocWithZone:zone] init];
    copy.productId = [self.productId copyWithZone:zone];
    copy.name      = [self.name copyWithZone:zone];
    return copy;
}


+ (Product*)jsonToObject:(NSDictionary*)jsonObject {
    
    Product* prd = [[[self class] alloc] init];
    
    prd.productId = [jsonObject objectForKeyNotNull:@"Id"];
    prd.name = [jsonObject objectForKeyNotNull:@"Name"];
    
    return prd;
}
@end
