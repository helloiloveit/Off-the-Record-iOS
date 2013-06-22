//
//  OWOnboardingItem.h
//  Off the Record
//
//  Created by Christopher Ballinger on 6/22/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWOnboardingItem : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *imagePath;

- (id) initWithText:(NSString*)text imagePath:(NSString*)imagePath;

@end
