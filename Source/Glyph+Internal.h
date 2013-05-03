//
//  Glyph+Internal.h
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "Glyph.h"



@interface Glyph ()

@property (nonatomic) CGRect boundingRect;

@property (nonatomic) CGGlyph graphicsGlyph;
@property (nonatomic) CGFontRef graphicsFont;
@property (nonatomic) CGFloat pointSize;
@property (nonatomic) CGAffineTransform textMatrix;

@end
