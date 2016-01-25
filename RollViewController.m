//
//  RollViewController.m
//  Farkle
//
//  Created by Jerry on 1/21/16.
//  Copyright © 2016 A. R. Padhani. All rights reserved.
//

#import "RollViewController.h"
#import "ViewController.h"
#import "DieLabel.h"
#import "Player.h"

@interface RollViewController () <DieLabelDelegate>

@property (nonatomic, strong) IBOutletCollection (DieLabel) NSMutableArray *dieLabelArray; //THE LABEL OF THE DICE
@property NSMutableArray *selectedDiceArray; //DICE THAT ARE SELECTED
@property Player *currentPlayer;
@property NSMutableArray *diceCount; //HOW MANY OF EACH DICE
@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (weak, nonatomic) IBOutlet UIButton *keepScoreButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;

@property int whichPlayer;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerScoreLabel;

@end

@implementation RollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.whichPlayer = 0;
    
    self.selectedDiceArray = [NSMutableArray new];
    
    self.diceCount = [NSMutableArray new];
    
    for (int i = 0; i<6; i++) {
        [self.diceCount addObject:[NSNumber numberWithInt:0]];
    }
    
    for (DieLabel *dice in self.dieLabelArray) {
        dice.delegate = self;
        dice.backgroundColor = [UIColor blueColor];
        dice.text = [dice roll];
        dice.hidden = YES;
    }
    NSLog(@"%@", self.players);
    self.currentPlayer = [self.players objectAtIndex: 0];
    self.playerNameLabel.text = self.currentPlayer.firstName;
    self.playerScoreLabel.text = [NSString stringWithFormat:@"%i", self.currentPlayer.score];
    self.keepScoreButton.enabled = NO;
    self.scoreButton.enabled = NO;
    
//    [self nextPlayer];
    
}

-(void)selectedToCount{

//    for (int i = 0; i < 6; i++) {
//        
//        for (NSString *diceLabel in self.selectedDiceArray) {
//            
//            if ([diceLabel isEqualToString:[NSString stringWithFormat:@"%i", i+1]]) {
//                
//                NSNumber *temp = self.diceCount[i];
//                NSLog(@"%@",self.diceCount);
//                
//                int z = (int)temp + 1;
//                temp = [NSNumber numberWithInt:z];
//                
//                [self.diceCount replaceObjectAtIndex:i withObject:temp];
//            }
//        }
//    }
    
    
    for (int i = 0; i < self.selectedDiceArray.count; i++) {
        
        DieLabel *selectedLabel = [self.selectedDiceArray objectAtIndex:i];
        NSString *labelText = selectedLabel.text;
        int selectedInt = [labelText intValue];
        
        for (int j = 0; j<6; j++) {
            
            if (selectedInt == j+1) {
                NSLog(@"self.diceCount[j]");
                int diceArraySelected = [self.diceCount[j] intValue];
                diceArraySelected ++;
                [self.diceCount replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:diceArraySelected]];
            }
            
        }
        
        // Remove dielabel of selected from view
        DieLabel *dieToHide = [self.selectedDiceArray objectAtIndex:i];
        dieToHide.hidden = YES;
        
    }
    
    [self score:self.diceCount];

}

-(void)nextPlayer{
//    NSUInteger playersCount = self.players.count;
//    playersCount-=1;
//    if (self.whichPlayer  == playersCount ) {
//        self.whichPlayer = -1;
//    }
    
    
    
    self.whichPlayer++;
    
    if (self.whichPlayer <= self.players.count - 1) {
        self.currentPlayer = [self.players objectAtIndex:self.whichPlayer];
        
        for (DieLabel *dice in self.dieLabelArray) {
            dice.backgroundColor = [UIColor blueColor];
            dice.hidden = NO;
        }
        
        self.playerNameLabel.text = self.currentPlayer.firstName;
        
        self.playerScoreLabel.text = [NSString stringWithFormat:@"%d",self.currentPlayer.score];
    } else {
        // Game over, tally up score and display winner
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"And the winner is..." message:@"You all lost" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *startOver = [UIAlertAction actionWithTitle:@"Start Over" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        [alertController addAction:startOver];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (void)handleLabelTapped:(UILabel *)label {
    DieLabel *diceLabel = (DieLabel *)label;
    if ([self.selectedDiceArray containsObject:(DieLabel *)diceLabel]) {
        [self.selectedDiceArray removeObject:diceLabel];
    } else {
        [self.selectedDiceArray addObject:diceLabel];
    }
    NSLog(@"%@", self.selectedDiceArray);
}

- (IBAction)onRollButtonPressed:(UIButton *)sender {
    
    if ([self shouldReRollAll]) {
        for (DieLabel *dice in self.dieLabelArray) {
            dice.delegate = self;
            dice.text = [dice roll];
            dice.hidden = NO;
        }
    } else {
        for (DieLabel *dice in self.dieLabelArray) {
            dice.delegate = self;
            dice.text = [dice roll];
        }
    }
    
    sender.hidden = YES;
    self.keepScoreButton.enabled = YES;
    self.scoreButton.enabled = YES;
}

- (BOOL)shouldReRollAll {
    int countHidden = 0;
    for (DieLabel *dice in self.dieLabelArray) {
        if (dice.hidden ) {
            countHidden++;
        }
    }
    if (countHidden == 6) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)onScoreButtonPressed:(UIButton *)sender {
    
    [self selectedToCount];
    self.rollButton.enabled = YES;
}

- (IBAction)onKeepScoreButtonPressed:(UIButton *)sender {
    
    [self.selectedDiceArray removeAllObjects];
    self.rollButton.enabled = YES;
    [self selectedToCount];
    [self nextPlayer];
}

- (void)score:(NSMutableArray *)selectedArray {
    int playSum = 0;
    
    // Six of a kind
    for (int i=0; i<self.diceCount.count; i++) {
        if ([[self.diceCount objectAtIndex:i] intValue] == 6) {
//            self.currentPlayer.score += 3000;
            playSum += 3000;
            [self.diceCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
            self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-6;

        }
    }
    
    // Five of a kind
    for (int i=0; i<self.diceCount.count; i++) {
        if ([[self.diceCount objectAtIndex:i] intValue] == 5) {
            // self.currentPlayer.score += 2000;
            playSum += 2000;
            [self.diceCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
            self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-5;

        }
    }
    
    // Straight
    if ([self.diceCount objectAtIndex:0] == [NSNumber numberWithInt:1]
        && [self.diceCount objectAtIndex:1] == [NSNumber numberWithInt:1]
        && [self.diceCount objectAtIndex:2] == [NSNumber numberWithInt:1]
        && [self.diceCount objectAtIndex:3] == [NSNumber numberWithInt:1]
        && [self.diceCount objectAtIndex:4] == [NSNumber numberWithInt:1]
        && [self.diceCount objectAtIndex:5] == [NSNumber numberWithInt:1]
        && [self.diceCount objectAtIndex:6] == [NSNumber numberWithInt:1]) {
        
        // self.currentPlayer.score += 1500;
        playSum += 1500;
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-6;
        for (int i=0; i<self.diceCount.count; i++) {
            [self.diceCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];

        }
    }
    
    int isMultiple = 0;
    
    // Two triples
    for (int i=0; i<self.diceCount.count; i++) {
        if ([[self.diceCount objectAtIndex:i] intValue] == 3) {
            isMultiple++;
        }
        if (isMultiple == 2) {
            // self.currentPlayer.score += 1500;
            playSum += 1500;
            for (int i=0; i<self.diceCount.count; i++) {
                [self.diceCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
                self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-6;

            }
        }
    }
    isMultiple = 0;

    // Three doubles
    for (int i=0; i<self.diceCount.count; i++) {
        if ([[self.diceCount objectAtIndex:i] intValue] == 2) {
            isMultiple++;
        }
        if (isMultiple == 3) {
            // self.currentPlayer.score += 1500;
            playSum += 1500;
            for (int i=0; i<self.diceCount.count; i++) {
                [self.diceCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
                self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-6;

            }
        }
    }
    
    int isDouble = 0;
    int isQuadruple = 0;
    // Four/Two pair
    for (int i=0; i<self.diceCount.count; i++) {
        if ([[self.diceCount objectAtIndex:i] intValue] == 2) {
            isDouble++;
        }
        if ([[self.diceCount objectAtIndex:i] intValue] == 4) {
            isQuadruple++;
        }
        if (isDouble == 2 && isQuadruple == 4) {
            // self.currentPlayer.score += 1500;
            playSum += 1500;
            for (int i=0; i<self.diceCount.count; i++) {
                [self.diceCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
                self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-6;

            }
        }
    }
    isMultiple = 0;
    isDouble = 0;
    isQuadruple = 0;
    
    // Four of a kind
    for (int i=0; i<self.diceCount.count; i++) {
        if ([[self.diceCount objectAtIndex:i] intValue] == 4) {
            // self.currentPlayer.score += 1000;
            playSum += 1000;
            [self.diceCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
            self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-4;
        }
    }
    
    // Three of a kind
    
    if ([[self.diceCount objectAtIndex:5] intValue] == 3) {
        // self.currentPlayer.score += 600;
        playSum += 600;
        [self.diceCount replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:0]];
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-3;

    }
    
    // Three of a kind
    if ([[self.diceCount objectAtIndex:4] intValue] == 3) {
        // self.currentPlayer.score += 500;
        playSum += 500;
        [self.diceCount replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:0]];
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-3;

    }
    
    // Three of a kind
    if ([[self.diceCount objectAtIndex:3] intValue] == 3) {
        // self.currentPlayer.score += 400;
        playSum += 400;
        [self.diceCount replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:0]];
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-3;

    }
    
    // Three of a kind
    if ([[self.diceCount objectAtIndex:2] intValue] == 3) {
        // self.currentPlayer.score += 300;
        playSum += 300;
        [self.diceCount replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:0]];
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-3;

    }
    
    // Three of a kind
    if ([[self.diceCount objectAtIndex:1] intValue] == 3) {
        // self.currentPlayer.score += 200;
        playSum += 200;
        [self.diceCount replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:0]];
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-3;

    }
    
    // Three of a kind
    if ([[self.diceCount objectAtIndex:0] intValue] == 3) {
        // self.currentPlayer.score += 300;
        playSum += 300;
        [self.diceCount replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:0]];
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-3;

    }
    
    //number of ones
    int isOne = [[self.diceCount objectAtIndex:0] intValue];
    
    if (isOne < 3) {
        // self.currentPlayer.score += isOne * 100;
        playSum += isOne * 100;
        [self.diceCount replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:0]];
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-1;

    }

    
    //number of fives
    int isFive = [[self.diceCount objectAtIndex:4] intValue];
    if (isFive < 3) {
        // self.currentPlayer.score += isFive * 50;
        playSum += isFive * 50;
        [self.diceCount replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:0]];
        self.currentPlayer.dieInPlay = self.currentPlayer.dieInPlay-1;

    }
    
    int sum = 0;
    
    for (int i=0; i < self.diceCount.count; i++) {
        sum += [self.diceCount[i] intValue];
    }
    
    if (sum == 0) {
        // Roll again
    } else if (sum == 6) {
        [self nextPlayer];
    }
    
    if (playSum == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Farkle!" message:@"You've lost your turn" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *nextPlayerTurn = [UIAlertAction actionWithTitle:@"Next Player" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Call Next Player and reset board
        }];
        [alertController addAction:nextPlayerTurn];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        self.currentPlayer.score += playSum;
        self.playerScoreLabel.text = [NSString stringWithFormat:@"%d",self.currentPlayer.score];
    }
    
    [self.selectedDiceArray removeAllObjects];
    
    // Auto Roll
    if ([self shouldReRollAll]) {
        for (DieLabel *dice in self.dieLabelArray) {
            dice.delegate = self;
            dice.text = [dice roll];
            dice.hidden = NO;
        }
    } else {
        for (DieLabel *dice in self.dieLabelArray) {
            dice.delegate = self;
            dice.text = [dice roll];
        }
    }
}

@end
