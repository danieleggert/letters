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

@property (nonatomic) CGPoint position;
@property (readonly, nonatomic) CGRect boundingRect;

@end
