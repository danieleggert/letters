//
//  GlyphView.m
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "GlyphView.h"

#import "GlyphSequence.h"
#import "Glyph.h"
#import "Glyph+Drawing.h"



@implementation GlyphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dirtySetupHack];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.glyph drawInContext:ctx centeredInRect:self.bounds];
}

- (void)dirtySetupHack;
{
    GlyphSequence *sequence = [GlyphSequence sequence];
    sequence.text = @"F";
    NSArray *glyphs = sequence.glyphs;
    NSAssert([glyphs count] == 1, @"");
    self.glyph = glyphs[0];
    [self setNeedsDisplay];
}

@end
