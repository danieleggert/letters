//
//  GlyphSequence.h
//  Letters
//
//  Created by Daniel Eggert on 5/3/13.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GlyphSequence : NSObject

+ (instancetype)sequence;

@property (nonatomic, copy) NSString *text;

@property (readonly) CGRect bounds;

@property (readonly) NSArray *glyphs;

@end
