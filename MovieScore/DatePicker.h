//
//  DatePicker.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieScore.h"

@protocol DatePickerDelegate;

@interface DatePicker : UIViewController
{
    NSString* value_;
    UIDatePicker *datePicker_;
    id<DatePickerDelegate> delegate_;
}

@property (nonatomic, assign) id<DatePickerDelegate> delegate;

- (id)initWithDefaultValue:(NSString *)defaultValue;
@end

@protocol DatePickerDelegate <NSObject>
- (void)DatePickerDelegate:(DatePicker *)DatePickerDelegate didClose:(NSString *)date;
@end
