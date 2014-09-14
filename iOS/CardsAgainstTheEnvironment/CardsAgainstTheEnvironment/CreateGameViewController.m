//
//  CreateGameViewController.m
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import "CreateGameViewController.h"
#import "textEntryCell.h"

@interface CreateGameViewController()

@property (strong, nonatomic) NSMutableArray *playerNames;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation CreateGameViewController{
    NSUInteger numPlayers;
}

-(void)viewDidLoad{
    numPlayers = 1;
    _playerNames = [[NSMutableArray alloc] init];
    [_table setDelegate:self];
    [_table setDataSource:self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSString *cellId;
    if(row == 0){
        // Room Name
        cellId = @"roomName";
        textEntryCell *cell = (textEntryCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        return cell;
    }else if (row == numPlayers + 1){
        // Add Player
        cellId = @"add";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        return cell;
    }else{
        // Player Username
        cellId = @"player";
        textEntryCell *cell = (textEntryCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        [cell.textField setPlaceholder:[NSString stringWithFormat:@"Player %@ Username",[NSNumber numberWithInteger:row]]];
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2 + numPlayers;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(row == [tableView numberOfRowsInSection:0]-1){
        numPlayers++;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:numPlayers inSection:0];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}
- (IBAction)done:(id)sender {
    
    PFObject *room = [PFObject objectWithClassName:@"Room"];
    room[@"name"] = ((textEntryCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField.text;
    for(int i = 0; i < numPlayers; i++){
        textEntryCell *cell = (textEntryCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow: i+1 inSection:0]];
        if([cell.textField.text isEqualToString:@""]){
            NSLog(@"Please enter a name for all fields");
        }else{
            NSDictionary *player = @{@"cardsInHand":@"0",@"points":@"0",@"userId":cell.textField.text};
            [_playerNames addObject:player];
        }
    }
    if([_playerNames count] == numPlayers){
        room[@"players"] = _playerNames;
        room[@"currentPlayer"] = [[_playerNames objectAtIndex:0] objectForKey:@"userId"];
        room[@"currentJudge"] = _user.username;
        PFQuery *whiteQuery = [PFQuery queryWithClassName:@"whiteCards"];
        PFQuery *blackQuery = [PFQuery queryWithClassName:@"blackCards"];
        room[@"whiteDeck"] = [whiteQuery findObjects];
        room[@"blackDeck"] = [blackQuery findObjects];
        [room saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [_user[@"rooms"] addObject:[room objectId]];
            [_user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }];
    }else{
        [_playerNames removeAllObjects];
    }
    
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
