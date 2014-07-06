//
//  OpportunityService.h
//
//  Created by Vijayant.
//

@class Opportunity;

typedef void(^ServiceCompletionBlock)(id result, NSError *error);

@interface OpportunityService : NSObject

- (void)findOpportunitiesByName:(NSString *)optyName completionBlock:(ServiceCompletionBlock)completionBlock;

//
//- (void)loadAlbumsForArtist:(Artist *)artist completionBlock:(ServiceCompletionBlock)completionBlock;
//
//- (void)fetchArtworkForAlbum:(Album *)album completionBlock:(ServiceCompletionBlock)completionBlock;

@end
