//
//  GlyphSequence.m
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "GlyphSequence.h"

#import "Glyph.h"
#import <CoreText/CoreText.h>




@interface GlyphSequence ()
{
    CTLineRef _line;
}

@property (nonatomic) CTLineRef line;

@end



@implementation GlyphSequence

+ (instancetype)sequence;
{
    return [[self alloc] init];
}

- (void)setText:(NSString *)text;
{
    if ((text == _text) || ([text isEqualToString:_text])) {
        return;
    }
    self.line = NULL;
}

- (void)setLine:(CTLineRef)line;
{
    if (line == _line) {
        return;
    }
    if (_line != NULL) {
        CFRelease(_line);
    }
    _line = CFRetain(line);
}

- (NSArray *)glyphs;
{
    if (self.line == NULL) {
        return @[];
    }
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *runs = (__bridge id) CTLineGetGlyphRuns(self.line);
    for (id myRun in runs) {
        CTRunRef const run = (__bridge CTRunRef) myRun;
        
        NSDictionary *attributes = (__bridge id) CTRunGetAttributes(run);
        
        CTFontRef font = (__bridge CTFontRef) attributes[(__bridge id) kCTFontAttributeName];
        CGFontRef const graphicsFont = CTFontCopyGraphicsFont(font, NULL);
        CGFloat const pointSize = CTFontGetSize(font);
        
        CFIndex const count = CTRunGetGlyphCount(run);
        CGGlyph glyphs[count];
        CGPoint positions[count];
        CTRunGetGlyphs(run, CFRangeMake(0, count), glyphs);
        CTRunGetPositions(run, CFRangeMake(0, count), positions);
        CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
        
        for (CFIndex i = 0; i < count; ++i) {
            Glyph *glyph = [Glyph glyph];
            glyph.graphicsFont = graphicsFont;
            glyph.pointSize = pointSize;
            glyph.position = positions[i];
            glyph.graphicsGlyph = glyphs[i];
            glyph.textMatrix = textMatrix;
            
            [result addObject:glyph];
        }
    }
    return @[];
    
}

@end
