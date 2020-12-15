//
//  ViewController.m
//  Quizzes
//
//  Created by co5ta on 14/12/2020.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)configure {
    self.playButton.layer.borderWidth = 1;
    self.playButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.playButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    self.playButton.layer.cornerRadius = 10;
}

@end
