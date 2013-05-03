//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "RootViewController.h"


@interface RootViewController () <UIGestureRecognizerDelegate>
@end

@implementation RootViewController {
    CGPoint panOffset;
    UIView* selectedView;
    CGFloat rotationOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    view1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view1];
    [self setupRecognizers];
}

- (void)setupRecognizers {
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    UIRotationGestureRecognizer* rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
    rotationGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:rotationGestureRecognizer];
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        panOffset = [gestureRecognizer locationInView:self.view];
        UIView* view = [self.view hitTest:panOffset withEvent:nil];
        if (view == self.view) {
            return NO;
        } else {
            selectedView = view;
            return YES;
        }
    } else if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        rotationOffset = [(UIRotationGestureRecognizer*)gestureRecognizer rotation];
        return YES;
    }
}

- (void)panned:(UIPanGestureRecognizer*)recognizer {
    CGAffineTransform transform = selectedView.transform;
    CGAffineTransform inverseTransform = CGAffineTransformInvert(transform);
    CGPoint point = [recognizer locationInView:self.view];
    CGPoint newPoint = point;
    CGPoint oldPoint = panOffset;
    newPoint = CGPointApplyAffineTransform(newPoint, inverseTransform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, inverseTransform);
    CGFloat deltaX = newPoint.x - oldPoint.x;
    CGFloat deltaY = newPoint.y - oldPoint.y;
    selectedView.transform = CGAffineTransformTranslate(transform, deltaX, deltaY);
    panOffset = point;
}

- (void)rotated:(UIRotationGestureRecognizer*)recognizer {
    if (!selectedView) return;
    CGFloat rotation = recognizer.rotation - rotationOffset;
    selectedView.transform = CGAffineTransformRotate(selectedView.transform, rotation);
    rotationOffset = recognizer.rotation;
}

- (void)tapped:(UITapGestureRecognizer*)tapGestureRecognizer {
    CGPoint point = [tapGestureRecognizer locationInView:self.view];
    UIView* targetView = [self.view hitTest:point withEvent:nil];
    if (targetView == self.view) {
        selectedView = nil;
    } else {
        selectedView = targetView;
    }
}

@end