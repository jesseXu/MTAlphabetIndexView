//
//  MTAlphabetIndexView.m
//  TestTransform
//
//  Created by jesse on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MTAlphabetIndexView.h"
#import <QuartzCore/QuartzCore.h>

#define length 28

@interface MTAlphabetIndexView ()
{
    CALayer     *_alphabetLayers[length];
    BOOL         _status[length];
}

@end


@implementation MTAlphabetIndexView

@synthesize delegate = _delegate;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self disableAllIndexes];
        
    }
    return self;
}



#pragma mark - private method

- (void)initLayers
{
    for (int i = 0; i < length / 4; i ++)
    {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(15.0f, 8.0f + i * 65.0f, 290.0f, 55.0f);
        
        for (int j = 0; j < 4; j ++)
        {
            NSInteger index = i * 4 + j;
            
            CALayer *alphabetLayer = [CALayer layer];
            alphabetLayer.frame = CGRectMake(j * 75.0f, 0.0f, 65.0f, 55.0f);
            alphabetLayer.backgroundColor = [UIColor redColor].CGColor;
            [layer addSublayer:alphabetLayer];
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake(10.0f, 25.0f, 30.0f, 30.0f);
            textLayer.string = [self alphabetAtIndex:index];
            textLayer.font = @"Helvetica-Bold";
            textLayer.fontSize = 24.0f;
            [alphabetLayer addSublayer:textLayer];
            
            _alphabetLayers[index] = alphabetLayer;
        }
        
        [self.layer addSublayer:layer];
    }
}


- (void)reloadData
{
    for (int i = 0; i < length; i ++)
    {
        if (_status[i])
        {
            CALayer *layer = _alphabetLayers[i];
            layer.backgroundColor = [UIColor colorWithRed:255.0/255 green:85.0f/255 blue:119.0/255 alpha:1.0f].CGColor;
            
            CATextLayer *textLayer = layer.sublayers.lastObject;
            textLayer.foregroundColor = [UIColor whiteColor].CGColor;
        }
        else 
        {
            CALayer *layer = _alphabetLayers[i];
            layer.backgroundColor = [UIColor colorWithWhite:66./255 alpha:1.].CGColor;
            
            CATextLayer *textLayer = layer.sublayers.lastObject;
            textLayer.foregroundColor = [UIColor colorWithWhite:204./255 alpha:1.].CGColor;
        }
    }
}


- (void)disableAllIndexes
{
    for (int i = 0; i < length; i ++)
    {
        _status[i] = NO;
    }
}


#pragma mark - public method

- (NSString *)alphabetAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        return @"#";
    }
    
    if (index > 0 && index < 27)
    {
        return [NSString stringWithFormat:@"%c", 'A' + index - 1];
    }
    
    return @"";
}


- (void)setIndex:(NSInteger)index enabled:(BOOL)enabled
{
    _status[index] = enabled;
}


- (void)setEnabledIndexes:(NSArray *)indexes
{
    [self disableAllIndexes];
    
    for (NSNumber *indexValue in indexes)
    {
        _status[[indexValue integerValue]] = YES;
    }
}


- (void)show
{
    [self initLayers];
    [self reloadData];
    
    CATransform3D transform = CATransform3DIdentity;
    float zDistanse = 500.0f;
    transform.m34 = 1.0f / zDistanse;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform,-0.8f ,1.0f,0.0f,0.0f)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform,0.0f,1.0f,0.0f,0.0f)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animation setDuration:0.2f];

    [CATransaction begin];
    
    for (CALayer *layer in self.layer.sublayers)
    {
        [layer addAnimation:animation forKey:nil];
    }
    
    [CATransaction commit];
    
}

- (void)hide
{
    CATransform3D transform = CATransform3DIdentity;
    float zDistanse = 500.0f;
    transform.m34 = 1.0f / zDistanse;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform, 0.0f, 1.0f, 0.0f, 0.0f)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform, 1.5f , 1.0f, 0.0f, 0.0f)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [animation setDuration:0.15f];
    
    [CATransaction begin];
    
    for (CALayer *layer in self.layer.sublayers)
    {
        [layer addAnimation:animation forKey:nil];
    }
    
    [CATransaction setCompletionBlock:^{

        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
        
    }];
    
    [CATransaction commit];
}

#pragma mark - UIView delegate

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger index = [self calIndexWithPoint:touchPoint];
    
    if (index > -1 && _status[index])
    {
        [self.delegate alphabetIndexView:self alphabetDidSelect:index];
        [self hide];
    }
}

- (NSInteger)calIndexWithPoint:(CGPoint)point
{
    if (point.x > 15.0f && point.x < 305.0f && point.y > 8.0f && point.y < 453.0f)
    {
        NSInteger col = ((NSInteger)(point.x -  15.0f)) / 75;
        NSInteger row = ((NSInteger)(point.y - 8.0f)) / 65;
        
        if (point.x < col * 75 + 15 + 65 && point.y < row * 65 + 8 + 55)
        {
            return row * 4 + col;
        }
        else 
            return -1;
    }
    
    return -1;
}


@end




