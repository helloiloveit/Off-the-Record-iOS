//
//  OTRDescriptionOnboardingView.h
//  Off the Record
//
//  Created by David on 7/24/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTROnboardingView.h"
#import "OTRBoolSetting.h"

@interface OTRDescriptionOnboardingView : OTROnboardingView
{
    OTRBoolSetting * crittercismSetting;
}


@property (nonatomic,strong) UISwitch * sendCrashReportsSwitch;
@property (nonatomic,strong) UILabel * sendCrashReportsLabel;

@end
