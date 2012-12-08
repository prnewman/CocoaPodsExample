//
//  CMViewController.h
//  CityMaps
//
//  Created by Paul Newman on 11/29/12.
//

#import "CMConfirmationView.h"

@interface CMViewController : UIViewController

- (void)createSubviewsIfNeeded;

- (void)backButtonWasPressed:(id)sender;

- (void)showModalBackground:(BOOL)show completion:(void (^)(BOOL finished))completionBlock;

- (void)updateLoadingMessageWithText:(NSString *)text;
- (void)showLoadingMessage:(NSString *)text;
- (void)showConfirmationMessage:(NSString *)text duration:(NSTimeInterval)duration;
- (void)showConfirmationMessage:(NSString *)text;
- (void)hideMessage;

@end
