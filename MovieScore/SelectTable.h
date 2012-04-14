//
//  SelectTable.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieScore.h"
#import "MasterData.h"

#define SELECT_TYPE_SCORE   1
#define SELECT_TYPE_COUNTRY 2
#define SELECT_TYPE_GENRE   3
#define SELECT_TYPE_PLACE   4

@protocol SelectTableDelegate;

@interface SelectTable : UITableViewController
{
    int type_;
    NSString* value_;
    NSArray* lists_;
    id<SelectTableDelegate> delegate_;
}

@property (nonatomic, assign) id<SelectTableDelegate> delegate;

- (id)initWithType:(int)type;
- (id)initWithDefaultValue:(int)type defaultValue:(NSString *)defaultValue;
@end

@protocol SelectTableDelegate <NSObject>
-(void)SelectTableDelegate:(SelectTable *)SelectTableDelegate didClose:(int)type value:(NSString *)value;
@end

