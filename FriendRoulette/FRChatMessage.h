//
//  FRChatMessage.h
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRChatMessage : NSObject {

}

@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *message;

+ (FRChatMessage *)messageWithUser:(NSString *)user message:(NSString *)message;

@end
