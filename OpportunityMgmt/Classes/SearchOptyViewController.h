//
//  SearchOptyViewController.h
//
//  Created by Vijayant.
//

#import "SFRestAPI.h"

@interface SearchOptyViewController : UITableViewController <UISearchBarDelegate, SFRestDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

- (IBAction)closeDialog:(id)sender;

@end
