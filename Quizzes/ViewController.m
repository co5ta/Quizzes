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
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *option1Button;
@property (weak, nonatomic) IBOutlet UIButton *option2Button;
@property (weak, nonatomic) IBOutlet UIButton *option3Button;
@property (weak, nonatomic) IBOutlet UIButton *option4Button;
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
    [self setUpPlayButton];
    [self setUpOptionButtons];
}

/// Updates the views according to the game state
- (void)setGameState: (GameState) state {
    [self.playButton setHidden:state == starting ? false : true];
}

/// Sets up play button
- (void)setUpPlayButton {
    self.playButton.layer.borderWidth = 1;
    self.playButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.playButton.layer.cornerRadius = 10;
    self.playButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
}

/// Sets up option buttons style
- (void)setUpOptionButtons {
    for (UIButton *button in @[self.option1Button, self.option2Button]) {
        button.layer.cornerRadius = 10;
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    }
}

@end
