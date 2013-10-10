//
//  OTRPushAccount.h
//  Off the Record
//
//  Created by Christopher Ballinger on 5/26/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "_OTRPushAccount.h"
#import "OTRManagedOAuthAccount.h"

@class AFOAuthCredential;

@interface OTRPushAccount : _OTRPushAccount

@property (nonatomic,strong) AFOAuthCredential * OAuthCredential;



@end
