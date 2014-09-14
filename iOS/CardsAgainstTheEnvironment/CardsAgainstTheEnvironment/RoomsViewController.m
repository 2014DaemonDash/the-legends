//
//  RoomsViewController.m
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import "RoomsViewController.h"
#import "RoomCell.h"
#import "CreateGameViewController.h"

@interface RoomsViewController()
@property (strong, nonatomic) NSArray *roomList;
@end

@implementation RoomsViewController{
}


-(void)viewDidLoad{
    _roomList = [[NSArray alloc] initWithArray:_user[@"rooms"]];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"User: %@", [_user description]);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 20, 15, 20);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Room" forIndexPath:indexPath];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"Add"]){
        CreateGameViewController *vc = (CreateGameViewController *)[segue destinationViewController];
        vc.user = _user;
    }
}

- (IBAction)logout:(id)sender {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addRoom:(id)sender {
    
    
}
@end
