//
//  OpportunityProduct.h
//
//  Created by Vijayant.
//

@interface OpportunityProduct : NSObject <NSCoding>

@property (nonatomic, copy) NSString *optyProductId;
@property (nonatomic, copy) NSString *opportunityId;
@property (nonatomic, copy) NSString *pricebookEntryId;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSNumber *quantity;
@property (nonatomic, copy) NSNumber *unitPrice;
@property (nonatomic, copy) NSNumber *totalPrice;

@property (nonatomic, copy) NSString *pricebookEntry_product2_Name;
@property (nonatomic, copy) NSString *pricebookEntry_pricebook2_Id;

+ (OpportunityProduct*)jsonToObject:(NSDictionary*)jsonObject;

@end
