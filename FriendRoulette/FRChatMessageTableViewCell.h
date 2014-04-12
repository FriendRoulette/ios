//
//  FRChatMessageTableViewCell.h
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRChatMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end
