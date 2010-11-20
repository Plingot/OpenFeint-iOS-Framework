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

#import "OpenFeint+NSNotification.h"
#import "OFUser.h"

NSString const* OFNSNotificationUserOnline = @"OFNSNotificationUserOnline";
NSString const* OFNSNotificationUserOffline = @"OFNSNotificationUserOffline";

NSString const* OFNSNotificationUserChanged = @"OFNSNotificationUserChanged";

NSString const* OFNSNotificationInfoPreviousUser = @"OFNSNotificationInfoPreviousUser";
NSString const* OFNSNotificationInfoCurrentUser = @"OFNSNotificationInfoCurrentUser";

NSString const* OFNSNotificationUnviewedChallengeCountChanged = @"OFNSNotificationUnviewedChallengeCountChanged";
NSString const* OFNSNotificationInfoUnviewedChallengeCount = @"OFNSNotificationInfoUnviewedChallengeCount";

NSString const *OFNSNotificationFriendPresenceChanged = @"OFNSNotificationFriendPresenceChanged";

NSString const* OFNSNotificationPendingFriendCountChanged = @"OFNSNotificationPendingFriendCountChanged";
NSString const* OFNSNotificationInfoPendingFriendCount = @"OFNSNotificationInfoPendingFriendCount";

NSString const* OFNSNotificationAddFriend = @"OFNSNotificationAddFriend";
NSString const* OFNSNotificationRemoveFriend = @"OFNSNotificationRemoveFriend";
NSString const* OFNSNotificationInfoFriend = @"OFNSNotificationInfoFriend";

NSString const* OFNSNotificationUnreadAnnouncementCountChanged = @"OFNSNotificationUnreadAnnouncementCountChanged";
NSString const* OFNSNotificationInfoUnreadAnnouncementCount = @"OFNSNotificationInfoUnreadAnnouncementCount";

NSString const* OFNSNotificationUnreadInboxCountChanged = @"OFNSNotificationUnreadInboxCountChanged";
NSString const* OFNSNotificationInfoUnreadInboxCount = @"OFNSNotificationInfoUnreadInboxCount";

NSString const* OFNSNotificationUnreadIMCountChanged = @"OFNSNotificationUnreadIMCountChanged";
NSString const* OFNSNotificationInfoUnreadIMCount = @"OFNSNotificationInfoUnreadIMCount";

NSString const* OFNSNotificationUnreadPostCountChanged = @"OFNSNotificationUnreadPostCountChanged";
NSString const* OFNSNotificationInfoUnreadPostCount = @"OFNSNotificationInfoUnreadPostCount";

NSString const* OFNSNotificationUnreadInviteCountChanged = @"OFNSNotificationUnreadInviteCountChanged";
NSString const* OFNSNotificationInfoUnreadInviteCount = @"OFNSNotificationInfoUnreadInviteCount";

NSString const* OFNSNotificationDashboardOrientationChanged = @"OFNSNotificationDashboardOrientationChanged";
NSString const* OFNSNotificationInfoOldOrientation = @"OFNSNotificationInfoOldOrientation";
NSString const* OFNSNotificationInfoNewOrientation = @"OFNSNotificationInfoNewOrientation";

@implementation OpenFeint (NSNotification)

+ (void)postUserChangedNotificationFromUser:(OFUser*)from toUser:(OFUser*)to
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:from, OFNSNotificationInfoPreviousUser, to, OFNSNotificationInfoCurrentUser, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationUserChanged object:nil userInfo:userInfo];
}

+ (void)postUnviewedChallengeCountChangedTo:(NSUInteger)unviewedChallengeCount
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:unviewedChallengeCount], OFNSNotificationInfoUnviewedChallengeCount, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationUnviewedChallengeCountChanged object:nil userInfo:userInfo];
}


+ (void)postFriendPresenceChanged:(OFUser *)theUser withPresence:(NSString *)thePresence
{
	NSLog(@"User: %@, Presence: %@", theUser, thePresence);
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:theUser, @"user", thePresence, @"presence", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationFriendPresenceChanged object:nil userInfo:userInfo];
}

+ (void)postPendingFriendsCountChangedTo:(NSUInteger)pendingFriendCount
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:pendingFriendCount], OFNSNotificationInfoPendingFriendCount, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationPendingFriendCountChanged object:nil userInfo:userInfo];
}

+ (void)postAddFriend:(OFUser*)newFriend
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:newFriend, OFNSNotificationInfoFriend, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationAddFriend object:nil userInfo:userInfo];
}

+ (void)postRemoveFriend:(OFUser*)oldFriend
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:oldFriend, OFNSNotificationInfoFriend, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationRemoveFriend object:nil userInfo:userInfo];
}

+ (void)postUnreadAnnouncementCountChangedTo:(uint)unreadAnnouncementCount
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:unreadAnnouncementCount], OFNSNotificationInfoUnreadAnnouncementCount, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationUnreadAnnouncementCountChanged object:nil userInfo:userInfo];
}

+ (void)postUnreadInboxCountChangedTo:(NSUInteger)unreadInboxCount
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:unreadInboxCount], OFNSNotificationInfoUnreadInboxCount, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationUnreadInboxCountChanged object:nil userInfo:userInfo];
}

+ (void)postUnreadIMCountChangedTo:(NSUInteger)unreadIMCount
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:unreadIMCount], OFNSNotificationInfoUnreadIMCount, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationUnreadIMCountChanged object:nil userInfo:userInfo];
}

+ (void)postUnreadPostCountChangedTo:(NSUInteger)unreadPostCount
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:unreadPostCount], OFNSNotificationInfoUnreadPostCount, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationUnreadPostCountChanged object:nil userInfo:userInfo];
}

+ (void)postUnreadInviteCountChangedTo:(NSUInteger)unreadInviteCount
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:unreadInviteCount], OFNSNotificationInfoUnreadInviteCount, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationUnreadInviteCountChanged object:nil userInfo:userInfo];
}

+ (void)postDashboardOrientationChangedTo:(UIInterfaceOrientation)newOrientation from:(UIInterfaceOrientation)oldOrientation
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:(int)newOrientation], OFNSNotificationInfoNewOrientation,
		[NSNumber numberWithInt:(int)oldOrientation], OFNSNotificationInfoOldOrientation,
		nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:OFNSNotificationDashboardOrientationChanged object:nil userInfo:userInfo];
}

@end
