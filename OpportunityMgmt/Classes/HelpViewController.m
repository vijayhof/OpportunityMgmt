//
//  HelpViewController.m
//
//  Created by Vijayant
//

#import "HelpViewController.h"

@implementation HelpViewController

@synthesize versionLbl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.versionLbl.text = [[NSString alloc] initWithFormat:@"Version %@", [self readVersionFromPlist]];
//    NSString* str = @"© OpenStreetMap \u00a9";
//        self.versionLbl.text = str;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (NSString *) readVersionFromPlist
{
    NSString* value = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return value;
}

@end
