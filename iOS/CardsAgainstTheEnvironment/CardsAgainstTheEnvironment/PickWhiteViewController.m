//
//  PickWhiteViewController.m
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import "PickWhiteViewController.h"

@interface PickWhiteViewController()
@property (weak, nonatomic) IBOutlet UICollectionView *handCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *handScrollView;
@property (weak, nonatomic) IBOutlet UIButton *pickCardButton;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@end

@implementation PickWhiteViewController

-(void)viewDidLoad{
    /*
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setItemSize:CGSizeMake(280, 390)];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_flowLayout setMinimumInteritemSpacing:40.0];
    [_handCollection setCollectionViewLayout:_flowLayout];
    [_handCollection setDelegate:self];
    [_handCollection setDataSource:self];
     */
    if ([_type isEqualToString:@"view"]){
        [_pickCardButton setHidden:YES];
    }
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
    NSArray *cards = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    for (int i = 0; i < cards.count; i++) {
        CGRect frame;
        frame.origin.x = _handScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _handScrollView.frame.size;
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [UIColor clearColor];
        CGRect cardFrame = CGRectMake(20, 60, 280, 390);
        UIView *card = [[UIView alloc] initWithFrame:cardFrame];
        card.backgroundColor = [UIColor whiteColor];
        card.layer.cornerRadius = 5.0f;
        
        CGRect labelFrame = CGRectMake(20, 20, 240, 150);
        UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [myLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:36]];
        [myLabel setTextColor:[UIColor blackColor]];

        if ([_type isEqualToString:@"judging"]) {
            [myLabel setTextColor:[UIColor whiteColor]];
            card.backgroundColor = [UIColor blackColor];
        }
        
        [myLabel setLineBreakMode:NSLineBreakByWordWrapping];
        //[myLabel setBackgroundColor:[UIColor orangeColor]];
        
        NSString *labelText = [cards objectAtIndex:i];
        [myLabel setText:labelText];
        
        // Tell the label to use an unlimited number of lines
        [myLabel setNumberOfLines:0];
        [myLabel sizeToFit];
        
        [card addSubview:myLabel];
        
        [subview addSubview:card];
        //subview.backgroundColor = [colors objectAtIndex:i];
        [_handScrollView addSubview:subview];
    }
    
    _handScrollView.contentSize = CGSizeMake(_handScrollView.frame.size.width * cards.count, _handScrollView.frame.size.height);
    [_handScrollView setDelegate:self];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WhiteCard" forIndexPath:indexPath];
    CGRect labelFrame = CGRectMake(20, 20, 240, 150);
    UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [myLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:36]];
    [myLabel setTextColor:[UIColor blackColor]];
    [myLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //[myLabel setBackgroundColor:[UIColor orangeColor]];
    
    NSString *labelText = @"Card Not Chosen";
    [myLabel setText:labelText];
    
    // Tell the label to use an unlimited number of lines
    [myLabel setNumberOfLines:0];
    [myLabel sizeToFit];
    
    [cell.contentView addSubview:myLabel];

    return cell;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 20, 15, 40);
}
- (IBAction)pickCard:(id)sender {
    int page = _handScrollView.contentOffset.x / _handScrollView.frame.size.width;
    NSLog(@"Chosen Card: %@",[NSNumber numberWithInt:page]);
    // Sync chosen card to Parse, specifically to the pool
    if([_type isEqualToString:@"judging"]){
        NSString *winningUser = [_room[@"playingCardPool"] objectForKey:@"Card Number Here"];
    }else{
        [_room[@"playingCardPool"] addObject:@"Card Number Here"];
    }
    // Draw new card if possible
    // Choose next player
    // Return to screen
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
