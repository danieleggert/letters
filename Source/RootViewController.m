//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RootViewController.h"
#import "GlyphView.h"
#import "GlyphSequence.h"
#import "Glyph.h"
#import "GestureController.h"


@interface RootViewController ()
@end



@implementation RootViewController {
    GestureController* gestureController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    for (UIView *view in [self viewsForString:@"UIKonf"]) {
        [self.view addSubview:view];
    }
    gestureController = [[GestureController alloc] initWithView:self.view];
}

- (NSArray *)viewsForString:(NSString *)text;
{
    NSMutableArray *result = [NSMutableArray array];

    GlyphSequence *sequence = [GlyphSequence sequence];
    sequence.text = text;
    for (Glyph *glyph in sequence.glyphs) {
        GlyphView *view = [GlyphView viewWithGlyph:glyph];
        [result addObject:view];
    }
    return result;
}


@end
