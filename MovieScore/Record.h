//
//  Record.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "QuartzCore/CALayer.h"
#import "MovieScore.h"
#import "ModelManager.h"
#import "SelectTable.h"
#import "InputText.h"
#import "InputTextFiled.h"
#import "DatePicker.h"

#define TABLE_VIEW_SECTION_MOVIE    0
#define TABLE_VIEW_SECTION_MEMO     1

#define TABLE_VIEW_ROW_TITLE        0
#define TABLE_VIEW_ROW_SCORE        1
#define TABLE_VIEW_ROW_COUNTRY      2
#define TABLE_VIEW_ROW_GENRE        3
#define TABLE_VIEW_ROW_PLACE        4
#define TABLE_VIEW_ROW_TIME         5
#define TABLE_VIEW_ROW_AMOUNT       6
#define TABLE_VIEW_ROW_DATE         7

#define TAG_NO_MAIL_AND_TWEET       1000
#define TAG_NO_PHOTO                1010

@interface Record : UITableViewController <NSFetchedResultsControllerDelegate, UINavigationControllerDelegate>
{
   @private
    NSMutableString* date_;
    NSMutableString* mtitle_;
    NSMutableString* score_;
    NSMutableString* country_;
    NSMutableString* genre_;
    NSMutableString* place_;
    NSMutableString* time_;
    NSMutableString* amount_;
    NSMutableString* memo_;
    NSMutableString* photo_;
    BOOL isLoadPhoto_;
    BOOL isUpdatePhoto_;
    UIImage* photoImage_;
    NSManagedObjectID* objectId_;
}

- (id)initWithObjectId:(NSManagedObjectID *)updateObjectId;
- (NSString *)emptyText:(NSString *)data;
- (NSString *)nilText:(NSString *)data;
- (BOOL)isNotNil:(NSMutableString *)string;
@end

@interface Record (Delegate) <SelectTableDelegate, InputTextDelegate, InputTextFiledDelegate, DatePickerDelegate>
{
}
@end

@interface Record (Action) <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
}
- (void)dispPhoto:image;
- (void)dispNoPhoto;
@end

@interface Record (Data)
{
}
@end