//
//  OTROnboardingView.h
//  Off the Record
//
//  Created by Christopher Ballinger on 6/22/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTROnboardingView;

typedef void(^ActionButtonCallback)(OTROnboardingView *onboardingView);


@interface OTROnboardingView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, copy) ActionButtonCallback actionButtonCallback;

@end
