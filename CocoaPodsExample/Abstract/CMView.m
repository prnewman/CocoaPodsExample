//
//  CMView.m
//  CityMaps
//
//  Created by Paul Newman on 12/2/12.
//  Copyright (c) 2012 CityMaps. All rights reserved.
//

#import "CMView.h"
#import "UIView+AutoLayout.h"
#import "CMConfirmationView.h"

#define kCMView_ConfirmationViewWidth     190.0f
#define kCMView_ConfirmationViewHeight    120.0f


@interface CMView()
{
    CMConfirmationView *_confirmationView;
    
    UIView *overlayView;
    
}
@end

@implementation CMView


- (id)init
{
	self = [super init];
	
	NSAssert([self isMemberOfClass:[CMView class]] == NO, @"CMView is abstract and not meant to be instansiated directly.");
	
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.verticalOffset = 0;
        
        [self createSubviewsIfNeeded];
    }
    return self;
}

- (void)createSubviewsIfNeeded
{
    // implemented in subclasses
    
    if (!overlayView) {
        // modal background view
        overlayView = [[UIView alloc] init];
        overlayView.backgroundColor = [UIColor blackColor];
        overlayView.alpha = 0.0f;
        overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:overlayView];
        // overlay constraints are needed to prevent animation (we just want fade in/out)
        [self addVisualConstraints:@"|[overlayView]|" forViews:NSDictionaryOfVariableBindings(overlayView)];
        [self addVisualConstraints:@"V:|[overlayView]|" forViews:NSDictionaryOfVariableBindings(overlayView)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleBackgroundTapped)];
        
        [overlayView addGestureRecognizer:tap];
    }
}

#pragma mark - Helpers

- (void)addConfirmationIfNecessary
{

	if (!_confirmationView)
	{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(hideMessage)];
        
        CGRect adjustedFrame = self.frame;
        
        if (adjustedFrame.origin.y < 0 && [CMUtil deviceIsIPhone])
            adjustedFrame.size.height -= adjustedFrame.origin.y; //548 - -198 = 746

        _confirmationView = [[CMConfirmationView alloc] initWithFrame:CGRectMake((self.frame.size.width * 0.5) - (kCMView_ConfirmationViewWidth * 0.5),
                                                                                 (self.frame.size.height * 0.5) - (kCMView_ConfirmationViewHeight * 0.5),
                                                                                 kCMView_ConfirmationViewWidth, kCMView_ConfirmationViewHeight)];
        
		_confirmationView.center = CGPointMake(self.frame.size.width * 0.5, adjustedFrame.size.height * 0.5);

		_confirmationView.alpha = 0;
        [_confirmationView addGestureRecognizer:tap];
        
		[self addSubview:_confirmationView];
	}
}

- (void)handleBackgroundTapped
{
    // override in subclass
}

# pragma mark - Public methods

- (void)showModalBackground:(BOOL)show animated:(BOOL)animated
{
    [self showModalBackground:show animated:animated completion:nil];
}

- (void)showModalBackground:(BOOL)show animated:(BOOL)animated completion:(void (^)(BOOL finished))completionBlock
{
//    int yOffset = (int)self.verticalOffset;
//    if (self.frame.origin.y < 0)
//        yOffset = (int)self.verticalOffset - (int)self.frame.origin.y;
    
    if (show) {
        if ([overlayView superview] != nil)
            [overlayView removeFromSuperview];
        
        NSString *verticalConstraint = [NSString stringWithFormat:@"V:|-%i-[overlayView]|", (int)self.verticalOffset];
        
        [self addSubview:overlayView];
        // overlay constraints
        [self addVisualConstraints:@"|[overlayView]|" forViews:NSDictionaryOfVariableBindings(overlayView)];
        [self addVisualConstraints:verticalConstraint forViews:NSDictionaryOfVariableBindings(overlayView)];
        
        if (!animated) {
            overlayView.alpha = 0.7f;
            return;
        }
        
        // fade in
        [UIView animateWithDuration:0.3f animations:^{
            overlayView.alpha = 0.7f;
        } completion:^(BOOL finished) {
            // callback method
            if (completionBlock != nil)
                completionBlock(finished);

        }];
        
    }
    else{
        
        if (!animated) {
            overlayView.alpha = 0.0f;
            [overlayView removeFromSuperview];
            return;
        }
        // fade out
        [UIView animateWithDuration:0.3f animations:^{
            overlayView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [overlayView removeFromSuperview];
        }];
    }
    
}


#pragma mark - Loading Text Popup

- (void)updateLoadingMessageWithText:(NSString *)text
{
	if (text == nil)
	{
		[self hideMessage];
	}
	else
	{
		[self addConfirmationIfNecessary];
		
		[self bringSubviewToFront:_confirmationView];
		[_confirmationView setPendingWithText:text];
		
		[UIView animateWithDuration:0.25 animations:^{
			_confirmationView.alpha = 1;
		}];
	}
}

- (void)showLoadingMessage:(NSString *)text
{
	[self addConfirmationIfNecessary];
	
	[self bringSubviewToFront:_confirmationView];
	[_confirmationView setPendingWithText:text];
	
	[UIView animateWithDuration:0.25 animations:^{
		_confirmationView.alpha = 1;
	}];
}

- (void)showConfirmationMessage:(NSString *)text duration:(NSTimeInterval)duration
{
	[self showConfirmationMessage:text duration:duration completion:nil];
}

- (void)showConfirmationMessage:(NSString *)text duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completionBlock
{
	[self addConfirmationIfNecessary];
	
	[self bringSubviewToFront:_confirmationView];
	[_confirmationView setDoneWithText:text];
	
	[UIView animateWithDuration:0.25 animations:^{
		_confirmationView.alpha = 1;
	} completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.25 delay:duration options:0 animations:^{
                _confirmationView.alpha = 0;
            } completion:^(BOOL finished) {
                if (completionBlock != nil) {
                    completionBlock(finished);
                }
            }];
        }
    }];
}

- (void)showConfirmationMessage:(NSString *)text
{
	[self addConfirmationIfNecessary];
	
	[self bringSubviewToFront:_confirmationView];
	[_confirmationView setDoneWithText:text];
	
	[UIView animateWithDuration:0.25 animations:^{
		_confirmationView.alpha = 1;
	}];
}

- (void)hideMessage
{
	[UIView animateWithDuration:0.25 animations:^{
		_confirmationView.alpha = 0;
	}];
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
