//
//  FeedbackViewController.h
//
//  Created by Vijayant.
//

@interface FeedbackViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;

- (IBAction)sendFeedbackAction:(id)sender;
- (IBAction) clickedBackground;

@end
