//
//  HTTPGetRequest.h
//
//  Created by Vijayant
//

typedef void(^SuccessBlock)(NSData *response);
typedef void(^FailureBlock)(NSError *error);

@interface HTTPGetRequest : NSObject

- (id)initWithURL:(NSURL *)requestURL successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
- (void)startRequest;

@end
