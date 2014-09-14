//
//  RoomViewController.m
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import "RoomViewController.h"

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

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"User: %@",[_user description]);
    if([_user.username isEqualToString:_room[@"currentJudge"]]){
        // Judge related methods
        [_judgingButton setHidden:NO];
        [_pickButton setEnabled:NO];
    }
    if([_user.username isEqualToString:_room[@"currentPlayer"]]){
        //
    }
}

@end
