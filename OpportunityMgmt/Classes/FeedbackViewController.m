//
//  FeedbackViewController.m
//
//  Created by Vijayant
//

#import <Parse/Parse.h>
#import "FeedbackViewController.h"

@interface FeedbackViewController ()
{
//    UIView* activeField;
}

@end

@implementation FeedbackViewController

@synthesize titleTextField;
@synthesize descTextView;

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)viewDidLoad
{
    NSLog(@"here1:feedback");
    
	[super viewDidLoad];
    
    // as uitextview does not show by default, add it programmatically.
    // Note color cannot be added thru interface builder
    [descTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.4] CGColor]];
    [descTextView.layer setBorderWidth:0.5];
    [descTextView.layer setCornerRadius: 5];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

//// Call this method somewhere in your view controller setup code.
//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    
//}
//
//// Called when the UIKeyboardDidShowNotification is sent.
//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    NSLog(@"feedback:keyboardWasShown");
//
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
//    }
//}
//
//// Called when the UIKeyboardWillHideNotification is sent
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    NSLog(@"feedback:keyboardWillBeHidden");
//
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    NSLog(@"feedback:textFieldDidBeginEditing");
//    activeField = textField;
//}
//
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"feedback:textFieldDidEndEditing");
//    [textField resignFirstResponder];
        [self.titleTextField resignFirstResponder];
//    activeField = nil;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction) clickedBackground
{
    [self.view endEditing:YES];
}


//
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    NSLog(@"feedback:textViewDidBeginEditing");
//    activeField = textView;
//}
//
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"feedback:textViewDidEndEditing");
    [self.descTextView resignFirstResponder];
//    activeField = nil;
}
//

#pragma mark - IBAction Methods

- (IBAction)sendFeedbackAction:(id)sender
{
    NSLog(@"feedback:sendFeedbackAction %@, %@", self.titleTextField.text, self.descTextView.text);
    NSString* title = self.titleTextField.text;
    NSString* desc = self.descTextView.text;
    
    if(title == nil || [title isEqualToString:@""] || desc == nil || [desc isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No feedback entered"
                                                            message:@"Please enter feedback before sending"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    PFObject *pfObject = [PFObject objectWithClassName:@"UserFeedback"];
    pfObject[@"title"] = self.titleTextField.text;
    pfObject[@"description"] = self.descTextView.text;
    pfObject[@"user"] = [PFUser currentUser];
    [pfObject saveInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
