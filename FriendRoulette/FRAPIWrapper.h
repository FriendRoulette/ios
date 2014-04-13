//
//  FRAPIWrapper.h
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Firebase/Firebase.h>

@interface FRAPIWrapper : NSObject

@property (strong, nonatomic) NSMutableURLRequest *urlRequest;
@property (strong, nonatomic) NSMutableData *responseData;
@property (nonatomic, copy) void (^response)(NSString *roomID);

- (void)enterQueueWithResponseListener:(void (^)(NSString *roomID))r;

- (void) sendRequestWithToken: (NSString *) token;



@end
