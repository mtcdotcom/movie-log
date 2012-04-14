//
//  InputText.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieScore.h"

#define INPUT_TYPE_TITLE    1
#define INPUT_TYPE_TIME     2
#define INPUT_TYPE_AMOUNT   3
#define INPUT_TYPE_MEMO     4

#define BUTTON_TAG_NO       1000

@protocol InputTextDelegate;

@interface InputText : UIViewController
{
    int type_;
    NSString* value_;
    UITextView *textView_;
    id<InputTextDelegate> delegate_;
}

@property (nonatomic, assign) id<InputTextDelegate> delegate;

- (id)initWithType:(int)type;
- (id)initWithDefaultValue:(int)type defaultValue:(NSString *)defaultValue;
@end

@protocol InputTextDelegate <NSObject>
- (void)InputTextDelegate:(InputText *)InputTextDelegate didClose:(int)type value:(NSString *)value;
@end