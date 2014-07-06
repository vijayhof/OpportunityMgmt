//
//  AddOptyProductViewController.h
//
//  Created by Vijayant.
//

#import "SFRestAPI.h"

@class PricebookEntry;

@interface AddOptyProductViewController : UIViewController<SFRestDelegate>


@property (nonatomic, strong) NSString *optyId;
@property (nonatomic, strong) PricebookEntry *pricebookEntry;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UILabel *productNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *unitPriceTxtField;
@property (nonatomic, weak) IBOutlet UITextField *quantityTxtField;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;

- (IBAction)saveAction:(id)sender;
- (IBAction) clickedBackground;

@end
