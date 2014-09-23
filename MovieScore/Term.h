//
//  Term.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieScore.h"
#import "ModelManager.h"

@protocol TermDelegate;

@interface Term : UITableViewController<NSFetchedResultsControllerDelegate>
{
  @private
    long termCount_;
    ModelManager *modelManager_;
    id<TermDelegate> delegate_;
}

@property (nonatomic, assign) id<TermDelegate> delegate;
@end

@protocol TermDelegate <NSObject>
-(void)termDelegate:(Term *)termDelegate didClose:(NSString *)data;
@end
