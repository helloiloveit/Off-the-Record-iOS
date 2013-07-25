//
//  OTROnboardingView.m
//  Off the Record
//
//  Created by Christopher Ballinger on 6/22/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTROnboardingView.h"

@implementation OTROnboardingView

@synthesize imageView,textLabel,actionButton,actionButtonCallback;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImage * imageBanner = [UIImage imageNamed:@"chatsecure_banner"];
        CGSize imageSize = imageBanner.size;
        CGRect imageViewRect = CGRectMake((frame.size.width-imageSize.width)/2, 10, imageSize.width, imageSize.height);
        self.imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageView setImage:imageBanner];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, imageViewRect.origin.y+imageViewRect.size.height+10, frame.size.width-20, 120)];
        
        int buttonWidth = 200;
        int buttonHeight = 80;
        CGRect buttonRect = CGRectMake((frame.size.width - buttonWidth)/2, frame.size.height - buttonHeight -20, buttonWidth, buttonHeight);
        self.actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.actionButton.frame = buttonRect;
        [self.actionButton addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
        [self addSubview:self.actionButton];
    }
    return self;
}

-(void)actionButtonPressed:(id)sender
{
    if (actionButtonCallback) {
        actionButtonCallback(self);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
