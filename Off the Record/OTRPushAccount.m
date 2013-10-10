//
//  OTRPushAccount.m
//  Off the Record
//
//  Created by Christopher Ballinger on 5/26/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTRPushAccount.h"
#import "Strings.h"
#import "OTRPushManager.h"
#import "OTRPushAPIClient.h"

@implementation OTRPushAccount

@synthesize OAuthCredential = _OAuthCredential;

- (NSString *) imageName {
    return @"ipad.png";
}

- (NSString *)providerName
{
    return CHATSECURE_PUSH_STRING;
}

- (Class)protocolClass {
    return [OTRPushManager class];
}

-(OTRAccountType)accountType
{
    return OTRAccountTypePush;
}

-(OTRAccountProtocol)protocol
{
    return OTRAccountProtocolPush;
}
-(NSString *)protocolString
{
    return kOTRProtocolTypePush;
}

-(AFOAuthCredential *)OAuthCredential
{
    if (!_OAuthCredential) {
        _OAuthCredential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.username];
    }
    return _OAuthCredential;
}

-(void)setOAuthCredential:(AFOAuthCredential *)OAuthCredential
{
    if (![OAuthCredential isEqual:_OAuthCredential]) {
        [AFOAuthCredential storeCredential:OAuthCredential withIdentifier:self.username];
    }
    _OAuthCredential = OAuthCredential;
}

@end
