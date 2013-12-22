//
//  KYRefreshControl.h
//  KYRefreshControl
//
//  Created by Kai Yu on 12/21/13.
//  Copyright (c) 2013 Zhang Kai Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYRefreshControl : UIControl
{
    @protected
    __weak UIScrollView *_scrollView;
}

- (instancetype)initWithThreshold:(CGFloat)threshold height:(CGFloat)height animationView:(UIView *)animationView;

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) NSAttributedString *attributedTitle UI_APPEARANCE_SELECTOR;

- (void)beginRefreshing;
- (void)endRefreshing;

@property (nonatomic) CGFloat threshold;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) void (^userIsDraggingAnimation)(CGFloat fractionDragged);
@property (nonatomic, strong) void (^thresholdReachedAnimation)();
@property (nonatomic, strong) void (^updatingAnimation)();
@property (nonatomic, strong) void (^disappearingAnimation)();
@property (nonatomic) NSTimeInterval disappearingTimeInterval;

@end
