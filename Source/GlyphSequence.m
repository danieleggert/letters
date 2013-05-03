//
//  GlyphSequence.m
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "GlyphSequence.h"

#import "Glyph+Internal.h"
#import <CoreText/CoreText.h>




@interface GlyphSequence ()
{
    CTLineRef _line;
}

@property (nonatomic) CTLineRef line;
@property (readonly, nonatomic, copy) NSDictionary *attributes;

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
    _text = [text copy];
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

- (CTLineRef)line;
{
    if (_line == NULL) {
        NSAttributedString *string = nil;
        if (self.text != nil) {
            string = [[NSAttributedString alloc] initWithString:self.text attributes:self.attributes];
        }
        if (string != nil) {
            _line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) string);
        }
    }
    return _line;
}

- (NSDictionary *)attributes;
{
    NSString *name = @"Helvetica";
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef) name, 72, NULL);
    return @{
             (__bridge id) kCTFontAttributeName: (__bridge id) font,
             };
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
        
        CGRect boundingRects[count];
        (void) CTFontGetBoundingRectsForGlyphs(font, kCTFontOrientationDefault, glyphs, boundingRects, count);
        
        for (CFIndex i = 0; i < count; ++i) {
            Glyph *glyph = [Glyph glyph];
            glyph.graphicsFont = graphicsFont;
            glyph.pointSize = pointSize;
            glyph.position = positions[i];
            glyph.graphicsGlyph = glyphs[i];
            glyph.textMatrix = textMatrix;
            glyph.boundingRect = boundingRects[i];
            
            [result addObject:glyph];
        }
    }
    return result;
}

@end
