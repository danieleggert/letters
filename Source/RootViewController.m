//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RootViewController.h"
#import "PanningHandler.h"
#import "GlyphView.h"
#import "GlyphSequence.h"
#import "Glyph.h"



@interface RootViewController () <UIGestureRecognizerDelegate>

@property (readonly, nonatomic, strong) NSMutableArray *panHandlers;

@end



@implementation RootViewController
{
    PanningHandler* panHandler;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup;
{
    _panHandlers = [NSMutableArray array];
    
    for (UIView *view in [self viewsForString:@"UIKonf"]) {
        [self.view addSubview:view];
        [self.panHandlers addObject:[[PanningHandler alloc] initWithView:view]];
    }
    
    UIRotationGestureRecognizer* rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
    [self.view addGestureRecognizer:rotationGestureRecognizer];
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


#pragma mark UIRotationGestureRecognizer

- (void)rotated:(UIRotationGestureRecognizer*)recognizer {
    NSLog(@"%f", recognizer.rotation);
}

@end
