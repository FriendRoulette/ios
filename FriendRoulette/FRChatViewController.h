//
//  FRChatViewController.h
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRChatMessage.h"
#import "FRChatMessageTableViewCell.h"
#import <Firebase/Firebase.h>

@interface FRChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSString *myLastMessage;
}

@property (strong, nonatomic) IBOutlet UITextView *chatView;
@property (weak, nonatomic) IBOutlet UITextField *editText;
@property (nonatomic) int recipientID;
@property (nonatomic) NSString *roomID;
@property (strong, nonatomic) Firebase *fireBase;

- (IBAction)sendButtonPressed:(UITextField *)sender;
- (void)sendMessage:(NSString *)message;


@end
