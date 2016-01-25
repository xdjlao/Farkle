#import <UIKit/UIKit.h>

@protocol DieLabelDelegate <NSObject>

@required

-(void)handleLabelTapped:(UILabel *)label;

@end



@interface DieLabel : UILabel

@property (assign, nonatomic) id <DieLabelDelegate> delegate;

-(NSString *)roll;

@end
