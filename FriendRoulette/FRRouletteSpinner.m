//
//  FRRouletteSpinner.m
//  FriendRoulette
//
//  Created by Keiran on 4/12/14.
//  Copyright (c) 2014 asskon. All rights reserved.
//

#import "FRRouletteSpinner.h"

@interface FRRouletteSpinner()

+ (void)rotateLayerInfinite:(CALayer *)layer;

@end

@implementation FRRouletteSpinner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initialize {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roulette.png"]];
    self.hidden = YES;
    image.frame = self.frame;
    CGRect frame = image.frame;
    CGPoint origin = frame.origin;
    origin.x = 0;
    origin.y = 0;
    frame.origin = origin;
    image.frame = frame;
    image.opaque = NO;
    self.opaque = NO;
    [self addSubview:image];
}

- (void)start {
    self.hidden = NO;
    [FRRouletteSpinner rotateLayerInfinite:self.layer];
}

- (void)stop {
    self.hidden = YES;
    [self.layer removeAllAnimations];
}

+ (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 1.3f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
