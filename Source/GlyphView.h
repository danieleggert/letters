//
//  GlyphView.h
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Glyph;



@interface GlyphView : UIView

+ (instancetype)viewWithGlyph:(Glyph *)glyph;

@property (nonatomic, strong) Glyph *glyph;

@end
