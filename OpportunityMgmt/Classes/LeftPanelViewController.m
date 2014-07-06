//
//  LeftPanelViewController.m
//
//  Created by Vijayant.
//

#import "LeftPanelViewController.h"

#import "SFAccountManager.h"
#import "SFIdentityData.h"

@interface LeftPanelViewController ()

@property (nonatomic, weak) IBOutlet UITableView *myTableView;
//@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;

@property (nonatomic, strong) NSMutableArray *arrayOfMenuItems;

@end

@implementation LeftPanelViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // without this line, the background color from xib file doesn't take effect. That is, when you change it from it's default background color.
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    [self setupMenuArray];
    NSString* name = [SFAccountManager sharedInstance].idData.displayName;
    NSString* email = [SFAccountManager sharedInstance].idData.email;

    NSLog(@"display name=%@", name);
    if(name)
    {
        _displayNameLabel.text = name;
    }

    if(email)
    {
        _emailLabel.text = email;
    }
}

#pragma mark -
#pragma mark Array Setup

- (void)setupMenuArray
{
    NSArray *menuItems = @[@"Give Feedback", @"Help", @"Logout"];
    
    self.arrayOfMenuItems = [NSMutableArray arrayWithArray:menuItems];
    
    [self.myTableView reloadData];
}

#pragma mark -
#pragma mark UITableView Datasource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayOfMenuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
    
    // Configure the cell to show the data.
	NSString* str = [_arrayOfMenuItems objectAtIndex:indexPath.row];
	cell.textLabel.text =  str;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [self.arrayOfMenuItems objectAtIndex:indexPath.row];
    
    [_menuItemDelegate menuItemSelected:str];
}


@end
