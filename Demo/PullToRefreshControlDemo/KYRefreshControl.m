//
//  KYRefreshControl.m
//  KYRefreshControl
//
//  Created by Kai Yu on 12/21/13.
//  Copyright (c) 2013 Zhang Kai Yu. All rights reserved.
//

#import "KYRefreshControl.h"
#import <UIKit/UIScrollView.h>
#define DEFAULT_Y -64
#define SUPER_VIEW_IS_DRAGGING self.scrollView.isDragging
@interface KYRefreshControl ()
@property (nonatomic) CGFloat height;
@property (nonatomic, readwrite, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *monitorDraggingTimer;
@end

@implementation KYRefreshControl



- (instancetype)initWithThreshold:(CGFloat)threshold height:(CGFloat)height animationView:(UIView *)animationView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _threshold = threshold;
        _height = height;
        _animationView = animationView;
        self.opaque = NO;
        self.hidden = YES;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        self.scrollView = (UIScrollView *)self.superview;
    }
    self.frame = CGRectMake(0, -self.height, CGRectGetWidth(self.superview.bounds), self.height);
    self.animationView.frame = self.bounds;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.animationView];
    [self.superview sendSubviewToBack:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.superview && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *contentOffsetValue = change[NSKeyValueChangeNewKey];
        CGPoint point;
        [contentOffsetValue getValue:&point];
        CGFloat offset = self.scrollView.contentOffset.y+self.scrollView.contentInset.top;
        CGFloat fractionDragged = MIN(1, -offset/self.threshold);
        if (point.y < DEFAULT_Y && !self.isRefreshing) {
            self.hidden = NO;
            if (self.userIsDraggingAnimation) {
                self.userIsDraggingAnimation(fractionDragged);
            }
        }
        if (point.y == DEFAULT_Y && !self.isRefreshing) {
            self.hidden = YES;
            if (self.userIsDraggingAnimation) {
                self.userIsDraggingAnimation(fractionDragged);
            }
        }
        if (point.y < DEFAULT_Y - self.threshold && self.isRefreshing == NO) {
            if (self.thresholdReachedAnimation) {
                self.thresholdReachedAnimation();
            }
            [self beginRefreshing];
            
        }
    }
}

- (void)beginRefreshing
{
 
    if (!self.isRefreshing) {
        self.refreshing = YES;
        self.monitorDraggingTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(monitorSuperviewDragging) userInfo:nil repeats:YES];
        if (self.monitorDraggingTimer) {
            [self.monitorDraggingTimer fire];
            [[NSRunLoop currentRunLoop] addTimer:self.monitorDraggingTimer forMode:NSRunLoopCommonModes];
        }
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        if (self.updatingAnimation) {
            self.updatingAnimation();
        }
    }
}

- (void)setSuperviewContentInsets
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        UIEdgeInsets currentContentInset = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(currentContentInset.top + self.height, currentContentInset.left, currentContentInset.bottom, currentContentInset.right);
    } completion:nil];
}


- (void)endRefreshing
{
    if (SUPER_VIEW_IS_DRAGGING) {
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.0];
    } else {
        if (self.disappearingAnimation) {
            self.disappearingAnimation();
        }
        [UIView animateWithDuration:self.disappearingTimeInterval ? self.disappearingTimeInterval : 0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            UIEdgeInsets currentContentInset = self.scrollView.contentInset;
            self.scrollView.contentInset = UIEdgeInsetsMake(currentContentInset.top - self.height, currentContentInset.left, currentContentInset.bottom, currentContentInset.right);
        } completion:^(BOOL finished) {
            self.refreshing = NO;
            self.hidden = YES;
        }];
    }
}

- (void)monitorSuperviewDragging
{
    if (self.scrollView.isDragging) {
        
    } else {
        if (self.isRefreshing) {
            [self setSuperviewContentInsets];
            [self.monitorDraggingTimer invalidate];
            self.monitorDraggingTimer = nil;
        }
    }
}

@end
