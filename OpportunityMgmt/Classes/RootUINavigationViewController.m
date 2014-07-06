//
//  RootUINavigationViewController.m
//
//  Created by Vijayant.
//

#import "RootUINavigationViewController.h"
#import "RecentOptyViewController.h"


@implementation RootUINavigationViewController

@synthesize slideOutDelegate = _slideOutDelegate;

#pragma mark - Standard Methods

- (void)toggleSlideOutAction
{
    [self.slideOutDelegate toggleSlideOut];
}

- (void)doMenuItemSelected:(NSString*)menuItemStr
{
    NSLog(@"doMenuItemSelected:%@", menuItemStr);

    if(![self validateTopLevelViewController:@"RecentOptyViewController"])
    {
        [self showErrorAlert];
        return;
    }
    
    RecentOptyViewController* controller = (RecentOptyViewController *)[self visibleViewController];
    if([menuItemStr isEqualToString:@"Search Opportunities"])
    {
        [controller performSegueWithIdentifier:@"RecentOptyToSearchOptys" sender:self];
    }
    else if([menuItemStr isEqualToString:@"Give Feedback"])
    {
        [controller performSegueWithIdentifier:@"RecentOptyToFeedback" sender:self];
    }
    else if([menuItemStr isEqualToString:@"Help"])
    {
        [controller performSegueWithIdentifier:@"RecentOptyToHelp" sender:self];
    }
    else
    {
        [self showErrorAlert];
        return;
    }
}

- (void) showErrorAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error occurred"
                                                        message:@"Cannot navigate to chosen option"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (BOOL) validateTopLevelViewController:(NSString*) viewControllerName
{
    Class vcClass = NSClassFromString(viewControllerName);
    
    if([[self visibleViewController] isMemberOfClass:vcClass])
    {
        return YES;
    }

    if([[[self viewControllers] objectAtIndex:0] isMemberOfClass:vcClass])
    {
        [self popToRootViewControllerAnimated:YES];
        return YES;
    }

    // worst case, need to setup home page (aka recent opty) as root controller for ui
    // navigation controller (self here). Not doing it right now, as it is overkill
    
    return NO;
}

@end
