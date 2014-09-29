//
//  Summary.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "Summary.h"

@interface Summary ()

- (void)countDict;

@end

@implementation Summary

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithYear:(NSString *)year
{
    self = [super init];
    if (self) {
        year_        = year;
        total_       = 0;
        totalTime_   = 0;
        totalAmount_ = 0;
        totalScore_  = 0.0;
        isload_      = FALSE;
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
                                     initWithTitle:@"絞り込み" style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(selectAction)] autorelease];
    UIBarButtonItem *itemButton = [[[UIBarButtonItem alloc]
                                     initWithTitle:@" 項目別 " style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(callSummaryDetail)] autorelease];
    
    self.toolbarItems = [NSArray arrayWithObjects:placeButton, fixedSpace, itemButton, nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    masterData_ = [MasterData sharedManager];

    self.title = @"サマリー";

    self.navigationController.navigationBar.barTintColor = TINT_BGCOLOR;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = TINT_COLOR;
    self.tableView.backgroundColor = TABLEVIEW_BGCOLOR;
    self.tableView.rowHeight = 38;
    self.tableView.allowsSelection = NO;

    [self setToolbar];
}

- (void)viewDidUnload
{
    masterData_  = nil;
    [masterData_ release];
    [super viewDidUnload];
}

- (void)dealloc
{  
    [masterData_ release];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (void)countDict
{
    ModelManager *modelManager = [[ModelManager alloc] initWithYear:year_ place:[masterData_ placeTypeCond:placeType_]];

    [modelManager fetchedResultsController:@"Movies"].delegate = self;
    
    total_       = [modelManager countObjects:@"Movies"];
    totalTime_   = 0;
    totalAmount_ = 0;
    totalScore_  = 0.0;
    totalTerm_   = 0;
    int start_y  = 0;
    int start_m  = 0;
    int end_y    = 0;
    int end_m    = 0;
    for (int i = 0; i < total_; i++) {
        NSManagedObject *managedObject = [modelManager fetchObject:@"Movies" WithRow:i AndSection:0];
        totalTime_   += [[managedObject valueForKey:@"time"] intValue];
        totalAmount_ += [[managedObject valueForKey:@"amount"] intValue];
        totalScore_  += [[managedObject valueForKey:@"score"] floatValue];
        if (i == 0) {
            end_y = [[managedObject valueForKey:@"year"] intValue];
            end_m = [[managedObject valueForKey:@"month"] intValue];
        }
        if (i == total_ - 1) {
            start_y = [[managedObject valueForKey:@"year"] intValue];
            start_m = [[managedObject valueForKey:@"month"] intValue];
        }
    }
    if (end_y == 0 && start_y != 0) {
        totalTerm_ = 1;
    } else if (end_y == 0 && start_y == 0) {
        totalTerm_ = 0;
    } else {
        totalTerm_ = (end_y * 12 + end_m) - (start_y * 12 + start_m) + 1;
    }
    isload_ = TRUE;
    [self.tableView reloadData];

    [modelManager release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 0;
    switch (section) {
        case TABLE_VIEW_SECTION_TOTAL:
            number = 4;
            break;
        case TABLE_VIEW_SECTION_AVG:
            number = 3;
            break;
        default:
            break;
    }
    return number;
}

- (NSString *)getFormatAmount
{
    NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
    [formatter setPositiveFormat:@"#,##0 円"];
    return [formatter stringFromNumber:[NSNumber numberWithInt:totalAmount_]];
}

- (NSString *)getFormatAmountAvg
{
    NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
    [formatter setPositiveFormat:@"#,##0 円"];
    NSString *avg;
    if (total_) {
        avg = [formatter stringFromNumber:[NSNumber numberWithInt:totalAmount_ / total_]];
    } else {
        avg = [formatter stringFromNumber:[NSNumber numberWithInt:0]];
    }
    
    return [NSString stringWithFormat:@"%@", avg];
}

- (float)getAvgMonth
{
    if (total_ == 0) {
        return 0;
    }
    return (float)total_ / totalTerm_;
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
    
    switch (indexPath.section) {
        case TABLE_VIEW_SECTION_TOTAL:
            switch (indexPath.row) {
                case TABLE_VIEW_ROW_TOTAL_TERM:
                {
                    cell.textLabel.text       = @"期間";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d ヶ月", totalTerm_];
                    break;
                }
                case TABLE_VIEW_ROW_TOTAL_COUNT:
                {
                    cell.textLabel.text       = @"本数";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld 本", total_];
                    break;
                }
                case TABLE_VIEW_ROW_TOTAL_TIME:
                {
                    cell.textLabel.text       = @"上映時間";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d 時間 %d 分", totalTime_ / 60, totalTime_ % 60];
                    break;
                }
                case TABLE_VIEW_ROW_TOTAL_AMOUNT:
                {
                    cell.textLabel.text       = @"金額";
                    cell.detailTextLabel.text = self.getFormatAmount;
                    break;
                }
                default:
                    break;
            }
            break;
        case TABLE_VIEW_SECTION_AVG:
            switch (indexPath.row) {
                case TABLE_VIEW_ROW_AVG_SCORE:
                {
                    float avg = 0.0;
                    if (totalScore_ != 0.0 || total_ != 0) {
                        avg = (float)totalScore_ / total_;
                    }
                    cell.textLabel.text       = @"点数";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f 点", avg];
                    break;
                }
                case TABLE_VIEW_ROW_AVG_COUNT:
                {
                    cell.textLabel.text       = @"本数 / 月";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f 本", [self getAvgMonth]];
                    break;
                }
                case TABLE_VIEW_ROW_AVG_AMOUNT:
                {
                    cell.textLabel.text       = @"金額 / 本";
                    cell.detailTextLabel.text = self.getFormatAmountAvg;
                    break;
                }
                default:
                break;
            }
            break;
        default:
            break;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] init] autorelease];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 22.0)];
    label.backgroundColor = SECTION_BGCOLOR;
    label.textColor       = SECTION_COLOR;
    label.font            = SECTION_FONT;
    
    UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 105.0, 0.0, 95.0, 22.0)];
    place.backgroundColor = SECTION_BGCOLOR;
    place.textColor       = SECTION_COLOR;
    place.font            = SECTION_FONT;
    place.textAlignment   = NSTextAlignmentRight;
    place.text            = [masterData_ placeType:placeType_];  

    switch (section) {
        case TABLE_VIEW_SECTION_TOTAL:
            if ([year_ isEqualToString:@"すべて"]) {
                label.text = [NSString stringWithFormat:@"   %@     トータル", year_];
            } else {
                label.text = [NSString stringWithFormat:@"   %@ 年   トータル", year_];
            }
            break;
        case TABLE_VIEW_SECTION_AVG:
            if ([year_ isEqualToString:@"すべて"]) {
                label.text = [NSString stringWithFormat:@"   %@     平均", year_];
            } else {
                label.text = [NSString stringWithFormat:@"   %@ 年   平均", year_];
            }
            break;
        default:
            break;
    }
    [view addSubview:label];
    [view addSubview:place];
    [label release];
    [place release];

    return view;
}

- (void)callSummaryDetail
{
    SummaryDetail* detail = [[SummaryDetail alloc] initWithYear:year_ placeType:placeType_];
	[self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (void)selectAction
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] init] autorelease];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"新作のみ"];
    [actionSheet addButtonWithTitle:@"旧作のみ"];
    [actionSheet addButtonWithTitle:@"DVD・Blu-ray"];
    [actionSheet addButtonWithTitle:@"すべて"];
    [actionSheet addButtonWithTitle:@"キャンセル"];
    actionSheet.cancelButtonIndex = 4;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view.window];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case PLACE_TYPE_NEW:
            placeType_ = PLACE_TYPE_NEW;
            break;
        case PLACE_TYPE_OLD:
            placeType_ = PLACE_TYPE_OLD;
            break;
        case PLACE_TYPE_DVD_BLURAY:
            placeType_ = PLACE_TYPE_DVD_BLURAY;
            break;
        case PLACE_TYPE_ALL:
            placeType_ = PLACE_TYPE_ALL;
            break;
    }
    [self setToolbar];
    [self countDict];
    [self.tableView reloadData];
}

@end
