//
//  LeftPanelViewController.h
//
//  Created by Vijayant.
//


#import <UIKit/UIKit.h>

@protocol LeftPanelViewControllerDelegate <NSObject>

@optional
//- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator;

@required
- (void)menuItemSelected:(NSString *)menuItemStr;

@end

@interface LeftPanelViewController : UIViewController

@property (nonatomic, assign) id<LeftPanelViewControllerDelegate> menuItemDelegate;

// IBOutlets
@property (nonatomic, weak) IBOutlet UILabel *displayNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;

@end