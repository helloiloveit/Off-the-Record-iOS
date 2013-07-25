//
//  OTRNewAccountTableView.m
//  Off the Record
//
//  Created by David on 7/25/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTRNewAccountTableView.h"
#import "Strings.h"
#import "OTRProtocol.h"
#import "OTRConstants.h"
#import "QuartzCore/QuartzCore.h"
#import "OTRManagedXMPPAccount.h"
#import "OTRManagedOscarAccount.h"

#define rowHeight 70
#define kDisplayNameKey @"displayNameKey"
#define kNameKey @"NameKey"
#define kProviderImageKey @"providerImageKey"

@implementation OTRNewAccountTableView

@synthesize accountSelectCallback;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        //Facebook
        NSDictionary *facebookAccount = @{kNameKey:EN_FACEBOOK_STRING,kDisplayNameKey:FACEBOOK_STRING,kProviderImageKey:kFacebookImageName};
        
        //Google Chat
        NSDictionary *googleAccount = @{kNameKey:EN_GOOGLE_TALK_STRING,kDisplayNameKey:GOOGLE_TALK_STRING,kProviderImageKey:kGTalkImageName};
        
        //Jabber
        NSDictionary *jabberAccount = @{kNameKey:EN_JABBER_STRING,kDisplayNameKey:JABBER_STRING,kProviderImageKey:kXMPPImageName};
        
        //Aim
        NSDictionary *aimAccount = @{kNameKey:EN_AIM_STRING,kDisplayNameKey:AIM_STRING,kProviderImageKey:kAIMImageName};
        
        accounts = @[facebookAccount,googleAccount,jabberAccount,aimAccount];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accounts count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary * cellAccount = [accounts objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellAccount objectForKey:kDisplayNameKey];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
    cell.imageView.image = [UIImage imageNamed:[cellAccount objectForKey:kProviderImageKey]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if( [[cellAccount objectForKey:kDisplayNameKey] isEqualToString:FACEBOOK_STRING])
    {
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 10.0;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OTRManagedAccount * cellAccount = [self accountForName:[accounts objectAtIndex:indexPath.row][kNameKey]];
    //NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    //[context MR_saveToPersistentStoreAndWait];
    
    if (accountSelectCallback) {
        accountSelectCallback(cellAccount);
    }
}


-(OTRManagedAccount *)accountForName:(NSString *)name
{
    //Facebook
    OTRManagedAccount * newAccount;
    if([name isEqualToString:EN_FACEBOOK_STRING])
    {
        OTRManagedXMPPAccount * facebookAccount = [OTRManagedXMPPAccount MR_createEntity];
        [facebookAccount setDefaultsWithDomain:kOTRFacebookDomain];
        newAccount = facebookAccount;
    }
    else if([name isEqualToString:EN_GOOGLE_TALK_STRING])
    {
        //Google Chat
        OTRManagedXMPPAccount * googleAccount = [OTRManagedXMPPAccount MR_createEntity];
        [googleAccount setDefaultsWithDomain:kOTRGoogleTalkDomain];
        newAccount = googleAccount;
    }
    else if([name isEqualToString:EN_JABBER_STRING])
    {
        //Jabber
        OTRManagedXMPPAccount * jabberAccount = [OTRManagedXMPPAccount MR_createEntity];
        [jabberAccount setDefaultsWithDomain:@""];
        newAccount = jabberAccount;
    }
    else if([name isEqualToString:EN_AIM_STRING])
    {
        //Aim
        OTRManagedOscarAccount * aimAccount = [OTRManagedOscarAccount MR_createEntity];
        [aimAccount setDefaultsWithProtocol:kOTRProtocolTypeAIM];
        newAccount = aimAccount;
    }
    return newAccount;
}




@end
