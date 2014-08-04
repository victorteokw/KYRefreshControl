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

- (instancetype)initWithThreshold:(CGFloat)threshold height:(CGFloat)height;

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

@property (nonatomic, strong) UIColor *tintColor; // NOTE: TO BE IMPLEMENTED
@property (nonatomic, strong) NSAttributedString *attributedTitle UI_APPEARANCE_SELECTOR; // NOTE: TO BE IMPLEMENTED

- (void)beginRefreshing;
- (void)endRefreshing;


@property (nonatomic, readonly) CGFloat threshold;

@property (nonatomic, strong, readonly) UIView *animationView;

@property (nonatomic) NSTimeInterval disappearingTimeInterval;

/** Methods for subclassing */
- (void)dragging:(CGFloat)fractionDragged;
- (void)thresholdReached;
- (void)updating;
- (void)disappearing;


@end
