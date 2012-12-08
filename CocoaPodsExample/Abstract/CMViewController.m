//
//  CMViewController.h
//  CityMaps
//
//  Created by Paul Newman on 11/29/12.
//

#import "CMViewController.h"
#import "CMAnalyticsManager.h"
#import "UIView+AutoLayout.h"

#define kCMViewController_ConfirmationViewWidth     190.0f
#define kCMViewController_ConfirmationViewHeight    120.0f


@interface CMViewController()
{
    CMConfirmationView *_confirmationView;
    
    UIView *_overlayView;
}

@end

@implementation CMViewController

/*
 Auto Layout only knows one type of constraint. All these different relationships between views work the same under the hood, using a simple mathematical formula:
 
 A = B*m + c
 
 Here, A and B are attributes of the two views, such as “this button’s left side” or “that label’s top”, m is a multiplier and c is the constant.
 If the formula is too abstract for you, think of it like this:
 
 view1_attribute = view2_attribute*multiplier + constant
 
 */

- (id)init
{
	self = [super init];
	
	NSAssert([self isMemberOfClass:[CMViewController class]] == NO, @"CMViewController is abstract and not meant to be instansiated directly.");
	
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubviewsIfNeeded];
}

// NOTE: Do not override loadView if you're using a nib file
- (void)createSubviewsIfNeeded
{
    if (!_overlayView) {
        // modal background view
        _overlayView = [[UIView alloc] init];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0.0f;
        _overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:_overlayView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleBackgroundTapped)];
        
        [_overlayView addGestureRecognizer:tap];
    }
    
    // these overlay constraints are needed to prevent animation (we just want fade in/out)
    [self.view addVisualConstraints:@"|[_overlayView]|" forViews:NSDictionaryOfVariableBindings(_overlayView)];
    [self.view addVisualConstraints:@"V:|[_overlayView]|" forViews:NSDictionaryOfVariableBindings(_overlayView)];
    
    //[self.view setNeedsUpdateConstraints];    
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    //[CMAnalyticsManager registerScreen:self.title];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

#pragma mark - Helpers

- (void)addConfirmationIfNecessary
{
	if (_confirmationView == nil)
	{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(hideMessage)];

		_confirmationView = [[CMConfirmationView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * 0.5) - (kCMViewController_ConfirmationViewWidth * 0.5), (self.view.frame.size.height * 0.5) - (kCMViewController_ConfirmationViewHeight * 0.5), kCMViewController_ConfirmationViewWidth, kCMViewController_ConfirmationViewHeight)];

		
        _confirmationView.center = CGPointMake(self.view.frame.size.width * 0.5, (self.view.frame.size.height * 0.5) - 44); // 44 if navbar
		_confirmationView.alpha = 0;
        [_confirmationView addGestureRecognizer:tap];

		[self.view addSubview:_confirmationView];
	}
}

# pragma mark - Button Actions

- (void)backButtonWasPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)handleBackgroundTapped
{
    // override in subclasses
}

# pragma mark - Modal background view

// TODO: Make this part of CMAbstractViewController
- (void)showModalBackground:(BOOL)show completion:(void (^)(BOOL finished))completionBlock
{
    // frame version
     /*
     if (!overlayView) {
        overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CMUtil currentScreenWidth], [CMUtil currentScreenHeight])];
        overlayView.backgroundColor = [UIColor blackColor];
        overlayView.alpha = 0.0;
     }
     
     if (show) {
        [self.view addSubview:overlayView];
     
        [UIView animateWithDuration:0.3f animations:^{
            overlayView.alpha = 0.5f;
        }];
     }
     else{
        [UIView animateWithDuration:0.5f animations:^{
            overlayView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [overlayView removeFromSuperview];
        }];
     }
     */
    
    if (show) {
        if ([_overlayView superview] != nil)
            [_overlayView removeFromSuperview];
        
        [self.view addSubview:_overlayView];
        // overlay constraints
        [self.view addVisualConstraints:@"|[_overlayView]|" forViews:NSDictionaryOfVariableBindings(_overlayView)];
        [self.view addVisualConstraints:@"V:|[_overlayView]|" forViews:NSDictionaryOfVariableBindings(_overlayView)];
        
        [UIView animateWithDuration:0.3f animations:^{
            _overlayView.alpha = 0.5f;
        } completion:^(BOOL finished) {
            // callback method
            if (completionBlock != nil)
                completionBlock(finished);
        }];
        
    }
    else{
        // fade out is a touch longer
        [UIView animateWithDuration:0.7f animations:^{
            _overlayView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [_overlayView removeFromSuperview];
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
		
		[self.view bringSubviewToFront:_confirmationView];
		[_confirmationView setPendingWithText:text];
		
		[UIView animateWithDuration:0.25 animations:^{
			_confirmationView.alpha = 1;
		}];
	}
}

- (void)showLoadingMessage:(NSString *)text
{
	[self addConfirmationIfNecessary];
	
	[self.view bringSubviewToFront:_confirmationView];
	[_confirmationView setPendingWithText:text];
	
	[UIView animateWithDuration:0.25 animations:^{
		_confirmationView.alpha = 1;
	}];
}

- (void)showConfirmationMessage:(NSString *)text duration:(NSTimeInterval)duration
{
	[self addConfirmationIfNecessary];
	
	[self.view bringSubviewToFront:_confirmationView];
	[_confirmationView setDoneWithText:text];
	
	[UIView animateWithDuration:0.25 animations:^{
		_confirmationView.alpha = 1;
	} completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.25 delay:duration options:0 animations:^{
                _confirmationView.alpha = 0;
            } completion:nil];
        }
    }];
}

- (void)showConfirmationMessage:(NSString *)text
{
	[self addConfirmationIfNecessary];
	
	[self.view bringSubviewToFront:_confirmationView];
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

@end
