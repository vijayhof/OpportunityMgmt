//
//  RecentOptyViewController.m
//
//  Created by Vijayant
//

#import "NSDictionary+Additions.h"
#import "RecentOptyViewController.h"
#import "RecentOptyCell.h"
#import "RootUINavigationViewController.h"

#import "SFRestAPI.h"
#import "SFRestAPI+Blocks.h"
#import "SFRestRequest.h"
#import "OptyProductViewController.h"

#import "Opportunity.h"

@interface RecentOptyViewController ()
{
    UIRefreshControl* _refreshControl;
    UIActivityIndicatorView* _spinner1;
    UIActivityIndicatorView* _spinner2;
    
    NSMutableArray *_dataRows;
    NSMutableArray *_searchResults;
    
    // opty id value. this value can come from either normal table view or search table view
    // it is used to pass value from this controller to the next (thru segue)
    NSString *selectedOptyId;
}

@end

@implementation RecentOptyViewController

#pragma mark - Standard Methods

- (void)dealloc
{
    _dataRows = nil;
    _searchResults = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add refresh control
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(doRefreshControl:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:_refreshControl];
    
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
    
    _spinner2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner2 setColor:[UIColor grayColor]];
    _spinner2.center = _spinner1.center;
    [self.searchDisplayController.searchResultsTableView addSubview:_spinner2];
    [self.searchDisplayController.searchResultsTableView bringSubviewToFront:_spinner2];
    _spinner2.hidesWhenStopped = YES;
    _spinner2.hidden = YES;
    
    
    [self doExecuteRecentOptyQuery];
}

- (void) doExecuteRecentOptyQuery
{
    _spinner1.hidden = NO;
    [_spinner1 startAnimating];
    
    NSString* recentOptyQuery = @"SELECT Id, Name FROM RecentlyViewed WHERE Type IN ('Opportunity') ORDER BY LastViewedDate DESC LIMIT 10";
    
    // SF Rest Query
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:recentOptyQuery];
    [[SFRestAPI sharedInstance] sendRESTRequest:request
     
                                      failBlock:^(NSError* error) {
                                          NSLog(@"In error %@", error);
                                          //add your failed error handling here
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self finishExecuteQuery];
                                          });
                                      }
     
                                  completeBlock:^(id jsonResponse) {
                                      
                                      NSLog(@"completeBlock:jsonResponse %@", jsonResponse);
                                      
                                      NSArray *records = [jsonResponse objectForKeyNotNull:@"records"];
                                      _dataRows = [[NSMutableArray alloc] initWithCapacity:(int)records.count];
                                      for(id jsonObj in records)
                                      {
                                          [_dataRows addObject:[Opportunity jsonToObject:((NSDictionary*)jsonObj)]];
                                      }
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData];
                                          [self finishExecuteQuery];
                                      });
                                  }
     ];
}

- (void) finishExecuteQuery
{
    if (_refreshControl.refreshing)
    {
        [_refreshControl endRefreshing];
    }
    
    if([_spinner1 isAnimating])
    {
        [_spinner1 stopAnimating];
    }
    
    if([_spinner2 isAnimating])
    {
        [_spinner2 stopAnimating];
    }
}

- (void) doRefreshControl:(id)sender
{
    [self doExecuteRecentOptyQuery];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //	[self.searchBar resignFirstResponder];
    [self doExecuteOptySearch:searchBar.text];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (void) doExecuteOptySearch:(NSString*) searchText
{
    _spinner2.hidden = NO;
    [_spinner2 startAnimating];
    
    NSString* optySearchQuery = [NSString stringWithFormat:@"FIND {%@*} IN NAME FIELDS RETURNING Opportunity(Id, Name, Amount, CloseDate) LIMIT 25",
                                 searchText];
    
    // SF Rest Query
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForSearch:optySearchQuery];
    
    [[SFRestAPI sharedInstance]
     sendRESTRequest:request
     
     failBlock:^(NSError* error) {
         NSLog(@"In error %@", error);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self finishExecuteQuery];
         });
     }
     
     completeBlock:^(id jsonResponse) {
         // jsonResponse is of type NSArray
         NSLog(@"completeBlock:jsonResponse %@", jsonResponse);
         NSArray* records = (NSArray*) jsonResponse;
         _searchResults = [[NSMutableArray alloc] initWithCapacity:(int)records.count];
         for(id jsonObj in records)
         {
             [_searchResults addObject:[Opportunity jsonToObject:((NSDictionary*)jsonObj)]];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.searchDisplayController.searchResultsTableView reloadData];
             [self finishExecuteQuery];
         });
         
     }
     ];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_searchResults count];
    }
    else
    {
        return [_dataRows count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentOptyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RecentOptyCellID"];
    
	NSDictionary *obj = nil;
    NSString* nameValue = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        obj = [_searchResults objectAtIndex:indexPath.row];
        
    }
    else
    {
        obj = [_dataRows objectAtIndex:indexPath.row];
    }
    
    nameValue = [(Opportunity*) obj name];
    
    cell.optyName.text =  nameValue;
    
	//this adds the arrow to the right hand side.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *obj = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        obj = [_searchResults objectAtIndex:indexPath.row];
        
    }
    else
    {
        obj = [_dataRows objectAtIndex:indexPath.row];
    }

    // set the selected opty id value
    selectedOptyId = [(Opportunity*) obj optyId];
    
    [self performSegueWithIdentifier:@"RecentOptyToOptyProducts" sender:self];

}

#pragma mark - IBAction Methods

- (IBAction)slideOutAction:(id)sender
{
    NSLog(@"slideOutAction");
    RootUINavigationViewController* rootNavController = (RootUINavigationViewController*)self.navigationController;
    [rootNavController toggleSlideOutAction];
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // pass optyId to OptyProducts page
	if ([segue.identifier isEqualToString:@"RecentOptyToOptyProducts"])
    {
		OptyProductViewController *controller = [segue destinationViewController];
		controller.optyId = selectedOptyId;
	}
    
}


@end
