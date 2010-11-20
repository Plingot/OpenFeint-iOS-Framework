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

#pragma once

#import "OFViewController.h"
#import "OFCallbackable.h"

@protocol OFShareLocationControllerCallback
@required
- (void)userSharedLocation;
@end


@interface OFShareLocationController : OFViewController<OFCallbackable, UIActionSheetDelegate>
{
	UILabel* descriptionLabel;
	UISwitch* shareLocationSwitch;
	id<OFShareLocationControllerCallback> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property (nonatomic, retain) IBOutlet UISwitch* shareLocationSwitch;
@property (nonatomic, assign) id<OFShareLocationControllerCallback> delegate;

- (IBAction)shareLocationChanged;

@end