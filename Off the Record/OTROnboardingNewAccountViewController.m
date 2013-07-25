//
//  OTROnboardingNewAccountViewController.m
//  Off the Record
//
//  Created by David on 7/25/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTROnboardingNewAccountViewController.h"
#import "OTRNewAccountTableView.h"
#import "OTRLoginViewController.h"

@interface OTROnboardingNewAccountViewController ()

@end

@implementation OTROnboardingNewAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	OTRNewAccountTableView * tableView = [[OTRNewAccountTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.scrollEnabled = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.accountSelectCallback = ^(OTRManagedAccount * newAccount)
    {
        OTRLoginViewController *loginViewController = [OTRLoginViewController loginViewControllerWithAcccountID:newAccount.objectID];
        loginViewController.isNewAccount = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    };
    
    [self.view addSubview:tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
