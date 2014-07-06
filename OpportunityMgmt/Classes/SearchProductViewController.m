//
//  SearchProductViewController.m
//
//  Created by Vijayant
//
#import "NSDictionary+Additions.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "PricebookEntry.h"

#import "SearchProductViewController.h"
#import "PricebookCell.h"

@interface SearchProductViewController ()
{
    UIActivityIndicatorView* _spinner1;
}
@property (nonatomic, strong) NSMutableArray *pbEntries;
@end

@implementation SearchProductViewController

@synthesize filterPricebook2Id = _filterPricebook2Id;
@synthesize selectedPbe = _selectedPbe;

@synthesize searchBar = _searchBar;
@synthesize pbEntries = pbEntries;

#pragma mark - Standard Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.pbEntries = [NSMutableArray array];
    
    // add ui activity indicator
    
    // move location of spinner half way to top
    CGPoint spinnerCenter = [self.tableView center];
    spinnerCenter.y = spinnerCenter.y / 2;
    
    _spinner1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner1 setColor:[UIColor grayColor]];
    _spinner1.center = spinnerCenter;
    [self.tableView addSubview:_spinner1];
    [self.tableView bringSubviewToFront:_spinner1];
    _spinner1.hidesWhenStopped = YES;
    _spinner1.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - IBAction Methods

- (IBAction)closeDialog:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Search Bar Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	self.searchBar.text = @"";
//	[self.searchBar resignFirstResponder];
	[self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _spinner1.hidden = NO;
    [_spinner1 startAnimating];

	[self.searchBar resignFirstResponder];
        
    NSString* productSearchQuery = [NSString stringWithFormat:@"SELECT id, name, product2id, productcode, unitprice, pricebook2id FROM PricebookEntry WHERE (name LIKE '%@%%' OR productcode LIKE '%@%%') AND pricebook2id = '%@' LIMIT 200", searchBar.text, searchBar.text, self.filterPricebook2Id];
    
    NSLog(@"productSearchQuery=%@", productSearchQuery);
    
    // SF Rest Query
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:productSearchQuery];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void) finishExecuteQuery
{
    if([_spinner1 isAnimating])
    {
        [_spinner1 stopAnimating];
    }
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse
{
    // TODO - filter for Product type only
    
    // jsonResponse is of type NSDictionary
    NSLog(@"here4 %@ %d", jsonResponse, [jsonResponse isKindOfClass:[NSArray class]]);
    NSArray *records = [jsonResponse objectForKeyNotNull:@"records"];

    NSLog(@"request:didLoadResponse: #records: %d", (int)records.count);
    self.pbEntries = [[NSMutableArray alloc] initWithCapacity:(int)records.count];
    for(id jsonObj in (NSArray*) records)
    {
        [self.pbEntries addObject:[PricebookEntry jsonToObject:((NSDictionary*)jsonObj)]];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishExecuteQuery];
        [self.tableView reloadData];
    });
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error
{
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishExecuteQuery];
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

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.pbEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PricebookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchProductTableCell"];
    
    PricebookEntry *pbe = [self.pbEntries objectAtIndex:indexPath.row];
    cell.name.text = pbe.name;
    cell.produceCode.text = pbe.productCode;
    cell.unitPrice.text = [pbe.unitPrice stringValue];
    
	return cell;
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ProductSelected"])
    {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		PricebookEntry* pbe = [self.pbEntries objectAtIndex:indexPath.row];
        self.selectedPbe = pbe;
        NSLog(@"selected pbe %@ %@", self.selectedPbe, self.selectedPbe.pricebookEntryId);
	}
}

@end
