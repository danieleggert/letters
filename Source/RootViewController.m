//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RootViewController.h"
#import "GlyphView.h"
#import "GlyphSequence.h"
#import "Glyph.h"
#import "GlyphController.h"
#import "AddTextViewController.h"


@interface RootViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *textToBeAdded;

@end



@interface RootViewController (AddingText) <UITextFieldDelegate>

- (void)addGlyphsForText:(NSString *)text;

@end



@implementation RootViewController {
    GlyphController* glyphController;
    UIView *_addTextView;
    AddTextViewController* addTextViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    glyphController = [[GlyphController alloc] initWithView:self.view];
    [self setupToolbar];
    [self addGlyphsForText:@"Hello!"];
}

- (void)setupToolbar {
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithTitle:@"More Text!"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showAddTextView:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(clearGlyphs:)];
    UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete Letter"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(deleteGlyphs:)];
    [self setToolbarItems:@[addButton, flexibleSpace, clearButton, deleteButton]];
}

- (NSArray *)viewsForString:(NSString *)text;
{
    NSMutableArray *result = [NSMutableArray array];

    GlyphSequence *sequence = [GlyphSequence sequence];
    sequence.text = text;
    for (Glyph *glyph in sequence.glyphs) {
        glyph.drawingStyle = (GlyphDrawingStyle_t) arc4random_uniform(GlyphDrawingStyleCount);
        GlyphView *view = [GlyphView viewWithGlyph:glyph];
        [result addObject:view];
    }
    return result;
}


- (void)clearGlyphs:(id)sender {
    [glyphController clear];
}

- (void)deleteGlyphs:(id)sender {
    [glyphController deleteSelectedGlyphs];
}

@end


@implementation RootViewController (AddingText)

- (void)showAddTextView:(id)sender;
{
    addTextViewController = [[AddTextViewController alloc] init];
    [self presentViewController:addTextViewController animated:YES completion:NULL];
}

- (void)dismissAddTextView {
    [self dismissViewControllerAnimated:YES completion:NULL];
    addTextViewController = nil;
}

- (void)addText:(UIButton *)sender;
{
    [addTextViewController.view endEditing:YES];
    [self addGlyphsForText:addTextViewController.textToBeAdded];
    [self dismissAddTextView];
}

- (void)cancelAddingText:(UIButton *)sender;
{
    [self dismissAddTextView];
}

- (void)addGlyphsForText:(NSString *)text;
{
    for (UIView *view in [self viewsForString:text]) {
        [self.view addSubview:view];
    }
}

@end
