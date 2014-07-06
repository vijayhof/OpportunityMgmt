//
//  SearchProductViewController.h
//
//  Created by Vijayant.
//

#import "SFRestAPI.h"

@class PricebookEntry;

@interface SearchProductViewController : UITableViewController <UISearchBarDelegate, SFRestDelegate>

// (input) pricebook id for which products would be shown or filtered
@property (strong, nonatomic) NSString *filterPricebook2Id;

// (output) pricebook entry object that would be populated with the selection
@property (strong, nonatomic) PricebookEntry *selectedPbe;

// outlets
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

// actions
- (IBAction)closeDialog:(id)sender;

@end
