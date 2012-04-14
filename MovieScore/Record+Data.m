//
//  Record+Data.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "Record.h"

@implementation Record (Data)

- (NSString*) stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

- (NSString*)createImageFilename
{
    NSString* filename = [NSString stringWithFormat:@"%@.jpg", [self stringWithUUID]];
    return filename;
}

- (NSString*)getImageFilepath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:[self createImageFilename]];
}

- (void)setData:(NSManagedObject *)managedObject
{
    [managedObject setValue:[self nilText:mtitle_] forKey:@"title"];
    [managedObject setValue:[NSNumber numberWithFloat:[score_ floatValue]] forKey:@"score"];
    [managedObject setValue:country_ forKey:@"country"];
    [managedObject setValue:genre_ forKey:@"genre"];
    [managedObject setValue:place_ forKey:@"place"];
    [managedObject setValue:[NSNumber numberWithInt:[time_ intValue]] forKey:@"time"];
    [managedObject setValue:[NSNumber numberWithInt:[amount_ intValue]] forKey:@"amount"];
    [managedObject setValue:memo_ forKey:@"memo"];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
	NSDate *date = [formatter dateFromString:date_];
    [managedObject setValue:date forKey:@"timeStamp"];
    formatter.dateFormat = @"yyyy";
    [managedObject setValue:[formatter stringFromDate:date] forKey:@"year"];
    formatter.dateFormat  = @"MM";
    [managedObject setValue:[formatter stringFromDate:date] forKey:@"month"];
}

- (void)savePhoto:(NSManagedObject *)managedObject
{
    NSString* imagePath = [self getImageFilepath];
    NSData* data = UIImageJPEGRepresentation(photoImage_, 0.5);
    [data writeToFile:imagePath atomically:NO];
    [managedObject setValue:imagePath forKey:@"photo"];
}

- (void)insert
{
    ModelManager* modelManager = [[ModelManager alloc] init];
    NSManagedObject *managedObject = [modelManager createNewObject:@"Movies"];
    
    [self setData:managedObject];

    if (isLoadPhoto_) {
        [self savePhoto:managedObject];
    }
    
    [modelManager saveContext];
    [modelManager release];
}

- (void)update
{
    ModelManager* modelManager = [[ModelManager alloc] init];
    NSManagedObject *managedObject = [modelManager fetchObject:@"Movies" WithObjectID:objectId_];
    
    [self setData:managedObject];
    
    if ([self isNotNil:photo_]) {
        if (!isLoadPhoto_) {
            [managedObject setValue:nil forKey:@"photo"];
        }
        if  (!isLoadPhoto_ || isUpdatePhoto_) {
            NSError *err;
            NSFileManager* manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:photo_ error:&err];
        }
    }
    
    if (isUpdatePhoto_) {
        [self savePhoto:managedObject];
    }
    
    [modelManager saveContext];
    [modelManager release];
}

- (void)delete
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"作品情報の削除"
                          message:@"この作品情報を削除します。よろしいですか？"
                          delegate:self
                          cancelButtonTitle:@"いいえ"
                          otherButtonTitles:@"はい", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (objectId_ != nil) {
            ModelManager* modelManager = [[ModelManager alloc] init];
            [modelManager deleteObject:@"Movies" WithObjectID:objectId_];
            [modelManager release];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)save
{
    if (objectId_ == nil) {
        [self insert];
    } else {
        [self update];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
