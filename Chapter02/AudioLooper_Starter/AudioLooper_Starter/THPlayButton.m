//
//  THPlayButton.m
//  AudioLooper_Starter
//
//  Created by QinTuanye on 2019/3/23.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "THPlayButton.h"
#import "UIColor+THAdditions.h"

@implementation THPlayButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set up Colors
    UIColor *strokeColor = [UIColor colorWithWhite:0.06 alpha:1.0f];
    UIColor *gradientLightColor = [UIColor colorWithRed:0.101 green:0.100 blue:0.103 alpha:1.000];
    UIColor *gradientDarkColor = [UIColor colorWithRed:0.237 green:0.242 blue:0.242 alpha:1.000];
    
    if (self.highlighted) {
        gradientLightColor = [gradientLightColor darkerColor];
        gradientDarkColor = [gradientDarkColor darkerColor];
    }
    
    NSArray *gradientColors = @[(id)gradientLightColor.CGColor,
                                (id)gradientDarkColor.CGColor];
    CGFloat locations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, locations);
    
    CGRect insetRect = CGRectInset(rect, 2.0f, 2.0f);
    
    // Draw Bezel
    CGContextSetFillColorWithColor(context, strokeColor.CGColor);
    UIBezierPath *bezelPath = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:6.0f];
    CGContextAddPath(context, bezelPath.CGPath);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.5f), 2.0f, [UIColor darkGrayColor].CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSaveGState(context);
    // add Clipping Region for Knob Background
    insetRect = CGRectInset(insetRect, 3.0f, 3.0f);
    UIBezierPath *buttonPath = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:4.0f];
    CGContextAddPath(context, buttonPath.CGPath);
    CGContextClip(context);
    
    CGFloat midX = CGRectGetMidX(insetRect);
    
    CGPoint startPoint = CGPointMake(midX, CGRectGetMaxY(insetRect));
    CGPoint endPoint = CGPointMake(midX, CGRectGetMinY(insetRect));
    
    // Draw Button Gradient Background
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
    
    UIColor *fillColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, [fillColor darkerColor].CGColor);
    
    CGFloat iconDim = 24.0f;
    // Draw Play Button
    if (!self.selected) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMidX(rect) - (iconDim - 3) / 2, CGRectGetMidY(rect) - iconDim / 2);
        CGContextMoveToPoint(context, 0.0f, 0.0f);
        CGContextAddLineToPoint(context, 0.0f, iconDim);
        CGContextAddLineToPoint(context, iconDim, iconDim / 2);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        CGContextRestoreGState(context);
    } else {
        // Draw Stop Button
        CGContextSaveGState(context);
        CGFloat tx = (CGRectGetWidth(rect) - iconDim) / 2;
        CGFloat ty = (CGRectGetHeight(rect) - iconDim) / 2;
        CGContextTranslateCTM(context, tx, ty);
        CGRect stopRect = CGRectMake(0.0f, 0.0f, iconDim, iconDim);
        UIBezierPath *stopPath = [UIBezierPath bezierPathWithRoundedRect:stopRect cornerRadius:2.0f];
        CGContextAddPath(context, stopPath.CGPath);
        CGContextDrawPath(context, kCGPathFill);
        CGContextRestoreGState(context);
    }
}

@end
