//
//  ViewController.m
//  Quizzes
//
//  Created by co5ta on 14/12/2020.
//

#import "ViewController.h"
#import "Question.h"

/// Enum of game state
typedef NS_CLOSED_ENUM(NSInteger, GameState) {
    starting = 1,
    loading,
    playing,
    over,
    error
};

@interface ViewController ()
/// Button to start a new game
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionButtons;
@property Question *question;
@end

@implementation ViewController

/// Called after the controller's view is loaded into memory
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

/// Configures the view controller
- (void)configure {
    self.question = [Question new];
    [self setUpPlayButton];
    [self setUpOptionButtons];
    [self setGameState:starting];
    [self getQuestion];
}

/// Updates the views according to the game state
- (void)setGameState: (GameState) state {
    [self.playButton setHidden:state == starting ? false : true];
    if (state == playing) { [self updateQuestion]; }
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
    NSLog(@"%@", self.optionButtons);
    for (UIButton *button in self.optionButtons) {
        NSLog(@"%@", button);
        button.layer.cornerRadius = 10;
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    }
}

/// Fetch a question from the API
- (void)getQuestion {
    [self setGameState:loading];
    NSURL *url = [NSURL URLWithString:@"https://www.openquizzdb.org/api.php?key=6C52KPNVYW&choice=4"];
    NSError *error;
    
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (error != nil) {
        NSLog(@"Fatal error 1: %@", error.localizedDescription);
        exit(0);
    }
    
    NSDictionary *dico = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        NSLog(@"Fatal error 2: %@", error.localizedDescription);
        exit(0);
    }
    
    NSDictionary *results = dico[@"results"][0];
    self.question.title = results[@"question"];
    self.question.response = results[@"reponse_correcte"];
    self.question.options = results[@"autres_choix"];
    [self setGameState:playing];
}

/// updates the question displayed and the possible responses
- (void)updateQuestion {
    [self.questionLabel setText:self.question.title];
    for (int i = 0; i < [self.question.options count]; i++) {
        [self.optionButtons[i] setTitle:self.question.options[i] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.questionLabel setHidden:NO];
        for (UIButton *button in self.optionButtons) {
            [button setHidden:NO];
        }
    }];
}

@end
