//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RootViewController.h"
#import "GlyphView.h"
#import "GlyphSequence.h"
#import "Glyph.h"


@interface RootViewController () <UIGestureRecognizerDelegate>

@property (nonatomic) GlyphView *selectedView;
@property (nonatomic, copy) NSString *textToBeAdded;

@end



@interface RootViewController (AddingText) <UITextFieldDelegate>

- (void)setupAddTextButton;
- (void)addGlyphsForText:(NSString *)text;

@end



@implementation RootViewController {
    CGPoint panOffset;
    CGFloat rotationOffset;
    UIView *_addTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self addGlyphsForText:@"Hello!"];
    [self setupRecognizers];
    [self setupAddTextButton];
}

- (void)setSelectedView:(GlyphView *)selectedView;
{
    if (selectedView == _selectedView) {
        return;
    }
    _selectedView.selected = NO;
    _selectedView = selectedView;
    _selectedView.selected = YES;
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
        GlyphView *glyphView = [view isKindOfClass:[GlyphView class]] ? (id) view : nil;
        if (glyphView == nil) {
            return NO;
        } else {
            self.selectedView = glyphView;
            return YES;
        }
    } else if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        rotationOffset = [(UIRotationGestureRecognizer*)gestureRecognizer rotation];
        return YES;
    }
    return NO;
}

- (void)panned:(UIPanGestureRecognizer*)recognizer {
    CGAffineTransform transform = self.selectedView.transform;
    CGAffineTransform inverseTransform = CGAffineTransformInvert(transform);
    CGPoint point = [recognizer locationInView:self.view];
    CGPoint newPoint = point;
    CGPoint oldPoint = panOffset;
    newPoint = CGPointApplyAffineTransform(newPoint, inverseTransform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, inverseTransform);
    CGFloat deltaX = newPoint.x - oldPoint.x;
    CGFloat deltaY = newPoint.y - oldPoint.y;
    self.selectedView.transform = CGAffineTransformTranslate(transform, deltaX, deltaY);
    panOffset = point;
}

- (void)rotated:(UIRotationGestureRecognizer*)recognizer {
    if (!self.selectedView) return;
    CGFloat rotation = recognizer.rotation - rotationOffset;
    self.selectedView.transform = CGAffineTransformRotate(self.selectedView.transform, rotation);
    rotationOffset = recognizer.rotation;
}

- (void)tapped:(UITapGestureRecognizer*)tapGestureRecognizer {
    CGPoint point = [tapGestureRecognizer locationInView:self.view];
    UIView* view = [self.view hitTest:point withEvent:nil];
    GlyphView *glyphView = [view isKindOfClass:[GlyphView class]] ? (id) view : nil;
    if (glyphView == nil) {
        self.selectedView = nil;
    } else {
        self.selectedView = glyphView;
    }
}

@end



@implementation RootViewController (AddingText)

- (void)setupAddTextButton;
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.titleLabel.text = @"+";
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton addTarget:self action:@selector(showAddTextView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}

- (void)showAddTextView:(id)sender;
{
    (void) sender;
    UIView *view = self.addTextView;
    if (view.superview == nil) {
        [self.view addSubview:view];
    }
    view.hidden = NO;
}

- (UIView *)addTextView;
{
    if (_addTextView == nil) {
        _addTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
        _addTextView.backgroundColor = [UIColor cyanColor];
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
        field.translatesAutoresizingMaskIntoConstraints = NO;
        field.backgroundColor = [UIColor whiteColor];
        field.delegate = self;
        [_addTextView addSubview:field];
        
        UIButton *add = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        add.translatesAutoresizingMaskIntoConstraints = NO;
        [add setTitle:@"Add" forState:UIControlStateNormal];
        [add addTarget:self action:@selector(addText:) forControlEvents:UIControlEventTouchUpInside];
        [_addTextView addSubview:add];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancel.translatesAutoresizingMaskIntoConstraints = NO;
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelAddingText:) forControlEvents:UIControlEventTouchUpInside];
        [_addTextView addSubview:cancel];
        
        NSDictionary *metrics = nil;
        NSDictionary *views = NSDictionaryOfVariableBindings(field, add, cancel);
        [_addTextView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[field]-[add(50)]-[cancel(==add)]-|" options:0 metrics:metrics views:views]];
        [_addTextView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[field]-|" options:0 metrics:metrics views:views]];
        [_addTextView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[add]-|" options:0 metrics:metrics views:views]];
        [_addTextView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[cancel]-|" options:0 metrics:metrics views:views]];
    }
    return _addTextView;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    self.textToBeAdded = textField.text;
}

- (void)addText:(UIButton *)sender;
{
    if (![self.view.window endEditing:NO]) {
        return;
    }
    [self addGlyphsForText:self.textToBeAdded];
    self.textToBeAdded = nil;
    self.addTextView.hidden = YES;
}

- (void)cancelAddingText:(UIButton *)sender;
{
    [self.view.window endEditing:YES];
    self.textToBeAdded = nil;
    self.addTextView.hidden = YES;
}

- (void)addGlyphsForText:(NSString *)text;
{
    for (UIView *view in [self viewsForString:text]) {
        [self.view addSubview:view];
    }
}

@end
