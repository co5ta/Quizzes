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
    self.question = [Question new];
    [self configure];
}

/// Configures the view controller
- (void)configure {
    [self setUpPlayButton];
    [self setUpOptionButtons];
    [self setGameState:starting];
}

/// Updates the views according to the game state
- (void)setGameState: (GameState) state {
    switch (state) {
        case starting:
            [self.playButton setHidden:NO];
            [self.questionLabel setAlpha:0];
            for (UIButton *button in self.optionButtons) {
                [button setAlpha:0];
                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
            }
            break;
        case loading:
            [self.playButton setHidden:YES];
            break;
        case playing:
            [self updateQuestion];
            break;
        default:
            break;
    }
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
    for (UIButton *button in self.optionButtons) {
        button.layer.cornerRadius = 10;
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    }
}

/// Action which launch a game
- (IBAction)startGame:(UIButton *)sender {
    [self getQuestion];
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
        [self.questionLabel setAlpha:1];
    } completion:^(BOOL finished) {
        if (finished) {
            NSTimeInterval delay = 1;
            for (UIButton *button in self.optionButtons) {
                [UIView animateWithDuration:0.3 delay:delay usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [button setAlpha:1];
                    button.transform = CGAffineTransformIdentity;
                } completion:nil];
                delay += 0.5;
            }
        }
    }];
}

@end
