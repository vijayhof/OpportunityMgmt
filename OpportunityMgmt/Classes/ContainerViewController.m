//
//  ContainerViewController.m
//
//  Created by Vijayant.
//

#import <QuartzCore/QuartzCore.h>

#import "NSDictionary+Additions.h"
#import "ContainerViewController.h"
#import "RootUINavigationViewController.h"
#import "LeftPanelViewController.h"

#import "SFAuthenticationManager.h"

#define SLIDE_TIMING .25

#define CORNER_RADIUS 4
#define PANEL_WIDTH 60

@interface ContainerViewController () <SlideOutViewControllerDelegate>

@property (nonatomic, strong) RootUINavigationViewController *rootNavController;
@property (nonatomic, strong) LeftPanelViewController *leftPanelController;

@property (nonatomic, assign) BOOL showingLeftPanel;

@end

@implementation ContainerViewController


#pragma mark - Standard Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set default value to not show left panel (for slide out)
    _showingLeftPanel = NO;
    
    [self setupView];
}

- (void)setupView
{
    // setup center view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainiPhoneStoryboard" bundle:nil];
    _rootNavController = (RootUINavigationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RootNavViewController"];
    
    [self addChildViewController:_rootNavController];
    
    [self.view addSubview:_rootNavController.view];
    
    [_rootNavController didMoveToParentViewController:self];
    
    // setup self as slideOutDelegate. will be called when slide out happens
    _rootNavController.slideOutDelegate = self;
}

-(void)toggleSlideOut
{
    NSLog(@"togglerSlideOut");
    if(_showingLeftPanel == NO)
    {
        [self showSlideOut];
    }
    else
    {
        [self hideSlideOut];
    }
}

-(void)showSlideOut
{
    NSLog(@"showSlideOut");
    if(_showingLeftPanel == YES)
    {
        // already showing, return
        return;
    }
    
    // init view if it doesn't already exist
    if (_leftPanelController == nil)
    {
        // this is where you define the view for the left panel
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainiPhoneStoryboard" bundle:nil];
        _leftPanelController = (LeftPanelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LeftPanelVCID"];
        
        [self addChildViewController:_leftPanelController];
        
        _leftPanelController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view addSubview:self.leftPanelController.view];
        [_leftPanelController didMoveToParentViewController:self];
        
                self.leftPanelController.menuItemDelegate = self;
        
    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftPanelController.view;
    
    [self.view sendSubviewToBack:view];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _rootNavController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                         }
                     }];
}

-(void)hideSlideOut
{
    NSLog(@"hideSlideOut");
    if(_showingLeftPanel == NO)
    {
        // already hidden, return
        return;
    }
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _rootNavController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetSlideOut];
                         }
                     }];
    
    
}

-(void)resetSlideOut
{
    // remove left view and reset variables, if needed
    if (_leftPanelController != nil)
    {
        [self.leftPanelController.view removeFromSuperview];
        self.leftPanelController = nil;
        
        //        _rootNavController.leftButton.tag = 1;
        self.showingLeftPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}


- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
    {
        [_rootNavController.view.layer setCornerRadius:CORNER_RADIUS];
        [_rootNavController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_rootNavController.view.layer setShadowOpacity:0.8];
        [_rootNavController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    else
    {
        [_rootNavController.view.layer setCornerRadius:0.0f];
        [_rootNavController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (void)menuItemSelected:(NSString *)menuItemStr
{
    // hide the slide out after the menu item is selected
    [self hideSlideOut];
    
     // better mechanism than string compare
    if([menuItemStr isEqualToString:@"Logout"])
    {
        [[SFAuthenticationManager sharedManager] logout];
    }
    else
    {
        [_rootNavController doMenuItemSelected:menuItemStr];
    }
}


@end
