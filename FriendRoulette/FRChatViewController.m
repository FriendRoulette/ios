//
//  FRChatViewController.m
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import "FRChatViewController.h"

@interface FRChatViewController ()

@end

@implementation FRChatViewController

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    
    self.chatMessages = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect newTableFrame = self.tableView.frame;
    CGSize size = newTableFrame.size;
    size.height -= (keyboardSize.height);
    newTableFrame.size = size;
    CGRect newInputFrame = self.editText.frame;
    CGPoint point = newInputFrame.origin;
    point.y -= keyboardSize.height;
    newInputFrame.origin = point;
    self.editText.frame = newInputFrame;
    //Here make adjustments to the tableview frame based on the value in keyboard size
    
    self.tableView.frame = newTableFrame;
}

-(void)dismissKeyboard {
    [self.editText resignFirstResponder];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect newTableFrame = self.tableView.frame;
    CGSize size = newTableFrame.size;
    size.height += (keyboardSize.height);
    newTableFrame.size = size;
    CGRect newInputFrame = self.editText.frame;
    CGPoint point = newInputFrame.origin;
    point.y += keyboardSize.height;
    newInputFrame.origin = point;
    self.editText.frame = newInputFrame;
    //Here make adjustments to the tableview frame based on the value in keyboard size
    
    self.tableView.frame = newTableFrame;
}

- (IBAction)sendButtonPressed:(UITextField *)sender {
    [self sendMessage:self.editText.text];
    self.editText.text = @"";
}

- (void)sendMessage:(NSString *)message {
    if ([message compare:@""] != NSOrderedSame) {
        FRChatMessage *chatMessage = [FRChatMessage messageWithUser:@"Me" message:message];
        [self.chatMessages addObject:chatMessage];
        [self.tableView reloadData];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    FRChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[FRChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.speakerLabel.text = [[self.chatMessages objectAtIndex:indexPath.row] user];
    cell.messageTextView.text = [[self.chatMessages objectAtIndex:indexPath.row] message];
    [cell.messageTextView sizeToFit];
    return cell;
}

#define TEXTVIEW_WIDTH 276
#define FONT_SIZE 13

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:FONT_SIZE]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [[[self.chatMessages objectAtIndex:indexPath.row] message] boundingRectWithSize:CGSizeMake(TEXTVIEW_WIDTH, 10000)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    NSLog(@"%f", rect.size.height);
    NSLog(@"%@", [[self.chatMessages objectAtIndex:indexPath.row] message]);
    return rect.size.height + 15;
                                                                                                              
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
