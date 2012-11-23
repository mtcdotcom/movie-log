//
//  MovieScore.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

// html形式でRGB指定を行う
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];

//
// 背景色
//

// ナビゲーションバー背景色
#define TINT_BGCOLOR HEXCOLOR(0x2b2b2e);

// ツールバー背景色
#define TOOLBAR_TINT_BGCOLOR HEXCOLOR(0x2b2b2e)

// テーブルビュー背景色
#define TABLEVIEW_BGCOLOR HEXCOLOR(0xffffff)

// テーブルビューセクションヘッダー背景色
#define SECTION_BGCOLOR HEXCOLOR(0x484741)

// 入力フィールド背景色
#define INPUT_FILED_BGCOLOR HEXCOLOR(0xffffff)

//
// フォント指定
//

// 入力フィールド反映ボタン
#define BUTTON_FONT [UIFont boldSystemFontOfSize:15]
#define BUTTON_COLOR HEXCOLOR(0xcd5c5c)

// セル セクション
#define SECTION_FONT [UIFont boldSystemFontOfSize:14]
#define SECTION_COLOR HEXCOLOR(0xffffff)

// セル テキスト
#define CELL_TEXT_FONT [UIFont boldSystemFontOfSize:15]
#define CELL_TEXT_COLOR HEXCOLOR(0x7b7f84)

// セル 詳細テキスト
#define CELL_DETAIL_TEXT_FONT [UIFont boldSystemFontOfSize:17]
#define CELL_DETAIL_TEXT_COLOR HEXCOLOR(0x414444)

// セル 点数
#define CELL_SCORE_FONT [UIFont boldSystemFontOfSize:21]
#define CELL_SCORE_COLOR HEXCOLOR(0x414444)

// セル 詳細情報
#define CELL_INFO_FONT [UIFont systemFontOfSize:10]
#define CELL_INFO_COLOR HEXCOLOR(0x7b7f84)
