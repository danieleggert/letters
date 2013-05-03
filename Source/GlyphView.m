//
//  GlyphView.m
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "GlyphView.h"

#import "Glyph.h"
#import "Glyph+Drawing.h"

static const CGFloat Margin = 1;


@interface GlyphView ()

@property (nonatomic) CGPoint offset;

@end



@implementation GlyphView

+ (instancetype)viewWithGlyph:(Glyph *)glyph;
{
    CGRect frame = glyph.boundingRect;
    frame.origin.x += glyph.position.x;
    frame.origin.y += glyph.position.y;
    CGRect const originalFrame = frame;
    frame = CGRectIntegral(frame);
    frame = CGRectInset(frame, -Margin, -Margin);
    GlyphView *view = [[super alloc] initWithFrame:frame];
    view.glyph = glyph;
    view.offset = CGPointMake(CGRectGetMinX(originalFrame) - CGRectGetMinX(frame),
                              CGRectGetMinY(originalFrame) - CGRectGetMinY(frame));
    view.backgroundColor = [UIColor clearColor];
    [view setNeedsDisplay];
    return view;
}

- (BOOL)isOpaque;
{
    return NO;
}

- (void)setSelected:(BOOL)selected;
{
    if (selected == _selected) {
        return;
    }
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect r = self.bounds;
    r.origin.x += self.offset.x;
    r.origin.y -= self.offset.y;

    
    [self.glyph drawSelected:self.selected context:ctx centeredInRect:r];
}

@end
