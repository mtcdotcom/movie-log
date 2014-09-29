//
//  MasterData.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "MasterData.h"

@implementation MasterData

static MasterData* sharedHistory = nil;

+ (MasterData*)sharedManager
{
	@synchronized(self) {
		if (sharedHistory == nil) {
			sharedHistory = [[self alloc] init];
		}
	}
	return sharedHistory;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (sharedHistory == nil) {
			sharedHistory = [super allocWithZone:zone];
			return sharedHistory;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (NSUInteger)retainCount
{
	return UINT_MAX;
}

- (oneway void)release
{
}

- (id)autorelease
{
	return self;
}

- (NSArray *)monthDatas
{
    NSArray *data =  [[NSArray alloc] initWithObjects:
                        @"01",
                        @"02",
                        @"03",
                        @"04",
                        @"05",
                        @"06",
                        @"07",
                        @"08",
                        @"09",
                        @"10",
                        @"11",
                        @"12",
                      nil];
    [data autorelease];
    return data;
}

- (NSArray *)scoreDatas
{
    NSArray *data = [[NSArray alloc] initWithObjects:
                        @"5.0",
                        @"4.5",
                        @"4.0",
                        @"3.5",
                        @"3.0",
                        @"2.5",
                        @"2.0",
                        @"1.5",
                        @"1.0",
                        @"0.5",
                        @"0.0",
                     nil];
    [data autorelease];
    return data;
}

- (NSArray *)countryDatas
{
    NSArray *data = [[NSArray alloc] initWithObjects:
                        @"日本",
                        @"アメリカ", 
                        @"アジア",
                        @"ヨーロッパ",
                        @"その他",
                     nil];
    [data autorelease];
    return data;
}

- (NSArray *)genreDatas
{
    NSArray *data = [[NSArray alloc] initWithObjects:
                        @"アクション",
                        @"ドラマ",
                        @"恋愛",
                        @"ミステリー",
                        @"サスペンス",
                        @"SF",
                        @"ファンタジー",
                        @"コメディ",
                        @"ホラー",
                        @"バイオレンス",
                        @"ドキュメンタリー",
                        @"アニメ",
                        @"その他",
                     nil];
    [data autorelease];
    return data;
}

- (NSArray *)placeDatas
{
    NSArray *data =  [[NSArray alloc] initWithObjects:
                        @"映画館(新作)",
                        @"映画館(旧作)",
                        @"PC・モバイル",
                        @"DVD・Blu-ray",
                        @"テレビ",
                        @"その他",
                      nil];
    [data autorelease];
    return data;
}

- (NSString *)placeTypeCond:(int)placeType 
{
    switch(placeType) {
        case PLACE_TYPE_NEW:
            return @"映画館(新作)";
            break;
        case PLACE_TYPE_OLD:
            return @"映画館(旧作)";
            break;
        case PLACE_TYPE_DVD_BLURAY:
            return @"DVD・Blu-ray";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)placeType:(int)placeType 
{
    switch(placeType) {
        case PLACE_TYPE_NEW:
            return @"新作のみ";
            break;
        case PLACE_TYPE_OLD:
            return @"旧作のみ";
            break;
        case PLACE_TYPE_DVD_BLURAY:
            return @"DVD・Blu-ray";
            break;
        case PLACE_TYPE_ALL:
            return @"すべて";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)reversePlaceType:(int)placeType 
{
    if (placeType == PLACE_TYPE_NEW) {
        return @" すべて ";
    } else {
        return @"新作のみ";
    }
}

@end
