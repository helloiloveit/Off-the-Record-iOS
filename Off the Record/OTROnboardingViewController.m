//
//  OTROnboardingViewController.m
//  Off the Record
//
//  Created by Christopher Ballinger on 6/22/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTROnboardingViewController.h"

#import "OTRDescriptionOnboardingView.h"

@interface OTROnboardingViewController ()

@end

@implementation OTROnboardingViewController

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
	self.view = [[OTRDescriptionOnboardingView alloc] initWithFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
