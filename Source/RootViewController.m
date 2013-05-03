//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RootViewController.h"
#import "PanningHandler.h"


@interface RootViewController () <UIGestureRecognizerDelegate>
@end

@implementation RootViewController {
    PanningHandler* panHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    view1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view1];
    panHandler = [[PanningHandler alloc] initWithView:view1];
    
    UIRotationGestureRecognizer* rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
    [self.view addGestureRecognizer:rotationGestureRecognizer];
}


#pragma mark UIRotationGestureRecognizer

- (void)rotated:(UIRotationGestureRecognizer*)recognizer {
    NSLog(@"%f", recognizer.rotation);
}

@end