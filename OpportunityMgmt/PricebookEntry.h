//
//  PricebookEntry.h
//
//  Created by Vijayant.
//

@interface PricebookEntry : NSObject <NSCoding,NSCopying>

@property (nonatomic, copy) NSString *pricebookEntryId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pricebook2Id;
@property (nonatomic, copy) NSString *product2Id;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSNumber *unitPrice;

//@property (nonatomic, copy) NSString *useStandardPrice; TODO later

+ (PricebookEntry*)jsonToObject:(NSDictionary*)jsonObject;

@end
