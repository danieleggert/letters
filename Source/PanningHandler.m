//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PanningHandler.h"


@interface PanningHandler () <UIGestureRecognizerDelegate>
@end

@implementation PanningHandler {

    CGPoint panOffset;
}

- (id)initWithView:(UIView*)view {
    self = [super init];
    if (self) {
        [self setupRecognizerForView:view];
    }
    return self;
}

- (void)setupRecognizerForView:(UIView*)view {
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panRecognizer.delegate = self;
    [view addGestureRecognizer:panRecognizer];
}


#pragma mark UIPanGestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    panOffset = [gestureRecognizer locationInView:gestureRecognizer.view];
    return YES;
}


- (void)panned:(UIPanGestureRecognizer*)recognizer {
    UIView* view = recognizer.view;
    CGPoint point = [recognizer locationInView:view.superview];
    CGRect newFrame = view.frame;
    newFrame.origin.x = point.x - panOffset.x;
    newFrame.origin.y = point.y - panOffset.y;
    view.frame = newFrame;
}

@end