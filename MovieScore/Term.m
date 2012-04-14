//
//  Term.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "Term.h"

@interface Term ()
@end

@implementation Term

@synthesize delegate = delegate_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    
	self.title = @"期間選択";
    self.navigationController.navigationBar.tintColor = TINT_BGCOLOR;
    self.tableView.backgroundColor = TABLEVIEW_BGCOLOR;
    self.tableView.rowHeight = 44.0;

    modelManager_ = [[ModelManager alloc] initWithsectionNameKey:@"year"];
    [modelManager_ fetchedResultsController:@"Movies"].delegate = self;
}

- (void)viewDidUnload
{
    [modelManager_ release];
    modelManager_ = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [modelManager_ release];
    [super dealloc];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelManager_ countSections:@"Movies"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
	}
    NSManagedObject *managedObject = [modelManager_ fetchObject:@"Movies" WithRow:0 AndSection:indexPath.row];
    NSString *year = [managedObject valueForKey:@"year"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@年", year];
    cell.textLabel.textColor = CELL_DETAIL_TEXT_COLOR;
    cell.textLabel.font      = CELL_DETAIL_TEXT_FONT;
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [delegate_ termDelegate:self didClose:[cell.textLabel.text stringByReplacingOccurrencesOfString:@"年" withString:@""]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end