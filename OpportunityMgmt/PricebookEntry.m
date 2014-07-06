//
//  PricebookEntry.m
//
//  Created by Vijayant.
//

#import "NSDictionary+Additions.h"
#import "PricebookEntry.h"

#define PBE_ID_KEY           @"pricebookEntryId"
#define PBE_NAME_KEY         @"name"
#define PBE_PRICEBOOK2ID_KEY @"pricebook2Id"
#define PBE_PRODUCT2ID_KEY   @"product2Id"
#define PBE_PRODUCTCODE_KEY  @"productCode"
#define PBE_UNITPRICE_KEY    @"unitPrice"

@implementation PricebookEntry

@synthesize pricebookEntryId = _pricebookEntryId;
@synthesize name = _name;
@synthesize pricebook2Id = _pricebook2Id;
@synthesize product2Id = _product2Id;
@synthesize productCode = _productCode;
@synthesize unitPrice = _unitPrice;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.pricebookEntryId = [decoder decodeObjectForKey:PBE_ID_KEY];
        self.name             = [decoder decodeObjectForKey:PBE_NAME_KEY];
        self.pricebook2Id     = [decoder decodeObjectForKey:PBE_PRICEBOOK2ID_KEY];
        self.product2Id       = [decoder decodeObjectForKey:PBE_PRODUCT2ID_KEY];
        self.productCode      = [decoder decodeObjectForKey:PBE_PRODUCTCODE_KEY];
        self.unitPrice        = [decoder decodeObjectForKey:PBE_UNITPRICE_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.pricebookEntryId forKey:PBE_ID_KEY];
    [coder encodeObject:self.name             forKey:PBE_NAME_KEY];
    [coder encodeObject:self.pricebook2Id     forKey:PBE_PRICEBOOK2ID_KEY];
    [coder encodeObject:self.product2Id       forKey:PBE_PRODUCT2ID_KEY];
    [coder encodeObject:self.productCode      forKey:PBE_PRODUCTCODE_KEY];
    [coder encodeObject:self.unitPrice        forKey:PBE_UNITPRICE_KEY];
}

- (id)copyWithZone:(NSZone *)zone
{
    PricebookEntry *copy = [[[self class] allocWithZone:zone] init];
    copy.pricebookEntryId = [self.pricebookEntryId copyWithZone:zone];
    copy.name             = [self.name copyWithZone:zone];
    copy.pricebook2Id     = [self.pricebook2Id copyWithZone:zone];
    copy.product2Id       = [self.product2Id copyWithZone:zone];
    copy.productCode      = [self.productCode copyWithZone:zone];
    copy.unitPrice        = [self.unitPrice copyWithZone:zone];
    return copy;
}


+ (PricebookEntry*)jsonToObject:(NSDictionary*)jsonObject {
    
    PricebookEntry* pbe = [[[self class] alloc] init];

    pbe.pricebookEntryId = [jsonObject objectForKeyNotNull:@"Id"];
    pbe.name             = [jsonObject objectForKeyNotNull:@"Name"];
    pbe.pricebook2Id     = [jsonObject objectForKeyNotNull:@"Pricebook2Id"];
    pbe.product2Id       = [jsonObject objectForKeyNotNull:@"Product2Id"];
    pbe.productCode      = [jsonObject objectForKeyNotNull:@"ProductCode"];
    pbe.unitPrice        = [jsonObject objectForKeyNotNull:@"UnitPrice"];
    
    return pbe;
}
@end
