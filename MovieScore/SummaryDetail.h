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
#import "Term.h"

#define LIST_TYPE_SCORE   0
#define LIST_TYPE_TERM    1
#define LIST_TYPE_COUNTRY 2
#define LIST_TYPE_GENRE   3
#define LIST_TYPE_PLACE   4

@interface SummaryDetail : UITableViewController <NSFetchedResultsControllerDelegate>
{
    BOOL isload_;
    long int listType_;
    int placeType_;
    NSString* year_;
    NSArray* years_;
    NSMutableDictionary* scoreDict_;
    NSMutableDictionary* yearDict_;
    NSMutableDictionary* monthDict_;
    NSMutableDictionary* countryDict_;
    NSMutableDictionary* genreDict_;
    NSMutableDictionary* placeDict_;
    MasterData* masterData_;
}

- (id)initWithYear:(NSString *)year placeType:(int)placeType;
@end

