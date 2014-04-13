//
//  FRAPIWrapper.m
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import "FRAPIWrapper.h"

#define BASE_URL @"http://api.friendroulette.net/user/oauth_create"
#define FIREBASE_BASE_URL @"https://friendroulette.firebaseio.com/"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface FRAPIWrapper()
- (NSDictionary *)jsonToDictionary:(NSData *)json;
- (NSData *)dataForHTTPPost:(NSDictionary*) parms;
@end

@implementation FRAPIWrapper

- (void)enterQueueWithResponseListener:(void (^)(NSString *roomID))r{
    self.response = r;
    ACAccountStore* as = [ACAccountStore new];
    
    ACAccountType* fbat = [as accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    NSAssert( fbat != nil, @"oops, can't find account-type for facebook!");
    
    [as requestAccessToAccountsWithType: fbat
     
                                options: @{ ACFacebookAppIdKey : @"541756572610649", // your FB appid here!
                                            ACFacebookPermissionsKey : @[ @"email", @"user_birthday", @"read_friendlists" ]}
     
                             completion: ^(BOOL granted, NSError *error) {
                                 
                                 NSAssert(granted && error == nil, @"The request did not complete successfully.");
                                 
                                 if ( granted )
                                 {
                                     NSArray* accounts = [as accountsWithAccountType: fbat];
                                     NSAssert( accounts.count > 0, @"oops, no accounts??" );
                                     
                                     ACAccount* fbaccount = [accounts lastObject];
                                     
                                     ACAccountCredential* ac = [fbaccount credential];
                                     NSAssert( ac != nil, @"oops, no credential??" );
                                     
                                     NSString* token = [ac oauthToken];
                                     NSAssert( token.length > 0, @"oops, no credential??" );
                                     
                                     [self sendRequestWithToken:token];
                                 }
                             }];

}

- (NSData *)dataForHTTPPost:(NSDictionary*) parms
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in parms) {
        id obj = [parms objectForKey:key];
        NSString *valueString;
        
        if ([obj isKindOfClass:[NSString class]])
            valueString = obj;
        else if ([obj isKindOfClass:[NSNumber class]])
            valueString = [(NSNumber *)obj stringValue];
        else if ([obj isKindOfClass:[NSURL class]])
            valueString = [(NSURL *)obj absoluteString];
        else
            valueString = [obj description];
        
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, valueString]];
    }
    NSString *postString = [array componentsJoinedByString:@"&"];
    
    return [postString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) sendRequestWithToken: (NSString *) token{
    NSURLSession *session = [NSURLSession sharedSession];
//    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BASE_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120000];
    [request setURL:[NSURL URLWithString:BASE_URL]];
    NSDictionary *params = @{@"oauth":token};
    NSLog(@"%@", token);
    NSData *postDataString = [self dataForHTTPPost:params];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postDataString length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postDataString];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonDict = [self jsonToDictionary:data];
        NSString *firebaseURLSuffix = [jsonDict objectForKey:@"uid"];
        NSString *jsonText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"RESPONSE TEXT %@", jsonText);
        if ([jsonDict objectForKey:@"status"] == nil) {
            NSLog(@"SUFFEX %@", firebaseURLSuffix);
            Firebase *fireBase = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"%@%@", FIREBASE_BASE_URL, firebaseURLSuffix]];
            [fireBase observeEventType:FEventTypeValue withBlock:^
             (FDataSnapshot *snapshot) {
                 NSLog(@"%@", snapshot.value);
                 if (![snapshot.value isEqual:[NSNull null]] && ![(NSString *)snapshot.value isEqualToString:@"null"]) {
                     self.response((NSString *)snapshot.value);
                     NSLog(@"IN ROOM! %@", (NSString *)snapshot.value);
                 }
             }];
            NSLog(@"Waiting for FireBase");
        } else {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:@"The server did not respond correctly!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
            NSLog(@"Error: status:false");
        }
    }] resume];
}

- (NSDictionary *)jsonToDictionary:(NSData *)json {
    //parse out the json data
    NSError* error;
    NSDictionary* jsonDict = [NSJSONSerialization
                          JSONObjectWithData:json //1
                          
                          options:kNilOptions
                          error:&error];
    return jsonDict;
}

@end
