//
//  ViewController.m
//  AnimationProject
//
//  Created by Vladyslav Gusakov on 3/31/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView-PlayGIF/UIImageView+PlayGIF.h"
//#import "loginViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate> {
    CGPoint ballCenter;
    CGPoint barCenter;
    BOOL firstTime;
    NSUInteger scoreCounter;
    UIDynamicItemBehavior *ballBehavior;
    UIPanGestureRecognizer *pan1;
}

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (strong, nonatomic) IBOutlet UIImageView *arcanoidBar;
@property (strong, nonatomic) IBOutlet UIImageView *ball;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIImageView *ground;
@property (strong, nonatomic) IBOutlet UIImageView *you_lost;
@property (strong, nonatomic) IBOutlet UIImageView *firstDigitImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondDigitImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdDigitImageView;
@property (strong, nonatomic) IBOutlet UIImageView *scoreImage;

- (IBAction)start:(UIButton *)sender;
- (IBAction)reset:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //arcanoid set up
    self.arcanoidBar.userInteractionEnabled = YES;
    self.arcanoidBar.hidden = YES;
    self.arcanoidBar.layer.cornerRadius = 5.0f;

    pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveObject:)];
    pan1.minimumNumberOfTouches = 1;
    [self.arcanoidBar addGestureRecognizer:pan1];

    //ball set up
    self.ball.layer.cornerRadius = 15.0f;
    self.ball.layer.masksToBounds = YES;
    self.ball.hidden = YES;

    //ground set up
    UIImage *image = [UIImage imageNamed:@"ground_new"];
    UIImage *tiledImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    self.ground.image = tiledImage;
    
    //score set up
    self.scoreImage.hidden = YES;
    self.firstDigitImageView.hidden = YES;
    self.secondDigitImageView.hidden = YES;
    self.thirdDigitImageView.hidden = YES;
    
    firstTime = YES;
    scoreCounter = 0;

    //username
    self.username.text = [NSString stringWithFormat:@"Logged as %@", self.usr];
    
    //reset button set up
    UIImage *birdie = [UIImage imageNamed:@"reset.gif"];
    
    const CGFloat colorMasking[6] = {222, 255, 222, 255, 222, 255};
    birdie = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(birdie.CGImage, colorMasking)];
    [self.resetButton setImage:birdie forState:UIControlStateNormal];
        
}

-(void) viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:NO];
    
    //additional arcanoid set up
    self.arcanoidBar.center = CGPointMake(self.view.center.x, self.ground.center.y - 30);
    barCenter = self.arcanoidBar.center;
    self.arcanoidBar.hidden = NO;
    
    //additional ball set up
    self.ball.center = CGPointMake(self.view.center.x, 30);
    ballCenter = self.ball.center;

}

-(void)moveObject:(UIPanGestureRecognizer *)pan;
{
    CGPoint panPoint = [pan locationInView:self.arcanoidBar.superview];
    self.arcanoidBar.center = CGPointMake(panPoint.x, self.arcanoidBar.center.y);
    [self.animator updateItemUsingCurrentState:self.arcanoidBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initGame {
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    [self.animator addBehavior:gravityBehavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ball, self.arcanoidBar]];
    
    [collisionBehavior addBoundaryWithIdentifier:@"ground"
                                       fromPoint:self.ground.frame.origin
                                         toPoint:CGPointMake(self.ground.frame.origin.x + self.ground.frame.size.width, self.ground.frame.origin.y)];
    
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.collisionDelegate = self;
    
    [self.animator addBehavior:collisionBehavior];
    
    ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ball]];
    ballBehavior.elasticity = 1;
    ballBehavior.resistance = 0;
    ballBehavior.friction = 0;
    ballBehavior.allowsRotation = YES;
    
    [self.animator addBehavior:ballBehavior];
    
    UIDynamicItemBehavior *paddleBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.arcanoidBar]];
    paddleBehavior.allowsRotation = NO;
    paddleBehavior.density = 100000.0;
    [self.animator addBehavior:paddleBehavior];    
}

- (IBAction)start:(UIButton *)sender {
    
    self.ball.hidden = NO;
    self.you_lost.hidden = YES;
    sender.hidden = YES;
    
    [self initGame];
    
    self.resetButton.hidden = YES;
    self.scoreImage.hidden = NO;
    self.firstDigitImageView.hidden = NO;
    self.firstDigitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"digit%lu", scoreCounter]];

}

- (IBAction)reset:(id)sender {
    
    firstTime = YES;
    [self.animator removeAllBehaviors];
    pan1.enabled = YES;

    
    [self.you_lost stopGIF];
    self.you_lost.hidden = YES;
    self.resetButton.hidden = YES;
    
    self.ball.center = ballCenter;
    self.arcanoidBar.center = barCenter;
    
    scoreCounter = 0;
    self.firstDigitImageView.hidden = NO;
    self.firstDigitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"digit%lu", scoreCounter]];
    
    self.secondDigitImageView.hidden = YES;
    self.thirdDigitImageView.hidden = YES;
    
    [self initGame];
    
}

-(void) collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    NSString *contactedObject = (NSString *) identifier;

    if ([contactedObject isEqualToString:@"ground"]// && firstTime == NO
        ) {
        NSLog(@"ground touched");
        
        ballBehavior.elasticity = 0;
        ballBehavior.resistance = 1;
        ballBehavior.friction = 1;
//        [self.animator removeAllBehaviors];

        pan1.enabled = NO;
    
        self.you_lost.gifPath = [[NSBundle mainBundle] pathForResource:@"you_lost.gif" ofType:nil];
        [self.you_lost startGIF];
        
        self.you_lost.hidden = NO;
        self.resetButton.hidden = NO;
        
    }
    else {
       // firstTime = NO;
    }
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p{
    
    if (item1 == self.ball && item2 == self.arcanoidBar) {
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
//        pushBehavior.angle = 0.78;
        pushBehavior.magnitude = 0.3;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.animator addBehavior:pushBehavior];
        
        
        //no laggy ball
            ++scoreCounter;
            if (scoreCounter < 10) {
                self.firstDigitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"digit%lu", scoreCounter]];
            } else
                if (scoreCounter < 100) {
                    self.secondDigitImageView.hidden = NO;
                    self.firstDigitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"digit%lu", scoreCounter/10]];
                    self.secondDigitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"digit%lu", scoreCounter%10]];
                } else {
                    self.thirdDigitImageView.hidden = YES;
                    self.firstDigitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"digit%lu", scoreCounter/100]];
                    self.secondDigitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"digit%lu", (scoreCounter%100)/10]];
                    self.secondDigitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"digit%lu", scoreCounter%10]];
                }
        });
        
        
    }
}


//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInView:self.view];
//    
//    CGFloat yPoint = barCenter.y;
//    CGPoint paddleCenter = CGPointMake(touchLocation.x, yPoint);
//    
//    self.arcanoidBar.center = paddleCenter;
//    [self.animator updateItemUsingCurrentState:self.arcanoidBar];
//}

@end
