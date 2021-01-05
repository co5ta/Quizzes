//
//  ViewController.m
//  Quizzes
//
//  Created by co5ta on 14/12/2020.
//

#import "ViewController.h"

@implementation ViewController

/// Called after the controller's view is loaded into memory
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self setGameState:starting];
}

/// Configures the view controller
- (void)configure {
    self.question = [Question new];
    [self setUpPlayButton];
    [self setUpOptionButtons];
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

/// Updates the views according to the game state
- (void)setGameState: (GameState) state {
    switch (state) {
        case starting:
            [self showHomeScreen];
            break;
        case loading:
            [self showLoadingScreen];
            break;
        case playing:
            [self updateQuestionDisplayed];
            break;
        default:
            break;
    }
}

/// Configures the UI to show the home screen
- (void)showHomeScreen {
    self.score = 0;
    [self.playButton setHidden:NO];
    [self.questionLabel setAlpha:0];
    for (UIButton *button in self.optionButtons) {
        [button setAlpha:0];
        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    }
}

/// Configures the UI to show the loading screen
- (void)showLoadingScreen {
    [self.playButton setHidden:YES];
    [self.questionLabel setAlpha:0];
    for (UIButton *button in self.optionButtons) {
        [button setAlpha:0];
        button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setBackgroundColor:UIColor.systemTealColor];
    }
}

/// Action which launch a game
- (IBAction)playButtonTapped:(UIButton *)sender {
    [self getNewQuestion];
}

/// Fetchs a new question to display
- (void)getNewQuestion {
    [self setGameState:loading];
    NSDictionary *results = [self requestQuestion];
    self.question.title = results[@"question"];
    self.question.response = results[@"correct_answer"];
    self.question.options = [NSMutableArray arrayWithArray:results[@"incorrect_answers"]];
    [self.question.options addObject:results[@"correct_answer"]];
    NSInteger randomIndex = arc4random_uniform((u_int32_t )self.question.options.count-1);
    [self.question.options exchangeObjectAtIndex:self.question.options.count-1 withObjectAtIndex:randomIndex];
    [self setGameState:playing];
}

/// Requests a new question to the API
- (NSDictionary*)requestQuestion {
    NSURL *url = [NSURL URLWithString:@"https://opentdb.com/api.php?amount=1&encode=url3986"];
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
    return dico[@"results"][0];
}

/// Updates the question data
- (void)updateQuestionDisplayed {
    [self.questionLabel setText:[self.question.title stringByRemovingPercentEncoding]];
    for (int i = 0; i < [self.question.options count]; i++) {
        [self.optionButtons[i] setTitle:[self.question.options[i] stringByRemovingPercentEncoding] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.questionLabel setAlpha:1];
    } completion:^(BOOL finished) {
        if (finished) {
            NSTimeInterval delay = 1;
            for (UIButton *button in self.optionButtons) {
                if ([button.currentTitle isEqualToString:@""]) { continue; }
                [UIView animateWithDuration:0.3 delay:delay usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [button setAlpha:1];
                    button.transform = CGAffineTransformIdentity;
                } completion:nil];
                delay += 0.5;
            }
        }
    }];
}

/// Checks if the answer is good or false and passes to the next question
- (IBAction)checkAnswer:(UIButton *)sender {
    BOOL goodAnswer = sender.currentTitle == self.question.response ? YES : NO;
    [sender setBackgroundColor:goodAnswer ? UIColor.systemGreenColor : UIColor.systemRedColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getNewQuestion];
    });
}

@end
