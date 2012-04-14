//
//  MovieList.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieScore.h"
#import "Term.h"
#import "Record.h"
#import "ModelManager.h"
#import "Summary.h"

#define SORT_TYPE_SCORE 0
#define SORT_TYPE_MONTH 1

#define TAG_NO_TITLE_LABEL   1000
#define TAG_NO_SCORE_LABE    1010
#define TAG_NO_INFO_LABEL    1020
#define TAG_NO_DATE_LABEL    1030

#define TAG_NO_SELECT_ACTION 2000
#define TAG_NO_SORT_ACTION   2010

@interface MovieList : UITableViewController<NSFetchedResultsControllerDelegate, TermDelegate, UIActionSheetDelegate>
{
   @private
    int sortType_;
    int placeType_;
    NSString *year_;
    NSMutableDictionary* countDict_;
    ModelManager* modelManager_;
    MasterData* masterData_;
}
@end
