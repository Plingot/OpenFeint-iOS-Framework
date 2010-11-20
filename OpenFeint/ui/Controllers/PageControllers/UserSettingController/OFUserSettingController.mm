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
#import "OFUserSettingController.h"
#import "OFResourceControllerMap.h"
#import "OFUserSetting.h"
#import "OFUserSettingService.h"
#import "OpenFeint.h"
#import "OFUserSettingPushController.h"
#import "OpenFeint+UserOptions.h"
#import "OpenFeint+Private.h"
#import "OFAccountSetupBaseController.h"
#import "OFFacebookAccountLoginController.h"
#import "OFTwitterAccountLoginController.h"
#import "OFHttpCredentialsCreateController.h"
#import "OFOpenFeintAccountLoginController.h"
#import "OpenFeint+NSNotification.h"

@implementation OFUserSettingController

- (bool)usePlainTableSectionHeaders
{
	return true;
}

- (void)populateResourceMap:(OFResourceControllerMap*)resourceMap
{
	resourceMap->addResource([OFUserSetting class], @"UserSetting");
	resourceMap->addResource([OFUserSettingPushController class], @"UserSettingAction");
	
}

- (OFService*)getService
{
	return [OFUserSettingService sharedInstance];
}

- (bool)shouldAlwaysRefreshWhenShown
{
	return true;
}

- (NSString*)getNoDataFoundMessage
{
	return OFLOCALSTRING(@"There are no settings available right now");
}

- (void)onCellWasClicked:(OFResource*)cellResource indexPathInTable:(NSIndexPath*)indexPath
{
	if ([cellResource isKindOfClass:[OFUserSettingPushController class]])
	{
		OFUserSettingPushController* pushControllerResource = (OFUserSettingPushController*)cellResource;
		UIViewController* controllerToPush = [pushControllerResource getController];
		if ([controllerToPush isKindOfClass:[OFFacebookAccountLoginController class]] ||
			[controllerToPush isKindOfClass:[OFTwitterAccountLoginController class]] ||
		    [controllerToPush isKindOfClass:[OFHttpCredentialsCreateController class]])
		{
			[(OFAccountSetupBaseController*)controllerToPush setAddingAdditionalCredential:YES];
		}
        if ([controllerToPush isKindOfClass:[OFOpenFeintAccountLoginController class]]) {
            [(OFOpenFeintAccountLoginController*)controllerToPush setHideIntroFlowSpacer:YES];
        }
		if (controllerToPush)
		{
			[self.navigationController pushViewController:controllerToPush animated:YES];
		}
	}
}

- (void)_logoutNow
{
	[OpenFeint logoutUser];
	[OpenFeint dismissDashboard];
}

- (IBAction)logout
{
	OFSafeRelease(logoutSheet);
	
	NSString* message = OFLOCALSTRING(@"Logging out will disable all Feint features.  Are you sure?");
	logoutSheet = [[UIActionSheet alloc] initWithTitle:message delegate:self cancelButtonTitle:OFLOCALSTRING(@"Cancel") destructiveButtonTitle:OFLOCALSTRING(@"Logout") otherButtonTitles:nil];
	[logoutSheet showInView:[OpenFeint getTopLevelView]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.destructiveButtonIndex)
	{
		[self _logoutNow];
	}
	actionSheet.delegate = nil;
	
	if (actionSheet == logoutSheet)
	{
		OFSafeRelease(logoutSheet);
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] 
		addObserver:self 
		selector:@selector(orientationDidChange:) 
		name:OFNSNotificationDashboardOrientationChanged 
		object:nil];

	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] 
		removeObserver:self
		name:OFNSNotificationDashboardOrientationChanged
		object:nil];

	[super viewWillDisappear:animated];
}
	
- (void)orientationDidChange:(NSNotification*)notification
{
	[logoutSheet dismissWithClickedButtonIndex:[logoutSheet cancelButtonIndex] animated:NO];
}

@end