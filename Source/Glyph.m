//
//  Glyph.m
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "Glyph+Internal.h"


@implementation Glyph

+ (instancetype)glyph;
{
    return [[self alloc] init];
}

- (void)dealloc;
{
    self.graphicsFont = NULL;
}

- (void)setGraphicsFont:(CGFontRef)graphicsFont;
{
    if (_graphicsFont == graphicsFont) {
        return;
    }
    if (_graphicsFont != NULL) {
        CFRelease(_graphicsFont);
    }
    if (graphicsFont == NULL) {
        _graphicsFont = NULL;
    } else {
        _graphicsFont = (void *) CFRetain(graphicsFont);
    }
}

@end
