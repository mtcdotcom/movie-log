//
//  Summary.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "SummaryDetail.h"

@interface SummaryDetail ()

- (void)initDict;
- (void)countDict;
- (void)listSegmentedControl:(UISegmentedControl*)seg;

@end

@implementation SummaryDetail

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithYear:(NSString *)year placeType:(int)placeType
{
    self = [super init];
    if (self) {
        year_      = year;
        placeType_ = placeType;
        isload_    = FALSE;
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
    
    self.navigationController.navigationBar.tintColor = TINT_BGCOLOR;
    self.tableView.backgroundColor = TABLEVIEW_BGCOLOR;
    self.tableView.rowHeight = 36;
    self.tableView.allowsSelection = NO;
    
    self.title = @"項目別";
    
    listType_ = LIST_TYPE_SCORE;
    
    NSArray *titles = [NSArray arrayWithObjects: @"点数", @"月", @"制作国", @"ジャンル", @"場所", nil];
    
    UISegmentedControl *segmentCtl = [[[UISegmentedControl alloc] initWithItems:titles] autorelease];
    segmentCtl.frame = CGRectMake(0.0, 0.0, 310.0, 30.0);
    segmentCtl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentCtl addTarget:self action:@selector(listSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segmentBarItem = [[[UIBarButtonItem alloc] initWithCustomView:segmentCtl] autorelease];
    segmentCtl.selectedSegmentIndex = 0;
    
    self.toolbarItems = [NSArray arrayWithObjects:segmentBarItem, nil];;
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    masterData_ = [MasterData sharedManager];
}


- (void)viewDidUnload
{
    [scoreDict_   release];
    [monthDict_   release];
    [countryDict_ release];
    [genreDict_   release];
    [placeDict_   release];
    [masterData_  release];
    
    scoreDict_   = nil;
    monthDict_   = nil;
    countryDict_ = nil;
    genreDict_   = nil;
    placeDict_   = nil;
    masterData_  = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [scoreDict_   release];
    [monthDict_   release];
    [countryDict_ release];
    [genreDict_   release];
    [placeDict_   release];
    [masterData_  release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!isload_) {
        [self countDict];
    }
    
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
    isload_ = FALSE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (void)initDict
{
    int i;
    
    NSArray *scores = masterData_.scoreDatas;
    scoreDict_ = [[NSMutableDictionary alloc] init];
    for (i = 0; i < [scores count]; i++) {
        [scoreDict_ setObject:[NSNumber numberWithInt:0] forKey:[scores objectAtIndex:i]];
    }
    
    NSArray *months = masterData_.monthDatas;
    monthDict_ = [[NSMutableDictionary alloc] init];
    for (i = 0; i < [months count]; i++) {
        [monthDict_ setObject:[NSNumber numberWithInt:0] forKey:[months objectAtIndex:i]];
    }
    
    NSArray *countries = masterData_.countryDatas;
    countryDict_ = [[NSMutableDictionary alloc] init];
    for (i = 0; i < [countries count]; i++) {
        [countryDict_ setObject:[NSNumber numberWithInt:0] forKey:[countries objectAtIndex:i]];
    }
    
    NSArray *genres = masterData_.genreDatas;
    genreDict_ = [[NSMutableDictionary alloc] init];
    for (i = 0; i < [genres count]; i++) {
        [genreDict_ setObject:[NSNumber numberWithInt:0] forKey:[genres objectAtIndex:i]];
    }
    
    NSArray *places = masterData_.placeDatas;
    placeDict_ = [[NSMutableDictionary alloc] init];
    for (i = 0; i < [places count]; i++) {
        [placeDict_ setObject:[NSNumber numberWithInt:0] forKey:[places objectAtIndex:i]];
    }
}

- (void)countDict
{
    [self initDict];
    ModelManager *modelManager = [[ModelManager alloc] initWithYear:year_ place:[masterData_ placeTypeCond:placeType_]];
    [modelManager fetchedResultsController:@"Movies"].delegate = self;

    NSString *data;
    int count = 0;
    for (int i = 0; i < [modelManager countObjects:@"Movies"]; i++) {
        NSManagedObject *managedObject = [modelManager fetchObject:@"Movies" WithRow:i AndSection:0];
        
        data = [NSString stringWithFormat:@"%0.1f",[[managedObject valueForKey:@"score"] floatValue]];
        if (data != nil) {
            count = [[scoreDict_ objectForKey:data] intValue];
            count++;
            [scoreDict_ setObject:[NSNumber numberWithInt:count] forKey:data];
        }
        
        data = [managedObject valueForKey:@"month"];
        if (data) {
            count = [[monthDict_ objectForKey:data] intValue];
            count++;
            [monthDict_ setObject:[NSNumber numberWithInt:count] forKey:data];
        }
        
        data = [managedObject valueForKey:@"country"];
        if (data) {
            count = [[countryDict_ objectForKey:data] intValue];
            count++;
            [countryDict_ setObject:[NSNumber numberWithInt:count] forKey:data];
        }
        
        data = [managedObject valueForKey:@"genre"];
        if (data) {
            count = [[genreDict_ objectForKey:data] intValue];
            count++;
            [genreDict_ setObject:[NSNumber numberWithInt:count] forKey:data];
        }
        
        data = [managedObject valueForKey:@"place"];
        if (data) {
            count = [[placeDict_ objectForKey:data] intValue];
            count++;
            [placeDict_ setObject:[NSNumber numberWithInt:count] forKey:data];
        }
    }
    
    isload_ = TRUE;
    [self.tableView reloadData];
    
    [modelManager release];
}

- (void)listSegmentedControl:(UISegmentedControl*)segmentCtl
{
    listType_ = segmentCtl.selectedSegmentIndex;
    isload_   = TRUE;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 0;
    switch (listType_) {
        case LIST_TYPE_SCORE:
            number = scoreDict_.count;
            break;
        case LIST_TYPE_MONTH:
            number = monthDict_.count;
            break;
        case LIST_TYPE_COUNTRY:
            number = countryDict_.count;
            break;
        case LIST_TYPE_GENRE:
            number = genreDict_.count;
            break;
        case LIST_TYPE_PLACE:
            number = placeDict_.count;
            break;
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font      = CELL_TEXT_FONT;
        cell.textLabel.textColor = CELL_TEXT_COLOR;
        cell.detailTextLabel.font      = CELL_DETAIL_TEXT_FONT;
        cell.detailTextLabel.textColor = CELL_DETAIL_TEXT_COLOR;
    }
    
    NSString *text = [[[NSString alloc] init] autorelease];
    NSString *detailText = [[[NSString alloc] init] autorelease];
    int month = 0;
    
    switch (listType_) {
        case LIST_TYPE_SCORE:
            if ([masterData_.scoreDatas count] > indexPath.row) {
                text = [NSString stringWithFormat:@"%@ 点", [masterData_.scoreDatas objectAtIndex:indexPath.row]];
                detailText = [NSString stringWithFormat:@"%d 本",
                              [[scoreDict_ objectForKey:[masterData_.scoreDatas objectAtIndex:indexPath.row]] intValue]];
            }
            break;
        case LIST_TYPE_MONTH:
            month = [[masterData_.monthDatas objectAtIndex:indexPath.row] intValue];
            if (month < 10) {
                text = [NSString stringWithFormat:@"  %d 月", month];
            } else {
                text = [NSString stringWithFormat:@"%d 月", month];
            }
            detailText = [NSString stringWithFormat:@"%d 本",
                          [[monthDict_ objectForKey:[masterData_.monthDatas objectAtIndex:indexPath.row]] intValue]];
            break;
        case LIST_TYPE_COUNTRY:
            if ([masterData_.countryDatas count] > indexPath.row) {
                text = [masterData_.countryDatas objectAtIndex:indexPath.row];
                detailText = [NSString stringWithFormat:@"%d 本",[[countryDict_ objectForKey:text] intValue]];
            }
            break;
        case LIST_TYPE_GENRE:
            if ([masterData_.genreDatas count] > indexPath.row) {
                text = [masterData_.genreDatas objectAtIndex:indexPath.row];
                detailText = [NSString stringWithFormat:@"%d 本",[[genreDict_ objectForKey:text] intValue]];
            }
            break;
        case LIST_TYPE_PLACE:
            if ([masterData_.placeDatas count] > indexPath.row) {
                text = [masterData_.placeDatas objectAtIndex:indexPath.row];
                detailText = [NSString stringWithFormat:@"%d 本",[[placeDict_ objectForKey:text] intValue]];
            }
            break;
        default:
            break;
    }
    
    cell.textLabel.text       = text;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *header = [[[NSString alloc] init] autorelease];
    switch (listType_) {
        case LIST_TYPE_SCORE:
            header = [NSString stringWithFormat:@"   %@ 年   点数別 本数", year_];
            break;
        case LIST_TYPE_MONTH:
            header = [NSString stringWithFormat:@"   %@ 年   月別 本数", year_];
            break;
        case LIST_TYPE_COUNTRY:
            header = [NSString stringWithFormat:@"   %@ 年   制作国別 本数", year_];
            break;
        case LIST_TYPE_GENRE:
            header = [NSString stringWithFormat:@"   %@ 年   ジャンル別 本数", year_];
            break;
        case LIST_TYPE_PLACE:
            header = [NSString stringWithFormat:@"   %@ 年   場所別 本数", year_];
            break;
        default:
            break;
    }
    UIView *view = [[[UIView alloc] init] autorelease];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
    label.backgroundColor = SECTION_BGCOLOR;
    label.textColor       = SECTION_COLOR;
    label.font            = SECTION_FONT;
    label.text            = header;

    UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70.0, 0.0, 60.0, 22.0)];
    place.backgroundColor = SECTION_BGCOLOR;
    place.textColor       = SECTION_COLOR;
    place.font            = SECTION_FONT;
    place.textAlignment   = NSTextAlignmentRight;
    place.text            = [masterData_ placeType:placeType_];  
    
    [view addSubview:label];
    [view addSubview:place];
    [label release];
    [place release];
    
    return view;
}

- (NSString *)placeType
{
    if (placeType_ == PLACE_TYPE_NEW) {
        return @"映画館(新作)";
    } else {
        return nil;
    }
}

@end
