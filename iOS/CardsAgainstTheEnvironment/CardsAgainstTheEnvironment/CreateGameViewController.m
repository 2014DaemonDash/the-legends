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
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:cell.textField.text];
            NSArray *users = [query findObjects];
            if(users != nil && [users count] != 0){
                NSDictionary *player = @{@"cardsInHand":@"0",@"points":@"0",@"userId":cell.textField.text};
                [_playerNames addObject:player];
            }
        }
    }
    if([_playerNames count] == numPlayers){
        room[@"players"] = _playerNames;
        room[@"currentPlayer"] = _user.username;
        room[@"currentJudge"] = _user.username;
        PFQuery *whiteQuery = [PFQuery queryWithClassName:@"WhiteCards"];
        PFQuery *blackQuery = [PFQuery queryWithClassName:@"BlackCards"];
        [whiteQuery findObjectsInBackgroundWithBlock:^(NSArray *whiteCards, NSError *error) {
            NSMutableArray *whiteDeck = [[NSMutableArray alloc] init];
            for(NSDictionary *whiteCard in whiteCards){
                [whiteDeck addObject:[whiteCard objectForKey:@"cardId"]];
            }
            room[@"whiteDeck"] = whiteDeck;
            [blackQuery findObjectsInBackgroundWithBlock:^(NSArray *blackCards, NSError *error) {
                NSMutableArray *blackDeck = [[NSMutableArray alloc] init];
                for(NSDictionary *blackCard in blackCards){
                    [blackDeck addObject:[blackCard objectForKey:@"cardId"]];
                }
                room[@"blackDeck"] = blackDeck;
                
                PFACL *defaultACL = [PFACL ACL];
                [defaultACL setPublicReadAccess:NO];
                for(NSDictionary *player in _playerNames){
                    PFQuery *userQuery = [PFUser query];
                    [userQuery whereKey:@"username" equalTo:[player objectForKey:@"userId"]];
                    PFUser *playerUser = [[userQuery findObjects] firstObject];
                    [defaultACL setReadAccess:YES forUser:playerUser];
                }
                [defaultACL setReadAccess:YES forUser:_user];
                [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
                [room setACL:defaultACL];
                [room saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSDictionary *roomInfo = @{@"roomId":[room objectId], @"roomName":room[@"name"]};
                                        [_user[@"rooms"] addObject:roomInfo];
                    [_user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }];
                }];
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
