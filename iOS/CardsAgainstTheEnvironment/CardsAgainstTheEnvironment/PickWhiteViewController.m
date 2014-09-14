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
@property (strong, nonatomic) NSMutableArray *deck;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@end

@implementation PickWhiteViewController{
    NSInteger playerNum;
}

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
    
    
    
    if ([_type isEqualToString:@"judge"]) {
        // Implement judging logic
        _cards = [[NSMutableArray alloc] initWithArray:[_room[@"playingCardPool"] mutableCopy]];

    }else{
        for(int i = 0; i < [_room[@"players"] count]; i++){
            NSDictionary *player = [_room[@"players"] objectAtIndex:i];
            if([[player objectForKey:@"userId"] isEqualToString:_user.username]){
                playerNum = i;
                _cards = [[NSMutableArray alloc] initWithArray:[player objectForKey:@"cardsInHand"]];
            }
        }
    }
    PFQuery *whiteQuery = [PFQuery queryWithClassName:@"WhiteCards"];
    [whiteQuery findObjectsInBackgroundWithBlock:^(NSArray *whiteDeck, NSError *error) {
        if([whiteDeck count] > 0){
            _deck = [[NSMutableArray alloc] initWithArray:[whiteDeck mutableCopy]];
        }
        for (int i = 0; i < _cards.count; i++) {
            CGRect frame;
            frame.origin.x = _handScrollView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = _handScrollView.frame.size;
            UIView *subview = [[UIView alloc] initWithFrame:frame];
            subview.backgroundColor = [UIColor clearColor];
            CGRect cardFrame = CGRectMake(20, 60, 280, 390);
            UIView *card = [[UIView alloc] initWithFrame:cardFrame];
            card.layer.cornerRadius = 5.0f;
            
            CGRect labelFrame = CGRectMake(20, 20, 240, 150);
            UILabel *myLabel = [[UILabel alloc] initWithFrame:labelFrame];
            [myLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:36]];
            [myLabel setTextColor:[UIColor blackColor]];
            card.backgroundColor = [UIColor whiteColor];

            if([_type isEqualToString:@"judge"]){
                [myLabel setTextColor:[self.view backgroundColor]];
                card.backgroundColor = [UIColor whiteColor];
            }
            [myLabel setLineBreakMode:NSLineBreakByWordWrapping];
            //[myLabel setBackgroundColor:[UIColor orangeColor]];
            
            NSString *cardContent;
            for(PFObject *card in _deck){
                //NSLog(@"CardID: %@",[NSNumber numberWithInteger:[card[@"cardId"] integerValue]]);
                NSInteger cardId;
                if([_type isEqualToString:@"judge"]){
                    cardId = [[[_cards objectAtIndex:i] objectForKey:@"cardId"] integerValue];
                }else{
                    cardId = [[_cards objectAtIndex:i] integerValue];
                }
                if([card[@"cardId"] integerValue] == cardId){
                    cardContent = [[NSString alloc] initWithString:card[@"cardContent"]];
                    NSLog(@"Card: %@",cardContent);
                    break;
                }
            }
            NSString *labelText = cardContent;
            [myLabel setText:labelText];
            
            // Tell the label to use an unlimited number of lines
            [myLabel setNumberOfLines:0];
            [myLabel sizeToFit];
            
            [card addSubview:myLabel];
            CGRect logoFrame = CGRectMake(220, 330, 50, 50);
            UIImage *logo = [UIImage imageNamed:@"poop.png"];
            UIImageView *logoView = [[UIImageView alloc] initWithFrame:logoFrame];
            [logoView setImage:logo];
            [card addSubview:logoView];
            
            [subview addSubview:card];
            //subview.backgroundColor = [colors objectAtIndex:i];
            [_handScrollView addSubview:subview];
        }
        
        _handScrollView.contentSize = CGSizeMake(_handScrollView.frame.size.width * _cards.count, _handScrollView.frame.size.height);
        [_handScrollView setDelegate:self];
    }];

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

-(NSInteger)drawCardFromDeck:(NSMutableArray *)deck{
    int r = arc4random_uniform((int)deck.count);     // Random card in pile
    NSInteger card = [[deck objectAtIndex:r] integerValue];
    [deck removeObjectAtIndex:r];
    return card;
}

- (IBAction)pickCard:(id)sender {
    int page = _handScrollView.contentOffset.x / _handScrollView.frame.size.width;
    NSLog(@"Chosen Card: %@",[NSNumber numberWithInt:page]);
    // Sync chosen card to Parse, specifically to the pool
    if([_type isEqualToString:@"judge"]){
        NSString *winningUser = [[_room[@"playingCardPool"] objectAtIndex:page] objectForKey:@"userId"];
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
        
        PFQuery *tipQuery = [PFQuery queryWithClassName:@"Tips"];
        [tipQuery findObjectsInBackgroundWithBlock:^(NSArray *tips, NSError *error) {
            int r = arc4random_uniform(tips.count);
            NSString *tip = [[NSString alloc] initWithString:[[tips objectAtIndex:r] objectForKey:@"tipContent"]];
            // Send push notification to query
            [PFPush sendPushMessageToQueryInBackground:pushQuery
                                           withMessage:[NSString stringWithFormat:@"%@ won the round \n\nEcoTip: %@",winningUser,tip]];
            NSMutableArray *players = [_room[@"players"] mutableCopy];
            for(int i = 0; i < players.count; i++){
                if([[[players objectAtIndex:i] objectForKey:@"userId"] isEqualToString:winningUser]){
                    NSMutableDictionary *player = [[players objectAtIndex:i] mutableCopy];
                    NSInteger pts = [[player objectForKey:@"points"] integerValue];
                    pts++;
                    [player setObject:[NSNumber numberWithInteger:pts] forKey:@"points"];
                    [players replaceObjectAtIndex:i withObject:player];
                }
            }
            [_room[@"judgePool"] removeObject:_room[@"currentJudge"]];
            // Check if judge pool is empty
            if([_room[@"judgePool"] count] == 0){
                // Reset judge list
                NSMutableArray *playerPool = [[NSMutableArray alloc] init];
                for(NSDictionary *player in _room[@"players"]){
                    [playerPool addObject:[player objectForKey:@"userId"]];
                }
                _room[@"judgePool"] = playerPool;
            }
            // Pick next Judge
            _room[@"currentJudge"] = [_room[@"judgePool"] firstObject];
            _room[@"currentPlayer"] = _room[@"currentJudge"];
            _room[@"currentBlackCard"] = [NSNumber numberWithInteger:-1];
            [_room saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];

        }];
    }else{
        NSDictionary *playedCard = @{@"cardId":[_cards objectAtIndex:page], @"userId":_user.username};
        NSMutableArray *playedPool = [_room[@"playingCardPool"] mutableCopy];
        [playedPool addObject:playedCard];
        _room[@"playingCardPool"] = playedPool;
        [_cards removeObjectAtIndex:page];
        
        // Draw new card if possible
        [_cards addObject:[NSNumber numberWithInteger:[self drawCardFromDeck:[_room[@"whiteDeck"] mutableCopy]]]];
        NSMutableDictionary *player = [[_room[@"players"] objectAtIndex:playerNum] mutableCopy];
        [player setObject:_cards forKey:@"cardsInHand"];
        [_room[@"players"] replaceObjectAtIndex:playerNum withObject:player];
        NSMutableArray *remainingPlayers = [_room[@"remainingPlayers"] mutableCopy];
        [remainingPlayers removeObject:_user.username];
        _room[@"remainingPlayers"] = remainingPlayers;
        // Choose next player
        if([remainingPlayers count] > 0){
            _room[@"currentPlayer"] = [remainingPlayers firstObject];
        }else{
            // All have picked, currentPlayer is currentJudge
            _room[@"currentPlayer"] = _room[@"currentJudge"];
        }
    }
    // Return to screen
    [_room saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
