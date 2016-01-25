//
//  DieLabel.m
//  Farkle
//
//  Created by Adish Padhani on 1/21/16.
//  Copyright © 2016 A. R. Padhani. All rights reserved.
//

#import "DieLabel.h"

@interface DieLabel () <UIGestureRecognizerDelegate>

@end

@implementation DieLabel


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelTapped:)];
        
        self.userInteractionEnabled = YES;
        self.gestureRecognizers = @[tapped];
        self.gestureRecognizers[0].delegate = self;

    }
    

    return self;
}

-(void)onLabelTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized){
        [self.delegate handleLabelTapped: self];
//        self.hidden = YES;
        if (self.backgroundColor != [UIColor grayColor]) {
            self.backgroundColor = [UIColor grayColor];
        } else {
            self.backgroundColor = [UIColor blueColor];
        }
        
    }

}

-(NSString *)roll{
    
    int rand = arc4random_uniform(6)+1;
    return [NSString stringWithFormat:@"%i",rand];
    
}

@end
