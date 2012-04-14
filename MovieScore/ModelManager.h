//
//  ModelManager.h
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ModelManager : NSObject<NSFetchedResultsControllerDelegate>
{
   @private
    NSString *year_;
    NSString *sectionNameKey_;
    NSString *place_;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (id)initWithYear:(NSString *)year;
- (id)initWithsectionNameKey:(NSString *)sectionNameKey;
- (id)initWithYear:(NSString *)year sectionNameKey:(NSString *)sectionNameKey;
- (id)initWithYear:(NSString *)year sectionNameKey:(NSString *)sectionNameKey place:(NSString *)place;
- (id)initWithYear:(NSString *)year place:(NSString *)place;
- (NSURL *)applicationDocumentsDirectory;
- (NSFetchedResultsController *)fetchedResultsController:(NSString *)entityName;
- (NSManagedObject *)fetchObject:(NSString *)entityName WithRow:(NSInteger)row AndSection:(NSInteger)section;
- (NSManagedObject *)fetchObject:(NSString *)entityName WithObjectID:(NSManagedObjectID *)objectId;
- (NSManagedObject *)fetchObject:(NSString *)entityName WithIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)countObjects:(NSString *)entityName;
- (NSInteger)countObjects:(NSString *)entityName section:(NSInteger)section;
- (NSInteger)countSections:(NSString *)entityName;
- (NSManagedObject *)createNewObject:(NSString *)entityName;
- (void)saveContext;
- (void)deleteObject:(NSString *)entityName WithRow:(NSInteger)row AndSection:(NSInteger)section;
- (void)deleteObject:(NSString *)entityName WithIndexPath:(NSIndexPath *)indexPath;
- (void)deleteObject:(NSString *)entityName WithObject:(NSManagedObject *)managedObject;
- (void)deleteObject:(NSString *)entityName WithObjectID:(NSManagedObjectID *)objectId;
@end
