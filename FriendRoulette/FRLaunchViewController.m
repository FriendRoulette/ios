//
//  FRViewController.m
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import "FRLaunchViewController.h"
#import "FRChatViewController.h"

@interface FRLaunchViewController ()

@end

@implementation FRLaunchViewController

- (void)viewDidLoad
{
    self.apiWrapper = [[FRAPIWrapper alloc] init];
    [super viewDidLoad];
    [self.spinner initialize];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findSomeone:(id)sender {
    [self.spinner start];
    [self.apiWrapper enterQueueWithResponseListener:^(NSString *roomID) {
        self.roomID = roomID;
        [self performSegueWithIdentifier:@"toChat" sender:self];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toChat"]) {
        FRChatViewController *vc = segue.destinationViewController;
        vc.roomID = self.roomID;
    }
}
@end
