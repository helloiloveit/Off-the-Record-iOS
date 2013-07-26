//
//  OTROnboardingViewController.m
//  Off the Record
//
//  Created by Christopher Ballinger on 6/22/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTROnboardingViewController.h"

#import "OTROnboardingDescriptionView.h"
#import "OTROnboardingNewAccountViewController.h"
#import "OTRManagedAccount.h"

@interface OTROnboardingViewController ()

@end

@implementation OTROnboardingViewController

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    OTROnboardingDescriptionView * descriptionView = [[OTROnboardingDescriptionView alloc] initWithFrame:self.view.bounds];
    descriptionView.actionButtonCallback = ^(OTROnboardingView *onboardingView){
        if([[OTRManagedAccount MR_numberOfEntities] intValue])
        {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }
        else{
            OTROnboardingNewAccountViewController * viewController = [[OTROnboardingNewAccountViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    };
    
    
    [self.view addSubview:descriptionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
