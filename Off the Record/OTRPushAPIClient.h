//
//  OTRPushAPIClient.h
//  Off the Record
//
//  Created by Christopher Ballinger on 9/29/12.
//  Copyright (c) 2012 Chris Ballinger. All rights reserved.
//

#import "AFHTTPClient.h"
#import "OTRPushAccount.h"
#import "AFOAuth2Client.h"

@interface OTRPushAPIClient : AFHTTPClient


@property (nonatomic,strong) AFOAuth2Client * oAuth2Client;

- (void) connectAccount:(OTRPushAccount*)account password:(NSString*)password successBlock:(void (^)(OTRPushAccount* loggedInAccount))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

- (void) createAccount:(OTRPushAccount*)account password:(NSString*)password successBlock:(void (^)(OTRPushAccount* loggedInAccount))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

- (void) sendPushToBuddy:(OTRManagedBuddy*)buddy successBlock:(void (^)(void))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

- (void) updatePushTokenForAccount:(OTRPushAccount*)account token:(NSData *)devicePushToken successBlock:(void (^)(void))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

- (void)refreshTokenIfNeededforAccount:(OTRPushAccount *)account successBlock:(void (^)(AFOAuthCredential * OAuthcredential))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

- (void)fetchTokenForUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(AFOAuthCredential * OAuthcredential))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

- (void)sendMessage:(NSString *)message toBuddy:(OTRManagedBuddy*)buddy successBlock:(void (^)(void))successBlock failureBlock:(void (^)(NSError *error))failureBlock;


+ (void)fetchTokenForUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(AFOAuthCredential * OAuthcredential))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
@end
