//
//  FRChatViewController.m
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import "FRChatViewController.h"

@interface FRChatViewController ()
- (void)pushMessage:(NSString *)message;
@end

@implementation FRChatViewController

#define FIREBASE_BASE_URL @"https://friendroulette.firebaseio.com/"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    myLastMessage = @"";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    
    self.fireBase = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"%@room%@", FIREBASE_BASE_URL, self.roomID]];
    [self.fireBase removeValue];
    [self.fireBase observeEventType:FEventTypeValue withBlock:^
     (FDataSnapshot *snapshot) {
         if (![snapshot.value isEqual:[NSNull null]] && (NSString *)snapshot.value != myLastMessage) {
             [self pushMessage:(NSString *)snapshot.value user:@"Friend"];
         }
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect newFrame = self.chatView.frame;
    CGSize size = newFrame.size;
    size.height -= (keyboardSize.height);
    newFrame.size = size;
    CGRect newInputFrame = self.editText.frame;
    CGPoint point = newInputFrame.origin;
    point.y -= keyboardSize.height;
    newInputFrame.origin = point;
    self.editText.frame = newInputFrame;
    
    self.chatView.frame = newFrame;
}

-(void)dismissKeyboard {
    [self.editText resignFirstResponder];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect newFrame = self.chatView.frame;
    CGSize size = newFrame.size;
    size.height += (keyboardSize.height);
    newFrame.size = size;
    CGRect newInputFrame = self.editText.frame;
    CGPoint point = newInputFrame.origin;
    point.y += keyboardSize.height;
    newInputFrame.origin = point;
    self.editText.frame = newInputFrame;
    
    self.chatView.frame = newFrame;
}

- (IBAction)sendButtonPressed:(UITextField *)sender {
    [self sendMessage:self.editText.text];
    self.editText.text = @"";
}

- (void)sendMessage:(NSString *)message {
    if ([message compare:@""] != NSOrderedSame) {
        // send message
        myLastMessage = message;
        [self pushMessage:message user:@"Me"];
        [self.fireBase setValue:message];
    }
}

- (void)pushMessage:(NSString *)message user:(NSString *)user {
    self.chatView.text = [NSString stringWithFormat:@"%@\n%@: %@", self.chatView.text, user, message];
    NSLog(@"PUSHING");
}

#pragma mark -
#pragma mark QBChatDelegate


- (void)viewWillDisappear:(BOOL)animated {
    self.fireBase = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"%@room%@", FIREBASE_BASE_URL, self.roomID]];
    [self.fireBase removeValue];
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
