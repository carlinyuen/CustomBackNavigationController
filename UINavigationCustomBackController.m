//
//  UINavigationCustomBackController.m
//  Zeitgeist 2012
//
//  Created by Carlin on 12/19/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

#import "UINavigationCustomBackController.h"

@interface UINavigationCustomBackController ()
{
	bool regularPop;		// If the shouldPopItem method is naturally called
	bool alertConfirmed;	// If a confirmation popup is not cancelled
}
@end

#pragma mark -
#pragma mark Implementation

@implementation UINavigationCustomBackController

@synthesize backDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		backDelegate = nil;
		regularPop = false;
		alertConfirmed = false;
    }
    return self;
}

#pragma mark -
#pragma mark Customization

/**
 * @brief Overwriting the shouldPopItem method in the UINavigationBarDelegate so we can define behavior on back button press.
*/
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{	
	// If this is a regular pop, aka called naturally from [super popViewControllerAnimated], then return true and pop nav item.
	if (regularPop)
	{
		regularPop = false;
		return true;
	}
	
	// If called naturally, but because of callback from confirmation on the alert popup, then return true and pop nav item.
	if (alertConfirmed)
	{
		alertConfirmed = false;
		return true;
	}

	// If backDelegate exists, see if we need to block pop
	if (backDelegate != nil && [backDelegate respondsToSelector:@selector(showAlertOnNavBackButtonPressed:)])
	{
		UIAlertView *alert = [backDelegate showAlertOnNavBackButtonPressed:self];
		
		if (alert)
		{
			alert.delegate = self;
			[alert show];
			
			regularPop = false;
			return false;
		}
	}

	// Default behavior - need to invoke popViewControllerAnimated to pop topmost view controller properly, but the parent call will also call this method so need the regularPop flag to keep track of it and refuse the pop this time around.
	regularPop = true;
	[self popViewControllerAnimated:true];
	return false;
}


/**
 * @brief Overwriting the popViewControllerAnimated method so we can define behavior on back button press.
*/
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{			
	// If backDelegate exists, see if we need to block pop
	if (backDelegate != nil && [backDelegate respondsToSelector:@selector(shouldPopViewControllerAnimated:)])
	{
		// Use this to track if user popped views manually
		UIViewController *topView = self.topViewController;
		
		animated = [backDelegate shouldPopViewControllerAnimated:self];
		
		// If manually popped, don't mess with it, and just return original top view
		if (topView != self.topViewController) {
			return topView;
		}
	}
	
	// Default action
	return [super popViewControllerAnimated:animated];
}

#pragma mark -
#pragma mark Alert handler

/**
 * @brief Implementing alertViewDelegate to handle when alert is confirmed.
*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex > 0)	// Not cancelled
	{
		alertConfirmed = true;
		[self popViewControllerAnimated:true];
	}
}

@end
