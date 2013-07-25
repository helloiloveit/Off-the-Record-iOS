//
//  OTRNewAccountTableView.h
//  Off the Record
//
//  Created by David on 7/25/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTRManagedAccount.h"

typedef void(^AccountSelectCallback)(OTRManagedAccount *newAccount);

@interface OTRNewAccountTableView : UITableView <UITableViewDataSource,UITableViewDelegate>
{
    NSArray * accounts;
}

@property (nonatomic,copy) AccountSelectCallback accountSelectCallback;

@end
