//
//  MovieList.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "MovieList.h"

@interface MovieList ()


- (void)setSectionNameKeyMonth;
- (void)setSectionNameKeyScore;
- (void)callRecordForUpdate:(NSIndexPath *)indexPath;
- (NSString *)nilText:(NSString *)data;

@end

@implementation MovieList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        sortType_  = SORT_TYPE_SCORE;
        placeType_ = PLACE_TYPE_ALL;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)setToolbar
{
    UIBarButtonItem* fixedSpace = [[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                    target:nil
                                    action:nil] autorelease];    
    UIBarButtonItem *placeButton = [[[UIBarButtonItem alloc]
                                    initWithTitle:@"絞り込み" style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(selectAction)] autorelease];
    UIBarButtonItem *sortButton = [[[UIBarButtonItem alloc]
                                    initWithTitle:@"並び換え" style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(sortAction)] autorelease];
    UIBarButtonItem *summaryButton = [[[UIBarButtonItem alloc]
                                       initWithTitle:@"サマリー" style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(callSummary)] autorelease];
    
    self.toolbarItems = [NSArray arrayWithObjects:placeButton, sortButton, fixedSpace, summaryButton, nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    masterData_ = [MasterData sharedManager];
    
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    df.dateFormat  = @"yyyy";
    year_          = [df stringFromDate:[NSDate date]];
    countDict_     = [[NSMutableDictionary alloc] init];
    modelManager_  = [[ModelManager alloc] initWithYear:year_ sectionNameKey:@"score"];
    [modelManager_ fetchedResultsController:@"Movies"].delegate = self;

	self.title = @"作品リスト";

    self.navigationController.navigationBar.tintColor = TINT_BGCOLOR;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithTitle:@"期間選択" style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(callTerm)] autorelease];
    
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                               target:self
                                               action:@selector(callRecord)] autorelease];

    self.tableView.backgroundColor = TABLEVIEW_BGCOLOR;
    self.tableView.rowHeight = 84.0;
    
    self.navigationController.toolbar.tintColor = TOOLBAR_TINT_BGCOLOR;
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    [self setToolbar];
}

- (void)viewDidUnload
{
    year_         = nil;
    countDict_    = nil;
    modelManager_ = nil;
    masterData_  = nil;
    [countDict_    release];
    [modelManager_ release];
    [masterData_   release];

    [super viewDidUnload];
}

- (void)dealloc
{
    year_ = nil;
    [countDict_    release];
    [modelManager_ release];
    [masterData_   release];
    
    [super dealloc];
}

- (void)loadTable
{
    switch(sortType_) {
        case SORT_TYPE_SCORE:
            [self setSectionNameKeyScore];
            break;
        case SORT_TYPE_MONTH:
            [self setSectionNameKeyMonth];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadTable];
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
    return [modelManager_ countSections:@"Movies"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [modelManager_ countObjects:@"Movies" section:section];
    [countDict_ setObject:[NSNumber numberWithInt:count] forKey:[NSNumber numberWithInt:section]];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *titleLabel;
    UILabel *scoreLabel;
    UILabel *infoLabel;
    UILabel *dateLabel;
    
    UIImageView *photoView;
    float leftMargin        = 8.0;
    float photoMargin       = 70.0;
    float topMargin         = 3.0;
    float topLabelHeight    = 67.0;
    float bottomLabelHeight = 17.0;
    float accessoryWidth    = 20.0;
    float scoreLabelWidth   = 60.0;
    float titleLabelWidth   = self.view.frame.size.width - scoreLabelWidth - accessoryWidth - photoMargin;

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoMargin,
                                                               topMargin,
                                                               titleLabelWidth,
                                                               topLabelHeight)];
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoMargin + titleLabelWidth,
                                                               topMargin,
                                                               scoreLabelWidth,
                                                               topLabelHeight)];
        infoLabel  = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin,
                                                               topLabelHeight,
                                                               photoMargin + titleLabelWidth - leftMargin,
                                                               bottomLabelHeight)];
        dateLabel  = [[UILabel alloc] initWithFrame:CGRectMake(photoMargin + titleLabelWidth,
                                                               topLabelHeight,
                                                               scoreLabelWidth,
                                                               bottomLabelHeight)];
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 8.0, 55.0, 55.0)];

        titleLabel.textColor       = CELL_DETAIL_TEXT_COLOR;
        titleLabel.font            = CELL_DETAIL_TEXT_FONT;
        titleLabel.numberOfLines   = 2;
        titleLabel.backgroundColor = TABLEVIEW_BGCOLOR;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.tag = TAG_NO_TITLE_LABEL;
        
        scoreLabel.textColor       = CELL_SCORE_COLOR;
        scoreLabel.font            = CELL_SCORE_FONT;
        scoreLabel.textAlignment   = NSTextAlignmentCenter;
        scoreLabel.backgroundColor = TABLEVIEW_BGCOLOR;
        scoreLabel.tag = TAG_NO_SCORE_LABE;
        
        infoLabel.textColor        = CELL_INFO_COLOR;
        infoLabel.font             = CELL_INFO_FONT;
        infoLabel.backgroundColor  = TABLEVIEW_BGCOLOR;
        infoLabel.tag = TAG_NO_INFO_LABEL;
        
        dateLabel.textColor        = CELL_INFO_COLOR;
        dateLabel.font             = CELL_INFO_FONT;
        dateLabel.textAlignment    = NSTextAlignmentCenter;
        dateLabel.backgroundColor  = TABLEVIEW_BGCOLOR;
        dateLabel.tag = TAG_NO_DATE_LABEL;
        
        photoView.autoresizingMask = UIViewAutoresizingNone;
        photoView.tag = TAG_NO_PHOTO_LABEL;
        
        [cell addSubview:dateLabel];
        [cell addSubview:titleLabel];
        [cell addSubview:scoreLabel];
        [cell addSubview:infoLabel];
        [cell.contentView addSubview:photoView];
        
        [dateLabel  release];
        [titleLabel release];
        [scoreLabel release];
        [infoLabel  release];
        [photoView  release];
	} else {
        titleLabel = (UILabel *)[cell viewWithTag:TAG_NO_TITLE_LABEL];
        scoreLabel = (UILabel *)[cell viewWithTag:TAG_NO_SCORE_LABE];
        infoLabel  = (UILabel *)[cell viewWithTag:TAG_NO_INFO_LABEL];
        dateLabel  = (UILabel *)[cell viewWithTag:TAG_NO_DATE_LABEL];
        photoView  = (UIImageView *)[cell viewWithTag:TAG_NO_PHOTO_LABEL];
    }

    NSManagedObject *managedObject = [modelManager_ fetchObject:@"Movies"
                                                        WithRow:indexPath.row
                                                     AndSection:indexPath.section];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    titleLabel.text = [self nilText:[managedObject valueForKey:@"title"]];
    scoreLabel.text = [NSString stringWithFormat:@"%0.1f点", [[managedObject valueForKey:@"score"] floatValue]];
    infoLabel.text  = [NSString stringWithFormat:@"%@ / %@ / %@",
                      [self nilText:[managedObject valueForKey:@"country"]],
                      [self nilText:[managedObject valueForKey:@"genre"]],
                      [self nilText:[managedObject valueForKey:@"place"]]
                      ];
    dateLabel.text  = [formatter stringFromDate:[managedObject valueForKey:@"timeStamp"]];
    
    NSString *tmp_path;
    if (![[[managedObject valueForKey:@"photo"] substringToIndex:1] isEqualToString:@"~"]) {
        NSRange rangeLib = [[managedObject valueForKey:@"photo"] rangeOfString:@"/Documents/"];
        if (rangeLib.location != NSNotFound) {
            tmp_path = [[NSString stringWithFormat:@"~/Documents/%@",
                         [[managedObject valueForKey:@"photo"] substringFromIndex:rangeLib.location + rangeLib.length]]
                        stringByExpandingTildeInPath];
        } else {
            tmp_path = [[managedObject valueForKey:@"photo"] stringByExpandingTildeInPath];
        }
    } else {
        tmp_path = [[managedObject valueForKey:@"photo"] stringByExpandingTildeInPath];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:tmp_path];

    photoView.image = image;
    
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSManagedObject *managedObject = [modelManager_ fetchObject:@"Movies" WithRow:0 AndSection:section];

    NSString *sortLabelText     = [[[NSString alloc] init] autorelease];

    switch(sortType_) {
        case SORT_TYPE_SCORE:
            sortLabelText = [NSString stringWithFormat:@"%0.1f 点", [[managedObject valueForKey:@"score"] floatValue]];
            break;
        case SORT_TYPE_MONTH:
            if ([[managedObject valueForKey:@"month"] intValue] > 9) {
                sortLabelText = [NSString stringWithFormat:@"%d 月", [[managedObject valueForKey:@"month"] intValue]];
            } else {
                sortLabelText = [NSString stringWithFormat:@" %d 月", [[managedObject valueForKey:@"month"] intValue]];
            }
            break;
        default:
            break;
    }
    
    UILabel *yearlabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 22.0)];
    yearlabel.backgroundColor   = SECTION_BGCOLOR;
    yearlabel.textColor         = SECTION_COLOR;
    yearlabel.font              = SECTION_FONT;
    yearlabel.text              = [NSString stringWithFormat:@"   %@ 年", year_];

    UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 0.0, 40.0, 22.0)];
    sortLabel.backgroundColor   = SECTION_BGCOLOR;
    sortLabel.textColor         = SECTION_COLOR;
    sortLabel.font              = SECTION_FONT;
    sortLabel.textAlignment     = NSTextAlignmentRight;
    sortLabel.text              = sortLabelText;
    
    UILabel *titlesLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 0.0, 80.0, 22.0)];
    titlesLabel.backgroundColor = SECTION_BGCOLOR;
    titlesLabel.textColor       = SECTION_COLOR;
    titlesLabel.font            = SECTION_FONT;
    titlesLabel.textAlignment   = NSTextAlignmentLeft;
    titlesLabel.text            = [NSString stringWithFormat:@"作品数 : %@", [countDict_ objectForKey:[NSNumber numberWithInt:section]]];;

    UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70.0, 0.0, 60.0, 22.0)];
    place.backgroundColor = SECTION_BGCOLOR;
    place.textColor       = SECTION_COLOR;
    place.font            = SECTION_FONT;
    place.textAlignment   = NSTextAlignmentRight;
    place.text            = [masterData_ placeType:placeType_];

    UIView *view = [[[UIView alloc] init] autorelease];
    [view addSubview:yearlabel];
    [view addSubview:sortLabel];
    [view addSubview:titlesLabel];
    [view addSubview:place];
    [yearlabel release];
    [sortLabel release];
    [titlesLabel release];
    [place release];

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self callRecordForUpdate:indexPath];
}

- (void)callRecord
{
    Record* record = [[Record alloc] init];
	[self.navigationController pushViewController:record animated:YES];
    [record release];
}

- (void)callRecordForUpdate:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [modelManager_ fetchObject:@"Movies" WithRow:indexPath.row AndSection:indexPath.section];
    Record* record = [[Record alloc] initWithObjectId:[managedObject objectID]];
	[self.navigationController pushViewController:record animated:YES];
    [record release];
}

- (void)callTerm
{
    Term* term = [[Term alloc] init];
    term.delegate = self;
	[self.navigationController pushViewController:term animated:YES];
    [term release];
}

- (void)callSummary
{
    Summary* summary = [[Summary alloc] initWithYear:year_];
	[self.navigationController pushViewController:summary animated:YES];
    [summary release];
}

- (void)selectAction
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] init] autorelease];
    actionSheet.delegate = self;
    actionSheet.tag = TAG_NO_SELECT_ACTION;
    [actionSheet addButtonWithTitle:@"新作のみ"];
    [actionSheet addButtonWithTitle:@"旧作のみ"];
    [actionSheet addButtonWithTitle:@"すべて"];
    [actionSheet addButtonWithTitle:@"キャンセル"];
    actionSheet.cancelButtonIndex = 3;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view.window];
}

- (void)sortAction
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] init] autorelease];
    actionSheet.delegate = self;
    actionSheet.tag = TAG_NO_SORT_ACTION;
    [actionSheet addButtonWithTitle:@"点数"];
    [actionSheet addButtonWithTitle:@"月"];
    [actionSheet addButtonWithTitle:@"キャンセル"];
    actionSheet.cancelButtonIndex = 2;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view.window];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(actionSheet.tag) {
        case TAG_NO_SELECT_ACTION:{
            switch (buttonIndex) {
                case PLACE_TYPE_NEW:
                    placeType_ = PLACE_TYPE_NEW;
                    break;
                case PLACE_TYPE_OLD:
                    placeType_ = PLACE_TYPE_OLD;
                    break;
                case PLACE_TYPE_ALL:
                    placeType_ = PLACE_TYPE_ALL;
                    break;
            }
            [self setToolbar];
            [self loadTable];
        }
        case TAG_NO_SORT_ACTION:{
            switch (buttonIndex) {
                case SORT_TYPE_SCORE:
                    sortType_ = SORT_TYPE_SCORE;
                    [self setSectionNameKeyScore];
                    break;
                case SORT_TYPE_MONTH:
                    sortType_ = SORT_TYPE_MONTH;
                    [self setSectionNameKeyMonth];
                    break;
            }
        }
        default:
            break;
    }
}

- (void)setSectionNameKeyMonth
{
    [countDict_    release];
    [modelManager_ release];
    countDict_    = [[NSMutableDictionary alloc] init];
    modelManager_ = [[ModelManager alloc] initWithYear:year_ sectionNameKey:@"month" place:[masterData_ placeTypeCond:placeType_]];
    [modelManager_ fetchedResultsController:@"Movies"].delegate = self;
    [self.tableView reloadData];
}

- (void)setSectionNameKeyScore
{
    [countDict_    release];
    [modelManager_ release];
    countDict_    = [[NSMutableDictionary alloc] init];
    modelManager_ = [[ModelManager alloc] initWithYear:year_ sectionNameKey:@"score" place:[masterData_ placeTypeCond:placeType_]];
    [modelManager_ fetchedResultsController:@"Movies"].delegate = self;
    [self.tableView reloadData];
}

- (void)termDelegate:(Term *)termDelegate didClose:(NSString *)data
{
    year_ = nil;
    year_ = data;
    [self loadTable];
}

- (NSString *)nilText:(NSMutableString *)string
{
    if (string && [string length] > 0) {
        return string;
    } else {
        return @"設定なし";
    }
}

@end
