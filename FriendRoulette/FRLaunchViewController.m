//
//  FRViewController.m
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import "FRLaunchViewController.h"

@interface FRLaunchViewController ()

@end

@implementation FRLaunchViewController

- (void)viewDidLoad
{
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
}
@end
