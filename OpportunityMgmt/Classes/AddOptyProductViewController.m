//
//  AddOptyProductViewController.m
//
//  Created by Vijayant
//

#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "OpportunityProduct.h"
#import "PricebookEntry.h"

#import "AddOptyProductViewController.h"

@interface AddOptyProductViewController ()
{
    UIActivityIndicatorView* _spinner1;
    UIView* activeField;
    
}
@property (nonatomic, strong) OpportunityProduct *optyProduct;
@end

@implementation AddOptyProductViewController

@synthesize optyId = _optyId;
@synthesize pricebookEntry = _pricebookEntry;
@synthesize optyProduct = _optyProduct;

@synthesize productNameLabel = _productNameLabel;
@synthesize unitPriceTxtField = _unitPriceTxtField;
@synthesize quantityTxtField = _quantityTxtField;
@synthesize descTextView = _descTextView;

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)viewDidLoad
{
    NSLog(@"here1:addopty optyid=%@, pbeid=%@", self.optyId, self.pricebookEntry.pricebookEntryId);
    
	[super viewDidLoad];
    
    // as uitextview does not show by default, add it programmatically.
    // Note color cannot be added thru interface builder
    [self.descTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.4] CGColor]];
    [self.descTextView.layer setBorderWidth:0.5];
    [self.descTextView.layer setCornerRadius: 5];
    
    // add ui activity indicator
    
    // move location of spinner half way to top
    CGPoint spinnerCenter = [self.view center];
    spinnerCenter.y = spinnerCenter.y / 2;
    
    _spinner1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner1 setColor:[UIColor grayColor]];
    _spinner1.center = spinnerCenter;
    [self.view addSubview:_spinner1];
    [self.view bringSubviewToFront:_spinner1];
    _spinner1.hidesWhenStopped = YES;
    _spinner1.hidden = YES;
    
	self.optyProduct = [[OpportunityProduct alloc] init];
    self.optyProduct.opportunityId = self.optyId;
    self.optyProduct.pricebookEntryId = self.pricebookEntry.pricebookEntryId;
    self.optyProduct.unitPrice = self.pricebookEntry.unitPrice;
    
    self.productNameLabel.text = self.pricebookEntry.name;
    self.unitPriceTxtField.text = [self.pricebookEntry.unitPrice stringValue];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	//[self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - SFRestAPIDelegate

- (void) doSaveOpportunityLineItem
{
    _spinner1.hidden = NO;
    [_spinner1 startAnimating];
    
    self.optyProduct.unitPrice = [NSNumber numberWithDouble:[self.unitPriceTxtField.text doubleValue]];
    self.optyProduct.quantity = [NSNumber numberWithDouble:[self.quantityTxtField.text doubleValue]];
    
    // SF Rest Update
    NSDictionary* fieldsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.optyProduct.quantity, @"Quantity",
                                self.optyProduct.unitPrice, @"UnitPrice",
                                self.optyProduct.opportunityId, @"OpportunityId",
                                self.optyProduct.pricebookEntryId, @"PricebookEntryId",
                                nil];
    NSLog(@"here2 %@", fieldsDict);
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"OpportunityLineItem"
                                                                                 fields:fieldsDict];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void) finishExecuteQuery
{
    if([_spinner1 isAnimating])
    {
        [_spinner1 stopAnimating];
    }
}

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse
{
    // TODO - cleanup later
    // jsonResponse is of type NSDictionary
    //    {
    //        errors =     (
    //        );
    //        id = 00ki000000CXZ8BAAX;
    //        success = 1;
    //    }
    NSLog(@"addoptyproduct:dLR:here1 %@ %d", jsonResponse, [jsonResponse isKindOfClass:[NSArray class]]);
    
    NSArray *errors = [jsonResponse objectForKey:@"errors"];
    
    NSLog(@"request:didLoadResponse: #errors: %d", (int)errors.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishExecuteQuery];
        [self performSegueWithIdentifier:@"SaveAddProduct" sender:self];
    });
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishExecuteQuery];
    });
    
    //add your failed error handling here
    NSLog(@"request:didFailLoadWithError: %@", error);
    NSString* errorString = [error localizedDescription];
    NSInteger errorCode = [error code];
    NSString* errorFailureReason = [error localizedFailureReason];
    
    if(!errorString)
    {
        if(errorCode && errorFailureReason)
        {
            errorString  = [[NSString alloc] initWithFormat:@"Error code: %d. Failure Reason: %@", errorCode, errorFailureReason];
        }
        else if(errorCode)
        {
            errorString  = [[NSString alloc] initWithFormat:@"Error code: %d", errorCode];
        }
        else if(errorFailureReason)
        {
            errorString  = [[NSString alloc] initWithFormat:@"Failure Reason: %@", errorFailureReason];
        }
        else
        {
            errorString  = [[NSString alloc] initWithFormat:@"Unexpected error %@", error];
        }
        
    }
    
    errorString = [[NSString alloc] initWithFormat:@"Unable to save product for opportunity. %@", errorString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Save Error"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request
{
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishExecuteQuery];
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request
{
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishExecuteQuery];
    });
}

#pragma mark - IBAction Methods

- (IBAction)saveAction:(id)sender
{
    NSLog(@"addopty:saveAction");
    [self doSaveOpportunityLineItem];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString*)identifier sender:(id)sender
{
    //    if ([identifier isEqualToString:@"SaveAddProduct"]) {
    //        NSLog(@"segue from addopty1=%@", identifier);
    //        [self saveOpportunityLineItem];
    //        return YES;
    //    }
    //
    return YES;
}


#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CancelAddProduct"])
    {
        NSLog(@"segue from addopty2=%@", segue.identifier);
    }
    else if ([segue.identifier isEqualToString:@"SaveAddProduct"])
    {
        NSLog(@"segue from addopty2=%@", segue.identifier);
    }
}


// Code for scroll view

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"feedback:keyboardWasShown");
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"feedback:keyboardWillBeHidden");
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"feedback:textFieldDidBeginEditing");
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"feedback:textFieldDidEndEditing");
    //    [textField resignFirstResponder];
    //    [self.titleTextField resignFirstResponder];
    activeField = nil;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    activeField = nil;
    [textField resignFirstResponder];
    return YES;
}

- (IBAction) clickedBackground
{
    activeField = nil;
    [self.view endEditing:YES];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"feedback:textViewDidBeginEditing");
    activeField = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"feedback:textViewDidEndEditing");
    activeField = nil;
}

@end
