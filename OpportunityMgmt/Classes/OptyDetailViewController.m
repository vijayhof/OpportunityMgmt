//
//  OptyDetailViewController.m
//
//  Created by Vijayant
//

#import "NSDictionary+Additions.h"

#import "SFRestAPI.h"
#import "SFRestRequest.h"

#import "Opportunity.h"
#import "OptyDetailViewController.h"

@interface OptyDetailViewController ()

@property (nonatomic, strong) Opportunity *opportunity;

@end

@implementation OptyDetailViewController

@synthesize optyId = _optyId;
@synthesize opportunity = _opportunity;

@synthesize optyNameLabel = _optyNameLabel;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    NSString* optyQuery = [NSString stringWithFormat:@"SELECT Id, Name, Pricebook2Id FROM Opportunity WHERE Id='%@'", self.optyId];

    NSLog(@"vDL:OptyDetailViewController %@", optyQuery);
    
    //Here we use a query that should work on either Force.com or Database.com
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:optyQuery];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    // jsonResponse is of type NSArrary
    NSLog(@"dLR:OptyDetailViewController %@ %d", jsonResponse, [jsonResponse isKindOfClass:[NSArray class]]);

    NSArray *records = [jsonResponse objectForKeyNotNull:@"records"];

    NSLog(@"request:didLoadResponse: #records: %d", (int)records.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        for(id jsonObj in records)
        {
            self.opportunity = [Opportunity jsonToObject:((NSDictionary*)jsonObj)];
            break;
        }
        
        self.optyNameLabel.text = self.opportunity.name;
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"browseAlbums"]) {
//        BrowseAlbumsViewController *controller = [segue destinationViewController];
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        controller.artist = [self.artists objectAtIndex:indexPath.row];
//    }
//}

@end
