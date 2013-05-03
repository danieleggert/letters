//
//  Glyph.h
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Glyph : NSObject

+ (instancetype)glyph;

@property (nonatomic) CGFontRef graphicsFont;
@property (nonatomic) CGFloat pointSize;

@property (nonatomic) CGGlyph graphicsGlyph;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGAffineTransform textMatrix;

@end
