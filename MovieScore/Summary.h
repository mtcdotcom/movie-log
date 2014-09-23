//
//  Summary.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieScore.h"
#import "ModelManager.h"
#import "MasterData.h"
#import "SummaryDetail.h"

#define TABLE_VIEW_SECTION_TOTAL    0
#define TABLE_VIEW_SECTION_AVG      1

#define TABLE_VIEW_ROW_TOTAL_TERM   0
#define TABLE_VIEW_ROW_TOTAL_COUNT  1
#define TABLE_VIEW_ROW_TOTAL_TIME   2
#define TABLE_VIEW_ROW_TOTAL_AMOUNT 3

#define TABLE_VIEW_ROW_AVG_SCORE    0
#define TABLE_VIEW_ROW_AVG_COUNT    1
#define TABLE_VIEW_ROW_AVG_AMOUNT   2

@interface Summary : UITableViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate>
{
    BOOL isload_;
    int placeType_;
    long int total_;
    int totalTime_;
    int totalAmount_;
    int totalTerm_;
    float totalScore_;
    NSString* year_;
    MasterData* masterData_;
}

- (id)initWithYear:(NSString *)year;
@end
