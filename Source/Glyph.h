//
//  Glyph.h
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum GlyphDrawingStyle_e {
    GlyphDrawingStyle0 = 0,
    GlyphDrawingStyle1,
    GlyphDrawingStyle2,
    GlyphDrawingStyle3,
    
    GlyphDrawingStyleCount,
} GlyphDrawingStyle_t;



@interface Glyph : NSObject

+ (instancetype)glyph;

@property (nonatomic) CGPoint position;
@property (readonly, nonatomic) CGRect boundingRect;
@property (nonatomic) GlyphDrawingStyle_t drawingStyle;

@end
