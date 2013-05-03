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
    // Flip:
    position.y -= CGRectGetHeight(self.boundingRect);
    // Offset for the bounding rect:
    position.x -= self.boundingRect.origin.x;
    position.y -= self.boundingRect.origin.y;
    
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    
    CGContextSetTextMatrix(ctx, CGAffineTransformScale(self.textMatrix, 1, -1));
    CGContextSetFont(ctx, self.graphicsFont);
    CGContextSetFontSize(ctx, self.pointSize);
    CGContextShowGlyphsAtPositions(ctx, (CGGlyph const []){self.graphicsGlyph}, (CGPoint const []){position}, 1);
}

@end
