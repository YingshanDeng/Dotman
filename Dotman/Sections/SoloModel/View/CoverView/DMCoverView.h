//
//  DMCoverView.h
//  Dotman
//
//  Created by YingshanDeng on 15/4/19.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMCoverViewType)
{
    DMCoverViewShadowType,
    DMCoverViewBlurType,
};

@interface DMCoverView : UIImageView

- (id)initCoverViewWithFrame:(CGRect)frame withType:(DMCoverViewType)type withBlurView:(UIView *)view;

- (void)fadeInToShowWithBlock:(void (^)(void))block;

- (void)fadeOutToHideWithBlock:(void (^)(void))block;

@end
