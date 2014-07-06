//
//  OptyProductViewController.h
//
//  Created by Vijayant.
//

#import "SFRestAPI.h"
#import "AddOptyProductViewController.h"


@interface OptyProductViewController : UITableViewController < SFRestDelegate>

@property (nonatomic, strong) NSString *optyId;

- (IBAction)productSelected:(UIStoryboardSegue *)segue;

- (IBAction)cancelAddProduct:(UIStoryboardSegue *)segue;
- (IBAction)saveAddProduct:(UIStoryboardSegue *)segue;

- (IBAction)closeDialog:(id)sender;

// click on add product button
- (IBAction)addProductAction:(id)sender;

@end
