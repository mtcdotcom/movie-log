//
//  SelectTable.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "SelectTable.h"


@implementation SelectTable

@synthesize delegate = delegate_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = TABLEVIEW_BGCOLOR;
    
    MasterData *masterData = [MasterData sharedManager];
    switch (type_) {
        case SELECT_TYPE_SCORE:
            self.title = @"点数";
            lists_ = masterData.scoreDatas;
            break;
        case SELECT_TYPE_COUNTRY:
            self.title = @"制作国";
            lists_ = masterData.countryDatas;
            break;
        case SELECT_TYPE_GENRE:
            self.title = @"ジャンル";
            lists_ = masterData.genreDatas;
            break;
        case SELECT_TYPE_PLACE:
            self.title = @"場所";
            lists_ = masterData.placeDatas;
            break;
        default:
            break;
    }
    [lists_ retain];
}

- (void)viewDidUnload
{
    [value_ release];
    [lists_ release];
    value_ = nil;
    lists_ = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [value_ release];
    [lists_ release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [lists_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierChecked = @"CheckedCell";
    UITableViewCell *cell;

    NSString *text = [lists_ objectAtIndex:indexPath.row];
    if (value_ != nil && [value_ isEqualToString:text]) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierChecked];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifierChecked] autorelease];
            cell.textLabel.font      = CELL_DETAIL_TEXT_FONT;
            cell.textLabel.textColor = CELL_DETAIL_TEXT_COLOR;
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier] autorelease];
            cell.textLabel.font      = CELL_DETAIL_TEXT_FONT;
            cell.textLabel.textColor = CELL_DETAIL_TEXT_COLOR;
        }
    }

    cell.textLabel.text = text;
    //[text release];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [delegate_ SelectTableDelegate:self didClose:type_ value:cell.textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
