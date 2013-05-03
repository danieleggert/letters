//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GestureController.h"
#import "GlyphView.h"


@interface GestureController () <UIGestureRecognizerDelegate>
@end


@implementation GestureController {
    CGPoint panOffset;
    CGFloat rotationOffset;
    UIView* glyphContainer;
    UIPanGestureRecognizer* panGestureRecognizer;
    UIRotationGestureRecognizer* rotationGestureRecognizer;
    UITapGestureRecognizer* tapGestureRecognizer;
    NSMutableSet* selectedGlyphs;
}

- (id)initWithView:(UIView*)aView {
    self = [super init];
    if (self) {
        glyphContainer = aView;
        [self clear];
        [self setupRecognizers];
    }
    return self;
}

- (void)clear {
    selectedGlyphs = [NSMutableSet set];
}

- (void)setupRecognizers {
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panGestureRecognizer.delegate = self;
    [glyphContainer addGestureRecognizer:panGestureRecognizer];
    rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
    rotationGestureRecognizer.delegate = self;
    [glyphContainer addGestureRecognizer:rotationGestureRecognizer];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGestureRecognizer.delegate = self;
    [glyphContainer addGestureRecognizer:tapGestureRecognizer];
}

- (void)selectGlyph:(GlyphView*)glyphView {
    glyphView.selected = YES;
    [selectedGlyphs addObject:glyphView];
}

- (void)deselectGlyph:(GlyphView*)glyphView {
    glyphView.selected = NO;
    [selectedGlyphs removeObject:glyphView];
}

- (void)toggleGlyphSelection:(GlyphView*)glyphView {
    if (glyphView.selected) {
        [self deselectGlyph:glyphView];
    } else {
        [self selectGlyph:glyphView];
    }
}

- (void)deselectAllGlyphs {
    NSSet* glyphs = [selectedGlyphs copy];
    for (GlyphView* glyph in glyphs) {
        [self deselectGlyph:glyph];
    }
}

- (BOOL)isGlyphSelected:(GlyphView*)glyph {
    return [selectedGlyphs containsObject:glyph];
}

- (void)panned:(UIPanGestureRecognizer*)recognizer {
    CGPoint touchPoint = [recognizer locationInView:glyphContainer];
    for (GlyphView* glyph in selectedGlyphs) {
        [self panGlyph:glyph touchPoint:touchPoint];
    }
    panOffset = touchPoint;
}

- (void)panGlyph:(GlyphView*)glyphView touchPoint:(CGPoint)touchPoint {
    CGAffineTransform transform = glyphView.transform;
    CGAffineTransform inverseTransform = CGAffineTransformInvert(transform);
    CGPoint newPoint = touchPoint;
    CGPoint oldPoint = panOffset;
    newPoint = CGPointApplyAffineTransform(newPoint, inverseTransform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, inverseTransform);
    CGFloat deltaX = newPoint.x - oldPoint.x;
    CGFloat deltaY = newPoint.y - oldPoint.y;
    glyphView.transform = CGAffineTransformTranslate(transform, deltaX, deltaY);
}

- (void)rotated:(UIRotationGestureRecognizer*)recognizer {
    if (!selectedGlyphs.count) return;
    CGFloat rotation = recognizer.rotation - rotationOffset;
    for (GlyphView* glyph in selectedGlyphs) {
        glyph.transform = CGAffineTransformRotate(glyph.transform, rotation);
    }
    rotationOffset = recognizer.rotation;
}

- (void)tapped:(UITapGestureRecognizer*)recognizer {
    CGPoint point = [recognizer locationInView:glyphContainer];
    UIView* targetView = [glyphContainer hitTest:point withEvent:nil];
    GlyphView *glyphView = [targetView isKindOfClass:[GlyphView class]] ? (id) targetView : nil;
    if (glyphView == nil) {

        [self deselectAllGlyphs];
    } else {
        [self toggleGlyphSelection:glyphView];
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)recognizer {
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return [self panRecognizerShouldBegin:recognizer];
    } else if ([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return [self rotationRecognizerShouldBegin:recognizer];
    }
    return YES;
}

- (BOOL)rotationRecognizerShouldBegin:(UIGestureRecognizer*)recognizer {
    rotationOffset = [(UIRotationGestureRecognizer*) recognizer rotation];
    return YES;
}

- (BOOL)panRecognizerShouldBegin:(UIGestureRecognizer*)recognizer {
    panOffset = [recognizer locationInView:glyphContainer];
    UIView* targetView = [glyphContainer hitTest:panOffset withEvent:nil];
    GlyphView *glyphView = [targetView isKindOfClass:[GlyphView class]] ? (id) targetView : nil;
    if (glyphView == nil) {
        return NO;
    } else {
        if (![self isGlyphSelected:glyphView]) {
            [self deselectAllGlyphs];
            [self selectGlyph:glyphView];
        }
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return gestureRecognizer == panGestureRecognizer && otherGestureRecognizer == rotationGestureRecognizer;
}


@end