//
//  OptyProductViewController.m
//
//  Created by Vijayant
//

#import "NSDictionary+Additions.h"

#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "Opportunity.h"
#import "OpportunityProduct.h"
#import "PricebookEntry.h"

#import "OptyProductCell.h"
#import "OptyProductViewController.h"
#import "SearchProductViewController.h"
#import "AddOptyProductViewController.h"
#import "Util.h"

@interface OptyProductViewController ()
{
    BOOL _unwindSelectedProductExecuted;
    BOOL _unwindAddProductExecuted;
    UIActivityIndicatorView* _spinner1;
    
}

@property (nonatomic, strong) Opportunity* opportunity;
@property (nonatomic, strong) NSMutableArray *optyProducts;

// to store the selected pricebook entry from Add Products page
@property (strong, nonatomic) PricebookEntry *selectedPbe;

@end

@implementation OptyProductViewController

@synthesize optyId = _optyId;
@synthesize opportunity = _opportunity;
@synthesize optyProducts = _optyProducts;
@synthesize selectedPbe = _selectedPbe;


#pragma mark - Standard Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
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

    [self doExecuteOptyProductQuery];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    if(_unwindSelectedProductExecuted)
    {
        _unwindSelectedProductExecuted = NO;
        [self performSegueWithIdentifier:@"OptyProductsToAddProduct" sender:@""];
    }
    
    if(_unwindAddProductExecuted)
    {
        _unwindAddProductExecuted = NO;
        [self doExecuteOptyProductQuery];
    }
    
}

- (void)doExecuteOptyProductQuery
{
    _spinner1.hidden = NO;
    [_spinner1 startAnimating];

	self.optyProducts = [NSMutableArray array];
    
    NSString* optyProductSearchQuery = [NSString stringWithFormat:@"SELECT Id, Name, Pricebook2Id, (SELECT Id, OpportunityId, Description, Quantity, ListPrice, UnitPrice, TotalPrice, ServiceDate, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PricebookEntry.Product2.Description, PricebookEntry.Product2.Family, PricebookEntry.Product2.Name, PricebookEntry.Product2.ProductCode FROM OpportunityLineItems ORDER BY SortOrder) FROM Opportunity WHERE Id='%@'", self.optyId];
    
    NSLog(@"optyProductSearchQuery= %@", optyProductSearchQuery);
    
    // SF Rest Query
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:optyProductSearchQuery];
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
    // jsonResponse is of type NSArrary
    NSLog(@"here4 %@ %d", jsonResponse, [jsonResponse isKindOfClass:[NSArray class]]);
    
    // get/set opportunity
    NSArray *records = [jsonResponse objectForKeyNotNull:@"records"];
    NSLog(@"request:didLoadResponse: #records: %d", (int)records.count);
    NSDictionary* optyJsonObj = [records objectAtIndex:0];
    if([optyJsonObj count] == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishExecuteQuery];
        });
        return;
    }
    
    self.opportunity = [Opportunity jsonToObject:((NSDictionary*)optyJsonObj)];
    NSLog(@"Opportunity=%@", self.opportunity);
    
    // get line items
    NSDictionary* optyLineItemsJsonObj = [optyJsonObj objectForKeyNotNull:@"OpportunityLineItems"];
    if ([optyLineItemsJsonObj count] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishExecuteQuery];
        });
        return;
    }
    
    NSArray *lineRecords = [optyLineItemsJsonObj objectForKeyNotNull:@"records"];
    
    if(lineRecords != nil && (int) lineRecords.count > 0)
    {
        self.optyProducts = [[NSMutableArray alloc] initWithCapacity:(int)lineRecords.count];

        for(id jsonObj in lineRecords)
        {
            [self.optyProducts addObject:[OpportunityProduct jsonToObject:((NSDictionary*)jsonObj)]];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self finishExecuteQuery];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishExecuteQuery];
        });
    }
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error
{
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    [self finishExecuteQuery];
}

- (void)requestDidCancelLoad:(SFRestRequest *)request
{
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
    [self finishExecuteQuery];
}

- (void)requestDidTimeout:(SFRestRequest *)request
{
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
    [self finishExecuteQuery];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.optyProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	OptyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptyProductTableCell"];
    
    OpportunityProduct *optyProduct = [self.optyProducts objectAtIndex:indexPath.row];
    cell.pricebookEntry_product2_Name.text = optyProduct.pricebookEntry_product2_Name;
    cell.quantity.text = [Util formatDecimalNumber:optyProduct.quantity];
    cell.totalPrice.text = [Util formatCurrencyWithoutSymbol:optyProduct.totalPrice];
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark - IBActions

- (IBAction)closeDialog:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addProductAction:(id)sender
{
    NSLog(@"addProductAction='%@'", self.opportunity.pricebook2Id);
    
    if(self.opportunity.pricebook2Id == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty Pricebook"
                                                            message:@"Please choose a Pricebook for the opportunity before proceeding"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else
    {
        [self performSegueWithIdentifier:@"OptyProductsToSearchProducts" sender:self];
    }
}


#pragma mark - Segue Methods

//
// after product is selected from SearchProduct page
//
- (IBAction)productSelected:(UIStoryboardSegue *)segue
{
    SearchProductViewController* controller = [segue sourceViewController];
    self.selectedPbe = controller.selectedPbe;
    _unwindSelectedProductExecuted = YES;
}

//
// called from Cancel in AddProduct page
//
- (IBAction)cancelAddProduct:(UIStoryboardSegue *)segue
{
    // do nothing
}

- (IBAction)saveAddProduct:(UIStoryboardSegue *)segue
{
    // do nothing
    _unwindAddProductExecuted = YES;
}

//- (void)addOptyProductViewControllerDidSave:(AddOptyProductViewController *)controller
//{
//    NSLog(@"optyproduct:addOptyProductViewControllerDidSave");
////    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString*)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"OptyProductsToSearchProducts"])
    {
        if (self.opportunity.pricebook2Id == nil) {
            return NO;
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
	if ([segue.identifier isEqualToString:@"OptyProductsToAddProduct"])
    {
        // pass optyId and pricebookEntryId to AddProducts page
        
        AddOptyProductViewController *controller = [segue destinationViewController];
        controller.optyId = self.opportunity.optyId;
        controller.pricebookEntry = self.selectedPbe;
        //        controller.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"OptyProductsToSearchProducts"])
    {
        // pass pricebook2Id to SearchProducts page
        UINavigationController *navController = [segue destinationViewController];
        SearchProductViewController *controller =[[navController viewControllers]objectAtIndex:0];
        controller.filterPricebook2Id = self.opportunity.pricebook2Id;
	}
}

@end
