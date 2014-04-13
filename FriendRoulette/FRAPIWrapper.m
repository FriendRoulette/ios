//
//  FRAPIWrapper.m
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import "FRAPIWrapper.h"

#define BASE_URL @"http://api.friendroulette.net/user/create_oauth"
#define FIREBASE_BASE_URL @"http://www.friendroulette.firebaseio.com/"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface FRAPIWrapper()
- (NSDictionary *)jsonToDictionary:(NSData *)json;
- (NSData *)dataForHTTPPost:(NSDictionary*) parms;
@end

@implementation FRAPIWrapper

- (void)enterQueueWithResponseListener:(void (^)(int roomID))r{
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
                                     
                                     NSLog( @"token=%@", token );
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
    NSLog(@"New2a HTTPPost Data:%@", postString);
    
    return [postString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) sendRequestWithToken: (NSString *) token{
    // Create the request.
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:BASE_URL]];
    NSDictionary *params = @{@"token":token};
    NSData *postDataString = [self dataForHTTPPost:params];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postDataString length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postDataString];

    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc]init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *jsonDict = [self jsonToDictionary:self.responseData];
    
    NSString *firebaseURLSuffix = [jsonDict objectForKey:@"FIREBASE_URL"];
    Firebase *fireBase = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"%@%@", FIREBASE_BASE_URL, firebaseURLSuffix]];
    [fireBase observeEventType:FEventTypeValue withBlock:^
    (FDataSnapshot *snapshot) {
        if ([(NSNumber *)snapshot.value intValue] != 0)
            self.response([snapshot.value intValue]);
    }];
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}


@end
