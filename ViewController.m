//
//  ViewController.m
//  Farkle
//
//  Created by Adish Padhani on 1/21/16.
//  Copyright © 2016 A. R. Padhani. All rights reserved.
//

#import "ViewController.h"
#import "RollViewController.h"
#import "Player.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.players = [[NSMutableArray alloc] init];
    
}

- (IBAction)onPlayButtonTapped:(UIBarButtonItem *)sender {
    
}

- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender {
    
    Player *newPlayer = [[Player alloc] init];
    newPlayer.firstName = self.textField.text;
    [self.players addObject:newPlayer];
    [self.tableView reloadData];
    self.textField.text = @"";
    NSLog(@"%@",self.players);
    
}

// Required Table View method. Tells the Table View how many cells to publish
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.players.count;
}

// Required Table View method. Tells the Table View what to do in each cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Player *currentPlayer = self.players[indexPath.row];
    cell.textLabel.text = currentPlayer.firstName;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    RollViewController *rollVC = segue.destinationViewController;
    rollVC.players = self.players;
    
}

@end
