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

@interface FRChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* chatMessages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *editText;

- (IBAction)sendButtonPressed:(UITextField *)sender;
- (void)sendMessage:(NSString *)message;


@end
