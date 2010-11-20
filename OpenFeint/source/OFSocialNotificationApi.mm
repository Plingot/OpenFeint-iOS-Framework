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

#import "OFSocialNotificationApi.h"
#import "OFSocialNotificationService.h"
#import "OFRequestHandle.h"

static id sharedDelegate = nil;

static NSString* customUrl = nil;

@implementation OFSocialNotificationApi

+ (void)setDelegate:(id<OFSocialNotificationApiDelegate>)delegate
{
	sharedDelegate = delegate;
	
	if(sharedDelegate == nil)
	{
		[OFRequestHandlesForModule cancelAllRequestsForModule:[OFSocialNotificationApi class]];
	}
}

+ (void)setCustomUrl:(NSString*)url
{
	OFSafeRelease(customUrl);
	customUrl = [url retain];
}

+ (OFRequestHandle*)sendWithText:(NSString*)text imageNamed:(NSString*)imageName
{
	OFRequestHandle* handle = nil;
	handle = [OFSocialNotificationService sendWithText:text imageNamed:imageName linkedUrl:customUrl];
	
	[OFRequestHandlesForModule addHandle:handle forModule:[OFSocialNotificationApi class]];
	return handle;
}

+ (void)sendSuccess
{
	if(sharedDelegate && [sharedDelegate respondsToSelector:@selector(didSendSocialNotificaiton)])
	{
		[sharedDelegate didSendSocialNotificaiton];
	}
}

+ (void)sendFailure
{
	if(sharedDelegate && [sharedDelegate respondsToSelector:@selector(didFailSendSocialNotification)])
	{
		[sharedDelegate didFailSendSocialNotification];
	}
}

@end