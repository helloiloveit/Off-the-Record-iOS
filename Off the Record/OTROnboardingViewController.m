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
    descriptionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIScrollView * sview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sview.contentSize = descriptionView.frame.size;
    sview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [sview addSubview:descriptionView];
    
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
    
    
    [self.view addSubview:sview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}
@end
