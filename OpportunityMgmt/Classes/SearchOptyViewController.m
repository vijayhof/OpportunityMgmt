//
//  SearchOptyViewController.m
//
//  Created by Vijayant
//

#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "Opportunity.h"
#import "SearchOptyViewController.h"
#import "OptyProductViewController.h"

@interface SearchOptyViewController ()
@property (nonatomic, strong) NSMutableArray *opportunities;
@end

@implementation SearchOptyViewController

@synthesize searchBar = _searchBar;
@synthesize opportunities = _opportunities;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.opportunities = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)closeDialog:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	self.searchBar.text = @"";
	[self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
    
    NSString* optySearchQuery = [NSString stringWithFormat:@"FIND {%@*} IN NAME FIELDS RETURNING Opportunity(Id, Name, Amount, CloseDate) LIMIT 25",
                                 searchBar.text];

    // SF Rest Query
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForSearch:optySearchQuery];

    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    // jsonResponse is of type NSArrary
    NSLog(@"here4 %@", jsonResponse);

    NSLog(@"request:didLoadResponse: #records: %d", (int)((NSArray *)jsonResponse).count);
    self.opportunities = [[NSMutableArray alloc] initWithCapacity:(int)((NSArray *)jsonResponse).count];
    dispatch_async(dispatch_get_main_queue(), ^{
        for(id jsonObj in (NSArray*) jsonResponse)
        {
            [self.opportunities addObject:[Opportunity jsonToObject:((NSDictionary*)jsonObj)]];
        }
        [self.tableView reloadData];
    });
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.opportunities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOptyTableCell"];
    
    Opportunity *opty = [self.opportunities objectAtIndex:indexPath.row];
    cell.textLabel.text = opty.name;
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"SearchOptyToOptyProducts"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Opportunity *opty = [self.opportunities objectAtIndex:indexPath.row];
		OptyProductViewController *controller = [segue destinationViewController];
		controller.optyId = opty.optyId;
	}

}


@end
