//
//  Record.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "Record.h"

@interface Record ()

- (void)pushViewController:(NSIndexPath *)indexPath;

@end

@implementation Record

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        isLoadPhoto_   = FALSE;
        isUpdatePhoto_ = FALSE;
    }
    return self;
}

- (id)initWithObjectId:(NSManagedObjectID *)objectId
{
    self = [super init];
    if (self) {
        objectId_      = objectId;
        isLoadPhoto_   = FALSE;
        isUpdatePhoto_ = FALSE;
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

	self.title = @"作品情報";
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = TABLEVIEW_BGCOLOR;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                               target:self
                                               action:@selector(save)] autorelease];

    UIBarButtonItem* fixedSpace = [[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                    target:nil
                                    action:nil] autorelease];

    UIBarButtonItem *cameraButton = [[[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                      target:self action:@selector(photo)] autorelease];
    
    UIBarButtonItem *actionButton = [[[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                                      target:self action:@selector(mailAndTweet)] autorelease];

    mtitle_  = [[NSMutableString alloc] initWithCapacity:0];
    score_   = [[NSMutableString alloc] initWithCapacity:0];
    country_ = [[NSMutableString alloc] initWithCapacity:0];
    genre_   = [[NSMutableString alloc] initWithCapacity:0];
    place_   = [[NSMutableString alloc] initWithCapacity:0];
    time_    = [[NSMutableString alloc] initWithCapacity:0];
    amount_  = [[NSMutableString alloc] initWithCapacity:0];
    memo_    = [[NSMutableString alloc] initWithCapacity:0];
    date_    = [[NSMutableString alloc] initWithCapacity:0];
    photo_   = [[NSMutableString alloc] initWithCapacity:0];

    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if (objectId_ != nil) {
        ModelManager* modelManager = [[ModelManager alloc] init];
        NSManagedObject *managedObject = [modelManager fetchObject:@"Movies" WithObjectID:objectId_];
    
        if ([managedObject valueForKey:@"title"]) {
            [mtitle_ setString:[managedObject valueForKey:@"title"]];
        }
        if ([managedObject valueForKey:@"score"]) {
            NSString *score = [[NSString alloc] initWithFormat:@"%0.1f",
                               [[managedObject valueForKey:@"score"] floatValue]];
            [score_ setString:score];
            [score release];
        }
        if ([managedObject valueForKey:@"country"]) {
            [country_ setString:[managedObject valueForKey:@"country"]];
        }
        if ([managedObject valueForKey:@"genre"]) {
            [genre_ setString:[managedObject valueForKey:@"genre"]];
        }
        if ([managedObject valueForKey:@"place"]) {
            [place_ setString:[managedObject valueForKey:@"place"]];
        }
        if ([managedObject valueForKey:@"time"]) {
            NSString *time =[[NSString alloc] initWithFormat:@"%d",
                             [[managedObject valueForKey:@"time"] intValue]];
            [time_ setString:time];
            [time release];
        }
        if ([managedObject valueForKey:@"amount"]) {
            NSString *amount =[[NSString alloc] initWithFormat:@"%d",
                               [[managedObject valueForKey:@"amount"] intValue]];
            [amount_ setString:amount];
            [amount release];
        }
        if ([managedObject valueForKey:@"memo"]) {
            [memo_ setString:[managedObject valueForKey:@"memo"]];
        }
        if ([managedObject valueForKey:@"timeStamp"]) {
            [date_ setString:[formatter stringFromDate:
                              [managedObject valueForKey:@"timeStamp"]]];
        }
        if ([managedObject valueForKey:@"photo"]) {
            [photo_ setString:[managedObject valueForKey:@"photo"]];
        }
        [modelManager release];

        if ([self isNotNil:photo_]) {
            NSString *tmp_path;
            if (![[photo_ substringToIndex:1] isEqualToString:@"~"]) {
                NSRange rangeLib = [photo_ rangeOfString:@"/Documents/"];
                if (rangeLib.location != NSNotFound) {
                    tmp_path = [[NSString stringWithFormat:@"~/Documents/%@",
                                  [photo_ substringFromIndex:rangeLib.location + rangeLib.length]]
                                 stringByExpandingTildeInPath];
                } else {
                    tmp_path = [photo_ stringByExpandingTildeInPath];
                }
            } else {
                tmp_path = [photo_ stringByExpandingTildeInPath];
            }
            UIImage *image = [UIImage imageWithContentsOfFile:tmp_path];
            [self dispPhoto:image];
            photoImage_ = image;
            [photoImage_ retain];
            [image release];
            isLoadPhoto_ = TRUE;
        } else {
            [self dispNoPhoto];
        }

        UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                         target:self action:@selector(delete)] autorelease];

        self.toolbarItems = [NSArray arrayWithObjects:trashButton, fixedSpace, cameraButton, fixedSpace, actionButton, nil];
        [self.navigationController setToolbarHidden:NO animated:NO];
    } else {
        [score_  setString:@"0.0"];
        [time_   setString:@"0"];
        [amount_ setString:@"0"];
        NSDate *today  = [[NSDate alloc] init];
        NSString *date = [formatter stringFromDate:today];
        [date_   setString:date];
        [today   release];
        
        [self dispNoPhoto];

        self.toolbarItems = [NSArray arrayWithObjects:fixedSpace, cameraButton, fixedSpace, actionButton, nil];
        [self.navigationController setToolbarHidden:NO animated:NO];
    }
}

- (void)viewDidUnload
{
    objectId_= nil;

    [mtitle_  release];
    [score_   release];
    [country_ release];
    [genre_   release];
    [place_   release];
    [time_    release];
    [amount_  release];
    [memo_    release];
    [date_    release];
    [photo_   release];

    score_   = nil;
    date_    = nil;
    mtitle_  = nil;
    score_   = nil;
    country_ = nil;
    genre_   = nil;
    place_   = nil;
    time_    = nil;
    amount_  = nil;
    memo_    = nil;
    photo_   = nil;

    [super viewDidUnload];
}

- (void)dealloc
{
    [mtitle_  release];
    [score_   release];
    [country_ release];
    [genre_   release];
    [place_   release];
    [time_    release];
    [amount_  release];
    [memo_    release];
    [date_    release];
    [photo_   release];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TABLE_VIEW_SECTION_MOVIE) {
        return 8;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0.0;

    switch (indexPath.section) {
        case TABLE_VIEW_SECTION_MOVIE:
            switch (indexPath.row) {
                case TABLE_VIEW_ROW_TITLE:
                    height = 66.0;
                    break;
                case TABLE_VIEW_ROW_SCORE:
                    height = 44.0;
                    break;
                case TABLE_VIEW_ROW_COUNTRY:
                    height = 44.0;
                    break;
                case TABLE_VIEW_ROW_GENRE:
                    height = 44.0;
                    break;
                case TABLE_VIEW_ROW_PLACE:
                    height = 44.0;
                    break;
                case TABLE_VIEW_ROW_TIME:
                    height = 44.0;
                    break;
                case TABLE_VIEW_ROW_AMOUNT:
                    height = 44.0;
                    break;
                case TABLE_VIEW_ROW_DATE:
                    height = 44.0;
                    break;
                default:
                    break;
            }
            break;
        case TABLE_VIEW_SECTION_MEMO:
        {
            UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
            CGSize bounds = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height);
            UIFont *font = cell.textLabel.font;
            CGRect rect = [cell.textLabel.text boundingRectWithSize:bounds
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:font}
                                                            context:nil];
            CGSize size = rect.size;
            height = size.height > 132.0 ? size.height + 20.0 : 132.0;
            height = height * 1.15;
            break;
        }
        default:
            break;
    }

    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"InfoCell";
    static NSString *CellIdentifier2 = @"MemoCell";
    UITableViewCell *cell;

    if (indexPath.section == TABLE_VIEW_SECTION_MOVIE) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]
                      initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier1]
                    autorelease];
            cell.backgroundColor     = TABLEVIEW_BGCOLOR;
            cell.textLabel.font      = CELL_TEXT_FONT;
            cell.textLabel.textColor = CELL_TEXT_COLOR;
            cell.detailTextLabel.font      = CELL_DETAIL_TEXT_FONT;
            cell.detailTextLabel.textColor = CELL_DETAIL_TEXT_COLOR;
        }
        switch (indexPath.row) {
            case TABLE_VIEW_ROW_TITLE:
                cell.textLabel.text = @"タイトル";
                if ([self isNotNil:mtitle_] && ![mtitle_ isEqualToString:@"設定なし"]) {
                    cell.detailTextLabel.text = mtitle_;
                }
                cell.detailTextLabel.numberOfLines = 2;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case TABLE_VIEW_ROW_SCORE:
                cell.textLabel.text = @"点数";
                if ([self isNotNil:score_]) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 点", score_];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case TABLE_VIEW_ROW_COUNTRY:
                cell.textLabel.text = @"制作国";
                if ([self isNotNil:country_]) {
                    cell.detailTextLabel.text = country_;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case TABLE_VIEW_ROW_GENRE:
                cell.textLabel.text = @"ジャンル";
                if ([self isNotNil:genre_]) {
                    cell.detailTextLabel.text = genre_;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case TABLE_VIEW_ROW_PLACE:
                cell.textLabel.text = @"場所";
                if ([self isNotNil:place_]) {
                    cell.detailTextLabel.text = place_;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case TABLE_VIEW_ROW_TIME:
                cell.textLabel.text = @"上映時間";
                if ([self isNotNil:time_]) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 分", time_];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case TABLE_VIEW_ROW_AMOUNT:
                cell.textLabel.text = @"金額";                
                if ([self isNotNil:amount_]) {
                    NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
                    [formatter setPositiveFormat:@"#,##0 円"];
                    cell.detailTextLabel.text = [formatter stringFromNumber:
                                                 [NSNumber numberWithInt:[amount_ intValue]]];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case TABLE_VIEW_ROW_DATE:
                cell.textLabel.text = @"日付";
                if ([self isNotNil:date_]) {
                    cell.detailTextLabel.text = date_;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]
                      initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2]
                     autorelease];
            cell.backgroundColor         = TABLEVIEW_BGCOLOR;
            cell.textLabel.font          = CELL_DETAIL_TEXT_FONT;
            cell.textLabel.textColor     = CELL_DETAIL_TEXT_COLOR;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        if ([self isNotNil:memo_]) {
            cell.textLabel.text = memo_;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }

    return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case TABLE_VIEW_SECTION_MOVIE:
            return @"作品情報";
            break;
        case TABLE_VIEW_SECTION_MEMO:
            return @"メモ";
            break;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == TABLE_VIEW_SECTION_MOVIE) {
        return 132.0;
    } else {
        return 64.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, 150.0, 44.0)];
    switch(section) {
        case TABLE_VIEW_SECTION_MOVIE:
            label.text = @"  作品情報";
            break;
        case TABLE_VIEW_SECTION_MEMO:
            label.text = @"  メモ";
            break;
    }
    label.backgroundColor = SECTION_BGCOLOR;
    label.font            = SECTION_FONT;
    label.textColor       = SECTION_COLOR;

    UIView *view = [[[UIView alloc] init] autorelease];
    [view addSubview:label];

    [label release];

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TABLE_VIEW_SECTION_MOVIE:
            [self pushViewController:indexPath];
            break;
        case TABLE_VIEW_SECTION_MEMO:
            [self pushViewController:indexPath];
            break;
        default:
            break;
    }
}

- (void)pushViewController:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TABLE_VIEW_SECTION_MOVIE:
        {
            switch (indexPath.row) {
                case TABLE_VIEW_ROW_TITLE:
                {
                    InputTextFiled* obj;
                    if ([self isNotNil:mtitle_]) {
                        obj = [[InputTextFiled alloc] initWithDefaultValue:INPUT_TYPE_TITLE
                                                              defaultValue:mtitle_];
                    } else {
                        obj = [[InputTextFiled alloc] initWithType:INPUT_TYPE_TITLE];
                    }
                    obj.delegate = self;
                    [self.navigationController pushViewController:obj animated:YES];
                    [obj release];
                    break;
                }
                case TABLE_VIEW_ROW_SCORE:
                {
                    SelectTable* obj;
                    if ([self isNotNil:score_]) {
                        obj = [[SelectTable alloc] initWithDefaultValue:SELECT_TYPE_SCORE
                                                           defaultValue:score_];
                    } else {
                        obj = [[SelectTable alloc] initWithType:SELECT_TYPE_SCORE];
                    }
                    obj.delegate = self;
                    [self.navigationController pushViewController:obj animated:YES];
                    [obj release];
                    break;
                }
                case TABLE_VIEW_ROW_COUNTRY:
                {
                    SelectTable* obj;
                    if ([self isNotNil:country_]) {
                        obj = [[SelectTable alloc] initWithDefaultValue:SELECT_TYPE_COUNTRY
                                                           defaultValue:country_];
                    } else {
                        obj = [[SelectTable alloc] initWithType:SELECT_TYPE_COUNTRY];
                    }
                    obj.delegate = self;
                    [self.navigationController pushViewController:obj animated:YES];
                    [obj release];
                    break;
                }
                case TABLE_VIEW_ROW_GENRE:
                {
                    SelectTable* obj;
                    if ([self isNotNil:genre_]) {
                        obj = [[SelectTable alloc] initWithDefaultValue:SELECT_TYPE_GENRE
                                                           defaultValue:genre_];
                    } else {
                        obj = [[SelectTable alloc] initWithType:SELECT_TYPE_GENRE];
                    }
                    obj.delegate = self;
                    [self.navigationController pushViewController:obj animated:YES];
                    [obj release];
                    break;
                }
                case TABLE_VIEW_ROW_PLACE:
                {
                    SelectTable* obj;
                    if ([self isNotNil:place_]) {
                        obj = [[SelectTable alloc] initWithDefaultValue:SELECT_TYPE_PLACE
                                                           defaultValue:place_];
                    } else {
                        obj = [[SelectTable alloc] initWithType:SELECT_TYPE_PLACE];
                    }
                    obj.delegate = self;
                    [self.navigationController pushViewController:obj animated:YES];
                    [obj release];
                    break;
                }
                case TABLE_VIEW_ROW_TIME:
                {
                    InputTextFiled* obj;
                    if ([self isNotNil:time_]) {
                        obj = [[InputTextFiled alloc] initWithDefaultValue:INPUT_TYPE_TIME
                                                              defaultValue:time_];
                    } else {
                        obj = [[InputTextFiled alloc] initWithType:INPUT_TYPE_TIME];
                    }
                    obj.delegate = self;
                    [self.navigationController pushViewController:obj animated:YES];
                    [obj release];
                    break;
                }
                case TABLE_VIEW_ROW_AMOUNT:
                {
                    InputTextFiled* obj;
                    if ([self isNotNil:amount_]) {
                        obj = [[InputTextFiled alloc] initWithDefaultValue:INPUT_TYPE_AMOUNT
                                                              defaultValue:amount_];
                    } else {
                        obj = [[InputTextFiled alloc] initWithType:INPUT_TYPE_AMOUNT];
                    }
                    obj.delegate = self;
                    [self.navigationController pushViewController:obj animated:YES];
                    [obj release];
                    break;
                }
                case TABLE_VIEW_ROW_DATE:
                {
                    DatePicker* obj;
                    if ([self isNotNil:date_]) {
                        obj = [[DatePicker alloc] initWithDefaultValue:date_];
                    } else {
                        obj = [[DatePicker alloc] init];
                    }
                    obj.delegate = self;
                    [self.navigationController pushViewController:obj animated:YES];
                    [obj release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case TABLE_VIEW_SECTION_MEMO:
        {
            InputText* obj;
            if ([self isNotNil:memo_]) {
                obj = [[InputText alloc] initWithDefaultValue:INPUT_TYPE_MEMO
                                                 defaultValue:memo_];
            } else {
                obj = [[InputText alloc] initWithType:INPUT_TYPE_MEMO];
            }
            obj.delegate = self;
            [self.navigationController pushViewController:obj animated:YES];
            [obj release];
        }
        default:
            break;
    }
}

- (NSString *)nilText:(NSMutableString *)string
{
    if ([self isNotNil:string]) {
        return string;
    } else {
        return @"設定なし";
    }
}

- (NSString *)emptyText:(NSMutableString *)string
{
    if ([self isNotNil:string]) {
        return string;
    } else {
        return @"";
    }
}

- (BOOL)isNotNil:(NSMutableString *)string
{
    if (string && [string length] > 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

@end