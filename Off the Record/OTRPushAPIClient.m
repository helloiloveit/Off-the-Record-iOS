//
//  OTRPushAPIClient.m
//  Off the Record
//
//  Created by Christopher Ballinger on 9/29/12.
//  Copyright (c) 2012 Chris Ballinger. All rights reserved.
//

#import "OTRPushAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "OTRPushController.h"
#import "OTRPushAccount.h"
#import "NSData+XMPP.h"
#import "OTRProtocolManager.h"
#import "OTRPushManager.h"

#define NSERROR_DOMAIN @"OTRPushAPIClientError"

#define SERVER_URL @"http://172.16.42.116:8000/"

@implementation OTRPushAPIClient

@synthesize oAuth2Client =_oAuth2Client;

+ (NSURL *)apiUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,@"api/"]];
}
+ (NSURL *)authUrl
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,@"o/token/"]];
}

-(AFOAuth2Client *)oAuth2Client
{
    if (!_oAuth2Client) {
        _oAuth2Client = [[AFOAuth2Client alloc] initWithBaseURL:[[self class] authUrl] clientID:@"testId" secret:@"testSecret"];
    }
    return _oAuth2Client;
}

- (id)init
{
    self = [self initWithBaseURL:[[self class] apiUrl]];
    if (!self) {
        return nil;
    }
    return self;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    //self.parameterEncoding = AFJSONParameterEncoding;
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (NSMutableURLRequest*) requestWithMethod:(NSString*)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    request.HTTPShouldHandleCookies = YES;
    return request;
}

- (void) processAccount:(OTRPushAccount*)account parameters:(NSDictionary*)parameters successBlock:(void (^)(OTRPushAccount* loggedInAccount))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    if (account.isConnected.boolValue) {
        if (failureBlock) {
            failureBlock([NSError errorWithDomain:NSERROR_DOMAIN code:123 userInfo:@{NSLocalizedDescriptionKey: @"Account already connected."}]);
        }
        return;
    }
    [self postPath:@"account/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            BOOL success = [[responseObject objectForKey:@"success"] boolValue];
            if (success) {
                OTRPushManager *pushManager = [[OTRProtocolManager sharedInstance] protocolForAccount:account];
                pushManager.isConnected = YES;
                NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
                OTRPushAccount *localAccount = (OTRPushAccount*)[localContext existingObjectWithID:account.objectID error:nil];
                localAccount.isConnected = @(YES);
                [localContext MR_saveToPersistentStoreAndWait];
                if (successBlock) {
                    successBlock(localAccount);
                }
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            } else {
                error = [NSError errorWithDomain:NSERROR_DOMAIN code:100 userInfo:@{NSLocalizedDescriptionKey: @"Success is false.", @"data": responseObject}];
            }
        } else {
            error = [NSError errorWithDomain:NSERROR_DOMAIN code:102 userInfo:@{NSLocalizedDescriptionKey: @"Response object not dictionary.", @"data": responseObject}];
        }
        if (error && failureBlock) {
            failureBlock(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error && failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void) connectAccount:(OTRPushAccount*)account password:(NSString*)password successBlock:(void (^)(OTRPushAccount* loggedInAccount))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    if ([account.username length] && [password length]) {
        [self processAccount:account parameters:@{@"email": account.username, @"password": password, @"create": @(YES)} successBlock:successBlock failureBlock:failureBlock];
    }
    else if(failureBlock)
    {
        failureBlock(nil);
    }
    
}

- (void) createAccount:(OTRPushAccount*)account password:(NSString*)password successBlock:(void (^)(OTRPushAccount* loggedInAccount))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    [self processAccount:account parameters:@{@"email": account.username, @"password": password, @"create": @(YES)} successBlock:successBlock failureBlock:failureBlock];
}

- (void) sendPushToBuddy:(OTRManagedBuddy*)buddy successBlock:(void (^)(void))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    [self postPath:@"knock/" parameters:@{@"email": buddy.accountName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            BOOL success = [[responseObject objectForKey:@"success"] boolValue];
            if (success) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                error = [NSError errorWithDomain:NSERROR_DOMAIN code:100 userInfo:@{NSLocalizedDescriptionKey: @"Success is false.", @"data": responseObject}];
            }
        } else {
            error = [NSError errorWithDomain:NSERROR_DOMAIN code:102 userInfo:@{NSLocalizedDescriptionKey: @"Response object not dictionary.", @"data": responseObject}];
        }
        if (error && failureBlock) {
            failureBlock(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


- (void) updatePushTokenForAccount:(OTRPushAccount*)account token:(NSData *)devicePushToken successBlock:(void (^)(void))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    NSDictionary *parameters = @{@"device_type": @"iPhone", @"operating_system": @"iOS", @"apple_push_token": [devicePushToken hexStringValue]};
    
    if (account) {
        [self postPath:@"device/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Token updated: %@", responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                BOOL success = [[responseObject objectForKey:@"success"] boolValue];
                if (success) {
                    if (successBlock) {
                        successBlock();
                    }
                    return;
                }
            }
            if (failureBlock) {
                failureBlock([NSError errorWithDomain:NSERROR_DOMAIN code:101 userInfo:@{NSLocalizedDescriptionKey: @"Data is not good!", @"data": responseObject}]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
    
}

- (void)refreshTokenIfNeededforAccount:(OTRPushAccount *)account successBlock:(void (^)(AFOAuthCredential * OAuthcredential))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    if ([account.username length]) {
        AFOAuthCredential * credential = account.OAuthCredential;
        if (credential.isExpired) {
            [self.oAuth2Client authenticateUsingOAuthWithPath:nil refreshToken:credential.refreshToken success:^(AFOAuthCredential *credential) {
                account.OAuthCredential = credential;
                if (successBlock) {
                    successBlock(credential);
                }
            } failure:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        }
        else {
            
            if (successBlock) {
                successBlock(credential);
            }
            else if (failureBlock){
                failureBlock(nil);
            }
            
        }
    }
    
}

- (void)fetchTokenForUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(AFOAuthCredential * OAuthcredential))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    [self.oAuth2Client authenticateUsingOAuthWithPath:nil username:username password:password scope:nil success:^(AFOAuthCredential *credential) {
        if (successBlock) {
            [AFOAuthCredential storeCredential:credential withIdentifier:username];
            successBlock(credential);
        }
    } failure:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)sendMessage:(NSString *)message toBuddy:(OTRManagedBuddy *)buddy successBlock:(void (^)(void))successBlock failureBlock:(void (^)(NSError *))failureBlock
{
    [self postPath:@"message/" parameters:@{@"email":buddy.accountName,@"text":message} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark
- (void)setAuthorizationHeaderWithToken:(NSString *)token {
    // Use the "Bearer" type as an arbitrary default
    [self setAuthorizationHeaderWithToken:token ofType:@"Bearer"];
}

- (void)setAuthorizationHeaderWithCredential:(AFOAuthCredential *)credential {
    [self setAuthorizationHeaderWithToken:credential.accessToken ofType:credential.tokenType];
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token
                                 ofType:(NSString *)type
{
    // See http://tools.ietf.org/html/rfc6749#section-7.1
    if ([[type lowercaseString] isEqualToString:@"bearer"]) {
        [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", token]];
    }
}

+ (void)fetchTokenForUsername:(NSString *)username password:(NSString *)password successBlock:(void (^)(AFOAuthCredential * OAuthcredential))successBlock failureBlock:(void (^)(NSError *error))failureBlock
{
    [[[self alloc] init] fetchTokenForUsername:username password:password successBlock:successBlock failureBlock:failureBlock];
}

@end
