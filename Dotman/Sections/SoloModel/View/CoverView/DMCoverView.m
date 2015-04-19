//
//  DMCoverView.m
//  Dotman
//
//  Created by YingshanDeng on 15/4/19.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DMCoverView.h"
#import "UIImage+ImageEffects.h"

@implementation DMCoverView
{
    DMCoverViewType _type;
    UIView *_blurView;
    CGFloat _coverViewOpacity;
}

- (id)initCoverViewWithFrame:(CGRect)frame withType:(DMCoverViewType)type withBlurView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _type = type;
        _blurView = view;
        [self setupCoverView];
    }
    return self;
}


- (void)fadeInToShow
{
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = _coverViewOpacity;
                     }
                     completion:nil];
}


- (void)fadeOutToHide
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {

        [self removeFromSuperview];

    }];
}

#pragma mark -

- (void)setupCoverView
{
    switch (_type)
    {
        case DMCoverViewShadowType:
            [self makeShadowCoverView];
            break;
        case DMCoverViewBlurType:
            [self makeBlurCoverView];
            break;
        default:
            break;
    }
}
- (void)makeShadowCoverView
{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.7f;
    _coverViewOpacity = 0.7f;
}

- (void)makeBlurCoverView
{
    UIImage *image = [UIImage convertViewToImage:_blurView];
    UIImage *blurSnapshotImage = [image applyBlurWithRadius:5.0f
                                                  tintColor:[UIColor colorWithWhite:0.2f alpha:0.7f]
                                      saturationDeltaFactor:1.8f
                                                  maskImage:nil];
    
    self.image = blurSnapshotImage;
    self.alpha = 0.0f;
    _coverViewOpacity = 1.0f;
}

@end
