//
//  Product.h
//
//  Created by Vijayant.
//

@interface Product : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *name;

+ (Product*)jsonToObject:(NSDictionary*)jsonObject;

@end
