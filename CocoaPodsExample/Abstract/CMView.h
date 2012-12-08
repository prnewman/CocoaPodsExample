//
//  CMView.h
//  CityMaps
//
//  Created by Paul Newman on 12/2/12.
//  Copyright (c) 2012 CityMaps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMView : UIView

@property (nonatomic, assign) CGFloat verticalOffset;

- (void)createSubviewsIfNeeded;

- (void)showModalBackground:(BOOL)show animated:(BOOL)animated;
- (void)showModalBackground:(BOOL)show animated:(BOOL)animated completion:(void (^)(BOOL finished))completionBlock;

- (void)handleBackgroundTapped;

- (void)updateLoadingMessageWithText:(NSString *)text;
- (void)showLoadingMessage:(NSString *)text;
- (void)showConfirmationMessage:(NSString *)text;
- (void)showConfirmationMessage:(NSString *)text duration:(NSTimeInterval)duration;
- (void)showConfirmationMessage:(NSString *)text duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completionBlock;
- (void)hideMessage;

@end
