//
//  Record+Delegate.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "Record.h"

@implementation Record (Delegate)

- (UITableViewCell *)getCell:(int)section row:(int)row
{
    UITableView *tableView = (UITableView *)self.view;
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}

- (void)setCellText:(int)section row:(int)row text:(NSString *)text
{
    UITableViewCell *cell = [self getCell:section row:row];
    cell.textLabel.text   = text;
    [cell setNeedsLayout];
}

- (void)setCellDetailText:(int)section row:(int)row text:(NSString *)text
{
    UITableViewCell *cell     = [self getCell:section row:row];
    cell.detailTextLabel.text = text;
    [cell setNeedsLayout];
}

- (void)InputTextFiledDelegate:(InputText *)InputTextDelegate didClose:(int)type value:(NSString *)value
{
    switch (type) {
        case INPUT_TYPE_TITLE:
            [mtitle_ setString:value];
            [self setCellDetailText:0
                                row:TABLE_VIEW_ROW_TITLE
                               text:value];
            break;
        case INPUT_TYPE_TIME:
            if ([value intValue] > 999) {
                [time_ setString:@"999"];
            } else {
                [time_ setString:value];
            }
            [self setCellDetailText:0
                                row:TABLE_VIEW_ROW_TIME
                               text:[NSString stringWithFormat:@"%@ 分", time_]];
            break;
        case INPUT_TYPE_AMOUNT:
            if ([value intValue] > 999999) {
                [amount_ setString:@"999999"];
            } else {
                [amount_ setString:value];
            }
            NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
            [formatter setPositiveFormat:@"#,##0 円"];
            [self setCellDetailText:0
                                row:TABLE_VIEW_ROW_AMOUNT
                               text:[formatter stringFromNumber:
                                     [NSNumber numberWithInt:[amount_ intValue]]]];
            break;
        default:
            break;
    }
}

- (void)InputTextDelegate:(InputText *)InputTextDelegate didClose:(int)type value:(NSString *)value
{
    switch (type) {
        case INPUT_TYPE_MEMO:
            [memo_ setString:value];
            [self setCellText:1 row:0 text:value];
            break;
        default:
            break;
    }
}

- (void)SelectTableDelegate:(SelectTable *)SelectTableDelegate didClose:(int)type value:(NSString *)value
{
    switch (type) {
        case SELECT_TYPE_SCORE:
            [score_ setString:value];
            [self setCellDetailText:TABLE_VIEW_SECTION_MOVIE
                                row:TABLE_VIEW_ROW_SCORE
                               text:[NSString stringWithFormat:@"%@ 点", value]];
            break;
        case SELECT_TYPE_COUNTRY:
            [country_ setString:value];
            [self setCellDetailText:TABLE_VIEW_SECTION_MOVIE
                                row:TABLE_VIEW_ROW_COUNTRY
                               text:value];
            break;
        case SELECT_TYPE_GENRE:
            [genre_ setString:value];
            [self setCellDetailText:TABLE_VIEW_SECTION_MOVIE
                                row:TABLE_VIEW_ROW_GENRE
                               text:value];
            break;
        case SELECT_TYPE_PLACE:
            [place_ setString:value];
            [self setCellDetailText:TABLE_VIEW_SECTION_MOVIE
                                row:TABLE_VIEW_ROW_PLACE
                               text:value];
            break;
        default:
            break;
    }
}

- (void)DatePickerDelegate:(DatePicker *)DatePickerDelegate didClose:(NSString *)date
{
    [date_ setString:date];
    [self setCellDetailText:TABLE_VIEW_SECTION_MOVIE
                        row:TABLE_VIEW_ROW_DATE
                       text:date];
}

@end
