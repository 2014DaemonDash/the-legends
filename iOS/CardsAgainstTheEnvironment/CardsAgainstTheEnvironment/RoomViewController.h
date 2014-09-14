//
//  RoomViewController.h
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RoomViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *blackCardView;
@property (weak, nonatomic) IBOutlet UIButton *judgingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pickButton;

@property (strong, nonatomic) NSString *blackCardContent;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFObject *room;
@end
