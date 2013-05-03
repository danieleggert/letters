//
//  Glyph+Drawing.h
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "Glyph.h"



@interface Glyph (Drawing)

- (void)drawInContext:(CGContextRef)ctx centeredInRect:(CGRect)rect;

@end
