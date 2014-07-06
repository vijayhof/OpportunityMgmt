//
//  Opportunity.h
//
//  Created by Vijayant.
//

@interface Opportunity : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *optyId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pricebook2Id;

+ (Opportunity*)jsonToObject:(NSDictionary*)jsonObject;

@end
