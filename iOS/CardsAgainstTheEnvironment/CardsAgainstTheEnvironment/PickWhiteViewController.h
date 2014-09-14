//
//  PickWhiteViewController.h
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface PickWhiteViewController : UIViewController<UICollectionViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) PFObject *room;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSString *blackContent;
@property (strong, nonatomic) NSString *type;

@end
