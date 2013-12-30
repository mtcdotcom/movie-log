//
//  InputText.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "InputText.h"

@implementation InputText

@synthesize delegate = delegate_;

- (id)initWithType:(int)type
{
    self = [super init];
    if (self) {
        type_  = type;
        value_ = nil;
        [value_ retain];
    }
    return self;
}

- (id)initWithDefaultValue:(int)type defaultValue:(NSString *)defaultValue;
{
    self = [super init];
    if (self) {
        type_  = type;
        value_ = defaultValue;
        [value_ retain];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
#endif
}

- (void)loadView
{
    [super loadView];

    textView_ = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 120.0)];

    switch (type_) {
        case INPUT_TYPE_MEMO:
            self.title = @"メモ";
            textView_.text         = value_;
            textView_.keyboardType = UIKeyboardTypeDefault;
            break;
        default:
            break;
    }

    textView_.font            = CELL_DETAIL_TEXT_FONT;
    textView_.textColor       = CELL_DETAIL_TEXT_COLOR;
    textView_.backgroundColor = INPUT_FILED_BGCOLOR;

    [textView_ becomeFirstResponder];
    [self.view addSubview:textView_];

    self.view.backgroundColor = TABLEVIEW_BGCOLOR;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)note
{
    if ([self.view subviews]) {
        [[self.view viewWithTag:BUTTON_TAG_NO]removeFromSuperview];
    }
    
    NSDictionary *info  = [note userInfo];
    NSValue *keyValue   = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyValue CGRectValue].size;
    NSInteger toolbarY  = self.view.frame.size.height - keyboardSize.height - 10.0;
    textView_.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, toolbarY - 10.0);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(self.view.frame.size.width - 122.0, toolbarY, 100.0, 33.0);
    button.tag   = BUTTON_TAG_NO;
    button.titleLabel.font = BUTTON_FONT;
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

- (void)done
{
    switch (type_) {
        case INPUT_TYPE_MEMO:
            [delegate_ InputTextDelegate:self didClose:type_ value:textView_.text];
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [value_    release];
    [textView_ release];
    value_     = nil;
    textView_  = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [value_    release];
    [textView_ release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
