//
//  Glyph+Drawing.m
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "Glyph+Drawing.h"
#import "Glyph+Internal.h"



@implementation Glyph (Drawing)

- (void)drawInContext:(CGContextRef)ctx centeredInRect:(CGRect)rect;
{
    CGPoint position = rect.origin;
    position.y += CGRectGetHeight(self.boundingRect);
    
    CGContextSetTextMatrix(ctx, CGAffineTransformScale(self.textMatrix, 1, -1));
    CGContextSetFont(ctx, self.graphicsFont);
    CGContextSetFontSize(ctx, self.pointSize);
    CGContextShowGlyphsAtPositions(ctx, (CGGlyph const []){self.graphicsGlyph}, (CGPoint const []){position}, 1);
}

@end