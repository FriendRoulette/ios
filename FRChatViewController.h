//
//  FRChatViewController.h
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRChatMessage.h"

@interface FRChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *chatMessages;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
