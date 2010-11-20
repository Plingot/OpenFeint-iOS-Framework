//  Copyright 2009-2010 Aurora Feint, Inc.
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  	http://www.apache.org/licenses/LICENSE-2.0
//  	
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "OFDependencies.h"
#import "OFFacebookAccountController.h"
#import "OFISerializer.h"
#import "OFFormControllerHelper+Submit.h"
#import "OpenFeint+Settings.h"
#import "OpenFeint+Private.h"
#import "MPOAuthAPIRequestLoader.h"
#import "OFSettings.h"
#import "OFImageLoader.h"
#import "OpenFeint+Private.h"
#import "OFFBDialog.h"
#import "OFIntroNavigationController.h"

@interface OFUIInvisibleKeyboardTrap : UIView
@end

@implementation OFUIInvisibleKeyboardTrap

- (void)didAddSubview:(UIView*)subview
{
	[self.superview bringSubviewToFront:self];
}

- (void)willRemoveSubview:(UIView*)subview
{
	[self.superview sendSubviewToBack:self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView* trappedKeyboard = [self.subviews objectAtIndex:0];
	CGPoint convertedPoint = [self convertPoint:point toView:trappedKeyboard];
	return [trappedKeyboard hitTest:convertedPoint withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView* trappedKeyboard = [self.subviews objectAtIndex:0];
	CGPoint convertedPoint = [self convertPoint:point toView:trappedKeyboard];
	return [trappedKeyboard pointInside:convertedPoint withEvent:event];
}

@end


@implementation OFFacebookAccountController

@synthesize fbuid;
@synthesize urlToLaunch;
@synthesize fbLoggedInStatusImageView;
@synthesize fbSession;

- (void)addHiddenParameters:(OFISerializer*)parameterStream
{
	[super addHiddenParameters:parameterStream];
	
	OFRetainedPtr <NSString> credentialsType = @"fbconnect"; 
	parameterStream->io("credential_type", credentialsType);	
}

- (void)closeLoginDialog
{
	if (loginDialog)
	{
		[loginDialog.session.delegates removeObject:self];
		loginDialog.delegate = nil;
		[loginDialog dismissWithSuccess:NO animated:YES];
		OFSafeRelease(loginDialog);
	}
}

- (bool)shouldUseOAuth
{
	return self.addingAdditionalCredential;
}

- (void)registerActionsNow
{
}

- (void)logoutFromFacebook
{
	[self.fbSession logout];
	self.fbuid = nil;
	self.fbSession = nil;
}

- (void)promptToLogin
{	
    if (loginDialog) return; // We did this aleady
    
	[self logoutFromFacebook];
	
	NSString* facebookApplicationKey = OFSettings::Instance()->getFacebookApplicationKey();
	NSString* sessionProxy = [NSString stringWithFormat:@"%@fbconnect/get_session", OFSettings::Instance()->getFacebookCallbackServerUrl()];
	FBSession* session = [FBSession sessionForApplication:facebookApplicationKey getSessionProxy:sessionProxy delegate:self];	
	
	loginDialog = [[OFFBDialog alloc] initWithSession:session];
	loginDialog.delegate = self;
	

	
    if ([OpenFeint isLargeScreen])
    {
        [loginDialog showInView:self.view];
    }
    else
    {
        [loginDialog show];
    }
}

- (void)viewDidLoad
{
	self.navigationItem.hidesBackButton = YES;
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.fbLoggedInStatusImageView.image = [OFImageLoader loadImage:@"OpenFeintStatusIconNotificationFailure.png"];
    [OFIntroNavigationController activeIntroNavigationController].fullscreenFrame = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];	
	if (!skipLoginOnAppear)
	{
		[self promptToLogin];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self closeLoginDialog];
    [OFIntroNavigationController activeIntroNavigationController].fullscreenFrame = NO;
	[super viewWillDisappear:animated];
}

- (void)session:(FBSession*)session didLogin:(FBUID)uid
{
	[self closeLoginDialog];
	self.fbuid = uid;
	self.fbSession = session;
	self.fbLoggedInStatusImageView.image = [OFImageLoader loadImage:@"OpenFeintStatusIconNotificationSuccess.png"];
}

- (void)displayError:(NSString*)errorString
{
	OFSafeRelease(loginDialog);
	[[[[UIAlertView alloc] 
		initWithTitle:OFLOCALSTRING(@"Facebook Connect Error")
		message:errorString
		delegate:nil
		cancelButtonTitle:OFLOCALSTRING(@"Ok")
		otherButtonTitles:nil] autorelease] show];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	[self displayError:[error localizedDescription]];
}

- (void)requestWasCancelled
{
	[self displayError:OFLOCALSTRING(@"Unable to get your name from Facebook. Please make sure the proper permissions are set on your profile at http://www.facebook.com/")]; 
}
	
- (void)dialogDidCancel:(FBDialog*)dialog
{
	[self closeLoginDialog];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error
{
	[self displayError:[error localizedDescription]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		[[UIApplication sharedApplication] openURL:self.urlToLaunch];
	}
}

- (void)onPresentingErrorDialog
{
	[self promptToLogin];
}

- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL*)url
{
	self.urlToLaunch = url;
	
    OFLOCALIZECOMMENT("Multiple items in string")
	NSString* message = [NSString stringWithFormat:OFLOCALSTRING(@"Exit %@ and open %@ in Safari?"), [OpenFeint applicationDisplayName], [url host]];
	
	UIAlertView* openAlert = [[[UIAlertView alloc] 
		initWithTitle:OFLOCALSTRING(@"Open Link In Safari")
		message:message
		delegate:self
		cancelButtonTitle:OFLOCALSTRING(@"Cancel")
		otherButtonTitles:nil] autorelease];
	[openAlert addButtonWithTitle:OFLOCALSTRING(@"Open Link")];
	[openAlert show];
	
	return NO;
}

- (void)dealloc
{
	self.urlToLaunch = nil;
	self.fbSession = nil;
	self.fbuid = nil;
	self.fbLoggedInStatusImageView = nil;
	OFSafeRelease(loginDialog);
	[super dealloc];
}

@end