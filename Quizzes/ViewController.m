//
//  ViewController.m
//  Quizzes
//
//  Created by co5ta on 14/12/2020.
//

#import "ViewController.h"

/// Enum of game state
typedef NS_CLOSED_ENUM(NSInteger, GameState) {
    starting = 1,
    loading,
    playing,
    over
};

@interface ViewController ()
/// Button to start a new game
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@end

@implementation ViewController

/// Called after the controller's view is loaded into memory
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

/// Configures the view controller
- (void)configure {
    [self setGameState:starting];
    self.playButton.layer.borderWidth = 1;
    self.playButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.playButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    self.playButton.layer.cornerRadius = 10;
}

/// Updates the views according to the game state
- (void)setGameState: (GameState) state {
    [self.playButton setHidden:state == starting ? false : true];
}

@end
