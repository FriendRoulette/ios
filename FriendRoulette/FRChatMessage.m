//
//  FRChatMessage.m
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import "FRChatMessage.h"

@implementation FRChatMessage

+ (FRChatMessage *)messageWithUser:(NSString *)user message:(NSString *)message {
    FRChatMessage *cm = [[FRChatMessage alloc] init];
    cm.user = user;
    cm.message = message;
    return cm;
}

@end
