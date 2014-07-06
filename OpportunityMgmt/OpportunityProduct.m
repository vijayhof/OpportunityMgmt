//
//  OpportunityProduct.m
//
//  Created by Vijayant.
//

#import "NSDictionary+Additions.h"
#import "OpportunityProduct.h"

#define OPTY_PRODUCT_ID_KEY            @"optyProductId"
#define OPTY_PRODUCT_OPTYID_KEY        @"opportunityId"
#define OPTY_PRODUCT_PBEID_KEY         @"pricebookEntryId"
#define OPTY_PRODUCT_DESC_KEY          @"description"
#define OPTY_PRODUCT_QUANTITY_KEY      @"quantity"
#define OPTY_PRODUCT_UNITPRICE_KEY     @"unitPrice"
#define OPTY_PRODUCT_TOTALPRICE_KEY    @"totalPrice"

#define OPTY_PRODUCT_PBE_PRD2_NAME_KEY @"pricebookEntry_product2_Name"
#define OPTY_PRODUCT_PBE_PB2_ID_KEY    @"pricebookEntry_pricebook2_Id"

@implementation OpportunityProduct

@synthesize optyProductId = _optyProductId;
@synthesize opportunityId = _opportunityId;
@synthesize pricebookEntryId = _pricebookEntryId;
@synthesize description = _description;
@synthesize quantity = _quantity;
@synthesize unitPrice = _unitPrice;
@synthesize totalPrice = _totalPrice;

@synthesize pricebookEntry_product2_Name = _pricebookEntry_product2_Name;
@synthesize pricebookEntry_pricebook2_Id = _pricebookEntry_pricebook2_Id;

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if (self) {
		self.optyProductId = [decoder decodeObjectForKey:OPTY_PRODUCT_ID_KEY];
		self.opportunityId = [decoder decodeObjectForKey:OPTY_PRODUCT_OPTYID_KEY];
		self.pricebookEntryId = [decoder decodeObjectForKey:OPTY_PRODUCT_PBEID_KEY];
		self.description = [decoder decodeObjectForKey:OPTY_PRODUCT_DESC_KEY];
		self.quantity = [decoder decodeObjectForKey:OPTY_PRODUCT_QUANTITY_KEY];
		self.unitPrice = [decoder decodeObjectForKey:OPTY_PRODUCT_UNITPRICE_KEY];
		self.totalPrice = [decoder decodeObjectForKey:OPTY_PRODUCT_TOTALPRICE_KEY];
        
        self.pricebookEntry_product2_Name = [decoder decodeObjectForKey:OPTY_PRODUCT_PBE_PRD2_NAME_KEY];
        self.pricebookEntry_pricebook2_Id = [decoder decodeObjectForKey:OPTY_PRODUCT_PBE_PB2_ID_KEY];
        
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.optyProductId forKey:OPTY_PRODUCT_ID_KEY];
    [coder encodeObject:self.opportunityId forKey:OPTY_PRODUCT_OPTYID_KEY];
    [coder encodeObject:self.pricebookEntryId forKey:OPTY_PRODUCT_PBEID_KEY];
	[coder encodeObject:self.description forKey:OPTY_PRODUCT_DESC_KEY];
	[coder encodeObject:self.quantity forKey:OPTY_PRODUCT_QUANTITY_KEY];
	[coder encodeObject:self.unitPrice forKey:OPTY_PRODUCT_UNITPRICE_KEY];
	[coder encodeObject:self.totalPrice forKey:OPTY_PRODUCT_TOTALPRICE_KEY];
    [coder encodeObject:self.pricebookEntry_product2_Name forKey:OPTY_PRODUCT_PBE_PRD2_NAME_KEY];
    [coder encodeObject:self.pricebookEntry_pricebook2_Id forKey:OPTY_PRODUCT_PBE_PB2_ID_KEY];
}

- (id)copyWithZone:(NSZone *)zone
{
    OpportunityProduct *copy = [[[self class] allocWithZone:zone] init];
    copy.optyProductId = [self.optyProductId copyWithZone:zone];
    copy.opportunityId = [self.opportunityId copyWithZone:zone];
    copy.pricebookEntryId = [self.pricebookEntryId copyWithZone:zone];
    copy.description   = [self.description copyWithZone:zone];
    copy.quantity      = [self.quantity copyWithZone:zone];
    copy.unitPrice      = [self.unitPrice copyWithZone:zone];
    copy.totalPrice      = [self.totalPrice copyWithZone:zone];
    copy.pricebookEntry_product2_Name = [self.pricebookEntry_product2_Name copyWithZone:zone];
    copy.pricebookEntry_pricebook2_Id = [self.pricebookEntry_pricebook2_Id copyWithZone:zone];
    return copy;
}


+ (OpportunityProduct*)jsonToObject:(NSDictionary*)jsonObject {
    
    OpportunityProduct* optyProduct = [[[self class] alloc] init];
    optyProduct.optyProductId    = [jsonObject objectForKeyNotNull:@"Id"];
    optyProduct.opportunityId    = [jsonObject objectForKeyNotNull:@"OpportunityId"];
    optyProduct.pricebookEntryId = [jsonObject objectForKeyNotNull:@"PricebookEntryId"];
    optyProduct.description      = [jsonObject objectForKeyNotNull:@"Description"];
    optyProduct.quantity         = [jsonObject objectForKeyNotNull:@"Quantity"];
    optyProduct.unitPrice        = [jsonObject objectForKeyNotNull:@"UnitPrice"];
    optyProduct.totalPrice        = [jsonObject objectForKeyNotNull:@"TotalPrice"];
    
    NSDictionary* pricebookEntryObj = [jsonObject objectForKeyNotNull:@"PricebookEntry"];
    if(pricebookEntryObj)
    {
        optyProduct.pricebookEntry_pricebook2_Id = [pricebookEntryObj objectForKeyNotNull:@"Pricebook2Id"];
        
        NSDictionary* product2Obj = [pricebookEntryObj objectForKeyNotNull:@"Product2"];
        if(product2Obj)
        {
            optyProduct.pricebookEntry_product2_Name = [product2Obj objectForKeyNotNull:@"Name"];
        }
    }
    
    return optyProduct;
}

@end
