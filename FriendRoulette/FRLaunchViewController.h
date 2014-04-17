//
//  FRViewController.h
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRRouletteSpinner.h"
#import "FRAPIWrapper.h"

@interface FRLaunchViewController : UIViewController
@property (weak, nonatomic) IBOutlet FRRouletteSpinner *spinner;
@property (strong, nonatomic) FRAPIWrapper *apiWrapper;
@property (strong, nonatomic) NSString *roomID;

- (IBAction)findSomeone:(id)sender;

@end
