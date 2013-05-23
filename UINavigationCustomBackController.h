//
//  UINavigationCustomBackController.h
//
//  Created by Carlin on 12/19/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

// Forward declaration
@class UINavigationCustomBackController;

// Protocol to define methods for a data souce delegate
@protocol UINavigationCustomBackDelegate<NSObject>

@optional
/**
 * @brief Delegate method to allow showing of a UIAlertView on navigation back button press. Useful to allow customization of a UIAlertView to display. Sample code:
 *
 
	- (UIAlertView *)showAlertOnNavBackButtonPressed:(UINavigationController *)navController
	{
		debug(@"showAlertOnNavBackButtonPressed");

		return [[UIAlertView alloc]
			initWithTitle:@"Are you sure you want to quit? You will lose all progress!"
			message:nil
			delegate:nil
			cancelButtonTitle:@"Cancel"
			otherButtonTitles:@"Yes", nil];
	}
 
 * 
 * @param navController A pointer to this UINavigationController.
 * @return Pointer to UIAlertView to be shown, or nil to bypass showing alert.
*/
- (UIAlertView *)showAlertOnNavBackButtonPressed:(UINavigationController *)navController;

/**
 * @brief Delegate method to indicate that the topmost view controller is being popped and let the navigation controller know whether or not to animate it. This is useful if you want to customize the transition animation / exit behavior when the view is being popped. Sample code:
 *
 
	- (bool)shouldPopViewControllerAnimated:(UINavigationCustomBackController *)navController
	{
		debug(@"shouldPopViewControllerAnimated");
		
		if ([navController.topViewController isMemberOfClass:[SomeClass class]])
		{
			[UIView transitionWithView:navController.view
				duration:0.5
				options:UIViewAnimationOptionTransitionFlipFromRight
				animations:nil
				completion:nil
			];
			return false;
		}
		return true;
	}
 
 *
 * @param navController A pointer to this UINavigationController.
 * @return TRUE to use default transition animation, FALSE to not animate.
*/
- (bool)shouldPopViewControllerAnimated:(UINavigationController *)navController;

@end


// Custom UINavigationController class
@interface UINavigationCustomBackController : UINavigationController <UIAlertViewDelegate>

@property (nonatomic, weak) id<UINavigationCustomBackDelegate> backDelegate;

@end
