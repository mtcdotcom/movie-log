//
//  InputTextFiled.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "InputTextFiled.h"

@implementation InputTextFiled

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

- (void)loadView
{
    [super loadView];
    
    textField_ = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 50.0, self.view.frame.size.width - 40.0, 44.0)];
    
    switch (type_) {
        case INPUT_TYPE_TITLE:
            self.title = @"タイトル";
            textField_.keyboardType = UIKeyboardTypeDefault;
            if (value_ && ![value_ isEqualToString:@"設定なし"]) {
                textField_.text = value_;
            }
            break;
        case INPUT_TYPE_TIME:
            self.title = @"上映時間";
            textField_.keyboardType = UIKeyboardTypeNumberPad;
            if (value_ && [value_ intValue] != 0) {
                textField_.text = value_;
            }
            textField_.textAlignment = UITextAlignmentRight;
            break;
        case INPUT_TYPE_AMOUNT:
            self.title = @"金額";
            textField_.keyboardType = UIKeyboardTypeNumberPad;
            if (value_ && [value_ intValue] != 0) {
                textField_.text = value_;
            }
            textField_.textAlignment = UITextAlignmentRight;
            break;
        default:
            break;
    }
    
    textField_.font            = CELL_DETAIL_TEXT_FONT;
    textField_.textColor       = CELL_DETAIL_TEXT_COLOR;
    textField_.backgroundColor = INPUT_FILED_BGCOLOR;
    textField_.clearButtonMode = UITextFieldViewModeAlways;
    textField_.borderStyle     = UITextBorderStyleRoundedRect
    ;
    textField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [textField_ becomeFirstResponder];
    [self.view addSubview:textField_];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.view.backgroundColor = TABLEVIEW_BGCOLOR;
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(self.view.frame.size.width - 122.0, toolbarY, 100.0, 33.0);
    button.tag   = BUTTON_TAG_NO;
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

- (void)done
{
    switch (type_) {
        case INPUT_TYPE_TITLE:
            [delegate_ InputTextFiledDelegate:self didClose:type_ value:textField_.text];
            break;
        case INPUT_TYPE_TIME:
            if (textField_.text == nil || [textField_.text intValue] == 0) {
                [delegate_ InputTextFiledDelegate:self didClose:type_ value:@"0"];
            } else {
                [delegate_ InputTextFiledDelegate:self didClose:type_ value:textField_.text];
            }
            break;
        case INPUT_TYPE_AMOUNT:
            if (textField_.text == nil || [textField_.text intValue] == 0) {
                [delegate_ InputTextFiledDelegate:self didClose:type_ value:@"0"];
            } else {
                [delegate_ InputTextFiledDelegate:self didClose:type_ value:textField_.text];
            }
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
    [value_     release];
    [textField_ release];
    value_      = nil;
    textField_  = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [value_     release];
    [textField_ release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
