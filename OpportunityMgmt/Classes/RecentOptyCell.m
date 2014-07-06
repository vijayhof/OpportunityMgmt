//
//  RecentOptyCell.m
//
//  Created by Vijayant
//

#import "RecentOptyCell.h"
//#import "UIView+Geometry.h"

#define RESIZE_ADJUSTMENT 57.0

@implementation RecentOptyCell

@synthesize optyId = _optyId;
@synthesize optyName = _optyName;

//- (void)willTransitionToState:(UITableViewCellStateMask)state {
//	[super willTransitionToState:state];
//
//	if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
//		self.albumNameLabel.frameWidth -= RESIZE_ADJUSTMENT;
//		self.artistNameLabel.frameWidth -= RESIZE_ADJUSTMENT;
//	}
//}
//
//- (void)didTransitionToState:(UITableViewCellStateMask)state {
//	if (state == UITableViewCellStateDefaultMask) {
//	
//		[UIView animateWithDuration:0.4 animations:^{
//			self.albumNameLabel.frameWidth += RESIZE_ADJUSTMENT;
//			self.artistNameLabel.frameWidth += RESIZE_ADJUSTMENT;
//		} completion:^(BOOL finished) {
//			[super didTransitionToState:state];
//		}];
//		
//	} else {
//		[super didTransitionToState:state];	
//	}
//}

@end
