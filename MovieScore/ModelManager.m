//
//  ModelManager.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "ModelManager.h"

@implementation ModelManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize fetchedResultsController = __fetchedResultsController;

- (id)init {
	if (self = [super init]) {
	}
	return self;
}

- (id)initWithYear:(NSString *)year
{
    self = [super init];
    if (self) {
        year_ = year;
        [year_ retain];
    }
    return self;
}

- (id)initWithsectionNameKey:(NSString *)sectionNameKey
{
    self = [super init];
    if (self) {
        sectionNameKey_ = sectionNameKey;
        [sectionNameKey_ retain];
    }
    return self;
}

- (id)initWithYear:(NSString *)year sectionNameKey:(NSString *)sectionNameKey
{
    self = [super init];
    if (self) {
        year_ = year;
        [year_ retain];
        sectionNameKey_ = sectionNameKey;
        [sectionNameKey_ retain];
    }
    return self;
}

- (id)initWithYear:(NSString *)year sectionNameKey:(NSString *)sectionNameKey place:(NSString *)place 
{
    self = [super init];
    if (self) {
        year_ = year;
        [year_ retain];
        sectionNameKey_ = sectionNameKey;
        [sectionNameKey_ retain];
        place_ = place;
        [place_ retain];
    }
    return self;
}

- (id)initWithYear:(NSString *)year place:(NSString *)place 
{
    self = [super init];
    if (self) {
        year_ = year;
        [year_ retain];
        place_ = place;
        [place_ retain];
    }
    return self;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController:(NSString *)entityName
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO] autorelease];
    NSSortDescriptor *sortDescriptor2 = [[[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO] autorelease];
    
    if ([sectionNameKey_ isEqualToString:@"score"]) {
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor2, sortDescriptor1, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    } else if ([sectionNameKey_ isEqualToString:@"month"]) {
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    } else {
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    }

    NSMutableArray* predicateArray = [NSMutableArray array];
    if (year_) {
        [predicateArray addObject: [NSPredicate predicateWithFormat: @"year = %@", year_]];
    }
    if (place_) {
        [predicateArray addObject: [NSPredicate predicateWithFormat: @"place != nil"]];
        [predicateArray addObject: [NSPredicate predicateWithFormat: @"place = %@", place_]];
    }
    NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    [fetchRequest setPredicate:predicate];
    
    [NSFetchedResultsController deleteCacheWithName:[NSString stringWithFormat:@"cache%@_%@", year_, place_]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:sectionNameKey_
                                                             cacheName:[NSString stringWithFormat:@"cache%@_%@", year_, place_]];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    [aFetchedResultsController release];
    
    return __fetchedResultsController;
}

#pragma mark API

- (NSManagedObject *)fetchObject:(NSString *)entityName WithIndexPath:(NSIndexPath *)indexPath 
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController];
	return [fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSManagedObject *)fetchObject:(NSString *)entityName WithRow:(NSInteger)row AndSection:(NSInteger)section  
{
	NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
	return [self fetchObject:entityName WithIndexPath:path];
}

- (NSManagedObject *)fetchObject:(NSString *)entityName WithObjectID:(NSManagedObjectID *)objectId
{
    NSManagedObject *managedObject = [self.managedObjectContext objectWithID:objectId];
    return managedObject;
}

- (NSInteger)countObjects:(NSString *)entityName
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entityName];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
	return [sectionInfo numberOfObjects];
}

- (NSInteger)countObjects:(NSString *)entityName section:(NSInteger)section
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entityName];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (NSInteger)countSections:(NSString *)entityName
{
	return [[[self fetchedResultsController:entityName] sections] count];	
}

- (NSManagedObject *)createNewObject:(NSString *)entityName
{
    if (__fetchedResultsController == nil) {
        __fetchedResultsController = [self fetchedResultsController:entityName];
    }
    NSManagedObjectContext *context = [__fetchedResultsController managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    return newManagedObject;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)deleteObject:(NSString *)entityName WithRow:(NSInteger)row AndSection:(NSInteger)section
{
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
	[self deleteObject:entityName WithIndexPath:indexPath];
}

- (void)deleteObject:(NSString *)entityName WithIndexPath:(NSIndexPath *)indexPath
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entityName];
	@try {
		NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
		if (managedObject) {
			[self deleteObject:entityName WithObject:managedObject];
        }
	}
	@catch (NSException * e) {
		NSLog(@"%@", e);
	}
}

- (void)deleteObject:(NSString *)entityName WithObject:(NSManagedObject *)managedObject
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entityName];	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	[context deleteObject:managedObject];
	[self saveContext];
}


- (void)deleteObject:(NSString *)entityName WithObjectID:(NSManagedObjectID *)objectId
{
    NSManagedObject *managedObject = [self.managedObjectContext objectWithID:objectId];
    [self deleteObject:entityName WithObject:managedObject];
}

@end
