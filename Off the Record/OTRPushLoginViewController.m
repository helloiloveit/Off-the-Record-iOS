//
//  OTRPushLoginViewController.m
//  Off the Record
//
//  Created by Christopher Ballinger on 5/26/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTRPushLoginViewController.h"
#import "OTRPushAPIClient.h"
#import "OTRPushManager.h"

@interface OTRPushLoginViewController ()

@end

@implementation OTRPushLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && [self.account.username length] && self.account.OAuthCredential) {
        return 1;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && self.account.OAuthCredential && self.account.username) {
        return 55.0f;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    if (section == 0 && self.account.OAuthCredential && self.account.username) {
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, 55);
        CGRect buttonFrame = CGRectMake(8, 8, tableView.frame.size.width-16, 45);
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = buttonFrame;
        [button setTitle:@"Disconnect Push Account" forState:UIControlStateNormal];
        [view addSubview:button];
    }
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    if (indexPath.section == 0 && [self.account.username length] && self.account.OAuthCredential) {
        
        if (indexPath.section == 0) {
            if (self.account.OAuthCredential && [self.account.username length]) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"accountCell"];
                cell.textLabel.text = USERNAME_STRING;
                cell.detailTextLabel.text = self.account.username;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

-(void)loginButtonPressed:(id)sender
{
    
    if (self.account.OAuthCredential && [self.account.username length]) {
        OTRPushManager * pushManager = [[OTRProtocolManager sharedInstance] protocolForAccount:self.account];
        [pushManager refreshToken];
        [OTRPushManager registerForPushNotifications];
    }
    else
    {
        NSString * username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [OTRPushAPIClient fetchTokenForUsername:username password:password successBlock:^
         (AFOAuthCredential *OAuthcredential) {
             self.account.username = username;
             self.account.OAuthCredential =OAuthcredential;
             NSManagedObjectContext * context = [NSManagedObjectContext MR_contextForCurrentThread];
             [context MR_saveOnlySelfAndWait];
             OTRPushManager * pushManager = [[OTRProtocolManager sharedInstance] protocolForAccount:self.account];
             [pushManager refreshToken];
             [OTRPushManager registerForPushNotifications];
            NSLog(@"Credential %@",OAuthcredential);
        } failureBlock:^(NSError *error) {
            NSLog(@"error %@",error);
        }];
    }
}

- (void) setupCells {
    if (!self.account.OAuthCredential && ![self.account.username length]) {
        [self addCellinfoWithSection:0 row:0 labelText:EMAIL_STRING cellType:kCellTypeTextField userInputView:self.usernameTextField];
        [self addCellinfoWithSection:0 row:1 labelText:PASSWORD_STRING cellType:kCellTypeTextField userInputView:self.passwordTextField];
    }
    
    //[self addCellinfoWithSection:0 row:2 labelText:REMEMBER_PASSWORD_STRING cellType:kCellTypeSwitch userInputView:self.rememberPasswordSwitch];
}

@end
