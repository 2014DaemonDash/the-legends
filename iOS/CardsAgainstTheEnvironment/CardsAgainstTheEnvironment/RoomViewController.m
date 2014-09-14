//
//  RoomViewController.m
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import "RoomViewController.h"
#include <stdlib.h>
#import "PickWhiteViewController.h"

@implementation RoomViewController

-(void)viewDidLoad{
    CGRect labelFrame = CGRectMake(20, 20, 240, 150);
    UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [myLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:36]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //[myLabel setBackgroundColor:[UIColor orangeColor]];
    
    NSString *labelText = @"Card Not Chosen";
    [myLabel setText:labelText];
    
    // Tell the label to use an unlimited number of lines
    [myLabel setNumberOfLines:0];
    [myLabel sizeToFit];
    
    [_blackCardView addSubview:myLabel];
    NSLog(@"Room: %@",[_room description]);

}

-(void)viewWillAppear:(BOOL)animated{
}

-(NSInteger)drawCardFromDeck:(NSMutableArray *)deck{
    int r = arc4random_uniform((int)deck.count);     // Random card in pile
    NSInteger card = [[deck objectAtIndex:r] integerValue];
    [deck removeObjectAtIndex:r];
    return card;
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"User: %@",[_user description]);
    if([_user.username isEqualToString:_room[@"currentJudge"]]){
        // Judge related methods
        [_judgingButton setHidden:NO];
        [_judgingButton setEnabled:NO];
        
        if([_room[@"currentBlackCard"] integerValue] == -1){
            // Draw black card;
            _room[@"currentBlackCard"] = [NSNumber numberWithInteger: [self drawCardFromDeck:_room[@"blackDeck"]]];
            NSMutableArray *playerPool = [[NSMutableArray alloc] init];
            for(NSDictionary *player in _room[@"players"]){
                [playerPool addObject:[player objectForKey:@"userId"]];
            }
            [playerPool removeObject:_user.username];
            _room[@"currentPlayer"] = [playerPool firstObject];
            _room[@"playingCardPool"] = [[NSMutableArray alloc] init];
            _room[@"remainingPlayers"] = playerPool;
            [_room saveInBackground];
        }
    }
    if([_user.username isEqualToString:_room[@"currentPlayer"]]){
        //
        if([_user.username isEqualToString:_room[@"currentJudge"]]){
            [_judgingButton setEnabled:YES];
            [_judgingButton setAlpha:1.0];
        }else{
            [_pickButton setTitle:@"Pick"];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *username = _user.username;
    PickWhiteViewController *vc = (PickWhiteViewController *)[segue destinationViewController];
    if([username isEqualToString:_room[@"currentJudge"]]){
        vc.type = @"judge";
    }else if([username isEqualToString:_room[@"currentPlayer"]]){
        vc.type = @"picker";
    }else{
        vc.type = @"view";
    }
    vc.user = _user;
    vc.room = _room;
}

@end
