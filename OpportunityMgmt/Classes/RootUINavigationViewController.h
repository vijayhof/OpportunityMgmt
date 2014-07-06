//
//  RootUINavigationViewController.h
//
//  Created by Vijayant.
//

#import <UIKit/UIKit.h>

@protocol SlideOutViewControllerDelegate <NSObject>

@required
- (void)toggleSlideOut;

@end

@interface RootUINavigationViewController : UINavigationController

@property (nonatomic, assign) id<SlideOutViewControllerDelegate> slideOutDelegate;

// this method will be called through action binding
- (void)toggleSlideOutAction;

- (void)doMenuItemSelected:(NSString*)menuItemStr;

@end
