//
//  DatePicker.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "DatePicker.h"

@implementation DatePicker

@synthesize delegate = delegate_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithDefaultValue:(NSString *)defaultValue;
{
    self = [super init];
    if (self) {
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
    
    self.title = @"日付";

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [formatter dateFromString:value_];
    [formatter release];
    
    self.view.backgroundColor = TABLEVIEW_BGCOLOR;
    datePicker_ = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    datePicker_.datePickerMode = UIDatePickerModeDate;
    datePicker_.date           = date;
    [self.view addSubview:datePicker_];
    NSInteger toolbarY  = self.view.frame.size.height - CGRectGetHeight(datePicker_.frame);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(self.view.frame.size.width - 122.0, toolbarY, 100.0, 33.0);
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

- (void)done
{
    NSDate *today = [[[NSDate alloc] init] autorelease];
    NSComparisonResult result = [today compare:datePicker_.date];
    if (result == NSOrderedAscending) {
        datePicker_.date = today;
    }
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [delegate_ DatePickerDelegate:self didClose:[formatter stringFromDate:datePicker_.date]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [value_ release];
    value_ = nil;
    [datePicker_ release];
    datePicker_ = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [value_ release];
    [datePicker_ release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
