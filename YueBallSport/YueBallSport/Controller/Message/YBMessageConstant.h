//
//  YBMessageConstant.h
//  YueBallSport
//
//  Created by 韩森 on 2016/11/15.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#ifndef YBMessageConstant_h
#define YBMessageConstant_h

#if __has_include(<ChatKit/LCChatKit.h>)
#import <ChatKit/LCChatKit.h>
#else
#import "LCChatKit.h"
#endif

#import "YBMessageUser.h"

#import "YBMessageConfig.h"
#import <ChatKit/LCChatKit.h>

#import "YBMessageConstant.h"


#define LCCKProfileKeyPeerId        @"chatId"
#define LCCKProfileKeyName          @"chatName"
#define LCCKProfileKeyAvatarURL     @"chatIcon"
#define LCCKDeveloperPeerId @"571dae7375c4cd3379024b2f"

#define YBMESSAGE_NavgationBarBackGroundColor [UIColor colorWithRed:72/255.0 green:187/255.0 blue:91/255.0 alpha:1.0f]

#define NAVIGATION_COLOR_IMKIT RGBCOLOR(40, 130, 226)
#define NAVIGATION_COLOR NAVIGATION_COLOR_IMKIT


#ifndef LCCKLocalizedStrings
#define LCCKLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle(key, @"LCChatKitString", [NSBundle lcck_bundleForName:@"Other" class:[self class]], nil)
#endif

//TODO:add more friends
#define LCCKContactProfiles \
@[ \
@{ LCCKProfileKeyPeerId:@"1", LCCKProfileKeyName:@"Tom", LCCKProfileKeyAvatarURL:@"http://www.avatarsdb.com/avatars/tom_and_jerry2.jpg" },\
@{ LCCKProfileKeyPeerId:@"2", LCCKProfileKeyName:@"Jerry", LCCKProfileKeyAvatarURL:@"http://www.avatarsdb.com/avatars/jerry.jpg" },\
@{ LCCKProfileKeyPeerId:@"3", LCCKProfileKeyName:@"Harry1", LCCKProfileKeyAvatarURL:@"http://www.avatarsdb.com/avatars/young_harry.jpg" },\
@{ LCCKProfileKeyPeerId:@"4", LCCKProfileKeyName:@"William", LCCKProfileKeyAvatarURL:@"http://www.avatarsdb.com/avatars/william_shakespeare.jpg" },\
@{ LCCKProfileKeyPeerId:@"5", LCCKProfileKeyName:@"Bob", LCCKProfileKeyAvatarURL:@"http://www.avatarsdb.com/avatars/bath_bob.jpg" },\
@{ LCCKProfileKeyPeerId:@"6", LCCKProfileKeyName:@"RP", LCCKProfileKeyAvatarURL:@"http://www.avatarsdb.com/avatars/bath_bob.jpg" },\
@{ LCCKProfileKeyPeerId:@"7", LCCKProfileKeyName:@"RP1", LCCKProfileKeyAvatarURL:@"http://www.avatarsdb.com/avatars/bath_bob.jpg" },\
@{ LCCKProfileKeyPeerId:@"8", LCCKProfileKeyName:@"hhx2222", LCCKProfileKeyAvatarURL:@"http://ac-x3o016bx.clouddn.com/jXyGZv2B2W4oc3OaEQtYDo3w7fJjgovHeXGuyfFD" },\
]

#define LCCKContactPeerIds \
[LCCKContactProfiles valueForKeyPath:LCCKProfileKeyPeerId]

#define LCCKTestPersonProfiles \
@[ \
@{ LCCKProfileKeyPeerId:@"1" },\
@{ LCCKProfileKeyPeerId:@"2" },\
@{ LCCKProfileKeyPeerId:@"3" },\
@{ LCCKProfileKeyPeerId:@"4" },\
@{ LCCKProfileKeyPeerId:@"5" },\
@{ LCCKProfileKeyPeerId:@"6" },\
@{ LCCKProfileKeyPeerId:@"7" },\
@{ LCCKProfileKeyPeerId:@"8" },\
]

#define LCCKTestPeerIds \
[LCCKTestPersonProfiles valueForKeyPath:LCCKProfileKeyPeerId]
#define __LCCKContactsOfDevelopers \
@[                                 \
LCCKDeveloperPeerId,           \
]

#define __LCCKContactsOfSections \
@[                               \
LCCKTestPeerIds,             \
]

#define LCCKTestConversationGroupAvatarURLs                      \
@[                                                           \
@"http://www.avatarsdb.com/avatars/mickey.jpg",            \
@"http://www.avatarsdb.com/avatars/mickey_mouse.jpg",      \
@"http://www.avatarsdb.com/avatars/all_together.jpg",      \
@"http://www.avatarsdb.com/avatars/baby_disney.jpg",       \
@"http://www.avatarsdb.com/avatars/donald_duck01.jpg",     \
@"http://www.avatarsdb.com/avatars/Blue_Team_Disney.jpg",  \
@"http://www.avatarsdb.com/avatars/mickey_mouse_smile.jpg",\
@"http://www.avatarsdb.com/avatars/baby_pluto_dog.jpg",    \
@"http://www.avatarsdb.com/avatars/donald_duck_angry.jpg", \
@"http://www.avatarsdb.com/avatars/mickey_mouse_colors.jpg"\
]

#pragma mark - UI opera
///=============================================================================
/// @name UI opera
///=============================================================================

#define localize(key, default) LCCKLocalizedStrings(key)

#pragma mark - Message Bars

#define kStringMessageBarErrorTitle localize(@"message.bar.error.title")
#define kStringMessageBarErrorMessage localize(@"message.bar.error.message")
#define kStringMessageBarSuccessTitle localize(@"message.bar.success.title")
#define kStringMessageBarSuccessMessage localize(@"message.bar.success.message")
#define kStringMessageBarInfoTitle localize(@"message.bar.info.title")
#define kStringMessageBarInfoMessage localize(@"message.bar.info.message")

#pragma mark - Buttons

#define kStringButtonLabelSuccessMessage localize(@"button.label.success.message")
#define kStringButtonLabelErrorMessage localize(@"button.label.error.message")
#define kStringButtonLabelInfoMessage localize(@"button.label.info.message")
#define kStringButtonLabelHideAll localize(@"button.label.hide.all")


static NSString *const YBMESSAGE_KEY_USERNAME = @"YBMESSAGE_KEY_USERNAME";
static NSString *const YBMESSAGE_KEY_USERID = @"YBMESSAGE_KEY_USERID";


#endif /* YBMessageConstant_h */
