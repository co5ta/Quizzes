//
//  ViewController.h
//  Quizzes
//
//  Created by co5ta on 14/12/2020.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface ViewController : UIViewController

/// Enum of game state
typedef NS_CLOSED_ENUM(NSInteger, GameState) {
    starting = 1,
    loading,
    playing,
    over,
    error
};

/// Button that starts a new game
@property (weak, nonatomic) IBOutlet UIButton *playButton;
/// Label that contains the question
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
/// Buttons that contains the available responses
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionButtons;
/// Object that contains data about the question
@property Question *question;
/// Score of the player
@property NSInteger score;

@end

