//
//  MasterData.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLACE_TYPE_NEW  0
#define PLACE_TYPE_OLD  1
#define PLACE_TYPE_ALL  2

@interface MasterData : NSObject

+ (MasterData*)sharedManager;

- (NSArray *)monthDatas;
- (NSArray *)scoreDatas;
- (NSArray *)countryDatas;
- (NSArray *)genreDatas;
- (NSArray *)placeDatas;
- (NSString *)placeTypeCond:(int)placeType;
- (NSString *)placeType:(int)placeType;
- (NSString *)reversePlaceType:(int)placeType ;

@end
