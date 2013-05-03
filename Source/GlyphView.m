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



@implementation GlyphView

+ (instancetype)viewWithGlyph:(Glyph *)glyph;
{
    CGRect frame = glyph.boundingRect;
    frame.origin.x += glyph.position.x;
    frame.origin.y += glyph.position.y;
    GlyphView *view = [[super alloc] initWithFrame:frame];
    view.glyph = glyph;
    [view setNeedsDisplay];
    return view;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.glyph drawInContext:ctx centeredInRect:self.bounds];
}

@end
