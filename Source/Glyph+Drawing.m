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

- (void)drawSelected:(BOOL)selected context:(CGContextRef)ctx centeredInRect:(CGRect)rect;
{
    CGContextSaveGState(ctx);
    switch (self.drawingStyle) {
        default:
        case GlyphDrawingStyle0: {
            CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
            CGContextSetTextDrawingMode(ctx, kCGTextFill);
            [self showInContext:ctx centeredInRect:rect];
//            UIImage *image = [UIImage imageNamed:@"texture1"];
//            CGRect rect = CGRectZero;
//            rect.size = image.size;
//            CGContextDrawTiledImage(ctx, rect, image.CGImage);
//            CGContextFillRect(ctx, CGRectMake(-100, -100, 200, 200));
            break;
        }
    }
    CGContextRestoreGState(ctx);
    if (selected) {
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetLineWidth(ctx, 3);
        CGContextSetTextDrawingMode(ctx, kCGTextStroke);
        [self showInContext:ctx centeredInRect:rect];
    }
}

- (void)showInContext:(CGContextRef)ctx centeredInRect:(CGRect)rect;
{
    CGPoint position = rect.origin;
    // Flip:
    position.y -= CGRectGetHeight(self.boundingRect);
    // Offset for the bounding rect:
    position.x -= self.boundingRect.origin.x;
    position.y -= self.boundingRect.origin.y;
    
    CGContextSetTextMatrix(ctx, CGAffineTransformScale(self.textMatrix, 1, -1));
    CGContextSetFont(ctx, self.graphicsFont);
    CGContextSetFontSize(ctx, self.pointSize);
    CGContextShowGlyphsAtPositions(ctx, (CGGlyph const []){self.graphicsGlyph}, (CGPoint const []){position}, 1);
}

@end
