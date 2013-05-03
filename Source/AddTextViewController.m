//
// Created by Florian on 03.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AddTextViewController.h"


@interface AddTextViewController () <UITextFieldDelegate>
@end

@implementation AddTextViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTextView];
}

- (void)addTextView;
{
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    field.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:field];
    [field becomeFirstResponder];

    UIButton *add = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    add.translatesAutoresizingMaskIntoConstraints = NO;
    [add setTitle:@"Add Text!" forState:UIControlStateNormal];
    [add addTarget:[(id)self.presentingViewController topViewController] action:@selector(addText:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];

    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancel.translatesAutoresizingMaskIntoConstraints = NO;
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel addTarget:[(id)self.presentingViewController topViewController] action:@selector(cancelAddingText:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];

    NSDictionary *metrics = nil;
    NSDictionary *views = NSDictionaryOfVariableBindings(field, add, cancel);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[field(30)]-[add]-[cancel]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[field]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[add]-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[cancel]-|" options:0 metrics:metrics views:views]];
}                    

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    self.textToBeAdded = textField.text;
}

@end