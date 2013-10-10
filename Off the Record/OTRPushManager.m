//
//  OTRPushManager.m
//  Off the Record
//
//  Created by Christopher Ballinger on 5/26/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTRPushManager.h"
#import "OTRConstants.h"
#import "OTRPushAPIClient.h"

@interface OTRPushManager()
@end

@implementation OTRPushManager
@synthesize account, isConnected;

-(id)initWithAccount:(OTRPushAccount *)newAccount
{
    if (self = [self init]) {
        self.account = newAccount;
        self.httpClient = [[OTRPushAPIClient alloc] init];
        [self refreshToken];
    }
    return self;
}

- (void)refreshToken
{
    if (self.account.OAuthCredential) {
        [self.httpClient refreshTokenIfNeededforAccount:self.account successBlock:^(AFOAuthCredential *OAuthcredential) {
            self.account.OAuthCredential = OAuthcredential;
            [self.httpClient setAuthorizationHeaderWithToken:OAuthcredential.accessToken];
        } failureBlock:^(NSError *error) {
            NSLog(@"Refresh token Error: %@",error);
        }];
        
    }
}

- (void) sendMessage:(OTRManagedMessage*)message {
    
}
- (void) connectWithPassword:(NSString *)password {
    
    [self.httpClient connectAccount:self.account password:password successBlock:^(OTRPushAccount *loggedInAccount) {
        self.isConnected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kOTRProtocolLoginSuccess object:nil];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error connecting: %@", error.userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:kOTRProtocolLoginFail object:nil];
        self.isConnected = NO;
    }];
}
- (void) disconnect {
    self.isConnected = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kOTRProtocolDiconnect object:nil];

}
- (void) addBuddy:(OTRManagedBuddy *)newBuddy {
    NSLog(@"push buddy added: %@", newBuddy);
}

-(void) removeBuddies:(NSArray *)buddies {
    
}
-(void) blockBuddies:(NSArray *)buddies {
    
}

+ (void) registerForPushNotifications {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

@end
