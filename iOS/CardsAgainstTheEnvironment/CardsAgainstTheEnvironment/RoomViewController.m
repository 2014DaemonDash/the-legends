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

@interface RoomViewController()

@property (strong, nonatomic) UILabel *blackContent;

@end

@implementation RoomViewController{
    
}

-(void)viewDidLoad{
    
    //[myLabel setBackgroundColor:[UIColor orangeColor]];
    CGRect labelFrame = CGRectMake(20, 20, 240, 150);
    _blackContent = [[UILabel alloc] initWithFrame:labelFrame];
    [_blackContent setFont:[UIFont fontWithName:@"Helvetica Bold" size:36]];
    [_blackContent setTextColor:[UIColor whiteColor]];
    [_blackContent setLineBreakMode:NSLineBreakByWordWrapping];
    NSString *labelText = @"Card Not Chosen";
    [_blackContent setText:labelText];
    
    // Tell the label to use an unlimited number of lines
    [_blackContent setNumberOfLines:0];
    [_blackContent sizeToFit];
    
    [_blackCardView addSubview:_blackContent];
    [self updateBlackCard];
    NSLog(@"Room: %@",[_room description]);

}

-(void)updateBlackCard{
    if([_room[@"currentBlackCard"] integerValue] != -1){
        PFQuery *blackQuery = [PFQuery queryWithClassName:@"BlackCards"];
        [blackQuery whereKey:@"cardId" equalTo:_room[@"currentBlackCard"]];
        [blackQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if([objects count] > 0){
                for (UIView *sub in _blackCardView.subviews) {
                    [sub removeFromSuperview];
                }
                NSString *labelText = [[NSString alloc] initWithString:[[objects firstObject] objectForKey:@"cardContent"]];
                CGRect labelFrame = CGRectMake(20, 20, 240, 150);
                _blackContent = [[UILabel alloc] initWithFrame:labelFrame];
                [_blackContent setText:labelText];
                [_blackContent setFont:[UIFont fontWithName:@"Helvetica Bold" size:34]];
                [_blackContent setTextColor:[UIColor whiteColor]];
                [_blackContent setLineBreakMode:NSLineBreakByWordWrapping];
                [_blackContent setText:labelText];
                
                // Tell the label to use an unlimited number of lines
                [_blackContent setNumberOfLines:0];
                [_blackContent sizeToFit];
                if(_blackContent.frame.size.height > 370){
                    [_blackContent setFont:[UIFont fontWithName:@"Helvetica Bold" size:30]];
                    [_blackContent sizeToFit];
                }
                if(_blackContent.frame.size.height > 370){
                    [_blackContent setFont:[UIFont fontWithName:@"Helvetica Bold" size:28]];
                    [_blackContent sizeToFit];
                }
                [_blackCardView addSubview:_blackContent];
            }
        }];
        
    }else{
        for (UIView *sub in _blackCardView.subviews) {
            [sub removeFromSuperview];
        }
        NSString *labelText = @"Card Not Chosen";
        CGRect labelFrame = CGRectMake(20, 20, 280, 150);
        _blackContent = [[UILabel alloc] initWithFrame:labelFrame];
        [_blackContent setText:labelText];
        [_blackContent setFont:[UIFont fontWithName:@"Helvetica Bold" size:36]];
        [_blackContent setTextColor:[UIColor whiteColor]];
        [_blackContent setLineBreakMode:NSLineBreakByWordWrapping];
        [_blackContent setText:labelText];
        
        // Tell the label to use an unlimited number of lines
        [_blackContent setNumberOfLines:0];
        [_blackContent sizeToFit];
        [_blackCardView addSubview:_blackContent];
    }
}

-(void)viewWillAppear:(BOOL)animated{
}

-(NSInteger)drawCardFromDeck:(NSMutableArray *)deck{
    int r = arc4random_uniform((int)deck.count);     // Random card in pile
    NSInteger card = [[deck objectAtIndex:r] integerValue];
    [deck removeObjectAtIndex:r];
    return card;
}

-(void)loadDesign{
    NSLog(@"User: %@",[_user description]);
    if([_user.username isEqualToString:_room[@"currentJudge"]]){
        // Judge related methods
        [_judgingButton setHidden:NO];
        [_judgingButton setEnabled:NO];
        
        if([_room[@"currentBlackCard"] integerValue] == -1){
            // Draw black card;
            _room[@"currentBlackCard"] = [NSNumber numberWithInteger: [self drawCardFromDeck:_room[@"blackDeck"]]];
            [self updateBlackCard];
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
    }else{
        [_pickButton setTitle:@"View"];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadDesign];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *username = _user.username;
    PickWhiteViewController *vc = (PickWhiteViewController *)[segue destinationViewController];
    if([[segue identifier] isEqualToString:@"View"]){
        if([username isEqualToString:_room[@"currentPlayer"]] && ![username isEqualToString:_room[@"currentJudge"]]){
            vc.type = @"picker";
        }else{
            vc.type = @"view";
        }
    }else{
        // Judge segue
        vc.type = @"judge";
    }
    vc.blackContent = [[NSString alloc] initWithString:_blackContent.text];
    vc.user = _user;
    vc.room = _room;
}
- (IBAction)refreshLayout:(id)sender {
    PFQuery *room = [PFQuery queryWithClassName:@"Room"];
    [room whereKey:@"objectId" equalTo:_room.objectId];
    _room = [[room findObjects] firstObject];
    [self updateBlackCard];
    [self loadDesign];
}

@end
