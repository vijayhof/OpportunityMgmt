//
//  OptyDetailViewController.h
//
//  Created by Vijayant.
//

@class SFRestDelegate;

@interface OptyDetailViewController : UIViewController<SFRestDelegate>

@property (nonatomic, strong) NSString *optyId;

// outlets
@property (nonatomic, weak) IBOutlet UILabel *optyNameLabel;

@end
